import 'package:home_qb_remote/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/core/qb_client.dart';
import 'package:home_qb_remote/features/torrent_tools_screen.dart';

const hash = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
const seedA = 'https://mirror.invalid/a.iso';
const seedB = 'http://mirror.invalid/b.iso';

/// Fake server: records every POST and keeps an in-memory seed list.
class WebSeedsController extends AppController {
  WebSeedsController({List<String> seeds = const [], this.postError})
    : seeds = [...seeds];
  List<String> seeds;
  Object? postError;
  final calls = <Map<String, String>>[];
  final reads = <Map<String, String>>[];

  @override
  Future<dynamic> apiGet(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async {
    reads.add({'endpoint': endpoint, ...query});
    return [
      for (final url in seeds) {'url': url},
    ];
  }

  @override
  Future<dynamic> apiPost(String endpoint, Map<String, String> fields) async {
    calls.add({'endpoint': endpoint, ...fields});
    if (postError != null) throw postError!;
    switch (endpoint) {
      case 'torrents/addWebSeeds':
        seeds.addAll(fields['urls']!.split('|'));
      case 'torrents/editWebSeed':
        seeds[seeds.indexOf(fields['origUrl']!)] = fields['newUrl']!;
      case 'torrents/removeWebSeeds':
        seeds.removeWhere(fields['urls']!.split('|').contains);
    }
    return '';
  }
}

/// Fails every read while [shouldFail] returns true, then delegates.
class FailingController extends WebSeedsController {
  FailingController(this.shouldFail);
  final bool Function() shouldFail;
  @override
  Future<dynamic> apiGet(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async {
    if (shouldFail()) {
      error = 'Cannot reach the server. Check its address and connection.';
      throw const QbException('Cannot reach the server.');
    }
    return super.apiGet(endpoint, query);
  }
}

Future<WebSeedsController> pumpScreen(
  WidgetTester tester, {
  List<String> seeds = const [],
  Object? postError,
  String? version,
}) async {
  final controller = WebSeedsController(seeds: seeds, postError: postError)
    ..version = version;
  addTearDown(controller.dispose);
  // Each fixture represents a newly opened route, not a controller swap on an
  // already mounted screen whose initial request has finished.
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: WebSeedsScreen(controller: controller, hash: hash),
    ),
  );
  await tester.pumpAndSettle();
  return controller;
}

Finder rowMenu(String url) => find.descendant(
  of: find.ancestor(of: find.text(url), matching: find.byType(ListTile)),
  matching: find.byType(PopupMenuButton<String>),
);

Future<void> submitAddDialog(WidgetTester tester, String text) async {
  await tester.tap(find.byTooltip('Добавить источники'));
  await tester.pumpAndSettle();
  await tester.enterText(
    find.widgetWithText(TextFormField, 'URL, каждый с новой строки'),
    text,
  );
  await tester.tap(find.text('Применить'));
  await tester.pumpAndSettle();
}

