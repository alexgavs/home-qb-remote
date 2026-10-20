import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:home_qb_remote/l10n/app_localizations.dart';

void main() {
  test('result counts use English and Russian plural rules', () async {
    final english = await AppLocalizations.delegate.load(const Locale('en'));
    final russian = await AppLocalizations.delegate.load(const Locale('ru'));
    expect(english.message0158(1, ''), '1 result');
    expect(english.message0158(2, ''), '2 results');
    expect(russian.message0158(1, ''), '1 результат');
    expect(russian.message0158(2, ''), '2 результата');
    expect(russian.message0158(5, ''), '5 результатов');
  });
  test('all eight catalogs contain every message and typed placeholder', () {
    Map<String, dynamic> readCatalog(String language) =>
        Map<String, dynamic>.from(
          jsonDecode(File('lib/l10n/app_$language.arb').readAsStringSync())
              as Map,
        );
    final english = readCatalog('en');
    final keys = english.keys.where((key) => !key.startsWith('@')).toSet();
    expect(
      keys.length,
      greaterThan(100),
      reason: 'The catalog covers the full application.',
    );
    for (final language in ['en', 'ru', 'uk', 'he', 'ar', 'de', 'fr', 'es']) {
      final catalog = readCatalog(language);
      expect(catalog['@@locale'], language);
      expect(
        catalog.keys.where((key) => !key.startsWith('@')).toSet(),
        keys,
        reason: '$language must have complete catalog coverage.',
      );
      for (final key in keys) {
        final message = catalog[key];
        expect(message, isA<String>(), reason: '$language/$key');
        expect(
          (message as String).trim(),
          isNotEmpty,
          reason: '$language/$key',
        );
        final metadata = english['@$key'];
        final placeholders = metadata is Map ? metadata['placeholders'] : null;
        if (placeholders is Map) {
          for (final name in placeholders.keys) {
            expect(
              message,
              contains('{$name'),
              reason: '$language/$key must preserve placeholder $name.',
            );
          }
        }
      }
      if (language != 'en') {
        final identical = keys
            .where((key) => catalog[key] == english[key])
            .length;
        expect(
          identical,
          lessThan(keys.length * 0.35),
          reason:
              '$language must contain translations, not an English fallback copy.',
        );
      }
    }
  });
}
