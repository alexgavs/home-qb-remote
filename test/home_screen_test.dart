import 'package:home_qb_remote/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/ui/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  testWidgets('first launch offers server setup on phone without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
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
    expect(find.text('Подключить сервер'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Подключить сервер'));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(360, 592),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets('torrent list filters and renders at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = AppController();
      addTearDown(controller.dispose);
      controller.currentProfile = const ServerProfile(
        id: 'test',
        name: 'Home NAS',
        url: 'http://localhost:8080',
        username: 'test',
        password: 'secret',
      );
      controller.profiles = [controller.currentProfile!];
      controller.torrents = const [
        Torrent(
          hash: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
          name: 'Ubuntu Linux',
          size: 1000,
          progress: 0.4,
          dlspeed: 100,
          upspeed: 20,
          state: 'downloading',
          eta: 6,
          category: 'Linux',
          ratio: 0.2,
        ),
        Torrent(
          hash: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
          name: 'Fedora Linux',
          size: 2000,
          progress: 1,
          dlspeed: 0,
          upspeed: 100,
          state: 'uploading',
          eta: 0,
          category: 'Linux',
          ratio: 2,
        ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(controller: controller),
        ),
      );
      expect(find.text('Ubuntu Linux'), findsOneWidget);
      expect(find.text('Ubuntu Linux').hitTestable(), findsOneWidget);
      expect(find.text('Fedora Linux'), findsOneWidget);
      expect(tester.takeException(), isNull);
      final search = find.byType(TextField).first;
      await tester.enterText(search, 'Ubuntu');
      await tester.pump();
      expect(find.text('Ubuntu Linux'), findsOneWidget);
      expect(find.text('Fedora Linux'), findsNothing);
      expect(find.textContaining('secret'), findsNothing);
      final l10n = AppLocalizations.of(tester.element(search))!;
      expect(find.text(l10n.torrentListFilterHint), findsOneWidget);
      await tester.tap(find.byTooltip(l10n.clearTorrentListFilter));
      await tester.pump();
      expect(find.text('Fedora Linux'), findsOneWidget);
      expect(tester.widget<TextField>(search).controller!.text, isEmpty);

      expect(tester.takeException(), isNull);
    });
  }
}
