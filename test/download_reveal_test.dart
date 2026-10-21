import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/l10n/l10n.dart';
import 'package:home_qb_remote/ui/home_screen.dart';

class RevealController extends AppController {
  void pulse() => notifyListeners();
  @override
  Future<void> refresh() async {}
}

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  testWidgets(
    'newest of 95 is first and explicit profile-bound reveal clears filters and scroll',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = RevealController();
      addTearDown(c.dispose);
      const profile = ServerProfile(
        id: 'a',
        name: 'Fixture NAS',
        url: 'http://fixture.invalid',
        username: '',
        password: '',
      );
      c.currentProfile = profile;
      c.profiles = [profile];
      c.torrents = [
        for (var i = 0; i < 95; i++)
          Torrent(
            hash: 'hash$i',
            name: i == 94 ? 'Newest download' : 'Old item $i',
            addedOn: i == 94 ? 9999 : i,
            size: 100,
            progress: i == 94 ? .1 : 1,
            dlspeed: 0,
            upspeed: 0,
            state: i == 94 ? 'downloading' : 'uploading',
            eta: 0,
            category: '',
            ratio: 0,
          ),
      ];
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(controller: c),
        ),
      );
      final l = lookupAppLocalizations(const Locale('en'));
      expect(find.text('Newest download').hitTestable(), findsOneWidget);
      final list = find.byType(CustomScrollView);
      await tester.drag(list, const Offset(0, -1200));
      await tester.pumpAndSettle();
      expect(find.text('Newest download').hitTestable(), findsNothing);
      expect(c.requestShowDownloads(profile), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Newest download').hitTestable(), findsOneWidget);
      final search = find.byType(TextField).first;
      await tester.enterText(search, 'Old item');
      c.pulse();
      await tester.pump();
      expect(tester.widget<TextField>(search).controller!.text, 'Old item');
      expect(c.requestShowDownloads(profile.withUrl(profile.url)), isFalse);
      await tester.pump();
      expect(tester.widget<TextField>(search).controller!.text, 'Old item');
      await tester.tap(find.widgetWithText(ChoiceChip, l.message0487));
      await tester.pump();
      expect(find.text('Newest download'), findsNothing);
      expect(c.requestShowDownloads(profile), isTrue);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(search).controller!.text, isEmpty);
      expect(find.text('Newest download').hitTestable(), findsOneWidget);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, l.message0172))
            .selected,
        isTrue,
      );
      await tester.tap(find.widgetWithText(ChoiceChip, l.message0486));
      await tester.pump();
      expect(find.text('Newest download').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
