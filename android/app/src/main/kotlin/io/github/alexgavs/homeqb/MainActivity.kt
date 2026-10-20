package io.github.alexgavs.homeqb

import android.content.Intent
import android.app.Activity
import android.app.LocaleManager
import android.content.res.Configuration
import android.os.Build
import android.os.LocaleList
import android.net.Uri
import android.os.Bundle
import android.provider.OpenableColumns
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.Executors

class MainActivity : FlutterFragmentActivity() {
    private val supportedLanguages = setOf("en", "ru", "uk", "he", "ar", "de", "fr", "es")
    private var localesChannel: MethodChannel? = null

    private fun selectedLocale(): String = if (Build.VERSION.SDK_INT >= 33) {
        getSystemService(LocaleManager::class.java).applicationLocales.toLanguageTags().substringBefore(',').substringBefore('-')
    } else {
        getSharedPreferences("app_locales", MODE_PRIVATE).getString("language", "") ?: ""
    }

    private fun notifyLocaleChanged() {
        val selected = selectedLocale()
        // Also notify when the system language changes while following the system.
        localesChannel?.invokeMethod("onLocaleChanged", selected)
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        super.onConfigurationChanged(newConfig)
        notifyLocaleChanged()
    }

    override fun onResume() {
        super.onResume()
        notifyLocaleChanged()
    }

