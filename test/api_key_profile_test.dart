import 'package:home_qb_remote/l10n/app_localizations.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/core/qb_client.dart';
import 'package:home_qb_remote/ui/home_screen.dart';

const _key = 'test-api-key-do-not-log';
const _hint =
    'qBittorrent 5.2+. При заполнении используется вместо имени и пароля.';

void main() {
  // The test binding also installs flutter_test's mock HttpClient, so any
  // connection attempt after a successful save answers HTTP 400 locally.
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  test('withUrl keeps the API key alongside the other credentials', () {
    const profile = ServerProfile(
      id: 'nas',
      name: 'NAS',
      url: 'https://qb.example.local',
      username: '',
      password: '',
      apiKey: _key,
      customCaPem: 'ca-pem',
      localUrl: 'http://192.168.1.2:8080',
      localSsid: 'Home',
    );
    final routed = profile.withUrl(profile.localUrl);
    expect(routed.url, 'http://192.168.1.2:8080');
    expect(routed.apiKey, _key);
    expect(routed.customCaPem, 'ca-pem');
    expect(routed.localSsid, 'Home');
  });

  test(
    'encode/decode round-trips the API key; legacy entries default to empty',
    () {
      const profile = ServerProfile(
        id: 'nas',
        name: 'NAS',
        url: 'https://qb.example.local',
        username: '',
        password: '',
        apiKey: _key,
      );
      final decoded = AppController.decodeProfile(
        jsonDecode(jsonEncode(AppController.encodeProfile(profile)))
            as Map<String, dynamic>,
      );
      expect(decoded.apiKey, _key);
      expect(decoded.username, '');
      expect(decoded.password, '');

      // Profiles written before the key existed carry no `apiKey` entry at all.
      final legacy = AppController.decodeProfile({
        'id': 'old',
        'name': 'Old',
        'url': 'http://127.0.0.1:8080',
        'username': 'user',
        'password': 'legacy-secret',
        'basicAuthUsername': 'proxy',
        'basicAuthPassword': 'proxy-secret',
      });
      expect(legacy.apiKey, '');
      expect(legacy.username, 'user');
      expect(legacy.password, 'legacy-secret');
      expect(legacy.basicAuthUsername, 'proxy');
    },
  );

  test('an API key combined with proxy Basic auth is rejected before the protected store is touched', () async {
    final controller = AppController();
    addTearDown(controller.dispose);
    await expectLater(
      controller.saveProfile(
        const ServerProfile(
          id: 'conflict',
          name: 'Conflict',
          url: 'http://127.0.0.1:8080',
          username: '',
          password: '',
          apiKey: _key,
          basicAuthUsername: 'proxy',
          basicAuthPassword: 'proxy-secret',
        ),
      ),
      throwsA(isA<QbException>()),
    );
    expect(await const FlutterSecureStorage().read(key: 'profiles.v1'), isNull);
    expect(controller.profiles, isEmpty);
    expect(controller.currentProfile, isNull);
  });

  test(
    'legacy login with proxy Basic auth and no API key is still saved',
    () async {
      final controller = AppController();
      addTearDown(controller.dispose);
      await controller.saveProfile(
        const ServerProfile(
          id: 'legacy',
          name: 'Legacy',
          url: 'http://127.0.0.1:8080',
          username: 'user',
          password: 'legacy-secret',
          basicAuthUsername: 'proxy',
          basicAuthPassword: 'proxy-secret',
        ),
      );
      final saved = jsonDecode(
        (await const FlutterSecureStorage().read(key: 'profiles.v1'))!,
      ) as List;
      expect(saved.single['id'], 'legacy');
      expect(saved.single['apiKey'], '');
      expect(controller.profiles.single.basicAuthUsername, 'proxy');
    },
  );

  testWidgets(
    'editor keeps the API key obscured and accepts a blank username in key mode',
    (tester) async {
      tester.view.physicalSize = const Size(1024, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = AppController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(controller: controller),
        ),
      );
      await tester.tap(find.text('Подключить сервер'));
      await tester.pumpAndSettle();

      expect(find.text(_hint), findsOneWidget);
      final apiKeyField = find.widgetWithText(
        TextFormField,
        'API-ключ (необязательно)',
      );
      expect(apiKeyField, findsOneWidget);
      final editable = tester.widget<EditableText>(
        find.descendant(of: apiKeyField, matching: find.byType(EditableText)),
      );
      expect(editable.obscureText, isTrue);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Адрес Web UI'),
        'http://127.0.0.1:8080',
      );
      await tester.enterText(apiKeyField, _key);
      // Username and password are intentionally left blank.
      await tester.tap(find.text('Сохранить'));
      await tester.pumpAndSettle();
      for (var i = 0; i < 50 && controller.profiles.isEmpty; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(find.byType(AlertDialog), findsNothing);
      expect(controller.profiles.single.apiKey, _key);
      expect(controller.profiles.single.username, '');
      expect(controller.profiles.single.password, '');
      final saved = jsonDecode(
        (await const FlutterSecureStorage().read(key: 'profiles.v1'))!,
      ) as List;
      expect(saved.single['apiKey'], _key);
      expect(find.textContaining(_key), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('editor refuses an API key combined with proxy Basic auth', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = AppController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeScreen(controller: controller),
      ),
    );
    await tester.tap(find.text('Подключить сервер'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Адрес Web UI'),
      'http://127.0.0.1:8080',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'API-ключ (необязательно)'),
      _key,
    );
    await tester.ensureVisible(find.text('Прокси и сертификаты'));
    await tester.tap(find.text('Прокси и сертификаты'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Basic auth: имя'),
      'proxy',
    );
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(
      find.text('API-ключ нельзя сочетать с Basic auth прокси'),
      findsOneWidget,
    );
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(controller.profiles, isEmpty);
    expect(await const FlutterSecureStorage().read(key: 'profiles.v1'), isNull);
    expect(tester.takeException(), isNull);
  });
}
