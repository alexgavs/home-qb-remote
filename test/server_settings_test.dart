import 'package:home_qb_remote/l10n/app_localizations.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/features/server_settings_screen.dart';

class SettingsController extends AppController {
  Map<String, dynamic>? saved;
  @override
  Future<dynamic> apiGet(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async => {
    'save_path': '/downloads',
    'dht': true,
    'pex': true,
    'max_active_torrents': 10,
  };
  @override
  Future<dynamic> apiPost(String endpoint, Map<String, String> fields) async {
    saved = Map<String, dynamic>.from(jsonDecode(fields['json']!) as Map);
    return null;
  }
}

void main() {
  testWidgets('preferences submit only changed fields preserving bool types', (
    tester,
  ) async {
    final controller = SettingsController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ru'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ServerSettingsScreen(controller: controller),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('BitTorrent'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('DHT'));
    await tester.tap(find.byTooltip('Сохранить'));
    await tester.pumpAndSettle();
    expect(controller.saved, {'dht': false});
    expect(tester.takeException(), isNull);
  });
}
