import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/core/qb_client.dart';
import 'package:home_qb_remote/integrations/jackett_client.dart';
import 'package:home_qb_remote/integrations/jackett_models.dart';
import 'package:home_qb_remote/integrations/jackett_screen.dart';
import 'package:home_qb_remote/integrations/torrent_identity.dart';
import 'package:home_qb_remote/l10n/l10n.dart';

const profile = JackettProfile(
  id: 'j',
  name: 'Search fixture',
  url: 'https://search.invalid',
  apiKey: 'private-jackett-key',
);
const target = ServerProfile(
  id: 'q',
  name: 'Chosen NAS',
  url: 'https://qb.invalid',
  username: 'user',
  password: 'qb-password',
);
final torrentBytes = utf8.encode('d4:infod4:name4:testee');

class _Controller extends AppController {
  @override
  Future<void> refresh() async {}
  void changeTarget() {
    currentProfile = target.withUrl('https://other.invalid');
    notifyListeners();
  }
}

class _Jackett extends JackettClient {
  _Jackett({
    this.magnet = false,
    this.maliciousTitle = false,
    this.alternate = false,
  }) : super(profile);
  final bool magnet, maliciousTitle, alternate;
  int downloads = 0;
  @override
  Future<List<JackettResult>> search(String query) async => [
    JackettResult(
      title: maliciousTitle
          ? 'https://tracker.invalid/passkey-secret/file'
          : 'Fixture result',
      downloadUri: Uri.parse(
        'https://search.invalid/download?apikey=private-jackett-key',
      ),
      magnetUri: magnet
          ? Uri.parse(
              'magnet:?xt=urn:btih:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
            )
          : null,
    ),
    if (alternate)
      JackettResult(
        title: 'Another indexer',
        downloadUri: Uri.parse('https://search.invalid/other-download'),
      ),
  ];
  @override
  Future<List<int>> downloadTorrent(JackettResult result) async {
    downloads++;
    return torrentBytes;
  }
}

class _Qb extends QbClient {
  _Qb() : super(target);
  bool loggedIn = false;
  bool ambiguous = false;
  int mutations = 0;
  List<int>? bytes;
  String? urls;
  List<Torrent> existing = [];
  @override
  Future<void> login() async {
    loggedIn = true;
  }

