import 'package:home_qb_remote/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/ui/add_torrent_dialog.dart';

class SuggestionController extends AppController {
  @override
  Future<dynamic> apiGet(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async {
    if (endpoint == 'app/defaultSavePath') return '/downloads';
    if (endpoint == 'torrents/categories') return {'Linux': {}};
    if (endpoint == 'torrents/tags') return ['home'];
    throw StateError('Unexpected request');
  }
}

void main() {
  for (final major in [4, 5]) {
    testWidgets('add options preserve server API contract v$major', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1100, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = SuggestionController()..version = 'v$major.0.0';
      addTearDown(controller.dispose);
      AddTorrentRequest? result;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ru'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await showDialog<AddTorrentRequest>(
                    context: context,
                    builder: (_) => AddTorrentDialog(controller: controller),
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
      await tester.enterText(
        find.byType(TextFormField).first,
        'magnet:?xt=urn:btih:abc',
      );
      await tester.tap(find.text('Параметры загрузки'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Linux'));
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Лимит загрузки, КиБ/с'),
        '64',
      );
      await tester.ensureVisible(find.text('Добавить остановленным'));
      await tester.tap(find.text('Добавить остановленным'));
      await tester.tap(find.text('Добавить').last);
      await tester.pumpAndSettle();
      expect(result, isNotNull);
      expect(result!.file, isFalse);
      expect(result!.options['savepath'], '/downloads');
      expect(result!.options['category'], 'Linux');
      expect(result!.options['dlLimit'], '65536');
      expect(result!.options[major == 5 ? 'stopped' : 'paused'], 'true');
      expect(
        result!.options.containsKey(major == 5 ? 'paused' : 'stopped'),
        isFalse,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
