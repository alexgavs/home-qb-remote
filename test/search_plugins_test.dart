import 'package:home_qb_remote/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/features/search_screen.dart';

class PluginController extends AppController {
  final calls = <(String, Map<String, String>)>[];
  bool enabled = false;
  bool installed = true;
  @override
  Future<dynamic> apiGet(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async => installed
      ? [
          {
            'name': 'home',
            'fullName': 'Home index',
            'enabled': enabled,
            'version': '1.0',
          },
        ]
      : [];
  @override
  Future<dynamic> apiPost(String endpoint, Map<String, String> fields) async {
    calls.add((endpoint, Map.of(fields)));
    if (endpoint == 'search/enablePlugin') enabled = fields['enable'] == 'true';
    if (endpoint == 'search/uninstallPlugin') installed = false;
    return null;
  }
}

void main() {
  testWidgets('plugin enable and confirmed removal use server-side endpoints', (
    tester,
  ) async {
    final controller = PluginController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SearchPluginsScreen(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(controller.calls.last.$1, 'search/enablePlugin');
    expect(controller.calls.last.$2, {'names': 'home', 'enable': 'true'});
    await tester.tap(find.byTooltip('Удалить плагин'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(controller.installed, isTrue);
    await tester.tap(find.text('Подтвердить'));
    await tester.pumpAndSettle();
    expect(controller.calls.last.$1, 'search/uninstallPlugin');
    expect(controller.calls.last.$2, {'names': 'home'});
    expect(find.text('На сервере нет поисковых плагинов'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
