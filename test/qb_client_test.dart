import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/core/qb_client.dart';

const hash = '0123456789abcdef0123456789abcdef01234567';
const loginPath = '/qb/api/v2/auth/login';
typedef Route = FutureOr<void> Function(HttpRequest request, List<int> body);

class SeenRequest {
  SeenRequest(HttpRequest request, this.body)
    : path = request.uri.path,
      query = request.uri.queryParameters,
      cookie = request.headers.value(HttpHeaders.cookieHeader),
      origin = request.headers.value('Origin'),
      referer = request.headers.value(HttpHeaders.refererHeader),
      authorization = request.headers.value(HttpHeaders.authorizationHeader),
      contentType = request.headers.value(HttpHeaders.contentTypeHeader);
  final String path;
  final Map<String, String> query;
  final List<int> body;
  final String? cookie, origin, referer, authorization, contentType;
  Map<String, String> get form => Uri.splitQueryString(utf8.decode(body));
}

void main() {
  late HttpServer server;
  late QbClient client;
  late List<SeenRequest> seen;
  late Map<String, Route> routes;
  late String url;
  // The SID the fake server currently accepts and issues; rotating it expires
  // every session the client holds, exactly like a qBittorrent restart.
  late String validSid;
  // The session cookie name the fake server issues and expects. Legacy
  // qBittorrent uses `SID`; 5.2+ uses `QBT_SID_<its own listening port>`.
  late String validCookieName;
  // Modern (qBittorrent 5.2+) login: HTTP 204, empty body, QBT_SID_ cookie.
  late bool modern;
  // A "server port" that differs from the loopback port the client connects
  // to, like a reverse proxy publishing qBittorrent on another port.
  late String modernCookieName;

  void useModernServer() {
    modern = true;
    validCookieName = modernCookieName;
    validSid = 'modern-session';
  }

  ServerProfile profile({
    String? address,
    String basicUser = '',
    String basicPassword = '',
  }) => ServerProfile(
    id: 'local',
    name: 'Local test',
    url: address ?? url,
    username: 'tester+name',
    password: 'secret & password',
    basicAuthUsername: basicUser,
    basicAuthPassword: basicPassword,
  );

  void jsonResponse(HttpRequest request, Object value) {
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(value));
  }

  int logins() => seen.where((r) => r.path == loginPath).length;

  Future<void> waitFor(bool Function() condition) async {
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (!condition()) {
      if (DateTime.now().isAfter(deadline)) fail('Condition not met in time.');
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    url = 'http://127.0.0.1:${server.port}/qb/';
    seen = [];
    routes = {};
    validSid = 'local-session';
    validCookieName = 'SID';
    modern = false;
    modernCookieName = 'QBT_SID_${server.port == 30024 ? 30025 : 30024}';
    server.listen((request) async {
      final body = await request.fold<List<int>>(
        [],
        (buffer, chunk) => buffer..addAll(chunk),
      );
      seen.add(SeenRequest(request, body));
      final override = routes[request.uri.path];
      if (override != null) {
        await override(request, body);
      } else if (request.uri.path == loginPath) {
        request.response.cookies.add(Cookie(validCookieName, validSid));
        if (modern) {
          request.response.statusCode = HttpStatus.noContent;
        } else {
          request.response.write('Ok.');
        }
      } else if (!request.cookies.any(
        (cookie) => cookie.name == validCookieName && cookie.value == validSid,
      )) {
        request.response.statusCode = 403;
      } else {
        switch (request.uri.path) {
          case '/qb/api/v2/app/version':
            request.response.write('v5.0.0');
          case '/qb/api/v2/torrents/info':
            jsonResponse(request, [
              {
                'hash': hash,
                'name': 'Local fixture',
                'size': 1024,
                'progress': 0.5,
                'dlspeed': 42,
                'upspeed': 2,
                'state': 'downloading',
                'eta': 12,
                'category': 'local',
                'ratio': 0.25,
              },
            ]);
          case '/qb/api/v2/torrents/properties':
            jsonResponse(request, {'total_size': 1024});
          case '/qb/api/v2/torrents/files':
            jsonResponse(request, [
              {'name': 'fixture.bin', 'size': 1024},
            ]);
          case '/qb/api/v2/torrents/trackers':
            jsonResponse(request, [
              {'url': 'http://127.0.0.1/announce', 'status': 2},
            ]);
          case '/qb/api/v2/search/start':
            jsonResponse(request, {'id': 7});
          default:
            request.response.write('Ok.');
        }
      }
      await request.response.close();
    });
    client = QbClient(profile());
  });

  tearDown(() async {
    client.close();
    await server.close(force: true);
  });

  test('login form escapes credentials; cookie, CSRF headers and reverse path are used', () async {
    await client.login();
    final login = seen.single;
    expect(login.form, {
      'username': 'tester+name',
      'password': 'secret & password',
    });
    expect(login.cookie, isNull);
    expect(login.origin, 'http://127.0.0.1:${server.port}');
    expect(login.referer, url);
    expect(await client.getVersion(), 'v5.0.0');
    expect(seen.last.cookie, 'SID=local-session');
  });

  test(
    'HTTP Basic credentials are independent of WebUI form credentials',
    () async {
      client.close();
      client = QbClient(
        profile(basicUser: 'proxy', basicPassword: 'proxy secret'),
      );
      await client.login();
      expect(
        seen.single.authorization,
        'Basic ${base64Encode(utf8.encode('proxy:proxy secret'))}',
      );
      expect(seen.single.form['username'], 'tester+name');
    },
  );

  test('rejected login is typed, retains no SID, exposes nothing and blocks the client', () async {
    routes[loginPath] = (request, _) {
      request.response.cookies.add(Cookie('SID', 'bad-session'));
      request.response.write('Fails. secret & password');
    };
    expect(client.authenticationBlocked, isFalse);
    await expectLater(
      client.login(),
      throwsA(
        isA<QbAuthenticationException>().having(
          (e) => e.message,
          'safe message',
          isNot(contains('secret & password')),
        ),
      ),
    );
    expect(client.authenticationBlocked, isTrue);
    await expectLater(
      client.getTorrents(),
      throwsA(isA<QbAuthenticationException>()),
    );
    expect(seen.length, 1);
  });

  test('models and three detail endpoints decode server data', () async {
    await client.login();
    final torrents = await client.getTorrents();
    expect(torrents.single.hash, hash);
    expect(torrents.single.progress, 0.5);
    expect(torrents.single.dlspeed, 42);
    final details = await client.getDetails(hash);
    expect(details.properties['total_size'], 1024);
    expect(details.files.single['name'], 'fixture.bin');
    expect(details.trackers.single['status'], 2);
    expect(seen.where((r) => r.query['hash'] == hash).length, 3);
  });

  test(
    'qB5 start/stop endpoints are preferred and older fallback is restricted',
    () async {
      routes['/qb/api/v2/torrents/stop'] = (request, _) =>
          request.response.statusCode = 404;
      await client.login();
      await client.setPaused([hash], paused: true);
      expect(
        seen.map((r) => r.path),
        containsAllInOrder([
          '/qb/api/v2/torrents/stop',
          '/qb/api/v2/torrents/pause',
        ]),
      );
      expect(seen.last.form['hashes'], hash);
      await client.setPaused([hash], paused: false);
      expect(seen.last.path, '/qb/api/v2/torrents/start');
      routes['/qb/api/v2/torrents/stop'] = (request, _) =>
          request.response.statusCode = 500;
      await expectLater(
        client.setPaused([hash], paused: true),
        throwsA(isA<QbException>()),
      );
      expect(seen.last.path, '/qb/api/v2/torrents/stop');
    },
  );

  test(
    'add URLs/options, multipart bytes and safe default deletion are correct',
    () async {
      await client.login();
      await client.addUrls(
        'magnet:?xt=urn:btih:$hash',
        options: {'category': 'local'},
      );
      expect(seen.last.form['category'], 'local');
      expect(seen.last.form['urls'], contains(hash));
      await client.addTorrentFile(
        'C:\\fake\\fixture.torrent',
        [0, 1, 2, 255],
        options: {'category': 'local', 'savepath': '/test/данные'},
      );
      expect(
        seen.last.contentType,
        startsWith('multipart/form-data; boundary='),
      );
      expect(
        utf8.decode(seen.last.body, allowMalformed: true),
        contains('filename="fixture.torrent"'),
      );
      expect(seen.last.body, containsAllInOrder([0, 1, 2, 255]));
      expect(
        utf8.decode(seen.last.body, allowMalformed: true),
        contains('name="category"\r\n\r\nlocal'),
      );
      expect(
        utf8.decode(seen.last.body, allowMalformed: true),
        contains('/test/данные'),
      );
      final beforeInvalidOption = seen.length;
      await expectLater(
        client.addTorrentFile(
          'bad.torrent',
          [1],
          options: {'bad\r\nfield': 'value'},
        ),
        throwsA(isA<QbException>()),
      );
      expect(seen.length, beforeInvalidOption);
      await client.deleteTorrents([hash]);
      expect(seen.last.form['deleteFiles'], 'false');
      await client.deleteTorrents([hash], deleteFiles: true);
      expect(seen.last.form['deleteFiles'], 'true');
    },
  );

  test(
    'generic API supports JSON POST result and rejects endpoint escape',
    () async {
      await client.login();
      expect(await client.post('search/start', {'pattern': 'fixture'}), {
        'id': 7,
      });
      final before = seen.length;
      for (final endpoint in [
        'https://evil.invalid/api',
        '//evil.invalid/path',
        '../auth/login',
        'app/version?password=x',
        '/api/v2/app/version',
        'app/%2e%2e',
      ]) {
        await expectLater(client.get(endpoint), throwsA(isA<QbException>()));
      }
      expect(seen.length, before);
    },
  );

  test(
    'cross-origin login redirect forwards neither credentials nor Basic auth',
    () async {
      final target = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      var targetRequests = 0;
      target.listen((request) async {
        targetRequests++;
        await request.response.close();
      });
      addTearDown(() => target.close(force: true));
      routes[loginPath] = (request, _) {
        request.response.statusCode = 307;
        request.response.headers.set(
          HttpHeaders.locationHeader,
          'http://127.0.0.1:${target.port}/collect',
        );
      };
      client.close();
      client = QbClient(profile(basicUser: 'proxy', basicPassword: 'private'));
      await expectLater(
        client.login(),
        throwsA(
          isA<QbException>().having(
            (e) => e.message,
            'blocked',
            contains('blocked'),
          ),
        ),
      );
      expect(targetRequests, 0);
      // A blocked redirect is a transport problem, not a credential verdict.
      expect(client.authenticationBlocked, isFalse);
    },
  );

  test(
    'cross-origin session redirect is blocked; same-origin redirect works',
    () async {
      await client.login();
      routes['/qb/api/v2/app/version'] = (request, _) {
        request.response.statusCode = 302;
        request.response.headers.set(
          HttpHeaders.locationHeader,
          '/qb/api/v2/app/realVersion',
        );
      };
      routes['/qb/api/v2/app/realVersion'] = (request, _) =>
          request.response.write('v4.6.7');
      expect(await client.getVersion(), 'v4.6.7');
      expect(seen.last.cookie, 'SID=local-session');
      routes['/qb/api/v2/app/version'] = (request, _) {
        request.response.statusCode = 302;
        request.response.headers.set(
          HttpHeaders.locationHeader,
          'http://localhost:${server.port}/collect',
        );
      };
      await expectLater(client.getVersion(), throwsA(isA<QbException>()));
      expect(seen.last.path, '/qb/api/v2/app/version');
    },
  );

  test(
    'expired session requires fresh login and request timeout is safe',
    () async {
      await client.login();
      routes['/qb/api/v2/app/version'] = (request, _) =>
          request.response.statusCode = 403;
      await expectLater(
        client.getVersion(),
        throwsA(isA<QbException>().having((e) => e.statusCode, 'status', 403)),
      );
      // A 403 on a read with a fresh session is not a credential rejection.
      expect(client.authenticationBlocked, isFalse);
      final before = seen.length;
      await expectLater(client.getVersion(), throwsA(isA<QbException>()));
      expect(seen.length, before);
      client.close();
      client = QbClient(profile(), timeout: const Duration(milliseconds: 100));
      await client.login();
      final release = Completer<void>();
      routes['/qb/api/v2/app/version'] = (request, _) => release.future;
      await expectLater(
        client.getVersion(),
        throwsA(
          isA<QbException>().having(
            (e) => e.message,
            'timeout',
            contains('timed out'),
          ),
        ),
      );
      expect(client.authenticationBlocked, isFalse);
      release.complete();
    },
  );

  test('GET session expiry relogs in once; mutations never retry', () async {
    await client.login();
    var reads = 0;
    routes['/qb/api/v2/app/version'] = (request, _) {
      reads++;
      if (reads == 1) {
        request.response.statusCode = 403;
      } else {
        request.response.write('v5.0.1');
      }
    };
    expect(await client.getVersion(), 'v5.0.1');
    expect(logins(), 2);
    final before = seen.length;
    routes['/qb/api/v2/torrents/delete'] = (request, _) =>
        request.response.statusCode = 403;
    await expectLater(
      client.deleteTorrents([hash]),
      throwsA(isA<QbException>().having((e) => e.statusCode, 'status', 403)),
    );
    expect(seen.length, before + 1);
    expect(seen.last.path, '/qb/api/v2/torrents/delete');
    expect(logins(), 2, reason: 'a rejected mutation must not trigger a login');
  });

  test(
    'rejected multipart upload and URL add are never replayed after 401',
    () async {
      await client.login();
      var adds = 0;
      routes['/qb/api/v2/torrents/add'] = (request, _) {
        adds++;
        request.response.statusCode = 401;
      };
      await expectLater(
        client.addTorrentFile('fixture.torrent', [1, 2, 3]),
        throwsA(isA<QbException>().having((e) => e.statusCode, 'status', 401)),
      );
      expect(adds, 1);
      expect(logins(), 1);
      // The 401 dropped the session; a new mutation needs an explicit login
      // and is still sent exactly once even though the server keeps refusing.
      await client.login();
      await expectLater(
        client.addUrls('magnet:?xt=urn:btih:$hash'),
        throwsA(isA<QbException>().having((e) => e.statusCode, 'status', 401)),
      );
      expect(adds, 2);
      expect(logins(), 2);
      expect(client.authenticationBlocked, isFalse);
    },
  );

  test(
    'concurrent expired reads share one re-login; explicit logins coalesce',
    () async {
      await Future.wait([client.login(), client.login(), client.login()]);
      expect(logins(), 1, reason: 'simultaneous explicit logins coalesce');
      expect(await client.getVersion(), 'v5.0.0');

      // Server restart: old SID expires, three detail reads are already out.
      validSid = 'renewed-session';
      var expired = 0;
      final allExpired = Completer<void>();
      routes[loginPath] = (request, _) async {
        // Hold the login until every stale read has been refused, so all three
        // 403s are in hand while exactly one login is in flight.
        await allExpired.future;
        request.response.cookies.add(Cookie('SID', validSid));
        request.response.write('Ok.');
      };
      Route expiring(Object value) => (request, _) {
        if (request.headers.value(HttpHeaders.cookieHeader) ==
            'SID=renewed-session') {
          jsonResponse(request, value);
        } else {
          expired++;
          request.response.statusCode = 403;
          if (expired == 3) allExpired.complete();
        }
      };
      routes['/qb/api/v2/torrents/properties'] = expiring({'total_size': 7});
      routes['/qb/api/v2/torrents/files'] = expiring([
        {'name': 'renewed.bin'},
      ]);
      routes['/qb/api/v2/torrents/trackers'] = expiring([
        {'url': 'http://127.0.0.1/announce', 'status': 2},
      ]);

      final details = await client.getDetails(hash);
      expect(details.properties['total_size'], 7);
      expect(details.files.single['name'], 'renewed.bin');
      expect(logins(), 2, reason: 'three expired reads share one re-login');
      final detailRequests = seen.where((r) => r.query['hash'] == hash);
      expect(detailRequests.length, 6, reason: 'each read retried once');
      expect(
        detailRequests.where((r) => r.cookie == 'SID=renewed-session').length,
        3,
      );
      expect(client.authenticationBlocked, isFalse);
      // The renewed session is current: no further login for ordinary reads.
      expect(await client.getVersion(), 'v5.0.0');
      expect(seen.last.cookie, 'SID=renewed-session');
      expect(logins(), 2);
    },
  );

  test(
    'late 401 for an old session neither wipes the renewed SID nor re-logs in',
    () async {
      await client.login();
      final release = Completer<void>();
      routes['/qb/api/v2/app/version'] = (request, _) async {
        if (request.headers.value(HttpHeaders.cookieHeader) ==
            'SID=local-session') {
          await release.future; // answer the stale request much later
          request.response.statusCode = 401;
        } else {
          request.response.write('v5.0.2');
        }
      };
      final slowRead = client.getVersion();
      await waitFor(() => seen.any((r) => r.path == '/qb/api/v2/app/version'));

      // Meanwhile the server restarts and another read renews the session.
      validSid = 'renewed-session';
      expect((await client.getTorrents()).single.hash, hash);
      expect(logins(), 2);
      expect(seen.last.cookie, 'SID=renewed-session');

      // Now the old-generation 401 arrives: the read simply retries with the
      // renewed SID, and the renewed session stays intact.
      release.complete();
      expect(await slowRead, 'v5.0.2');
      expect(logins(), 2, reason: 'stale 401 must not start another login');
      expect(seen.last.cookie, 'SID=renewed-session');
      expect((await client.getTorrents()).single.hash, hash);
      expect(logins(), 2);
      expect(client.authenticationBlocked, isFalse);
    },
  );

  test('rejected re-login blocks every automatic retry and explicit login without network; a new client reconnects', () async {
    await client.login();
    expect(await client.getVersion(), 'v5.0.0');

    // Password changed on the server: sessions expire and logins fail.
    validSid = 'rotated-session';
    routes[loginPath] = (request, _) => request.response.write('Fails.');
    await expectLater(
      client.getVersion(),
      throwsA(isA<QbAuthenticationException>()),
    );
    expect(client.authenticationBlocked, isTrue);
    expect(logins(), 2, reason: 'exactly one rejected re-login attempt');

    // Polling, details, mutations and explicit login: all refused offline.
    final before = seen.length;
    await expectLater(
      client.getVersion(),
      throwsA(isA<QbAuthenticationException>()),
    );
    await expectLater(
      client.getTorrents(),
      throwsA(isA<QbAuthenticationException>()),
    );
    await expectLater(
      client.getDetails(hash),
      throwsA(isA<QbAuthenticationException>()),
    );
    await expectLater(
      client.getBytes('torrents/export', {'hash': hash}),
      throwsA(isA<QbAuthenticationException>()),
    );
    await expectLater(
      client.deleteTorrents([hash]),
      throwsA(isA<QbAuthenticationException>()),
    );
    await expectLater(
      client.login(),
      throwsA(
        isA<QbAuthenticationException>().having(
          (e) => e.message,
          'safe message',
          isNot(contains('secret & password')),
        ),
      ),
    );
    expect(seen.length, before, reason: 'no network traffic while blocked');
    expect(client.authenticationBlocked, isTrue);

    // The user fixes the credentials and reconnects: a fresh client works.
    routes.remove(loginPath);
    client.close();
    client = QbClient(profile());
    expect(client.authenticationBlocked, isFalse);
    await client.login();
    expect(await client.getVersion(), 'v5.0.0');
    expect(seen.last.cookie, 'SID=rotated-session');
    expect(client.authenticationBlocked, isFalse);
  });

  test(
    'login refused with 401/403 blocks; server errors and read expiry do not',
    () async {
      routes[loginPath] = (request, _) => request.response.statusCode = 500;
      await expectLater(
        client.login(),
        throwsA(
          allOf(isA<QbException>(), isNot(isA<QbAuthenticationException>())),
        ),
      );
      expect(client.authenticationBlocked, isFalse);
      routes.remove(loginPath);
      await client.login();
      expect(logins(), 2, reason: 'a transient failure may be retried');

      // Server keeps refusing the fresh session: ordinary expiry, not a block.
      validSid = 'unreachable-session';
      routes['/qb/api/v2/app/version'] = (request, _) =>
          request.response.statusCode = 401;
      await expectLater(
        client.getVersion(),
        throwsA(
          allOf(
            isA<QbException>().having((e) => e.statusCode, 'status', 401),
            isNot(isA<QbAuthenticationException>()),
          ),
        ),
      );
      expect(client.authenticationBlocked, isFalse);
      expect(logins(), 3);

      // A banned IP or wrong proxy credentials answer the login with 403.
      client.close();
      client = QbClient(profile());
      routes[loginPath] = (request, _) => request.response.statusCode = 403;
      await expectLater(
        client.login(),
        throwsA(
          isA<QbAuthenticationException>().having(
            (e) => e.statusCode,
            'status',
            403,
          ),
        ),
      );
      expect(client.authenticationBlocked, isTrue);
      final before = seen.length;
      await expectLater(
        client.login(),
        throwsA(isA<QbAuthenticationException>()),
      );
      expect(seen.length, before);
    },
  );

  test(
    'binary exports preserve non-UTF8 bytes without text conversion',
    () async {
      const bytes = [0, 255, 128, 254, 100];
      routes['/qb/api/v2/torrents/export'] = (request, _) {
        request.response.headers.contentType = ContentType(
          'application',
          'x-bittorrent',
        );
        request.response.add(bytes);
      };
      await client.login();
      expect(await client.getBytes('torrents/export', {'hash': hash}), bytes);
      expect(seen.last.query, {'hash': hash});
    },
  );

  test('closed client refuses work and never resurrects a session', () async {
    await client.login();
    client.close();
    final before = seen.length;
    await expectLater(client.getVersion(), throwsA(isA<QbException>()));
    await expectLater(client.login(), throwsA(isA<QbException>()));
    expect(seen.length, before);
    expect(client.authenticationBlocked, isFalse);
  });

  test('invalid URLs and partial client certificate settings fail safely', () {
    for (final address in [
      'file:///tmp/qb',
      'http://user:password@localhost/',
      'https://localhost/?token=secret',
      'http://localhost:99999/',
    ]) {
      expect(
        () => QbClient(profile(address: address)),
        throwsA(isA<QbException>()),
      );
    }
    expect(
      () => QbClient(
        ServerProfile(
          id: 'bad',
          name: 'bad',
          url: url,
          username: '',
          password: '',
          clientKeyPem: 'private key material',
        ),
      ),
      throwsA(
        isA<QbException>().having(
          (e) => e.message,
          'safe',
          isNot(contains('private key material')),
        ),
      ),
    );
  });

  group('qBittorrent 5.2+ login (HTTP 204, QBT_SID_<server port>)', () {
    test('modern login succeeds and API requests echo the exact server cookie name', () async {
      useModernServer();
      expect(modernCookieName, isNot('QBT_SID_${server.port}'));
      await client.login();
      expect(seen.single.path, loginPath);
      expect(seen.single.cookie, isNull);
      expect(await client.getVersion(), 'v5.0.0');
      expect(seen.last.cookie, '$modernCookieName=modern-session');
      expect(seen.last.cookie, isNot(startsWith('SID=')));
      expect((await client.getTorrents()).single.hash, hash);
      await client.deleteTorrents([hash]);
      expect(seen.last.cookie, '$modernCookieName=modern-session');
      expect(client.authenticationBlocked, isFalse);
    });

    test(
      'unrelated cookies beside the session cookie are never retained',
      () async {
        useModernServer();
        routes[loginPath] = (request, _) {
          request.response.cookies
            ..add(Cookie('theme', 'dark'))
            ..add(Cookie(modernCookieName, validSid))
            ..add(Cookie('tracking', 'id-123'));
          request.response.statusCode = HttpStatus.noContent;
        };
        await client.login();
        expect(await client.getVersion(), 'v5.0.0');
        expect(seen.last.cookie, '$modernCookieName=modern-session');
      },
    );

    test('wrong credentials (401/403) or Fails. on a modern server block permanently', () async {
      useModernServer();
      routes[loginPath] = (request, _) =>
          request.response.statusCode = HttpStatus.unauthorized;
      await expectLater(
        client.login(),
        throwsA(
          isA<QbAuthenticationException>().having(
            (e) => e.statusCode,
            'status',
            401,
          ),
        ),
      );
      expect(client.authenticationBlocked, isTrue);
      var before = seen.length;
      await expectLater(
        client.login(),
        throwsA(isA<QbAuthenticationException>()),
      );
      await expectLater(
        client.getVersion(),
        throwsA(isA<QbAuthenticationException>()),
      );
      await expectLater(
        client.deleteTorrents([hash]),
        throwsA(isA<QbAuthenticationException>()),
      );
      expect(seen.length, before, reason: 'no network traffic while blocked');

      client.close();
      client = QbClient(profile());
      routes[loginPath] = (request, _) =>
          request.response.statusCode = HttpStatus.forbidden;
      await expectLater(
        client.login(),
        throwsA(
          isA<QbAuthenticationException>().having(
            (e) => e.statusCode,
            'status',
            403,
          ),
        ),
      );
      expect(client.authenticationBlocked, isTrue);
      before = seen.length;
      await expectLater(
        client.getTorrents(),
        throwsA(isA<QbAuthenticationException>()),
      );
      expect(seen.length, before);

      // A modern server still answers a bad password with `Fails.`.
      client.close();
      client = QbClient(profile());
      routes[loginPath] = (request, _) => request.response.write('Fails.');
      await expectLater(
        client.login(),
        throwsA(isA<QbAuthenticationException>()),
      );
      expect(client.authenticationBlocked, isTrue);
    });

    test('modern expiry: concurrent reads share one re-login, mutations never repeat', () async {
      useModernServer();
      await client.login();
      expect(await client.getVersion(), 'v5.0.0');

      // qBittorrent restart: the old QBT_SID_ value expires while three
      // detail reads are in flight.
      validSid = 'renewed-modern';
      var expired = 0;
      final allExpired = Completer<void>();
      routes[loginPath] = (request, _) async {
        await allExpired.future;
        request.response.cookies.add(Cookie(modernCookieName, validSid));
        request.response.statusCode = HttpStatus.noContent;
      };
      Route expiring(Object value) => (request, _) {
        if (request.headers.value(HttpHeaders.cookieHeader) ==
            '$modernCookieName=renewed-modern') {
          jsonResponse(request, value);
        } else {
          expired++;
          request.response.statusCode = HttpStatus.forbidden;
          if (expired == 3) allExpired.complete();
        }
      };
      routes['/qb/api/v2/torrents/properties'] = expiring({'total_size': 9});
      routes['/qb/api/v2/torrents/files'] = expiring([
        {'name': 'renewed-modern.bin'},
      ]);
      routes['/qb/api/v2/torrents/trackers'] = expiring([
        {'url': 'http://127.0.0.1/announce', 'status': 2},
      ]);
      final details = await client.getDetails(hash);
      expect(details.properties['total_size'], 9);
      expect(details.files.single['name'], 'renewed-modern.bin');
      expect(logins(), 2, reason: 'three expired reads share one re-login');
      final detailRequests = seen.where((r) => r.query['hash'] == hash);
      expect(detailRequests.length, 6, reason: 'each read retried once');
      expect(
        detailRequests
            .where((r) => r.cookie == '$modernCookieName=renewed-modern')
            .length,
        3,
      );
      expect(detailRequests.any((r) => r.cookie!.startsWith('SID=')), isFalse);

      // A refused mutation is sent exactly once and triggers no login.
      var adds = 0;
      routes['/qb/api/v2/torrents/add'] = (request, _) {
        adds++;
        request.response.statusCode = HttpStatus.forbidden;
      };
      final before = seen.length;
      await expectLater(
        client.addUrls('magnet:?xt=urn:btih:$hash'),
        throwsA(isA<QbException>().having((e) => e.statusCode, 'status', 403)),
      );
      expect(adds, 1);
      expect(seen.length, before + 1);
      expect(logins(), 2, reason: 'a rejected mutation must not re-login');
      await expectLater(
        client.addTorrentFile('fixture.torrent', [1, 2, 3]),
        throwsA(isA<QbException>()),
      );
      expect(adds, 1, reason: 'the 403 dropped the session; no replay');
      expect(logins(), 2);
      expect(client.authenticationBlocked, isFalse);
    });

    test('a replacement QBT_SID_ cookie on a read is adopted for the same generation only', () async {
      useModernServer();
      await client.login();
      routes['/qb/api/v2/app/version'] = (request, _) {
        request.response.cookies.add(Cookie(modernCookieName, 'rotated'));
        request.response.write('v5.2.3');
      };
      expect(await client.getVersion(), 'v5.2.3');
      validSid = 'rotated';
      routes.remove('/qb/api/v2/app/version');
      expect(await client.getVersion(), 'v5.0.0');
      expect(seen.last.cookie, '$modernCookieName=rotated');
      expect(logins(), 1);

      // A stale answer carrying an old cookie must not override a renewal
      // that happened while it was pending.
      final release = Completer<void>();
      routes['/qb/api/v2/app/version'] = (request, _) async {
        if (request.headers.value(HttpHeaders.cookieHeader) ==
            '$modernCookieName=rotated') {
          await release.future;
          request.response.cookies.add(Cookie(modernCookieName, 'stale'));
          request.response.statusCode = HttpStatus.unauthorized;
        } else {
          request.response.write('v5.2.3');
        }
      };
      final slowRead = client.getVersion();
      await waitFor(
        () => seen.where((r) => r.path == '/qb/api/v2/app/version').length == 3,
      );
      validSid = 'renewed-after-stale';
      expect((await client.getTorrents()).single.hash, hash);
      expect(logins(), 2);
      release.complete();
      expect(await slowRead, 'v5.2.3');
      expect(logins(), 2, reason: 'stale 401 must not start another login');
      expect(seen.last.cookie, '$modernCookieName=renewed-after-stale');
    });

    test('responses that are not a sign-in are refused without a session or a block', () async {
      Future<void> expectNoSession(String reason) async {
        await expectLater(
          client.login(),
          throwsA(
            allOf(isA<QbException>(), isNot(isA<QbAuthenticationException>())),
          ),
          reason: reason,
        );
        expect(client.authenticationBlocked, isFalse, reason: reason);
        final before = seen.length;
        await expectLater(
          client.getVersion(),
          throwsA(
            isA<QbException>().having(
              (e) => e.message,
              'needs explicit sign-in',
              contains('Sign in'),
            ),
          ),
          reason: reason,
        );
        expect(seen.length, before, reason: 'no cookie to send: $reason');
      }

      // HTTP 204 without any session cookie.
      routes[loginPath] = (request, _) =>
          request.response.statusCode = HttpStatus.noContent;
      await expectNoSession('204 without cookie');

      // HTTP 204 with cookies whose names are not a qBittorrent session.
      for (final name in [
        'QBT_SID_0',
        'QBT_SID_65536',
        'QBT_SID_99999',
        'QBT_SID_030024',
        'QBT_SID_',
        'QBT_SID_30024x',
        'QBT_SID_-1',
        'QBT_SID',
        'qbt_sid_30024',
        'sid',
        'SIDX',
        'SESSION',
      ]) {
        routes[loginPath] = (request, _) {
          request.response.cookies.add(Cookie(name, 'value'));
          request.response.statusCode = HttpStatus.noContent;
        };
        await expectNoSession('204 with cookie $name');
      }

      // Recognised name but empty value.
      routes[loginPath] = (request, _) {
        request.response.headers.add(
          HttpHeaders.setCookieHeader,
          '$modernCookieName=; Path=/',
        );
        request.response.statusCode = HttpStatus.noContent;
      };
      await expectNoSession('204 with empty cookie value');

      // HTTP 200 with an HTML page (proxy portal) even with a cookie.
      routes[loginPath] = (request, _) {
        request.response.cookies.add(Cookie('SID', 'portal'));
        request.response.headers.contentType = ContentType.html;
        request.response.write('<html><body>Ok.</body></html>');
      };
      await expectNoSession('200 HTML page');

      // HTTP 200 with an empty body, with and without a cookie.
      routes[loginPath] = (request, _) =>
          request.response.cookies.add(Cookie(modernCookieName, 'empty'));
      await expectNoSession('200 empty body with cookie');
      routes[loginPath] = (request, _) {};
      await expectNoSession('200 empty body');

      // Legacy `Ok.` without a recognised cookie.
      routes[loginPath] = (request, _) {
        request.response.cookies.add(Cookie('SESSIONID', 'other'));
        request.response.write('Ok.');
      };
      await expectNoSession('200 Ok. with unsupported cookie name');

      // Other 2xx codes are not a sign-in verdict either.
      routes[loginPath] = (request, _) {
        request.response.cookies.add(Cookie(modernCookieName, 'value'));
        request.response.statusCode = HttpStatus.accepted;
      };
      await expectNoSession('202 with cookie');

      // The same client recovers once the server answers properly.
      useModernServer();
      routes.remove(loginPath);
      await client.login();
      expect(await client.getVersion(), 'v5.0.0');
      expect(seen.last.cookie, '$modernCookieName=modern-session');
    });

    test('legacy SID and modern QBT_SID_ servers are both accepted', () async {
      // Legacy: 200 `Ok.` with SID.
      await client.login();
      expect(await client.getVersion(), 'v5.0.0');
      expect(seen.last.cookie, 'SID=local-session');

      // Modern with the smallest and largest valid port numbers.
      for (final name in ['QBT_SID_1', 'QBT_SID_65535', 'QBT_SID_8080']) {
        client.close();
        client = QbClient(profile());
        useModernServer();
        validCookieName = name;
        await client.login();
        expect(await client.getVersion(), 'v5.0.0');
        expect(seen.last.cookie, '$name=modern-session');
      }
    });
  });
}