    private val importsExecutor = Executors.newSingleThreadExecutor()
    private var importsChannel: MethodChannel? = null
    private var initialIntent: Intent? = null
    private var pendingExport: Pair<ByteArray, MethodChannel.Result>? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        initialIntent = intent
        if (Build.VERSION.SDK_INT >= 33) {
            val preferences = getSharedPreferences("app_locales", MODE_PRIVATE)
            if (!preferences.getBoolean("framework_migrated", false)) {
                val previous = preferences.getString("language", "") ?: ""
                val manager = getSystemService(LocaleManager::class.java)
                // Preserve an explicit system setting; import the old in-app choice only once.
                if (manager.applicationLocales.isEmpty && previous in supportedLanguages) {
                    manager.applicationLocales = LocaleList.forLanguageTags(previous)
                }
                preferences.edit().remove("language").putBoolean("framework_migrated", true).apply()
            }
        }
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        localesChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "org.homeqb/locales")
        localesChannel!!.setMethodCallHandler { call, result ->
            when (call.method) {
                "getLocale" -> result.success(selectedLocale())
                "usesSystemAppLocales" -> result.success(Build.VERSION.SDK_INT >= 33)
                "setLocale" -> {
                    val code = call.argument<String>("languageCode")
                    if (code == null || (code.isNotEmpty() && code !in supportedLanguages)) {
                        result.error("invalid_locale", "Unsupported language", null)
                    } else {
                        if (Build.VERSION.SDK_INT >= 33) {
                            getSystemService(LocaleManager::class.java).applicationLocales = LocaleList.forLanguageTags(code)
                        } else {
                            getSharedPreferences("app_locales", MODE_PRIVATE).edit().putString("language", code).apply()
                        }
                        result.success(code)
                        notifyLocaleChanged()
                    }
                }
                else -> result.notImplemented()
            }
        }
        importsChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "org.homeqb/imports")
        importsChannel!!.setMethodCallHandler { call, result ->
            if (call.method == "setPrivacyMode") {
                val enabled = (call.arguments as? Map<*, *>)?.get("enabled") as? Boolean
                if (enabled == null) {
                    result.error("invalid_privacy_mode", "Privacy setting is required", null)
                } else {
                    runOnUiThread {
                        try {
                            if (enabled) window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                            else window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                            result.success(null)
                        } catch (_: Exception) {
                            result.error("privacy_mode_failed", "Unable to update screen privacy", null)
                        }
                    }
                }
            } else if (call.method == "importPkcs12") {
                val bytes = call.argument<ByteArray>("bytes")
                val password = (call.argument<String>("password") ?: "").toCharArray()
                if (bytes == null || bytes.isEmpty() || bytes.size > 4 * 1024 * 1024) {
                    password.fill(0.toChar())
                    result.error("invalid_pkcs12", "Expected a PKCS12 file of at most 4 MiB", null)
                } else {
                    importsExecutor.execute {
                        try {
                            val store = java.security.KeyStore.getInstance("PKCS12")
                            bytes.inputStream().use { store.load(it, password) }
                            val alias = java.util.Collections.list(store.aliases())
                                .firstOrNull { store.entryInstanceOf(it, java.security.KeyStore.PrivateKeyEntry::class.java) }
                                ?: error("Missing identity")
                            val key = store.getKey(alias, password) as? java.security.PrivateKey
                                ?: error("Missing private key")
                            require(key.format.equals("PKCS#8", ignoreCase = true))
                            val encoded = key.encoded ?: error("Key is not exportable")
                            val chain = store.getCertificateChain(alias) ?: error("Missing certificate chain")
                            require(chain.isNotEmpty())
                            val payload = mapOf(
                                "certChainPem" to chain.joinToString("\n") { pem("CERTIFICATE", it.encoded) },
                                "keyPkcs8Pem" to pem("PRIVATE KEY", encoded)
                            )
                            encoded.fill(0)
                            runOnUiThread { result.success(payload) }
                        } catch (_: Exception) {
                            runOnUiThread {
                                result.error("pkcs12_import_failed", "Unable to import PKCS12 identity. Check the password and file format.", null)
                            }
                        } finally {
                            password.fill(0.toChar())
                            bytes.fill(0)
                        }
                    }
                }
            } else if (call.method == "exportTorrent") {
                val bytes = call.argument<ByteArray>("bytes")
                val name = call.argument<String>("name") ?: "export.torrent"
                if (bytes == null || bytes.size > 16 * 1024 * 1024) {
                    result.error("invalid_export", "Torrent bytes are required and must be at most 16 MiB", null)
                } else if (pendingExport != null) {
                    result.error("export_busy", "A save dialog is already open", null)
                } else {
                    pendingExport = bytes to result
                    try {
                        startActivityForResult(Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                            addCategory(Intent.CATEGORY_OPENABLE)
                            type = "application/x-bittorrent"
                            putExtra(Intent.EXTRA_TITLE, name.substringAfterLast('/').substringAfterLast('\\'))
                        }, 4107)
                    } catch (_: Exception) {
                        pendingExport = null
                        result.error("export_failed", "Unable to open a save dialog", null)
                    }
                }
            } else if (call.method != "initialImport") {
                result.notImplemented()
            } else {
                val source = initialIntent
                initialIntent = null
                importsExecutor.execute {
                    try {
                        val payload = readImport(source)
                        runOnUiThread { result.success(payload) }
                    } catch (_: Exception) {
                        runOnUiThread { result.error("import_failed", "Unable to read the selected torrent file", null) }
                    }
                }
            }
        }
    }

    private fun pem(label: String, bytes: ByteArray): String {
        val text = android.util.Base64.encodeToString(bytes, android.util.Base64.NO_WRAP)
        return "-----BEGIN $label-----\n" + text.chunked(64).joinToString("\n") + "\n-----END $label-----\n"
    }

    @Deprecated("Legacy Activity result is retained for the Flutter save channel")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != 4107) return
        val pending = pendingExport ?: return
        pendingExport = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            pending.second.success(false)
            return
        }
        importsExecutor.execute {
            try {
                contentResolver.openOutputStream(uri, "w")?.use { it.write(pending.first) }
                    ?: error("Cannot open selected destination")
                runOnUiThread { pending.second.success(true) }
            } catch (_: Exception) {
                runOnUiThread { pending.second.error("export_failed", "Unable to save the torrent file", null) }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        importsExecutor.execute {
            val payload = try { readImport(intent) } catch (_: Exception) {
                mapOf("error" to "Unable to read the selected torrent file")
            }
            if (payload != null) runOnUiThread { importsChannel?.invokeMethod("onImport", payload) }
        }
    }

    @Suppress("DEPRECATION")
    private fun readImport(source: Intent?): Map<String, Any>? {
        if (source == null) return null
        if (source.action == Intent.ACTION_SEND) {
            source.getCharSequenceExtra(Intent.EXTRA_TEXT)?.toString()?.let {
                if (it.isNotBlank()) return mapOf("text" to it)
            }
        }
        val uri: Uri = when (source.action) {
            Intent.ACTION_SEND -> source.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
            Intent.ACTION_VIEW -> source.data
            else -> null
        } ?: return null
        if (uri.scheme != "content") return null
        var name = uri.lastPathSegment ?: "import.torrent"
        if (uri.scheme == "content") {
            contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use {
                if (it.moveToFirst()) name = it.getString(0) ?: name
            }
        }
        val mime = contentResolver.getType(uri)
        if (mime != "application/x-bittorrent" && !name.endsWith(".torrent", ignoreCase = true)) return null
        val bytes = contentResolver.openInputStream(uri)?.use { input ->
            val limit = 16 * 1024 * 1024
            val buffer = java.io.ByteArrayOutputStream()
            val chunk = ByteArray(8192)
            while (true) {
                val count = input.read(chunk)
                if (count < 0) break
                require(buffer.size() + count <= limit) { "Torrent file exceeds 16 MiB" }
                buffer.write(chunk, 0, count)
            }
            buffer.toByteArray()
        } ?: return null
        return mapOf("name" to name.substringAfterLast('/').substringAfterLast('\\'), "bytes" to bytes)
    }

    override fun onDestroy() {
        pendingExport?.second?.error("export_cancelled", "Activity closed", null)
        pendingExport = null
        importsChannel?.setMethodCallHandler(null)
        localesChannel?.setMethodCallHandler(null)
        localesChannel = null
        importsExecutor.shutdown()
        super.onDestroy()
    }
}
