import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/l10n/error_messages.dart';
import 'package:home_qb_remote/l10n/l10n.dart';

void main() {
  for (final language in ['en', 'ru', 'uk', 'he', 'ar', 'de', 'fr', 'es']) {
    test('$language errors translate only safe known identifiers', () async {
      final l10n = await AppLocalizations.delegate.load(Locale(language));
      expect(
        localizeError(l10n, 'The server connection is closed.'),
        l10n.message0015,
      );
      expect(
        localizeError(l10n, 'The server rejected the request (HTTP 429).'),
        l10n.message0034('429'),
      );
      expect(
        localizeError(l10n, 'The server rejected the request (HTTP 999).'),
        l10n.message0007,
      );
      expect(
        localizeError(
          l10n,
          'Unexpected secret=do-not-show https://private.invalid',
        ),
        l10n.message0007,
      );
    });
  }
}
