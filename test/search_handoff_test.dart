import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/core/qb_client.dart';
import 'package:home_qb_remote/features/search_screen.dart';
import 'package:home_qb_remote/features/search_session.dart';
import 'package:home_qb_remote/l10n/l10n.dart';
import 'package:home_qb_remote/ui/add_torrent_dialog.dart';

const serverA = ServerProfile(
  id: 'A',
  name: 'Server A',
  url: 'http://a.invalid',
  username: 'user',
  password: 'secret',
);
const serverB = ServerProfile(
  id: 'B',
  name: 'Server B',
  url: 'http://b.invalid',
  username: 'user',
  password: 'secret',
);
final strings = lookupAppLocalizations(const Locale('en'));
final hash = List.filled(40, 'a').join();
final magnet = 'magnet:?xt=urn:btih:$hash';

class SearchController extends AppController {
  void choose(ServerProfile profile) {
    currentProfile = profile;
    connectionUrl = profile.url;
    notifyListeners();
  }

  @override
  Future<void> refresh() async {}
}

class SearchFixture {
  final calls =
      <({String server, String operation, Map<String, String> fields})>[];
  final clients = <FakeSearchApi>[];
  List<Map<String, dynamic>> rows = [];
  List<Torrent> existing = [];
  Completer<dynamic>? pendingStart;
  Completer<void>? pendingAdd;
  Object? pluginError;
  Object? addError;
  SearchServerApi create(ServerProfile profile) {
    final client = FakeSearchApi(this, profile.id);
    clients.add(client);
    return client;
  }

  Iterable<({String server, String operation, Map<String, String> fields})>
  get additions => calls.where((call) => call.operation == 'torrents/add');
}

