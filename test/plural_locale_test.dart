import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/l10n/app_localizations.dart';

void main() {
  test('Ukrainian result counts follow one, few and many rules', () async {
    final strings = await AppLocalizations.delegate.load(const Locale('uk'));
    expect(strings.message0158(1, ''), '1 результат');
    expect(strings.message0158(2, ''), '2 результати');
    expect(strings.message0158(5, ''), '5 результатів');
    expect(strings.message0158(21, ''), '21 результат');
    expect(strings.message0378(2), '2 фрагменти');
    expect(strings.message0378(5), '5 фрагментів');
  });
}
