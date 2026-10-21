import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/core/qb_client.dart';
import 'package:home_qb_remote/integrations/jackett_client.dart';
import 'package:home_qb_remote/integrations/jackett_models.dart';
import 'package:home_qb_remote/integrations/torrent_identity.dart';

const jackettKey = 'fixture-jackett-private-key';
const qbPassword = 'fixture-qb-password';
const qbToken = 'fixture-qb-api-key';
final torrentBytes = <int>[
  ...ascii.encode('d4:infod4:name3:'),
  255,
  0,
  254,
  ...ascii.encode('ee'),
];

class _Seen {
  _Seen(HttpRequest request, this.bytes)
    : method = request.method,
      uri = request.uri,
      cookie = request.headers.value('cookie'),
      auth = request.headers.value('authorization'),
      contentType = request.headers.contentType;
  final String method;
  final Uri uri;
  final List<int> bytes;
  final String? cookie, auth;
  final ContentType? contentType;
}

void main() {
  late HttpServer jackettServer, qbServer;
  late JackettClient jackett;
  late QbClient qb;
  late List<_Seen> jackettSeen, qbSeen;
  late FutureOr<void> Function(HttpRequest, List<int>) qbRoute;
  late String jackettUrl, qbUrl;
  late bool redirectDownload;
  late bool keyMode;

  setUp(() async {
    jackettSeen = [];
    qbSeen = [];
    redirectDownload = false;
    keyMode = false;
    jackettServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    qbServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    jackettUrl = 'http://127.0.0.1:${jackettServer.port}';
    qbUrl = 'http://127.0.0.1:${qbServer.port}';
    jackettServer.listen((request) async {
      final body = await request.fold<List<int>>(
        [],
        (all, chunk) => all..addAll(chunk),
      );
      jackettSeen.add(_Seen(request, body));
      if (request.uri.path.endsWith('/api')) {
        expect(request.uri.queryParameters['apikey'], jackettKey);
        request.response.cookies.add(
          Cookie('SID', 'jackett-cookie-must-not-leak'),
        );
        request.response.write(
          '<rss><channel><item><title>Invented fixture</title><enclosure url="$jackettUrl/download?apikey=$jackettKey" /></item></channel></rss>',
        );
      } else if (redirectDownload) {
        request.response.statusCode = 302;
        request.response.headers.set(
          'location',
          '$qbUrl/private?apikey=$jackettKey',
        );
      } else {
        request.response.add(torrentBytes);
      }
      await request.response.close();
    });
    qbRoute = (request, body) {
      if (request.uri.path.endsWith('/auth/login')) {
        expect(Uri.splitQueryString(utf8.decode(body)), {
          'username': 'fixture-qb-user',
          'password': qbPassword,
        });
        request.response.cookies.add(
          Cookie('QBT_SID_30024', 'qb-owned-session'),
        );
        request.response.statusCode = 204;
      } else if (request.uri.path.endsWith('/app/version')) {
        request.response.write('v5.2.3');
      } else if (request.uri.path.endsWith('/torrents/info')) {
        request.response.headers.contentType = ContentType.json;
        request.response.write('[]');
      } else {
        request.response.write('Ok.');
      }
    };
    qbServer.listen((request) async {
      final body = await request.fold<List<int>>(
        [],
        (all, chunk) => all..addAll(chunk),
      );
      qbSeen.add(_Seen(request, body));
      try {
        await qbRoute(request, body);
        await request.response.close();
      } catch (_) {
        request.response.close();
      }
    });
    jackett = JackettClient(
      JackettProfile(
        id: 'jackett',
        name: 'Fixture',
        url: jackettUrl,
        apiKey: jackettKey,
      ),
    );
    qb = QbClient(
      ServerProfile(
        id: 'qb',
        name: 'Fixture',
        url: qbUrl,
        username: 'fixture-qb-user',
        password: qbPassword,
      ),
    );
  });
  tearDown(() async {
    jackett.close();
    qb.close();
    await jackettServer.close(force: true);
    await qbServer.close(force: true);
  });

  Future<List<int>> preparedBytes() async {
    final results = await jackett.search('invented query');
    final bytes = await jackett.downloadTorrent(results.single);
    expect(torrentInfoHashes(bytes), isNotEmpty);
    return bytes;
  }

  void assertIsolation() {
    for (final request in jackettSeen) {
      expect(request.auth, isNull);
      expect(request.cookie, isNull);
      expect(latin1.decode(request.bytes), isNot(contains(qbPassword)));
      expect(request.uri.toString(), isNot(contains(qbToken)));
    }
    for (final request in qbSeen) {
      if (request.uri.path.endsWith('/auth/login')) {
        expect(Uri.splitQueryString(utf8.decode(request.bytes)), {
          'username': 'fixture-qb-user',
          'password': qbPassword,
        });
      }
      expect(request.uri.toString(), isNot(contains(jackettKey)));
      expect(latin1.decode(request.bytes), isNot(contains(jackettKey)));
      expect(latin1.decode(request.bytes), isNot(contains(jackettUrl)));
      expect(request.cookie ?? '', isNot(contains('jackett-cookie')));
      if (!request.uri.path.endsWith('/auth/login') && !keyMode) {
        expect(request.cookie, 'QBT_SID_30024=qb-owned-session');
      }
    }
  }

  test(
    'actual clients hand off binary multipart with isolated password/SID',
    () async {
      final bytes = await preparedBytes();
      await qb.login();
      expect(await qb.getTorrents(), isEmpty);
      await qb.addTorrentFile(
        'download.torrent',
        bytes,
        options: {'savepath': '/fixture', 'category': 'test'},
      );
      final upload = qbSeen.singleWhere(
        (r) => r.uri.path.endsWith('/torrents/add'),
      );
      expect(upload.method, 'POST');
      expect(upload.contentType?.mimeType, 'multipart/form-data');
      final boundary = upload.contentType!.parameters['boundary']!;
      final body = latin1.decode(upload.bytes);
      final start =
          body.indexOf('Content-Type: application/x-bittorrent\r\n\r\n') +
          'Content-Type: application/x-bittorrent\r\n\r\n'.length;
      final end = body.indexOf('\r\n--$boundary--', start);
      expect(upload.bytes.sublist(start, end), torrentBytes);
      expect(body, contains('name="savepath"\r\n\r\n/fixture'));
      expect(
        qbSeen.where((r) => r.method == 'POST'),
        hasLength(2),
      ); // login + single upload
      assertIsolation();
    },
  );

  test(
    'upload401 is not replayed and does not silently password-login again',
    () async {
      final bytes = await preparedBytes();
      await qb.login();
      await qb.getTorrents();
      final previous = qbRoute;
      qbRoute = (request, body) {
        if (request.uri.path.endsWith('/torrents/add')) {
          request.response.statusCode = 401;
        } else {
          previous(request, body);
        }
      };
      await expectLater(
        qb.addTorrentFile('download.torrent', bytes),
        throwsA(isA<QbException>()),
      );
      expect(
        qbSeen.where((r) => r.uri.path.endsWith('/torrents/add')),
        hasLength(1),
      );
      expect(
        qbSeen.where((r) => r.uri.path.endsWith('/auth/login')),
        hasLength(1),
      );
      assertIsolation();
    },
  );

  test(
    'uncertain upload timeout performs exactly one POST without retry',
    () async {
      final bytes = await preparedBytes();
      qb.close();
      qb = QbClient(
        ServerProfile(
          id: 'qb',
          name: 'Fixture',
          url: qbUrl,
          username: 'fixture-qb-user',
          password: qbPassword,
        ),
        timeout: const Duration(milliseconds: 150),
      );
      await qb.login();
      await qb.getTorrents();
      final previous = qbRoute;
      qbRoute = (request, body) async {
        if (request.uri.path.endsWith('/torrents/add')) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
        } else {
          await previous(request, body);
        }
      };
      await expectLater(
        qb.addTorrentFile('download.torrent', bytes),
        throwsA(isA<QbException>()),
      );
      expect(
        qbSeen.where((r) => r.uri.path.endsWith('/torrents/add')),
        hasLength(1),
      );
      expect(
        qbSeen.where((r) => r.uri.path.endsWith('/auth/login')),
        hasLength(1),
      );
      assertIsolation();
    },
  );

  test(
    'Bearer upload401 blocks without cookie/password fallback or replay',
    () async {
      final bytes = await preparedBytes();
      qb.close();
      keyMode = true;
      qb = QbClient(
        ServerProfile(
          id: 'qb',
          name: 'Fixture',
          url: qbUrl,
          username: '',
          password: '',
          apiKey: qbToken,
        ),
      );
      final previous = qbRoute;
      qbRoute = (request, body) {
        if (request.uri.path.endsWith('/torrents/add')) {
          request.response.statusCode = 401;
        } else {
          previous(request, body);
        }
      };
      await qb.login();
      await qb.getTorrents();
      await expectLater(
        qb.addTorrentFile('download.torrent', bytes),
        throwsA(isA<QbAuthenticationException>()),
      );
      await expectLater(
        qb.getTorrents(),
        throwsA(isA<QbAuthenticationException>()),
      );
      expect(qb.authenticationBlocked, isTrue);
      expect(qbSeen.where((r) => r.uri.path.endsWith('/auth/login')), isEmpty);
      expect(
        qbSeen.where((r) => r.uri.path.endsWith('/torrents/add')),
        hasLength(1),
      );
      for (final request in qbSeen) {
        expect(request.auth, 'Bearer $qbToken');
        expect(request.cookie, isNull);
      }
      assertIsolation();
    },
  );

  test(
    'Jackett download redirect cannot contact qB or disclose its key',
    () async {
      redirectDownload = true;
      final result = (await jackett.search('invented query')).single;
      await expectLater(
        jackett.downloadTorrent(result),
        throwsA(isA<JackettException>()),
      );
      expect(qbSeen, isEmpty);
      expect(jackettSeen, hasLength(2));
      assertIsolation();
    },
  );
}