class FakeSearchApi implements SearchServerApi {
  FakeSearchApi(this.fixture, this.server);
  final SearchFixture fixture;
  final String server;
  bool closed = false;
  void record(String operation, [Map<String, String> fields = const {}]) =>
      fixture.calls.add((
        server: server,
        operation: operation,
        fields: Map.of(fields),
      ));
  @override
  Future<dynamic> get(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async {
    record(endpoint, query);
    if (endpoint == 'search/plugins') {
      if (fixture.pluginError != null) throw fixture.pluginError!;
      return [];
    }
    if (endpoint == 'search/results') {
      return {'status': 'Stopped', 'results': fixture.rows};
    }
    if (endpoint == 'app/defaultSavePath') return '/downloads';
    if (endpoint == 'torrents/tags') return <String>[];
    return <String, dynamic>{};
  }

  @override
  Future<dynamic> post(String endpoint, Map<String, String> fields) async {
    record(endpoint, fields);
    if (endpoint == 'search/start') {
      return fixture.pendingStart?.future ?? Future.value({'id': 7});
    }
    return '';
  }

  @override
  Future<List<Torrent>> getTorrents() async {
    record('torrents/info');
    return fixture.existing;
  }

  @override
  Future<void> addUrls(
    String urls, {
    Map<String, String> options = const {},
  }) async {
    record('torrents/add', {'urls': urls, ...options});
    if (fixture.addError != null) throw fixture.addError!;
    await fixture.pendingAdd?.future;
  }

  @override
  void close() {
    closed = true;
  }
}

Future<void> pumpSearch(
  WidgetTester tester,
  SearchController controller,
  SearchFixture fixture,
) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: TypedSearchScreen(
        controller: controller,
        apiFactory: fixture.create,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> runSearch(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).first, 'Ubuntu');
  await tester.tap(find.text(strings.message0168));
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  testWidgets('invalid certificate factory failures remain recoverable', (
    tester,
  ) async {
    final controller = SearchController()..choose(serverA);
    addTearDown(controller.dispose);
    var attempts = 0;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: TypedSearchScreen(
          controller: controller,
          apiFactory: (_) {
            attempts++;
            throw const FormatException('Invalid custom certificate');
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text(strings.message0156), findsOneWidget);
    await runSearch(tester);
    expect(tester.takeException(), isNull);
    expect(find.text(strings.message0161), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsNothing);
    await runSearch(tester);
    expect(attempts, 3);
    expect(tester.takeException(), isNull);
  });

  test('magnet identities normalize v1 base32/hex and keep full v2 hashes', () {
    expect(magnetInfoHashes('magnet:?xt=urn:btih:${'A' * 32}'), {'0' * 40});
    expect(magnetInfoHashes('magnet:?xt=urn:btih:${'B' * 40}'), {'b' * 40});
    expect(magnetInfoHashes('magnet:?xt=urn:btmh:1220${'c' * 64}'), {'c' * 64});
    expect(magnetInfoHashes('magnet:?xt=urn:btih:bad'), isEmpty);
    expect(supportedSearchDownload('javascript:alert(1)'), isFalse);
    expect(
      safeSearchTitle('Title https://secret.invalid/key', 'Hidden'),
      'Hidden',
    );
  });

  test(
    'cleanup collects a late start response exactly once on its original API',
    () async {
      final fixture = SearchFixture()..pendingStart = Completer<dynamic>();
      final api = fixture.create(serverA) as FakeSearchApi;
      final job = BoundSearchJob(api);
      final start = job.start({'pattern': 'test'});
      final cleanup = job.cleanup();
      expect(api.closed, isFalse);
      fixture.pendingStart!.complete({'id': 37});
      expect(await start, 37);
      await cleanup;
      await job.cleanup();
      expect(fixture.calls.map((call) => '${call.server}/${call.operation}'), [
        'A/search/start',
        'A/search/stop',
        'A/search/delete',
      ]);
      expect(fixture.calls.last.fields, {'id': '37'});
      expect(api.closed, isTrue);
    },
  );

  testWidgets(
    'secret URLs stay hidden and a confirmed handoff submits once with options',
    (tester) async {
      final controller = SearchController()..choose(serverA);
      addTearDown(controller.dispose);
      final fixture = SearchFixture()
        ..pendingAdd = Completer<void>()
        ..rows = [
          {
            'fileName': 'Ubuntu',
            'fileUrl': 'https://index.invalid/private/PASSKEY?apikey=TOPSECRET',
            'siteUrl': 'https://index.invalid/path/TOPSECRET',
            'fileSize': 1024,
            'nbSeeders': 4,
          },
        ];
      await pumpSearch(tester, controller, fixture);
      await runSearch(tester);
      expect(find.textContaining('TOPSECRET'), findsNothing);
      await tester.tap(find.byTooltip(strings.message0181));
      await tester.pumpAndSettle();
      expect(fixture.additions, isEmpty);
      expect(
        find.text(strings.searchDownloadTarget('Server A')),
        findsOneWidget,
      );
      expect(find.textContaining('TOPSECRET'), findsNothing);
      await tester.enterText(
        find.widgetWithText(TextFormField, strings.message0148),
        'Linux',
      );
      await tester.tap(find.text(strings.searchConfirmAdd));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(
        find.byTooltip(strings.message0181),
        warnIfMissed: false,
      );
      expect(fixture.additions, hasLength(1));
      expect(fixture.additions.single.server, 'A');
      expect(fixture.additions.single.fields['category'], 'Linux');
      fixture.pendingAdd!.complete();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(strings.message0181));
      await tester.pumpAndSettle();
      expect(fixture.additions, hasLength(1));
    },
  );

