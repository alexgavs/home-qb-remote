import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/services/locale_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('test.homeqb/locales');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late String nativeSelection;
  late bool systemAppLocales;
  late List<MethodCall> calls;
  late LocaleController controller;

  setUp(() {
    nativeSelection = '';
    systemAppLocales = true;
    calls = [];
    FlutterSecureStorage.setMockInitialValues({'app.language.v1': 'ru'});
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      if (call.method == 'usesSystemAppLocales') return systemAppLocales;
      if (call.method == 'getLocale') return nativeSelection;
      if (call.method == 'setLocale') {
        nativeSelection = (call.arguments as Map)['languageCode'] as String;
        return nativeSelection;
      }
      throw MissingPluginException();
    });
    controller = LocaleController(
      platform: TargetPlatform.android,
      channel: channel,
    );
  });
  tearDown(() {
    controller.dispose();
    messenger.setMockMethodCallHandler(channel, null);
  });

  test(
    'Android native system override wins over stale Dart preference',
    () async {
      nativeSelection = 'he';
      await controller.initialize();
      expect(controller.locale, const Locale('he'));
      expect(controller.effectiveLocale, const Locale('he'));
      expect(calls.map((call) => call.method), [
        'usesSystemAppLocales',
        'getLocale',
      ]);
    },
  );

  test(
    'app selection writes native setting and follow-system clears it',
    () async {
      await controller.initialize();
      await controller.setLanguage('uk');
      expect(nativeSelection, 'uk');
      expect(controller.languageCode, 'uk');
      await controller.setLanguage(null);
      expect(nativeSelection, '');
      expect(controller.locale, isNull);
    },
  );

  test(
    'Android Settings event rebuilds selected language and system fallback',
    () async {
      await controller.initialize();
      var updates = 0;
      controller.addListener(() => updates++);
      Future<void> event(String value) async {
        await messenger.handlePlatformMessage(
          channel.name,
          const StandardMethodCodec().encodeMethodCall(
            MethodCall('onLocaleChanged', value),
          ),
          (_) {},
        );
      }

      await event('he');
      expect(controller.languageCode, 'he');
      await event('');
      expect(controller.locale, isNull);
      expect(updates, 2);
    },
  );

  test(
    'resume reloads external selection even without a channel event',
    () async {
      await controller.initialize();
      nativeSelection = 'ar';
      controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await Future<void>.delayed(Duration.zero);
      expect(controller.languageCode, 'ar');
    },
  );

  test(
    'unsupported choices are rejected before changing system preference',
    () async {
      await controller.initialize();
      final before = calls.length;
      await expectLater(controller.setLanguage('zz'), throwsArgumentError);
      expect(calls.length, before);
      expect(nativeSelection, '');
    },
  );

  test('legacy Android worker uses persisted in-app language', () async {
    systemAppLocales = false;
    await controller.initialize();
    await controller.setLanguage('he');
    expect(await controller.backgroundLocale(), const Locale('he'));
    await controller.setLanguage(null);
    expect(
      await const FlutterSecureStorage().read(key: 'app.legacy_language.v1'),
      isNull,
    );
  });

  test('Android 13 worker ignores stale legacy override', () async {
    FlutterSecureStorage.setMockInitialValues({'app.legacy_language.v1': 'he'});
    await controller.initialize();
    expect(
      await const FlutterSecureStorage().read(key: 'app.legacy_language.v1'),
      isNull,
    );
  });

  test(
    'desktop choice survives restart and clearing returns to system language',
    () async {
      controller.dispose();
      controller = LocaleController(platform: TargetPlatform.windows);
      await controller.initialize();
      expect(controller.languageCode, 'ru');
      await controller.setLanguage('es');
      controller.dispose();
      controller = LocaleController(platform: TargetPlatform.windows);
      await controller.initialize();
      expect(controller.languageCode, 'es');
      await controller.setLanguage(null);
      expect(
        await const FlutterSecureStorage().read(key: 'app.language.v1'),
        isNull,
      );
    },
  );

  test('locale resolution supports region variants, Hebrew alias and English fallback', () {
    expect(
      LocaleController.resolve([const Locale('uk', 'UA')]),
      const Locale('uk'),
    );
    expect(
      LocaleController.resolve([const Locale('iw', 'IL')]),
      const Locale('he'),
    );
    expect(LocaleController.resolve([const Locale('ja')]), const Locale('en'));
    expect(
      LocaleController.resolve([const Locale('ja'), const Locale('de')]),
      const Locale('de'),
    );
  });
}
