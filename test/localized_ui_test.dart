import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/features/advanced_screen.dart';
import 'package:home_qb_remote/features/rss_screen.dart';
import 'package:home_qb_remote/features/torrent_tools_screen.dart';
import 'package:home_qb_remote/l10n/app_localizations.dart';
import 'package:home_qb_remote/ui/home_screen.dart';

const _torrent = Torrent(
  hash: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  name: 'Ubuntu server data',
  size: 1024,
  progress: 0.5,
  dlspeed: 128,
  upspeed: 16,
  state: 'downloading',
  eta: 20,
  category: 'Server category',
  ratio: 0.1,
);

void main() {
  for (final language in ['en', 'ru', 'uk', 'he', 'ar', 'de', 'fr', 'es']) {
    testWidgets('$language screens localize and respect text direction', (
      tester,
    ) async {
      final previousErrorHandler = FlutterError.onError;
      FlutterError.onError = (details) {
        if (details.exceptionAsString().contains('RenderFlex overflowed')) {
          debugPrint(details.toString());
        }
        previousErrorHandler?.call(details);
      };
      addTearDown(() => FlutterError.onError = previousErrorHandler);
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = AppController();
      addTearDown(controller.dispose);
      controller.currentProfile = const ServerProfile(
        id: 'test',
        name: 'Home NAS server data',
        url: 'http://localhost:8080',
        username: 'test',
        password: 'never-render-this-secret',
      );
      controller.profiles = [controller.currentProfile!];
      controller.torrents = [_torrent];
      final expectedDirection = ['he', 'ar'].contains(language)
          ? TextDirection.rtl
          : TextDirection.ltr;
      for (final screen in <Widget>[
        HomeScreen(controller: controller),
        AdvancedScreen(controller: controller),
        TorrentToolsScreen(controller: controller, torrent: _torrent),
        TypedRssScreen(
          controller: controller,
          items: const {},
          rules: const {},
        ),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: screen,
          ),
        );
        await tester.pumpAndSettle();
        final scaffold = find.byType(Scaffold).first;
        expect(Directionality.of(tester.element(scaffold)), expectedDirection);
        expect(
          tester.takeException(),
          isNull,
          reason: '$language ${screen.runtimeType}',
        );
        if (screen is HomeScreen) {
          expect(find.text('Ubuntu server data'), findsOneWidget);
          expect(find.text('Home NAS server data'), findsWidgets);
          // The fourth status chip remains the paused filter in every locale;
          // translated labels must never become API/filter identifiers.
          final pausedChip = find.byType(ChoiceChip).at(3);
          await tester.ensureVisible(pausedChip);
          await tester.tap(pausedChip);
          await tester.pumpAndSettle();
          expect(find.text('Ubuntu server data'), findsNothing);
          final allChip = find.byType(ChoiceChip).first;
          await tester.ensureVisible(allChip);
          await tester.tap(allChip);
          await tester.pumpAndSettle();
          expect(find.text('Ubuntu server data'), findsOneWidget);
        }
        final labels = tester
            .widgetList<Text>(find.byType(Text))
            .map((text) => text.data ?? '')
            .join('\n');
        expect(labels, isNot(contains('never-render-this-secret')));
        if (!['ru', 'uk'].contains(language)) {
          expect(
            RegExp(r'[А-Яа-яЁё]').hasMatch(labels),
            isFalse,
            reason: '$language must not fall back to Russian UI: $labels',
          );
        }
      }
    });
  }
}