  @override
  Future<dynamic> get(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async {
    expect(
      loggedIn,
      true,
      reason: 'The new captured client must explicitly sign in.',
    );
    return switch (endpoint) {
      'app/defaultSavePath' => '/downloads',
      'torrents/categories' => <String, dynamic>{},
      _ => <dynamic>[],
    };
  }

  @override
  Future<List<Torrent>> getTorrents() async {
    expect(loggedIn, true);
    return existing;
  }

  @override
  Future<void> addTorrentFile(
    String name,
    List<int> bytes, {
    Map<String, String> options = const {},
  }) async {
    mutations++;
    this.bytes = bytes;
    expect(options.toString(), isNot(contains(profile.apiKey)));
    if (ambiguous) throw const QbException('Timed out');
  }

  @override
  Future<void> addUrls(
    String urls, {
    Map<String, String> options = const {},
  }) async {
    mutations++;
    this.urls = urls;
  }
}

Future<void> frames(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));

  Future<AppLocalizations> open(
    WidgetTester tester,
    _Controller controller,
    _Jackett jackett,
    _Qb qb, {
    String language = 'en',
    bool invalidClient = false,
    Size size = const Size(900, 1000),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    controller.currentProfile = target;
    controller.version = '5.2.3';
    await tester.pumpWidget(
      MaterialApp(
        locale: Locale(language),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: JackettSearchScreen(
          profile: profile,
          controller: controller,
          jackettFactory: (_) => jackett,
          qbFactory: (_) => invalidClient
              ? throw const QbException('Invalid certificate fixture')
              : qb,
        ),
      ),
    );
    final l10n = tester.element(find.byType(Scaffold)).l10n;
    await tester.enterText(find.byType(TextField), 'fixture');
    await tester.tap(find.text(l10n.jackettSearchAction));
    await frames(tester);
    return l10n;
  }

  testWidgets('small phone keeps Jackett results reachable with IME insets', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 592);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 240);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);
    final controller = _Controller();
    addTearDown(controller.dispose);
    final service = _Jackett();
    final qb = _Qb();
    await open(tester, controller, service, qb, size: const Size(360, 592));
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).first)
          .focusNode
          .hasFocus,
      isFalse,
    );
    await tester.scrollUntilVisible(
      find.text('Fixture result'),
      120,
      scrollable: find
          .descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('Fixture result').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(service.downloads, 0);
    expect(qb.mutations, 0);
  });

  testWidgets(
    'confirmed torrent uploads bytes, never the Jackett URL or key; repeated add is blocked',
    (tester) async {
      final controller = _Controller();
      final service = _Jackett();
      final qb = _Qb();
      addTearDown(controller.dispose);
      final l10n = await open(tester, controller, service, qb);
      expect(qb.mutations, 0);
      expect(find.textContaining(profile.apiKey), findsNothing);
      await tester.tap(find.byTooltip(l10n.jackettDownloadAction));
      await frames(tester);
      expect(find.text(l10n.searchDownloadTarget(target.name)), findsOneWidget);
      expect(qb.mutations, 0);
      await tester.tap(find.text(l10n.searchConfirmAdd));
      await frames(tester);
      expect(qb.mutations, 1);
      expect(qb.bytes, torrentBytes);
      expect(qb.urls, isNull);
      expect(find.text(l10n.torrentSubmitted), findsOneWidget);
      await tester.tap(find.text(l10n.viewDownloads));
      await frames(tester);
      expect(controller.showDownloadsRevision, 1);
      expect(qb.mutations, 1);
      await tester.tap(find.byTooltip(l10n.jackettDownloadAction));
      await frames(tester);
      expect(qb.mutations, 1);
      expect(find.text(l10n.searchAlreadyAdded), findsOneWidget);
    },
  );

  testWidgets(
    'profile change during confirmation never submits to either server',
    (tester) async {
      final controller = _Controller();
      final service = _Jackett();
      final qb = _Qb();
      addTearDown(controller.dispose);
      final l10n = await open(tester, controller, service, qb);
      await tester.tap(find.byTooltip(l10n.jackettDownloadAction));
      await frames(tester);
      controller.changeTarget();
      await frames(tester);
      expect(find.text(l10n.searchProfileChanged), findsOneWidget);
      expect(qb.mutations, 0);
      expect(service.downloads, 0);
    },
  );

  testWidgets(
    'ambiguous mutation is not repeated and reports a read-only check',
    (tester) async {
      final controller = _Controller();
      final service = _Jackett();
      final qb = _Qb()..ambiguous = true;
      addTearDown(controller.dispose);
      final l10n = await open(tester, controller, service, qb);
      await tester.tap(find.byTooltip(l10n.jackettDownloadAction));
      await frames(tester);
      await tester.tap(find.text(l10n.searchConfirmAdd));
      await frames(tester);
      expect(find.text(l10n.searchAddOutcomeUnknown), findsOneWidget);
      expect(qb.mutations, 1);
      await tester.tap(find.byTooltip(l10n.jackettDownloadAction));
      await frames(tester);
      expect(qb.mutations, 1);
    },
  );

  testWidgets('known info hash prevents upload even when result URL differs', (
    tester,
  ) async {
    final controller = _Controller();
    final service = _Jackett();
    final qb = _Qb();
    qb.existing = [
      Torrent(
        hash: torrentInfoHashes(torrentBytes).single,
        name: 'Existing',
        size: 1,
        progress: 0,
        dlspeed: 0,
        upspeed: 0,
        state: 'stoppedDL',
        eta: 0,
        category: '',
        ratio: 0,
      ),
    ];
    addTearDown(controller.dispose);
    final l10n = await open(tester, controller, service, qb);
    await tester.tap(find.byTooltip(l10n.jackettDownloadAction));
    await frames(tester);
    await tester.tap(find.text(l10n.searchConfirmAdd));
    await frames(tester);
    expect(qb.mutations, 0);
    expect(find.text(l10n.searchAlreadyAdded), findsOneWidget);
  });

  testWidgets(
    'Hebrew search hides source secrets and forwards only a confirmed magnet',
    (tester) async {
      final controller = _Controller();
      final service = _Jackett(magnet: true, maliciousTitle: true);
      final qb = _Qb();
      addTearDown(controller.dispose);
      final l10n = await open(tester, controller, service, qb, language: 'he');
      expect(
        Directionality.of(tester.element(find.byType(Scaffold))),
        TextDirection.rtl,
      );
      expect(find.textContaining('passkey-secret'), findsNothing);
      await tester.tap(find.byTooltip(l10n.jackettDownloadAction));
      await frames(tester);
      expect(find.textContaining('passkey-secret'), findsNothing);
      await tester.tap(find.text(l10n.searchConfirmAdd));
      await frames(tester);
      expect(qb.mutations, 1);
      expect(qb.urls, startsWith('magnet:?xt=urn:btih:'));
      expect(service.downloads, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'uncertain torrent identity blocks the same torrent from another indexer',
    (tester) async {
      final controller = _Controller();
      final service = _Jackett(alternate: true);
      final qb = _Qb()..ambiguous = true;
      addTearDown(controller.dispose);
      final l10n = await open(tester, controller, service, qb);
      await tester.tap(find.byTooltip(l10n.jackettDownloadAction).first);
      await frames(tester);
      await tester.tap(find.text(l10n.searchConfirmAdd));
      await frames(tester);
      expect(qb.mutations, 1);
      await tester.tap(find.byTooltip(l10n.jackettDownloadAction).last);
      await frames(tester);
      await tester.tap(find.text(l10n.searchConfirmAdd));
      await frames(tester);
      expect(qb.mutations, 1);
      expect(find.text(l10n.searchAlreadyAdded), findsOneWidget);
    },
  );

  testWidgets(
    'invalid transport configuration is a localized error without a mutation',
    (tester) async {
      final controller = _Controller();
      final service = _Jackett();
      final qb = _Qb();
      addTearDown(controller.dispose);
      final l10n = await open(
        tester,
        controller,
        service,
        qb,
        invalidClient: true,
      );
      await tester.tap(find.byTooltip(l10n.jackettDownloadAction));
      await frames(tester);
      expect(find.text(l10n.jackettDownloadFailed), findsOneWidget);
      expect(qb.mutations, 0);
      expect(tester.takeException(), isNull);
    },
  );
}
