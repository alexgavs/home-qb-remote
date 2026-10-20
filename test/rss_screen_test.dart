import 'package:home_qb_remote/l10n/app_localizations.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/features/rss_screen.dart';

final feedFixture = {
  'Home': {
    'Linux': {
      'url': 'https://feeds.invalid/rss',
      'articles': [
        {
          'title': 'New Linux',
          'id': 'article-1',
          'date': '2026-10-21',
          'torrentURL': 'magnet:?xt=urn:btih:abc',
        },
      ],
    },
  },
};

class RssController extends AppController {
  final calls = <String, Map<String, String>>{};
  @override
  Future<dynamic> apiGet(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async => endpoint == 'rss/items' ? feedFixture : {};
  @override
  Future<dynamic> apiPost(String endpoint, Map<String, String> fields) async {
    calls[endpoint] = Map.of(fields);
    return null;
  }
}

void main() {
  testWidgets(
    'existing v5 RSS nested torrent options are edited and unknown fields retained',
    (tester) async {
      tester.view.physicalSize = const Size(1000, 1500);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = RssController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TypedRssScreen(
            controller: controller,
            items: const {},
            rules: const {
              'My rule': {
                'enabled': true,
                'torrentParams': {
                  'save_path': '/original',
                  'category': 'old',
                  'stopped': true,
                  'upload_limit': 123,
                  'tags': ['keep'],
                },
                'unknownOption': 'preserve',
              },
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Правила'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('My rule'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.widgetWithText(TextFormField, '/original'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Путь сохранения'),
        '/new',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Категория'),
        'Linux',
      );
      await tester.ensureVisible(find.text('Добавлять на паузе'));
      await tester.tap(find.text('Добавлять на паузе'));
      await tester.tap(find.text('Сохранить'));
      await tester.pumpAndSettle();
      final rule =
          jsonDecode(controller.calls['rss/setRule']!['ruleDef']!) as Map;
      expect(rule['torrentParams'], {
        'save_path': '/new',
        'category': 'Linux',
        'stopped': false,
        'upload_limit': 123,
        'tags': ['keep'],
      });
      expect(rule['unknownOption'], 'preserve');
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('RSS article read retains nested feed path and ID', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 592);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = RssController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TypedRssScreen(
          controller: controller,
          items: feedFixture,
          rules: const {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('New Linux').hitTestable(), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.ancestor(
          of: find.text('New Linux'),
          matching: find.byType(ListTile),
        ),
        matching: find.byType(PopupMenuButton<String>),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Отметить прочитанной'));
    await tester.pumpAndSettle();
    expect(controller.calls['rss/markAsRead'], {
      'itemPath': r'Home\Linux',
      'articleId': 'article-1',
    });
    expect(tester.takeException(), isNull);
  });
}