  testWidgets('profile change while confirming cannot send to either server', (
    tester,
  ) async {
    final controller = SearchController()..choose(serverA);
    addTearDown(controller.dispose);
    final fixture = SearchFixture()
      ..rows = [
        {'fileName': 'Ubuntu', 'fileUrl': magnet},
      ];
    await pumpSearch(tester, controller, fixture);
    await runSearch(tester);
    await tester.tap(find.byTooltip(strings.message0181));
    await tester.pumpAndSettle();
    controller.choose(serverB);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, strings.searchConfirmAdd),
          )
          .onPressed,
      isNull,
    );
    expect(fixture.additions, isEmpty);
    await tester.tap(find.text(strings.message0043));
    await tester.pumpAndSettle();
    expect(fixture.additions, isEmpty);
  });

  testWidgets(
    'fresh magnet lookup suppresses a torrent already on the selected server',
    (tester) async {
      final controller = SearchController()..choose(serverA);
      addTearDown(controller.dispose);
      final fixture = SearchFixture()
        ..rows = [
          {'fileName': 'Ubuntu', 'fileUrl': magnet},
        ]
        ..existing = [
          Torrent(
            hash: hash,
            name: 'Existing',
            size: 1,
            progress: 1,
            dlspeed: 0,
            upspeed: 0,
            state: 'uploading',
            eta: 0,
            category: '',
            ratio: 0,
          ),
        ];
      await pumpSearch(tester, controller, fixture);
      await runSearch(tester);
      await tester.tap(find.byTooltip(strings.message0181));
      await tester.pumpAndSettle();
      await tester.tap(find.text(strings.searchConfirmAdd));
      await tester.pumpAndSettle();
      expect(fixture.additions, isEmpty);
      expect(find.text(strings.searchAlreadyAdded), findsOneWidget);
    },
  );

  testWidgets(
    'definitive authentication failure blocks opening another route',
    (tester) async {
      final controller = SearchController()..choose(serverA);
      addTearDown(controller.dispose);
      final fixture = SearchFixture()
        ..pluginError = const QbAuthenticationException(
          'Sign-in was rejected. Check the server credentials and WebUI access settings, then reconnect.',
        );
      await pumpSearch(tester, controller, fixture);
      expect(controller.requiresAuthentication, isTrue);
      expect(fixture.clients, hasLength(1));
      await tester.pumpWidget(const SizedBox());
      await pumpSearch(tester, controller, fixture);
      expect(fixture.clients, hasLength(1));
    },
  );

  testWidgets('late search start cleans up A after selecting B', (
    tester,
  ) async {
    final controller = SearchController()..choose(serverA);
    addTearDown(controller.dispose);
    final fixture = SearchFixture()..pendingStart = Completer<dynamic>();
    await pumpSearch(tester, controller, fixture);
    await tester.enterText(find.byType(TextField).first, 'Ubuntu');
    await tester.tap(find.text(strings.message0168));
    await tester.pump();
    controller.choose(serverB);
    await tester.pump();
    fixture.pendingStart!.complete({'id': 91});
    await tester.pumpAndSettle();
    final cleanup = fixture.calls.where(
      (call) => ['search/stop', 'search/delete'].contains(call.operation),
    );
    expect(cleanup, hasLength(2));
    expect(
      cleanup.every((call) => call.server == 'A' && call.fields['id'] == '91'),
      isTrue,
    );
    expect(
      fixture.calls.where(
        (call) =>
            call.server == 'B' &&
            call.operation.startsWith('search/') &&
            call.operation != 'search/plugins',
      ),
      isEmpty,
    );
  });

  testWidgets('ambiguous submission exposes a read-only check without replay', (
    tester,
  ) async {
    final controller = SearchController()..choose(serverA);
    addTearDown(controller.dispose);
    final fixture = SearchFixture()
      ..rows = [
        {
          'fileName': 'Ubuntu',
          'fileUrl': 'https://index.invalid/TOPSECRET',
          'nbSeeders': 'https://index.invalid/TOPSECRET',
        },
      ]
      ..addError = TimeoutException('private details');
    await pumpSearch(tester, controller, fixture);
    await runSearch(tester);
    expect(find.textContaining('TOPSECRET'), findsNothing);
    await tester.tap(find.byTooltip(strings.message0181));
    await tester.pumpAndSettle();
    await tester.tap(find.text(strings.searchConfirmAdd));
    await tester.pumpAndSettle();
    expect(find.text(strings.searchAddOutcomeUnknown), findsOneWidget);
    await tester.tap(find.text(strings.searchCheckServer));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip(strings.message0181));
    await tester.pumpAndSettle();
    expect(fixture.additions, hasLength(1));
    expect(
      fixture.calls.where((call) => call.operation == 'torrents/info'),
      hasLength(1),
    );
    expect(find.textContaining('private details'), findsNothing);
  });

  testWidgets('file payload confirmation returns captured target and options', (
    tester,
  ) async {
    final controller = SearchController()..choose(serverA);
    addTearDown(controller.dispose);
    AddTorrentRequest? request;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                request = await showDialog<AddTorrentRequest>(
                  context: context,
                  builder: (_) => AddTorrentDialog(
                    controller: controller,
                    targetProfile: serverA,
                    filePayload: true,
                    downloadTitle: 'Ubuntu',
                    hideUrls: true,
                    showFilePicker: false,
                    loadSuggestions: (endpoint) async =>
                        endpoint == 'app/defaultSavePath'
                        ? '/media'
                        : endpoint == 'torrents/tags'
                        ? []
                        : {},
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text(strings.message0462), findsNothing);
    await tester.tap(find.text(strings.searchConfirmAdd));
    await tester.pumpAndSettle();
    expect(request!.file, isTrue);
    expect(request!.urls, isEmpty);
    expect(request!.targetProfile, same(serverA));
    expect(request!.options['savepath'], '/media');
  });
}
