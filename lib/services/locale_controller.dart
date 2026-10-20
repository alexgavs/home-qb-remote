import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Android's per-app setting is authoritative; other platforms store only the
/// optional override. Null always means follow the operating system.
class LocaleController extends ChangeNotifier with WidgetsBindingObserver {
  LocaleController({
    TargetPlatform? platform,
    FlutterSecureStorage? storage,
    MethodChannel? channel,
  }) : _platform = platform ?? defaultTargetPlatform,
       _storage =
           storage ??
           const FlutterSecureStorage(
             iOptions: IOSOptions(
               accessibility: KeychainAccessibility.first_unlock_this_device,
             ),
             mOptions: MacOsOptions(usesDataProtectionKeychain: false),
           ),
       _channel = channel ?? const MethodChannel('org.homeqb/locales');

  static final instance = LocaleController();
  static const languageNames = <String, String>{
    'en': 'English',
    'ru': 'Русский',
    'uk': 'Українська',
    'he': 'עברית',
    'ar': 'العربية',
    'de': 'Deutsch',
    'fr': 'Français',
    'es': 'Español',
  };
  static const _key = 'app.language.v1';
  static const _legacyBackgroundKey = 'app.legacy_language.v1';
  final TargetPlatform _platform;
  final FlutterSecureStorage _storage;
  final MethodChannel _channel;
  Future<void>? _initialization;
  String? _languageCode;
  bool _disposed = false;
  bool _legacyAndroid = false;

  String? get languageCode => _languageCode;
  Locale? get locale => _languageCode == null ? null : Locale(_languageCode!);
  Locale get effectiveLocale => resolve(
    locale == null
        ? WidgetsBinding.instance.platformDispatcher.locales
        : [locale!],
  );

  static Locale resolve(
    List<Locale>? preferred, [
    Iterable<Locale>? supported,
  ]) {
    final codes = (supported ?? languageNames.keys.map(Locale.new))
        .map((locale) => locale.languageCode)
        .toSet();
    for (final candidate in preferred ?? const <Locale>[]) {
      final code = candidate.languageCode == 'iw'
          ? 'he'
          : candidate.languageCode;
      if (codes.contains(code)) return Locale(code);
    }
    return const Locale('en');
  }

  static String? _normalize(String? value) {
    if (value == null || value.isEmpty) return null;
    var code = value.replaceAll('_', '-').split('-').first.toLowerCase();
    if (code == 'iw') code = 'he';
    return languageNames.containsKey(code) ? code : null;
  }

  Future<void> initialize() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    WidgetsBinding.instance.addObserver(this);
    if (_platform == TargetPlatform.android) {
      _channel.setMethodCallHandler((call) async {
        if (call.method == 'onLocaleChanged' && !_disposed) {
          _languageCode = _normalize(
            call.arguments is String ? call.arguments as String : null,
          );
          unawaited(_cacheLegacyLocale());
          // A system-language change also matters when the override stays null.
          notifyListeners();
        }
      });
    }
    try {
      if (_platform == TargetPlatform.android) {
        _legacyAndroid =
            await _channel.invokeMethod<bool>('usesSystemAppLocales') == false;
      }
      final selected = _platform == TargetPlatform.android
          ? await _channel.invokeMethod<String>('getLocale')
          : await _storage.read(key: _key);
      if (!_disposed) _languageCode = _normalize(selected);
      await _cacheLegacyLocale();
    } on PlatformException {
      // A language preference failure must not prevent access to the app.
    } on MissingPluginException {
      // Desktop/widget harnesses may not supply the optional native adapter.
    }
    if (!_disposed) notifyListeners();
  }

  Future<void> setLanguage(String? code) async {
    if (code != null && !languageNames.containsKey(code)) {
      throw ArgumentError.value(code, 'code', 'Unsupported language');
    }
    if (_platform == TargetPlatform.android) {
      final applied = await _channel.invokeMethod<String>('setLocale', {
        'languageCode': code ?? '',
      });
      if (_disposed) return;
      _languageCode = _normalize(applied);
    } else {
      if (code == null) {
        await _storage.delete(key: _key);
      } else {
        await _storage.write(key: _key, value: code);
      }
      if (_disposed) return;
      _languageCode = code;
    }
    notifyListeners();
    await _cacheLegacyLocale();
  }

  /// A worker has no Activity channel. Android 13+ supplies its per-app locale
  /// to the Flutter engine; older Android needs the in-app override separately.
  Future<Locale> backgroundLocale() async {
    try {
      final saved = await _storage.read(
        key: _platform == TargetPlatform.android ? _legacyBackgroundKey : _key,
      );
      final code = _normalize(saved);
      if (code != null) return Locale(code);
    } on PlatformException {
      // Locale preferences must never block a background completion check.
    } on MissingPluginException {
      // Optional storage adapter absent in a test harness.
    }
    return resolve(WidgetsBinding.instance.platformDispatcher.locales);
  }

  Future<void> _cacheLegacyLocale() async {
    if (_platform != TargetPlatform.android) return;
    try {
      if (_legacyAndroid && _languageCode != null) {
        await _storage.write(key: _legacyBackgroundKey, value: _languageCode);
      } else {
        await _storage.delete(key: _legacyBackgroundKey);
      }
    } on PlatformException {
      // The native preference remains authoritative if this optional cache fails.
    } on MissingPluginException {
      // Optional storage adapter absent in a test harness.
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (_platform == TargetPlatform.android) {
      unawaited(_refreshAndroidLocale());
    } else if (_languageCode == null && !_disposed) {
      notifyListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _platform == TargetPlatform.android) {
      unawaited(_refreshAndroidLocale());
    }
  }

  Future<void> _refreshAndroidLocale() async {
    try {
      final value = await _channel.invokeMethod<String>('getLocale');
      if (!_disposed) {
        _languageCode = _normalize(value);
        await _cacheLegacyLocale();
        if (!_disposed) notifyListeners();
      }
    } on PlatformException {
      // Preserve the last known setting on a transient native-channel error.
    } on MissingPluginException {
      // No Android adapter in a test/desktop harness.
    }
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    if (_platform == TargetPlatform.android) {
      _channel.setMethodCallHandler(null);
    }
    super.dispose();
  }
}
