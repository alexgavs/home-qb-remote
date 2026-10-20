import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_controller.dart';
import 'core/import_validation.dart';
import 'ui/home_screen.dart';
import 'services/device_services.dart';
import 'services/incoming_document_service.dart';
import 'services/locale_controller.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleController.instance.initialize();
  runApp(const HomeQbApp());
}

enum _StartupFailure { storage, reset }

class HomeQbApp extends StatefulWidget {
  const HomeQbApp({super.key});
  @override
  State<HomeQbApp> createState() => _HomeQbAppState();
}

class _HomeQbAppState extends State<HomeQbApp> with WidgetsBindingObserver {
  final controller = AppController();
  final navigator = GlobalKey<NavigatorState>();
  final appLinks = AppLinks();
  final incomingDocuments = IncomingDocumentService();
  StreamSubscription<Uri>? _links;
  static const imports = MethodChannel('org.homeqb/imports');
  final List<Map<String, dynamic>> _pending = [];
  bool _showingImport = false;
  bool _ready = false;
  bool _locked = true;
  bool _authenticating = false;
  bool _confirmReset = false;
  _StartupFailure? _startupError;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller.addListener(_processImports);
    _bootstrap();
    _links = appLinks.uriLinkStream.listen(
      (uri) async {
        if (Platform.isIOS && uri.scheme == 'file') {
          try {
            final data = await incomingDocuments
                .read(uri)
                .timeout(const Duration(seconds: 20));
            if (mounted) _queueImport(data);
          } catch (_) {
            /* Invalid or inaccessible documents are never uploaded. */
          }
          return;
        }
        if (uri.scheme == 'magnet') _queueImport({'text': uri.toString()});
        if (uri.scheme == 'homeqb') {
          final url = uri.queryParameters['url'];
          if (url != null) _queueImport({'text': url});
        }
      },
      onError: (Object _) {
        /* Platform routing failure must not crash the app. */
      },
    );
    imports.setMethodCallHandler((call) async {
      if (call.method == 'onImport' && call.arguments is Map) {
        _queueImport(Map<String, dynamic>.from(call.arguments as Map));
      }
    });
    _loadInitialImport();
  }

  Future<void> _bootstrap() async {
    try {
      await DeviceServices.initialize();
      controller.onTorrentsChanged = (previous, current) {
        unawaited(
          DeviceServices.onTorrentsChanged(
            previous,
            current,
            profileId: controller.currentProfile?.id,
          ).catchError((Object _) {}),
        );
      };
      if (DeviceServices.lockEnabled && !await DeviceServices.authenticate()) {
        if (mounted) setState(() => _ready = true);
        return;
      }
      await controller.init();
      if (mounted) {
        setState(() {
          _locked = false;
          _ready = true;
        });
      }
      controller.setActive(true);
      _processImports();
    } catch (_) {
      if (mounted) {
        setState(() {
          _startupError = _StartupFailure.storage;
          _ready = true;
        });
      }
    }
  }

  Future<void> _unlock() async {
    if (_authenticating) return;
    _authenticating = true;
    try {
      if (await DeviceServices.authenticate()) {
        if (controller.currentProfile == null) await controller.init();
        if (mounted) setState(() => _locked = false);
        controller.setActive(true);
        _processImports();
      }
    } finally {
      _authenticating = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    controller.setActive(state == AppLifecycleState.resumed && !_locked);
    if ((state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive ||
            state == AppLifecycleState.hidden) &&
        DeviceServices.lockEnabled &&
        !_authenticating &&
        !DeviceServices.authenticationInProgress) {
      setState(() => _locked = true);
      controller.setActive(false);
    }
    if (state == AppLifecycleState.resumed &&
        _locked &&
        _ready &&
        _startupError == null) {
      _unlock();
    }
  }

  @override
  Future<bool> didPopRoute() async => _locked;

  Future<void> _loadInitialImport() async {
    try {
      final data = await imports.invokeMapMethod<String, dynamic>(
        'initialImport',
      );
      if (data != null) _queueImport(data);
    } on MissingPluginException {
      /* Native sharing is Android-specific. */
    } on PlatformException {
      // A malformed incoming document must not prevent ordinary application use.
    }
  }

  void _queueImport(Map<String, dynamic> data) {
    if (data['error'] != null) return;
    final text = data['text'];
    if (text != null && (text is! String || singleIncomingUrl(text) == null)) {
      return;
    }
    final bytes = data['bytes'];
    if (bytes is List && !isTorrentFile(bytes.cast<int>())) return;
    // An external intent must never trigger an automatic server mutation.
    if (_pending.length < 10) _pending.add(data);
    _processImports();
  }

  void _processImports() {
    if (_pending.isEmpty ||
        _showingImport ||
        _locked ||
        controller.currentProfile == null) {
      return;
    }
    _showingImport = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final context = navigator.currentContext;
      if (!mounted || context == null || _locked) {
        _showingImport = false;
        return;
      }
      final data = _pending.removeAt(0);
      final text = data['text'] as String?;
      final target = controller.currentProfile;
      if (target == null) {
        _pending.insert(0, data);
        _showingImport = false;
        return;
      }
      final accepted = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(ctx)!.incomingTorrentTitle),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(ctx)!.serverName(target.name)),
                  const SizedBox(height: 12),
                  Text(
                    text == null
                        ? AppLocalizations.of(ctx)!.incomingTorrentFile
                        : AppLocalizations.of(ctx)!.incomingTorrentLink,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    text ??
                        '${data['name'] ?? AppLocalizations.of(ctx)!.torrentFile}',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(AppLocalizations.of(ctx)!.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(AppLocalizations.of(ctx)!.add),
            ),
          ],
        ),
      );
      try {
        if (accepted == true &&
            !_locked &&
            controller.currentProfile?.id == target.id) {
          if (text != null) {
            await controller.addUrls(text);
          } else if (data['bytes'] is List) {
            await controller.addTorrentFile(
              '${data['name'] ?? 'incoming.torrent'}',
              (data['bytes'] as List).cast<int>(),
            );
          }
        }
      } catch (_) {
        /* Controller exposes a redacted error in the home screen. */
      }
      _showingImport = false;
      _processImports();
    });
  }

  Future<void> _resetLocalData() async {
    try {
      await DeviceServices.resetLocalData();
      controller.clearLocalState();
      _pending.clear();
      navigator.currentState?.popUntil((route) => route.isFirst);
      if (mounted) {
        setState(() {
          _locked = false;
          _confirmReset = false;
          _startupError = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _confirmReset = false;
          _startupError = _StartupFailure.reset;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _links?.cancel();
    imports.setMethodCallHandler(null);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: LocaleController.instance,
    builder: (context, _) => MaterialApp(
      locale: LocaleController.instance.locale,
      localeListResolutionCallback: LocaleController.resolve,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: navigator,
      title: 'Home qB',
      debugShowCheckedModeBanner: false,
      // Cover the entire navigator: detail pages and dialogs must be hidden too.
      builder: (context, child) => Stack(
        children: [
          if (child != null)
            ExcludeFocus(
              excluding: _locked,
              child: AbsorbPointer(absorbing: _locked, child: child),
            ),
          if (_ready && _locked)
            Positioned.fill(
              child: Material(
                color: const Color(0xff0c1424),
                child: BlockSemantics(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline, size: 48),
                        const SizedBox(height: 20),
                        Text(switch (_startupError) {
                          _StartupFailure.storage => AppLocalizations.of(
                            context,
                          )!.startupStorageFailed,
                          _StartupFailure.reset => AppLocalizations.of(
                            context,
                          )!.localDataResetFailed,
                          null => AppLocalizations.of(context)!.appLocked,
                        }),
                        const SizedBox(height: 20),
                        if (!_confirmReset)
                          FilledButton(
                            onPressed: _startupError == null
                                ? _unlock
                                : _bootstrap,
                            child: Text(AppLocalizations.of(context)!.open),
                          ),
                        if (!_confirmReset)
                          TextButton(
                            onPressed: () =>
                                setState(() => _confirmReset = true),
                            child: Text(
                              AppLocalizations.of(context)!.resetLocalData,
                            ),
                          ),
                        if (_confirmReset) ...[
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .resetLocalDataWarning,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                setState(() => _confirmReset = false),
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                          FilledButton(
                            onPressed: _resetLocalData,
                            child: Text(
                              AppLocalizations.of(context)!.deleteLocalData,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff32d4b2),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xff0c1424),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: !_ready
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : HomeScreen(controller: controller),
    ),
  );
}
