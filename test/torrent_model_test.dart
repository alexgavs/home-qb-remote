import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/core/models.dart';

void main() {
  test('preserves added_on Unix seconds for newest-first sorting', () {
    final older = Torrent.fromJson({'hash': 'old', 'added_on': 1700000000});
    final newer = Torrent.fromJson({'hash': 'new', 'added_on': 1700000005});
    expect(older.addedOn, 1700000000);
    expect(newer.addedOn, greaterThan(older.addedOn));
    expect(Torrent.fromJson({'added_on': '1700000005'}).addedOn, 1700000005);
  });
  test(
    'missing or invalid timestamps remain unknown without breaking a list',
    () {
      expect(Torrent.fromJson({}).addedOn, 0);
      for (final value in [
        null,
        '',
        'invalid',
        -1,
        double.nan,
        double.infinity,
      ]) {
        expect(Torrent.fromJson({'added_on': value}).addedOn, 0);
      }
    },
  );
}
