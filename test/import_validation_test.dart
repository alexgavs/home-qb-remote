import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/core/import_validation.dart';

void main() {
  test('external URL cannot hide bulk downloads or control characters', () {
    expect(singleIncomingUrl('magnet:?xt=urn:btih:abc'), isNotNull);
    expect(
      singleIncomingUrl('https://example.invalid/file.torrent'),
      isNotNull,
    );
    for (final text in [
      'magnet:?xt=urn:btih:abc\nhttp://localhost/secret',
      'https://example.invalid/a\r\nhttps://example.invalid/b',
      'https://example.invalid/a b',
      'file:///private/file',
      'https://user:password@example.invalid/torrent',
      'https://${'a' * 17000}',
    ]) {
      expect(
        singleIncomingUrl(text),
        isNull,
        reason: 'Incoming URL must be one unambiguous link',
      );
    }
  });
  test(
    'document upload accepts torrent bencode but rejects private/invalid bytes',
    () {
      expect(
        isTorrentFile(utf8.encode('d4:infod4:name4:test6:lengthi1eee')),
        isTrue,
      );
      for (final text in [
        'password=secret',
        'd8:password6:secrete',
        'd4:info6:secrete',
        'd4:infodegarbage',
        'd4:infod1:ni01eee',
        'd4:infod1:ni-0eee',
        'd4:infod1:ni1e',
        'd4:infode4:infodee',
        'd4:infod01:a1:bee',
        'd4:infod1:a999999999:ee',
      ]) {
        expect(
          isTorrentFile(utf8.encode(text)),
          isFalse,
          reason: 'Malformed or non-torrent data must never be uploaded',
        );
      }
      expect(
        isTorrentFile(utf8.encode('d4:infod1:a${'l' * 70}${'e' * 72}')),
        isFalse,
      );
      expect(isTorrentFile(List.filled(16 * 1024 * 1024 + 1, 100)), isFalse);
    },
  );
}