void main() {
  group('URL validation', () {
    test('accepts http and https with a host', () {
      expect(validateWebSeedUrl(seedA), isNull);
      expect(validateWebSeedUrl(seedB), isNull);
      expect(validateWebSeedUrls('$seedA\r\n\n  $seedB  \n'), isNull);
    });
    test('rejects other schemes, empty host, whitespace and control chars', () {
      expect(validateWebSeedUrl('ftp://mirror.invalid/a'), isNotNull);
      expect(validateWebSeedUrl('http://'), isNotNull);
      expect(validateWebSeedUrl('mirror.invalid/a'), isNotNull);
      expect(validateWebSeedUrl('http://mirror.invalid/a b'), isNotNull);
      expect(validateWebSeedUrl('http://mirror.invalid/a\tb'), isNotNull);
      expect(validateWebSeedUrl('http://mirror.invalid/a\x01'), isNotNull);
      expect(validateWebSeedUrl('http://mirror.invalid/a|b'), isNotNull);
      expect(validateWebSeedUrls(''), isNotNull);
      expect(validateWebSeedUrls('$seedA\nftp://x.invalid/a'), isNotNull);
    });
    test('splits lines and detects server support by version', () {
      expect(splitWebSeedUrls(' $seedA \n\n$seedB\r\n'), [seedA, seedB]);
      expect(webSeedEditingSupported('v5.2.0'), isTrue);
      expect(webSeedEditingSupported('v6.0.1'), isTrue);
      expect(webSeedEditingSupported('v5.1.2'), isFalse);
      expect(webSeedEditingSupported('v4.6.7'), isFalse);
      expect(webSeedEditingSupported(null), isNull);
      expect(webSeedEditingSupported('unknown'), isNull);
    });
  });

  testWidgets('lists sources and shows the empty state', (tester) async {
    await pumpScreen(tester);
    expect(find.text('HTTP-источников нет'), findsOneWidget);
    final controller = await pumpScreen(tester, seeds: [seedA, seedB]);
    expect(find.text(seedA), findsOneWidget);
    expect(find.text(seedB), findsOneWidget);
    expect(find.text('HTTP-источников нет'), findsNothing);
    expect(controller.reads, [
      {'endpoint': 'torrents/webseeds', 'hash': hash},
    ]);
    expect(controller.calls, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adds several URLs joined by a pipe and refreshes the list', (
    tester,
  ) async {
    final controller = await pumpScreen(tester);
    await submitAddDialog(tester, '$seedA\n\n  $seedB  \n');
    expect(controller.calls, [
      {
        'endpoint': 'torrents/addWebSeeds',
        'hash': hash,
        'urls': '$seedA|$seedB',
      },
    ]);
    expect(controller.reads, hasLength(2));
    expect(find.text(seedA), findsOneWidget);
    expect(find.text(seedB), findsOneWidget);
    expect(find.text('Изменения применены'), findsOneWidget);
    expect(find.textContaining('addWebSeeds'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rejects invalid URLs before any request', (tester) async {
    final controller = await pumpScreen(tester);
    await submitAddDialog(tester, '$seedA\nftp://mirror.invalid/c');
    expect(find.textContaining('http:// или https://'), findsOneWidget);
    expect(controller.calls, isEmpty);
    expect(controller.reads, hasLength(1));
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(find.text('HTTP-источников нет'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('edits a source with origUrl and newUrl', (tester) async {
    final controller = await pumpScreen(tester, seeds: [seedA]);
    await tester.tap(rowMenu(seedA));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Изменить'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(TextFormField, seedA), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Новый URL'),
      seedB,
    );
    await tester.tap(find.text('Применить'));
    await tester.pumpAndSettle();
    expect(controller.calls, [
      {
        'endpoint': 'torrents/editWebSeed',
        'hash': hash,
        'origUrl': seedA,
        'newUrl': seedB,
      },
    ]);
    expect(find.text(seedB), findsOneWidget);
    expect(find.text(seedA), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('removal requires confirmation and can be cancelled', (
    tester,
  ) async {
    final controller = await pumpScreen(tester, seeds: [seedA, seedB]);
    await tester.tap(rowMenu(seedA));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Удалить'));
    await tester.pumpAndSettle();
    expect(find.text('Удалить HTTP-источник?'), findsOneWidget);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(controller.calls, isEmpty);
    expect(find.text(seedA), findsOneWidget);

    await tester.tap(rowMenu(seedA));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Удалить'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Подтвердить'));
    await tester.pumpAndSettle();
    expect(controller.calls, [
      {'endpoint': 'torrents/removeWebSeeds', 'hash': hash, 'urls': seedA},
    ]);
    expect(find.text(seedA), findsNothing);
    expect(find.text(seedB), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unsupported server reports a version error, not success', (
    tester,
  ) async {
    final controller = await pumpScreen(
      tester,
      version: 'v4.6.7',
      postError: const QbException(
        'The server rejected the request (HTTP 404).',
        statusCode: 404,
      ),
    );
    expect(find.textContaining('qBittorrent 5.2'), findsOneWidget);
    await submitAddDialog(tester, seedA);
    expect(controller.calls, hasLength(1));
    expect(find.text('Изменения применены'), findsNothing);
    expect(find.textContaining('Нужен qBittorrent 5.2'), findsOneWidget);
    expect(find.textContaining('addWebSeeds'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('load failure shows the error and offers retry', (tester) async {
    var fail = true;
    final controller = FailingController(() => fail);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: WebSeedsScreen(controller: controller, hash: hash),
      ),
    );
    await tester.pumpAndSettle();
    final strings = AppLocalizations.of(
      tester.element(find.byType(WebSeedsScreen)),
    )!;
    expect(find.text(strings.message0036), findsOneWidget);
    expect(find.text('Повторить'), findsOneWidget);
    fail = false;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.text('Повторить'), findsNothing);
    expect(find.text('HTTP-источников нет'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('torrent tools opens the sources screen', (tester) async {
    final controller = WebSeedsController(seeds: [seedA]);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TorrentToolsScreen(
          controller: controller,
          torrent: const Torrent(
            hash: hash,
            name: 'Linux',
            size: 1,
            progress: 1,
            dlspeed: 0,
            upspeed: 0,
            state: 'uploading',
            eta: 0,
            category: '',
            ratio: 1,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('HTTP-источники'), 200);
    await tester.ensureVisible(find.text('HTTP-источники'));
    await tester.pumpAndSettle();
    expect(find.text('HTTP-источники').hitTestable(), findsOneWidget);
    await tester.tap(find.text('HTTP-источники'));
    await tester.pumpAndSettle();
    expect(find.text(seedA), findsOneWidget);
    expect(find.byTooltip('Добавить источники'), findsOneWidget);
    expect(controller.reads, [
      {'endpoint': 'torrents/webseeds', 'hash': hash},
    ]);
    expect(tester.takeException(), isNull);
  });
}
