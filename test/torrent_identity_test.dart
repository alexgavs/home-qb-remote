import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/integrations/torrent_identity.dart';

void main() {
  List<int> torrent(String info) =>
      utf8.encode('d8:announce14:https://x.test4:info${info}e');
  test(
    'v1 hash uses original encoded info bytes and ignores top-level keys',
    () {
      const info = 'd4:name4:test6:lengthi3ee'; // deliberately unsorted: never canonicalize
      final hashes = torrentInfoHashes(torrent(info));
      expect(hashes, {sha1.convert(utf8.encode(info)).toString()});
      expect(torrentInfoHashes(utf8.encode('d4:info${info}e')), hashes);
    },
  );
  test('pure v2 SHA256 and hybrid both identities', () {
    const v2 = 'd12:meta versioni2e4:name4:teste';
    expect(torrentInfoHashes(torrent(v2)), {
      sha256.convert(utf8.encode(v2)).toString(),
    });
    const hybrid = 'd12:meta versioni2e6:pieces0:4:name4:teste';
    expect(torrentInfoHashes(torrent(hybrid)), {
      sha1.convert(utf8.encode(hybrid)).toString(),
      sha256.convert(utf8.encode(hybrid)).toString(),
    });
  });
  test(
    'exact matching is case insensitive; truncated v2 requires explicit flag',
    () {
      final hash = sha256.convert(utf8.encode('fixture')).toString();
      expect(matchesTorrentIdentity({hash}, hash.toUpperCase()), isTrue);
      expect(matchesTorrentIdentity({hash}, hash.substring(0, 40)), isFalse);
      expect(
        matchesTorrentIdentity(
          {hash},
          hash.substring(0, 40),
          allowTruncatedV2: true,
        ),
        isTrue,
      );
      expect(
        matchesTorrentIdentity({hash}, 'not-a-hash', allowTruncatedV2: true),
        isFalse,
      );
    },
  );
  test(
    'rejects malformed, duplicate info, and duplicate identity metadata',
    () {
      for (final text in [
        'not bencode',
        'd4:infod4:name4:testeejunk',
        'd4:infode4:infodee',
        'd4:infod12:meta versioni2e12:meta versioni1eee',
      ]) {
        expect(
          () => torrentInfoHashes(utf8.encode(text)),
          throwsFormatException,
        );
      }
    },
  );
}
