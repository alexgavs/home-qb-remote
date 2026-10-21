import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/integrations/jackett_client.dart';
import 'package:home_qb_remote/integrations/jackett_models.dart';

const fakeKey = 'invented-jackett-key';
String feed(String items) =>
    '<rss xmlns:torznab="http://torznab.com/schemas/2015/feed"><channel>$items</channel></rss>';
String item(String uri, {String extra = ''}) =>
    '<item><title>Invented title</title><enclosure url="$uri" length="123" />$extra</item>';
Matcher failure(String code) =>
    isA<JackettException>().having((e) => e.code, 'code', code);

void main() {
  late HttpServer server;
  late JackettClient client;
  late JackettProfile profile;
  late FutureOr<void> Function(HttpRequest) handler;
  late List<HttpRequest> requests;
  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    profile = JackettProfile(
      id: 'fixture',
      name: 'Fixture',
      url: 'http://127.0.0.1:${server.port}/jackett',
      apiKey: fakeKey,
    );
    requests = [];
    handler = (request) {
      request.response.write(feed(item('/jackett/download')));
    };
    server.listen((request) async {
      requests.add(request);
      try {
        await handler(request);
        await request.response.close();
      } catch (_) {
        request.response.close();
      }
    });
    client = JackettClient(profile);
  });
  tearDown(() async {
    client.close();
    await server.close(force: true);
  });

  test('profiles round trip and errors redact endpoint/key', () {
    expect(JackettProfile.fromJson(profile.toJson()).apiKey, fakeKey);
    expect(
      const JackettException('network').toString(),
      'JackettException(network)',
    );
    expect(
      () => JackettClient(
        JackettProfile(
          id: 'x',
          name: 'x',
          url: 'https://user:secret@example.test',
          apiKey: fakeKey,
        ),
      ),
      throwsA(failure('invalid_profile')),
    );
  });

  test(
    'Torznab search uses independent key and no qB cookie or auth',
    () async {
      handler = (request) {
        expect(
          request.uri.path,
          '/jackett/api/v2.0/indexers/all/results/torznab/api',
        );
        expect(request.uri.queryParameters, {
          't': 'search',
          'q': 'test query',
          'apikey': fakeKey,
        });
        expect(request.headers.value('authorization'), isNull);
        expect(request.cookies, isEmpty);
        request.response.write(
          feed(
            item(
              '/jackett/download',
              extra: '<torznab:attr name="size" value="999"/><torznab:attr name="seeders" value="7"/><jackettindexer id="fixture">Fixture</jackettindexer>',
            ),
          ),
        );
      };
      final results = await client.search('test query');
      expect(results.single.title, 'Invented title');
      expect(results.single.size, 999);
      expect(results.single.seeders, 7);
      expect(results.single.indexer, 'Fixture');
    },
  );

  test('accepts explicit indexer Torznab endpoint', () async {
    client.close();
    client = JackettClient(
      JackettProfile(
        id: 'i',
        name: 'i',
        url: '${profile.url}/api/v2.0/indexers/example/results/torznab/',
        apiKey: fakeKey,
      ),
    );
    await client.search('test');
    expect(
      requests.single.uri.path,
      '/jackett/api/v2.0/indexers/example/results/torznab/api',
    );
  });

  test('rejects cross-origin result link and secret-bearing magnet', () async {
    handler = (request) => request.response.write(
      feed(
        item('https://foreign.example.test/file') +
            item(
              'magnet:?xt=urn:btih:0123456789abcdef0123456789abcdef01234567&amp;apikey=$fakeKey',
            ),
      ),
    );
    expect(await client.search('test'), isEmpty);
  });

  test(
    'valid magnet preserved without downloading or contacting tracker',
    () async {
      handler = (request) => request.response.write(
        feed(
          item('magnet:?xt=urn:btih:0123456789abcdef0123456789abcdef01234567'),
        ),
      );
      final result = (await client.search('test')).single;
      expect(result.magnetUri?.scheme, 'magnet');
      await expectLater(
        client.downloadTorrent(result),
        throwsA(failure('unsafe_download')),
      );
      expect(requests, hasLength(1));
    },
  );

  test('refuses same-origin and foreign redirects without followup', () async {
    for (final target in [
      '/jackett/other',
      'https://foreign.example.test/?apikey=$fakeKey',
    ]) {
      handler = (request) {
        request.response.statusCode = 302;
        request.response.headers.set('location', target);
      };
      await expectLater(
        client.search('test'),
        throwsA(failure('redirect_blocked')),
      );
    }
    expect(requests, hasLength(2));
  });

  test(
    'download refuses foreign URL before any credentials are sent',
    () async {
      await expectLater(
        client.downloadTorrent(
          JackettResult(
            title: 'x',
            downloadUri: Uri.parse('https://foreign.example.test/private'),
          ),
        ),
        throwsA(failure('unsafe_download')),
      );
      expect(requests, isEmpty);
    },
  );

  test('binary download validates torrent and keeps key client-side', () async {
    final bytes = utf8.encode('d4:infod4:name4:testee');
    handler = (request) {
      request.response.add(bytes);
    };
    final result = JackettResult(
      title: 'x',
      downloadUri: Uri.parse('${profile.url}/download?apikey=$fakeKey'),
    );
    expect(await client.downloadTorrent(result), bytes);
    expect(requests.single.uri.queryParameters['apikey'], fakeKey);
  });

  test('rejects fake torrent bytes', () async {
    handler = (request) => request.response.write('<html>not a torrent</html>');
    await expectLater(
      client.downloadTorrent(
        JackettResult(
          title: 'x',
          downloadUri: Uri.parse('${profile.url}/download'),
        ),
      ),
      throwsA(failure('invalid_torrent')),
    );
  });

  test('rejects DTD, malformed XML, deep nesting and too many entries', () async {
    for (final xml in [
      '<!DOCTYPE rss [<!ENTITY x SYSTEM "file:///not-read">]><rss><channel/></rss>',
      '<rss><channel></rss>',
      '<rss><channel>${List.filled(40, '<a>').join()}${List.filled(40, '</a>').join()}</channel></rss>',
      feed(List.filled(1001, item('/download')).join()),
    ]) {
      handler = (request) => request.response.write(xml);
      await expectLater(client.search('test'), throwsA(failure('invalid_xml')));
    }
  });

  test('rejects oversized XML and binary response before buffering', () async {
    handler = (request) {
      request.response.add(List.filled(4 * 1024 * 1024 + 1, 32));
    };
    await expectLater(
      client.search('test'),
      throwsA(failure('response_too_large')),
    );
    handler = (request) {
      request.response.add(List.filled(16 * 1024 * 1024 + 1, 32));
    };
    await expectLater(
      client.downloadTorrent(
        JackettResult(
          title: 'x',
          downloadUri: Uri.parse('${profile.url}/download'),
        ),
      ),
      throwsA(failure('response_too_large')),
    );
  });

  test('bounded total deadline and close cancel in-flight search', () async {
    client.close();
    client = JackettClient(profile, timeout: const Duration(milliseconds: 100));
    handler = (_) async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
    };
    await expectLater(client.search('test'), throwsA(failure('timeout')));
    client.close();
    client = JackettClient(profile);
    final pending = client.search('test');
    final expected = expectLater(pending, throwsA(failure('closed')));
    await Future<void>.delayed(const Duration(milliseconds: 30));
    client.close();
    await expected;
    await expectLater(client.search('test'), throwsA(failure('closed')));
  });

  test(
    'HTTP errors are redacted and unknown metadata remains unknown',
    () async {
      handler = (request) {
        request.response.statusCode = 403;
        request.response.write('key=$fakeKey');
      };
      await expectLater(
        client.search('test'),
        throwsA(failure('authentication')),
      );
      handler = (request) => request.response.write(
        feed('<item><title>Fixture</title><link>/download</link></item>'),
      );
      final result = (await client.search('test')).single;
      expect(result.size, isNull);
      expect(result.seeders, isNull);
      expect(result.indexer, isNull);
    },
  );
  test('TLS handshake failure is redacted and never downgraded', () async {
    final socketServer = await ServerSocket.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    socketServer.listen((socket) {
      socket.add(utf8.encode('HTTP/1.1 400 Bad Request\r\n\r\n'));
      socket.close();
    });
    final tlsClient = JackettClient(
      JackettProfile(
        id: 'tls',
        name: 'tls',
        url: 'https://127.0.0.1:${socketServer.port}',
        apiKey: fakeKey,
      ),
    );
    try {
      await expectLater(tlsClient.search('test'), throwsA(failure('network')));
      expect(requests, isEmpty);
    } finally {
      tlsClient.close();
      await socketServer.close();
    }
  });
  test('rejects malformed/control-bearing magnets and redacts URL-like indexer', () async {
    handler = (request) => request.response.write(
      feed(
        item('magnet:?xt=http://example.test') +
            item(
              'magnet:?xt=urn:btih:0123456789abcdef0123456789abcdef01234567&amp;dn=%0Ahidden',
            ) +
            item(
              '/download',
              extra:
                  '<torznab:attr name="magneturl" value="https://foreign.example.test/?apikey=$fakeKey"/><jackettindexer>https://private.example.test/?apikey=$fakeKey</jackettindexer>',
            ),
      ),
    );
    final results = await client.search('test');
    expect(results, hasLength(1));
    expect(results.single.magnetUri, isNull);
    expect(results.single.indexer, isNull);
  });
  test(
    'does not surface the service API key echoed in a result title',
    () async {
      handler = (request) => request.response.write(
        feed('<item><title>$fakeKey</title><link>/download</link></item>'),
      );
      expect(await client.search('test'), isEmpty);
    },
  );
}
