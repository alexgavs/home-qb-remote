import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/integrations/jellyfin_client.dart';
import 'package:home_qb_remote/integrations/jellyfin_models.dart';
import 'package:home_qb_remote/integrations/jellyfin_screen.dart';
import 'package:home_qb_remote/l10n/l10n.dart';

const profile = JellyfinProfile(
  id: 'fake',
  name: 'Library fixture',
  url: 'https://library.invalid/media',
  accessToken: 'never-sent-fixture-token',
  userId: '0123456789abcdef0123456789abcdef',
);

class FixtureClient extends JellyfinClient {
  FixtureClient() : super(profile);
  final queries = <String>[];
  JellyfinErrorCode? failure;
  bool closed = false;

  @override
  Future<List<JellyfinItem>> search(String query) async {
    queries.add(query);
    if (failure != null) throw JellyfinException(failure!);
    return [
      JellyfinItem(
        id: 'fixture',
        title: query.isEmpty ? 'Fixture film' : 'Found fixture',
        year: 2025,
        overview: '<b>Uninterpreted server overview</b>',
      ),
    ];
  }

  @override
  void close() {
    closed = true;
    super.close();
  }
}

void main() {
  testWidgets('RTL library searches and details remain read-only', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final client = FixtureClient();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('he'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: JellyfinLibraryScreen(
          profile: profile,
          clientFactory: (_) => client,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(Scaffold));
    final l10n = context.l10n;
    expect(Directionality.of(context), TextDirection.rtl);
    expect(find.text(l10n.jellyfinLibraryTitle), findsOneWidget);
    expect(find.text(l10n.jellyfinReadOnlyNotice), findsOneWidget);
    expect(client.queries, ['']);
    expect(find.text('Fixture film'), findsOneWidget);
    await tester.tap(find.text('Fixture film'));
    await tester.pumpAndSettle();
    expect(find.text('<b>Uninterpreted server overview</b>'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
    expect(find.byIcon(Icons.download), findsNothing);
    await tester.tap(find.text(l10n.jellyfinClose));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'new query');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(client.queries, ['', 'new query']);
    expect(find.text('Found fixture'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    expect(client.closed, isTrue);
  });

  testWidgets('safe authentication errors localize and retry is explicit', (
    tester,
  ) async {
    final client = FixtureClient()..failure = JellyfinErrorCode.authentication;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: JellyfinLibraryScreen(
          profile: profile,
          clientFactory: (_) => client,
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = tester.element(find.byType(Scaffold)).l10n;
    expect(find.text(l10n.jellyfinAuthenticationFailed), findsOneWidget);
    expect(find.textContaining(profile.accessToken), findsNothing);
    expect(client.queries, ['']);
    client.failure = null;
    await tester.tap(find.text(l10n.jellyfinRetry));
    await tester.pumpAndSettle();
    expect(client.queries, ['', '']);
    expect(find.text('Fixture film'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
