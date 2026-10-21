import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/integrations/integration_store.dart';
import 'package:home_qb_remote/integrations/integrations_screen.dart';
import 'package:home_qb_remote/l10n/l10n.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  testWidgets(
    'optional profile can be saved without a qB server and secrets stay out of the list',
    (tester) async {
      final controller = AppController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('he'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: IntegrationsScreen(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(Scaffold)).l10n;
      expect(
        Directionality.of(tester.element(find.byType(Scaffold))),
        TextDirection.rtl,
      );
      await tester.tap(find.text(l10n.integrationAddJackett));
      await tester.pumpAndSettle();
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Home search');
      await tester.enterText(fields.at(1), 'http://localhost:9117');
      await tester.enterText(fields.at(2), 'private-fixture-key');
      final secretField = tester.widget<TextField>(
        find.descendant(of: fields.at(2), matching: find.byType(TextField)),
      );
      expect(secretField.obscureText, true);
      await tester.tap(find.text(l10n.integrationSave));
      await tester.pumpAndSettle();
      expect(find.text('Home search'), findsOneWidget);
      expect(find.textContaining('private-fixture-key'), findsNothing);
      expect(find.textContaining('localhost'), findsNothing);
      final document = jsonDecode(
        (await const FlutterSecureStorage().read(
          key: IntegrationStore.storageKey,
        ))!,
      );
      expect(document['jackett'][0]['apiKey'], 'private-fixture-key');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'corrupt protected document exposes retry and refuses profile replacement',
    (tester) async {
      FlutterSecureStorage.setMockInitialValues({
        IntegrationStore.storageKey: 'corrupt existing document',
      });
      final controller = AppController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: IntegrationsScreen(controller: controller),
        ),
      );
      await tester.pumpAndSettle();
      final l10n = tester.element(find.byType(Scaffold)).l10n;
      expect(find.text(l10n.integrationStorageFailed), findsOneWidget);
      expect(find.text(l10n.integrationAddJackett), findsNothing);
      expect(
        await const FlutterSecureStorage().read(
          key: IntegrationStore.storageKey,
        ),
        'corrupt existing document',
      );
    },
  );
}
