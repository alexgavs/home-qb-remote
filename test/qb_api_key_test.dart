import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/core/qb_client.dart';

// qBittorrent 5.2+ WebUI API key mode (`Authorization: Bearer <key>`), modelled
// on the 5.2.3 webapplication.cpp rules: a non-empty Bearer header decides the
// session on its own (no cookie, no `auth/login`, no expiry), a wrong key is
// refused even where a cookie or the subnet whitelist would have let the
// request through, and cookie auth is never a fallback for a bad key.

const hash = '0123456789abcdef0123456789abcdef01234567';
const loginPath = '/qb/api/v2/auth/login';
const versionPath = '/qb/api/v2/app/version';
// A throwaway loopback-only value with every token68-style character class;
// never a real key.
const apiKey = 'loopback-test-key-0123456789ABCDEFabcdef._~+/=';
const bearer = 'Bearer $apiKey';
const validSid = 'cookie-session';
typedef Route = FutureOr<void> Function(HttpRequest request, List<int> body);

class SeenRequest {
  SeenRequest(HttpRequest request, this.body)
    : method = request.method,
      path = request.uri.path,
      uri = request.uri.toString(),
      query = request.uri.queryParameters,
      cookie = request.headers.value(HttpHeaders.cookieHeader),
      origin = request.headers.value('Origin'),
      referer = request.headers.value(HttpHeaders.refererHeader),
      authorization = request.headers.value(HttpHeaders.authorizationHeader),
      contentType = request.headers.value(HttpHeaders.contentTypeHeader);
  final String method, path, uri;
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
  // The key the fake server accepts; changing it revokes the client's key.
  late String validKey;
  // Whether requests carrying neither a valid key nor a session cookie are
  // served anyway (qBittorrent's subnet whitelist / localhost auth bypass).
  late bool allowUnauthenticated;

  ServerProfile profile({
    String key = apiKey,
    String basicUser = '',
    String basicPassword = '',
    String? address,
  }) => ServerProfile(
    id: 'local',
    name: 'Local test',
    url: address ?? url,
    username: 'tester',
    password: 'cookie password',
    apiKey: key,
    basicAuthUsername: basicUser,
    basicAuthPassword: basicPassword,
  );

  void jsonResponse(HttpRequest request, Object value) {
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(value));
  }

  int logins() => seen.where((r) => r.path == loginPath).length;
  int probes() => seen.where((r) => r.path == versionPath).length;

  Future<void> waitFor(bool Function() condition) async {
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (!condition()) {
      if (DateTime.now().isAfter(deadline)) fail('Condition not met in time.');
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  Matcher keyRejected([int? status]) => isA<QbAuthenticationException>()
      .having((e) => e.message, 'safe message', isNot(contains(apiKey)))
      .having(
        (e) => e.statusCode,
        'status',
        status ?? anything,
      );

  Matcher ordinaryFailure({Matcher? where}) => allOf([
    isA<QbException>(),
    isNot(isA<QbAuthenticationException>()),
    ?where,
  ]);

  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    url = 'http://127.0.0.1:${server.port}/qb/';
    seen = [];
    routes = {};
    validKey = apiKey;
    allowUnauthenticated = false;
    server.listen((request) async {
      final body = await request.fold<List<int>>(
        [],
        (buffer, chunk) => buffer..addAll(chunk),
      );
      seen.add(SeenRequest(request, body));
      final override = routes[request.uri.path];
      if (override != null) {
        await override(request, body);
        await request.response.close();
        return;
      }
      final authorization = request.headers.value(
        HttpHeaders.authorizationHeader,
      );
      final hasCookie = request.cookies.any(
        (cookie) => cookie.name == 'SID' && cookie.value == validSid,
      );
      if (authorization != null && authorization.startsWith('Bearer ')) {
        // A Bearer header is the whole verdict: a wrong key is refused even
        // when a cookie or the whitelist would have allowed the request.
        if (authorization != 'Bearer $validKey') {
          request.response.statusCode = HttpStatus.unauthorized;
          await request.response.close();
          return;
        }
      } else if (request.uri.path == loginPath) {
        request.response.cookies.add(Cookie('SID', validSid));
        request.response.write('Ok.');
        await request.response.close();
        return;
      } else if (!hasCookie && !allowUnauthenticated) {
        request.response.statusCode = HttpStatus.forbidden;
        await request.response.close();
        return;
      }
      switch (request.uri.path) {
        case versionPath:
          request.response.write('v5.2.3');
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
        case '/qb/api/v2/torrents/export':
          request.response.headers.contentType = ContentType(
            'application',
            'x-bittorrent',
          );
          request.response.add([0, 255, 128]);
        case '/qb/api/v2/search/start':
          jsonResponse(request, {'id': 7});
        default:
          request.response.write('Ok.');
      }
      await request.response.close();
    });
    client = QbClient(profile());
  });

  tearDown(() async {
    client.close();
    await server.close(force: true);
  });

  test(
    'a valid key signs in with one GET app/version: no auth/login, no cookie',
    () async {
      await client.login();
      final probe = seen.single;
      expect(probe.method, 'GET');
      expect(probe.path, versionPath);
      expect(probe.authorization, bearer);
      expect(probe.cookie, isNull);
      expect(probe.body, isEmpty);
      expect(probe.origin, 'http://127.0.0.1:${server.port}');
      expect(probe.referer, url);
      expect(logins(), 0);
      expect(client.authenticationBlocked, isFalse);

      // Explicit logins coalesce into a single probe as well.
      await Future.wait([client.login(), client.login(), client.login()]);
      expect(probes(), 2);
      expect(logins(), 0);
    },
  );

  test('the key is sent on every GET, form POST, multipart upload and binary read; never a cookie', () async {
    await client.login();
    expect(await client.getVersion(), 'v5.2.3');
    expect((await client.getTorrents()).single.hash, hash);
    final details = await client.getDetails(hash);
    expect(details.properties['total_size'], 1024);
    expect(await client.post('search/start', {'pattern': 'fixture'}), {
      'id': 7,
    });
    await client.deleteTorrents([hash]);
    expect(seen.last.path, '/qb/api/v2/torrents/delete');
    expect(seen.last.form['hashes'], hash);
    await client.addUrls('magnet:?xt=urn:btih:$hash');
    expect(seen.last.form['urls'], contains(hash));
    await client.addTorrentFile(
      'fixture.torrent',
      [0, 1, 2, 255],
      options: {'category': 'local'},
    );
    expect(seen.last.contentType, startsWith('multipart/form-data'));
    expect(seen.last.body, containsAllInOrder([0, 1, 2, 255]));
    expect(await client.getBytes('torrents/export', {'hash': hash}), [
      0,
      255,
      128,
    ]);
    expect(seen.length, greaterThan(9));
    for (final request in seen) {
      expect(request.authorization, bearer, reason: request.path);
      expect(request.cookie, isNull, reason: request.path);
    }
    expect(logins(), 0);
    expect(client.authenticationBlocked, isFalse);
  });

  test('cookies issued by the server in key mode are never retained', () async {
    routes[versionPath] = (request, _) {
      request.response.cookies
        ..add(Cookie('SID', 'portal'))
        ..add(Cookie('QBT_SID_8080', 'stray'));
      request.response.write('v5.2.3');
    };
    await client.login();
    expect(await client.getVersion(), 'v5.2.3');
    expect((await client.getTorrents()).single.hash, hash);
    expect(seen.every((r) => r.cookie == null), isTrue);
    expect(seen.every((r) => r.authorization == bearer), isTrue);
  });

  test('a wrong key is a permanent 401 block even where the server would allow an unauthenticated request', () async {
    allowUnauthenticated = true;
    client.close();
    client = QbClient(profile(key: 'wrong-key'));
    await expectLater(
      client.login(),
      throwsA(
        isA<QbAuthenticationException>()
            .having((e) => e.statusCode, 'status', 401)
            .having(
              (e) => e.message,
              'safe message',
              isNot(contains('wrong-key')),
            ),
      ),
    );
    expect(client.authenticationBlocked, isTrue);
    expect(seen.single.path, versionPath);
    expect(seen.single.authorization, 'Bearer wrong-key');
    expect(logins(), 0, reason: 'no password login fallback');

    // Nothing is retried, with or without the key, while blocked.
    final before = seen.length;
    await expectLater(client.login(), throwsA(keyRejected(401)));
    await expectLater(client.getVersion(), throwsA(keyRejected(401)));
    await expectLater(client.getTorrents(), throwsA(keyRejected(401)));
    await expectLater(client.getDetails(hash), throwsA(keyRejected(401)));
    await expectLater(
      client.getBytes('torrents/export', {'hash': hash}),
      throwsA(keyRejected(401)),
    );
    await expectLater(client.deleteTorrents([hash]), throwsA(keyRejected()));
    await expectLater(
      client.addUrls('magnet:?xt=urn:btih:$hash'),
      throwsA(keyRejected()),
    );
    await expectLater(
      client.addTorrentFile('fixture.torrent', [1]),
      throwsA(keyRejected()),
    );
    await expectLater(
      client.post('search/start', {'pattern': 'x'}),
      throwsA(keyRejected()),
    );
    expect(seen.length, before, reason: 'no network traffic while blocked');
    expect(
      seen.every((r) => r.authorization == 'Bearer wrong-key'),
      isTrue,
      reason: 'never a request without the key, never a cookie login',
    );

    // A fresh client with the corrected key reconnects.
    client.close();
    client = QbClient(profile());
    expect(client.authenticationBlocked, isFalse);
    await client.login();
    expect(await client.getVersion(), 'v5.2.3');
    expect(logins(), 0);
  });

  test('a 403 on the probe blocks exactly like a 401', () async {
    routes[versionPath] = (request, _) =>
        request.response.statusCode = HttpStatus.forbidden;
    await expectLater(client.login(), throwsA(keyRejected(403)));
    expect(client.authenticationBlocked, isTrue);
    final before = seen.length;
    await expectLater(client.login(), throwsA(keyRejected(403)));
    await expectLater(client.getTorrents(), throwsA(keyRejected(403)));
    expect(seen.length, before);
    expect(logins(), 0);
  });

  test('a key revoked mid-session: the read is sent once, no re-login, blocked for good', () async {
    await client.login();
    expect(await client.getVersion(), 'v5.2.3');
    validKey = 'rotated-on-server';
    final before = seen.length;
    await expectLater(client.getVersion(), throwsA(keyRejected(401)));
    expect(seen.length, before + 1, reason: 'exactly one attempt, no retry');
    expect(seen.last.authorization, bearer);
    expect(logins(), 0, reason: 'a rejected key must not try a password');
    expect(client.authenticationBlocked, isTrue);

    // Even once the server would accept the key again, the client stays
    // blocked offline: reconnecting means a new client.
    validKey = apiKey;
    await expectLater(client.getVersion(), throwsA(keyRejected(401)));
    await expectLater(client.getTorrents(), throwsA(keyRejected(401)));
    expect(seen.length, before + 1);
  });

  test('concurrent reads refused together are each sent once and share one rejection', () async {
    await client.login();
    validKey = 'rotated-on-server';
    await expectLater(client.getDetails(hash), throwsA(keyRejected(401)));
    final reads = seen.where((r) => r.query['hash'] == hash);
    expect(reads.length, 3, reason: 'no read is retried');
    expect(logins(), 0);
    expect(probes(), 1, reason: 'no re-probe either');
    expect(client.authenticationBlocked, isTrue);
  });

  Matcher forbidden() => ordinaryFailure(
    where: isA<QbException>().having((e) => e.statusCode, 'status', 403),
  );

  test('a 403 on a mutation with a valid key is an operation refusal: sent once, one GET probe, no login, client stays usable', () async {
    // qBittorrent 5.2.x answers 403 for e.g. torrents/setSavePath to an
    // unwritable directory even though the key is fine; only app/version
    // (same Bearer, no cookie, no auth/login) decides whether the key is bad.
    await client.login();
    var adds = 0;
    routes['/qb/api/v2/torrents/add'] = (request, _) {
      adds++;
      request.response.statusCode = HttpStatus.forbidden;
    };
    await expectLater(
      client.addTorrentFile('fixture.torrent', [1, 2, 3]),
      throwsA(forbidden()),
    );
    expect(adds, 1, reason: 'the upload is never replayed');
    expect(logins(), 0);
    expect(probes(), 2, reason: 'sign-in probe plus one confirmation probe');
    expect(seen.last.path, versionPath);
    expect(seen.last.method, 'GET');
    expect(seen.last.authorization, bearer);
    expect(seen.last.cookie, isNull);
    expect(client.authenticationBlocked, isFalse);
    expect(await client.getVersion(), 'v5.2.3');
    expect((await client.getTorrents()).single.hash, hash);
    expect(adds, 1);
    expect(seen.every((r) => r.authorization == bearer), isTrue);
    expect(seen.every((r) => r.cookie == null), isTrue);

    // A 401 on a form mutation stays a final key verdict with a fresh client.
    client.close();
    client = QbClient(profile());
    await client.login();
    var deletes = 0;
    routes['/qb/api/v2/torrents/delete'] = (request, _) {
      deletes++;
      request.response.statusCode = HttpStatus.unauthorized;
    };
    final before = probes();
    await expectLater(client.deleteTorrents([hash]), throwsA(keyRejected(401)));
    expect(deletes, 1);
    expect(probes(), before, reason: 'a 401 needs no confirmation');
    expect(logins(), 0);
    expect(client.authenticationBlocked, isTrue);
  });

  test('a 403 from another endpoint whose confirmation probe is also 403 blocks for good', () async {
    await client.login();
    var infos = 0;
    routes['/qb/api/v2/torrents/info'] = (request, _) {
      infos++;
      request.response.statusCode = HttpStatus.forbidden;
    };
    routes[versionPath] = (request, _) =>
        request.response.statusCode = HttpStatus.forbidden;
    await expectLater(client.getTorrents(), throwsA(keyRejected(403)));
    expect(infos, 1, reason: 'the read is not retried');
    expect(probes(), 2, reason: 'exactly one confirmation probe');
    expect(seen.last.path, versionPath);
    expect(seen.last.authorization, bearer);
    expect(seen.last.cookie, isNull);
    expect(logins(), 0);
    expect(client.authenticationBlocked, isTrue);

    // Blocked offline even once the server would accept the key again.
    routes.remove(versionPath);
    routes.remove('/qb/api/v2/torrents/info');
    final before = seen.length;
    await expectLater(client.getTorrents(), throwsA(keyRejected(403)));
    await expectLater(client.getVersion(), throwsA(keyRejected(403)));
    await expectLater(client.login(), throwsA(keyRejected(403)));
    await expectLater(client.deleteTorrents([hash]), throwsA(keyRejected()));
    expect(seen.length, before);
  });

  test('simultaneous 403s share one confirmation probe', () async {
    await client.login();
    final release = Completer<void>();
    for (final path in [
      '/qb/api/v2/torrents/properties',
      '/qb/api/v2/torrents/files',
      '/qb/api/v2/torrents/trackers',
    ]) {
      routes[path] = (request, _) =>
          request.response.statusCode = HttpStatus.forbidden;
    }
    routes[versionPath] = (request, _) async {
      await release.future;
      request.response.write('v5.2.3');
    };
    final verdict = expectLater(client.getDetails(hash), throwsA(forbidden()));
    await waitFor(
      () =>
          seen.where((r) => r.query['hash'] == hash).length == 3 &&
          probes() == 2,
    );
    // Every 403 has arrived while the single probe is still pending.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(probes(), 2);
    release.complete();
    await verdict;
    expect(probes(), 2, reason: 'one probe for all three refusals');
    expect(seen.where((r) => r.query['hash'] == hash).length, 3);
    expect(logins(), 0);
    expect(client.authenticationBlocked, isFalse);

    // The shared probe is cleared: a later 403 confirms again, and a probe
    // that is refused then blocks every waiter.
    routes[versionPath] = (request, _) =>
        request.response.statusCode = HttpStatus.forbidden;
    await expectLater(client.getDetails(hash), throwsA(keyRejected(403)));
    expect(probes(), 3);
    expect(client.authenticationBlocked, isTrue);
  });

  test('a confirmation probe that fails for an ordinary reason leaves the client unblocked', () async {
    await client.login();
    var adds = 0;
    routes['/qb/api/v2/torrents/add'] = (request, _) {
      adds++;
      request.response.statusCode = HttpStatus.forbidden;
    };
    // Server error on the probe: the original 403 surfaces, nothing is cached.
    routes[versionPath] = (request, _) =>
        request.response.statusCode = HttpStatus.internalServerError;
    await expectLater(
      client.addUrls('magnet:?xt=urn:btih:$hash'),
      throwsA(forbidden()),
    );
    expect(adds, 1);
    expect(probes(), 2);
    expect(client.authenticationBlocked, isFalse);
    await expectLater(
      client.addUrls('magnet:?xt=urn:btih:$hash'),
      throwsA(forbidden()),
    );
    expect(adds, 2, reason: 'each call is sent once, never replayed');
    expect(probes(), 3, reason: 'no stale verdict is reused');
    expect(client.authenticationBlocked, isFalse);
    routes.remove(versionPath);
    expect(await client.getVersion(), 'v5.2.3');
    expect((await client.getTorrents()).single.hash, hash);

    // Probe timeout (unreachable mid-request): still unblocked and reusable.
    client.close();
    client = QbClient(profile(), timeout: const Duration(milliseconds: 100));
    await client.login();
    final release = Completer<void>();
    routes[versionPath] = (request, _) => release.future;
    await expectLater(
      client.addUrls('magnet:?xt=urn:btih:$hash'),
      throwsA(forbidden()),
    );
    expect(adds, 3);
    expect(client.authenticationBlocked, isFalse);
    release.complete();
    routes.remove(versionPath);
    routes.remove('/qb/api/v2/torrents/add');
    expect(await client.getVersion(), 'v5.2.3');
    await client.addUrls('magnet:?xt=urn:btih:$hash');
    expect(logins(), 0);
    expect(seen.every((r) => r.authorization == bearer), isTrue);
    expect(seen.every((r) => r.cookie == null), isTrue);
  });

  test('a late 401 for a pending mutation still blocks the client, without a login', () async {
    await client.login();
    final release = Completer<void>();
    routes['/qb/api/v2/torrents/delete'] = (request, _) async {
      await release.future;
      request.response.statusCode = HttpStatus.unauthorized;
    };
    final verdict = expectLater(
      client.deleteTorrents([hash]),
      throwsA(keyRejected(401)),
    );
    await waitFor(
      () => seen.any((r) => r.path == '/qb/api/v2/torrents/delete'),
    );
    // Other work continues while the mutation is pending.
    expect(await client.getVersion(), 'v5.2.3');
    expect(client.authenticationBlocked, isFalse);
    release.complete();
    await verdict;
    expect(client.authenticationBlocked, isTrue);
    final before = seen.length;
    await expectLater(client.getVersion(), throwsA(keyRejected(401)));
    expect(seen.length, before);
    expect(logins(), 0);
  });

  test('server errors, timeouts and unreachable hosts are recoverable and never block', () async {
    // Transient server error on the probe.
    routes[versionPath] = (request, _) =>
        request.response.statusCode = HttpStatus.serviceUnavailable;
    await expectLater(
      client.login(),
      throwsA(
        ordinaryFailure(
          where: isA<QbException>().having((e) => e.statusCode, 'status', 503),
        ),
      ),
    );
    expect(client.authenticationBlocked, isFalse);
    // Not signed in yet: reads ask for an explicit login without network.
    var before = seen.length;
    await expectLater(
      client.getVersion(),
      throwsA(
        ordinaryFailure(
          where: isA<QbException>().having(
            (e) => e.message,
            'needs sign-in',
            contains('Sign in'),
          ),
        ),
      ),
    );
    expect(seen.length, before);
    routes.remove(versionPath);
    await client.login();
    expect(probes(), 2, reason: 'the same client simply tries again');
    expect(await client.getVersion(), 'v5.2.3');

    // A 500 on an established generation is an ordinary failure.
    routes['/qb/api/v2/torrents/info'] = (request, _) =>
        request.response.statusCode = HttpStatus.internalServerError;
    await expectLater(
      client.getTorrents(),
      throwsA(
        ordinaryFailure(
          where: isA<QbException>().having((e) => e.statusCode, 'status', 500),
        ),
      ),
    );
    expect(client.authenticationBlocked, isFalse);
    routes.remove('/qb/api/v2/torrents/info');
    expect((await client.getTorrents()).single.hash, hash);

    // Timeout.
    client.close();
    client = QbClient(profile(), timeout: const Duration(milliseconds: 100));
    final release = Completer<void>();
    routes[versionPath] = (request, _) => release.future;
    await expectLater(
      client.login(),
      throwsA(
        ordinaryFailure(
          where: isA<QbException>().having(
            (e) => e.message,
            'timeout',
            contains('timed out'),
          ),
        ),
      ),
    );
    expect(client.authenticationBlocked, isFalse);
    release.complete();
    routes.remove(versionPath);
    await client.login();
    expect(await client.getVersion(), 'v5.2.3');

    // Unreachable server (closed loopback port).
    final gone = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final goneUrl = 'http://127.0.0.1:${gone.port}/qb/';
    await gone.close(force: true);
    client.close();
    client = QbClient(profile(address: goneUrl));
    await expectLater(client.login(), throwsA(ordinaryFailure()));
    expect(client.authenticationBlocked, isFalse);
    before = seen.length;
    await expectLater(client.login(), throwsA(ordinaryFailure()));
    expect(seen.length, before, reason: 'that server never saw anything');
    expect(logins(), 0);
  });

  test(
    'a 2xx that is not a version string is not a sign-in and does not block',
    () async {
      Future<void> expectNoSession(String reason) async {
        await expectLater(
          client.login(),
          throwsA(ordinaryFailure()),
          reason: reason,
        );
        expect(client.authenticationBlocked, isFalse, reason: reason);
        final before = seen.length;
        await expectLater(
          client.getTorrents(),
          throwsA(ordinaryFailure()),
          reason: reason,
        );
        expect(seen.length, before, reason: 'no generation: $reason');
      }

      routes[versionPath] = (request, _) {
        request.response.headers.contentType = ContentType.html;
        request.response.write('<html><body>Please sign in</body></html>');
      };
      await expectNoSession('HTML portal page');
      routes[versionPath] = (request, _) =>
          request.response.statusCode = HttpStatus.noContent;
      await expectNoSession('204 without a body');
      routes[versionPath] = (request, _) {};
      await expectNoSession('200 with an empty body');
      routes[versionPath] = (request, _) => request.response.write('Ok.');
      await expectNoSession('200 with a non-version body');

      routes.remove(versionPath);
      await client.login();
      expect(await client.getVersion(), 'v5.2.3');
      expect(logins(), 0);
    },
  );

  test('an API key combined with HTTP Basic credentials is refused before any network', () {
    for (final conflicting in [
      profile(basicUser: 'proxy'),
      profile(basicPassword: 'proxy secret'),
      profile(basicUser: 'proxy', basicPassword: 'proxy secret'),
    ]) {
      expect(
        () => QbClient(conflicting),
        throwsA(
          allOf(
            ordinaryFailure(),
            isA<QbException>().having(
              (e) => e.message,
              'safe message',
              allOf(
                isNot(contains(apiKey)),
                isNot(contains('proxy secret')),
                contains('API key'),
              ),
            ),
          ),
        ),
      );
    }
    expect(seen, isEmpty);
  });

  test('keys with whitespace, line breaks, control or non-ASCII characters are refused before any network', () {
    for (final bad in [
      ' $apiKey',
      '$apiKey ',
      'abc def',
      'abc\r\nX-Injected: 1',
      'abc\n',
      'abc\r',
      '\tabc',
      'abc\x00',
      'abc\x7f',
      'ключ',
      'a' * 1025,
    ]) {
      expect(
        () => QbClient(profile(key: bad)),
        throwsA(
          allOf(
            ordinaryFailure(),
            isA<QbException>().having(
              (e) => e.message,
              'safe message',
              isNot(contains(bad.trim())),
            ),
          ),
        ),
        reason: jsonEncode(bad),
      );
    }
    expect(seen, isEmpty);
  });

  test(
    'keys made of any visible ASCII characters are accepted as-is',
    () async {
      const exotic =
          r'!"#$%&'
          "'"
          r'()*,:;<>?@[\]^`{|}';
      validKey = exotic;
      client.close();
      client = QbClient(profile(key: exotic));
      await client.login();
      expect(seen.single.authorization, 'Bearer $exotic');
      expect(await client.getVersion(), 'v5.2.3');
    },
  );

  test(
    'the key never appears in errors, URLs, query, Origin or Referer',
    () async {
      final errors = <Object>[];
      Future<void> collect(Future<void> Function() action) async {
        try {
          await action();
          fail('expected a failure');
        } on QbException catch (error) {
          errors.add(error);
        }
      }

      routes[versionPath] = (request, _) =>
          request.response.statusCode = HttpStatus.internalServerError;
      await collect(client.login);
      routes[versionPath] = (request, _) {
        request.response.statusCode = 307;
        request.response.headers.set(
          HttpHeaders.locationHeader,
          'http://localhost:${server.port}/collect',
        );
      };
      await collect(client.login);
      routes.remove(versionPath);
      await client.login();
      validKey = 'rotated-on-server';
      await collect(client.getVersion);
      await collect(client.login);
      await collect(() => client.deleteTorrents([hash]));
      expect(errors.length, 5);
      for (final error in errors) {
        expect(error.toString(), isNot(contains(apiKey)));
        expect((error as QbException).message, isNot(contains(apiKey)));
      }
      for (final request in seen) {
        expect(request.uri, isNot(contains(apiKey)));
        expect(request.query.values, isNot(contains(apiKey)));
        expect(request.origin, isNot(contains(apiKey)));
        expect(request.referer, isNot(contains(apiKey)));
        expect(request.path, isNot(contains(apiKey)));
        expect(request.authorization, bearer, reason: 'header only');
      }
    },
  );

  test('a cross-origin redirect is blocked without the key; same-origin redirects keep it', () async {
    final target = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final leaked = <String?>[];
    target.listen((request) async {
      leaked.add(request.headers.value(HttpHeaders.authorizationHeader));
      await request.response.close();
    });
    addTearDown(() => target.close(force: true));
    for (final location in [
      'http://127.0.0.1:${target.port}/collect',
      'http://localhost:${server.port}/qb/api/v2/app/version',
    ]) {
      routes[versionPath] = (request, _) {
        request.response.statusCode = 307;
        request.response.headers.set(HttpHeaders.locationHeader, location);
      };
      await expectLater(
        client.login(),
        throwsA(
          ordinaryFailure(
            where: isA<QbException>().having(
              (e) => e.message,
              'blocked',
              contains('blocked'),
            ),
          ),
        ),
      );
      expect(leaked, isEmpty);
      expect(client.authenticationBlocked, isFalse);
    }

    routes[versionPath] = (request, _) {
      request.response.statusCode = 302;
      request.response.headers.set(
        HttpHeaders.locationHeader,
        '/qb/api/v2/app/realVersion',
      );
    };
    routes['/qb/api/v2/app/realVersion'] = (request, _) {
      if (request.headers.value(HttpHeaders.authorizationHeader) == bearer) {
        request.response.write('v5.2.3');
      } else {
        request.response.statusCode = HttpStatus.unauthorized;
      }
    };
    await client.login();
    expect(await client.getVersion(), 'v5.2.3');
    expect(seen.last.path, '/qb/api/v2/app/realVersion');
    expect(seen.last.authorization, bearer);
    expect(seen.last.cookie, isNull);
  });

  test('a closed client in key mode refuses work without network', () async {
    await client.login();
    client.close();
    final before = seen.length;
    await expectLater(client.getVersion(), throwsA(ordinaryFailure()));
    await expectLater(client.login(), throwsA(ordinaryFailure()));
    expect(seen.length, before);
    expect(client.authenticationBlocked, isFalse);
  });

  test('an empty key leaves cookie-session mode exactly as before', () async {
    client.close();
    client = QbClient(profile(key: ''));
    await client.login();
    expect(seen.single.path, loginPath);
    expect(seen.single.method, 'POST');
    expect(seen.single.authorization, isNull);
    expect(seen.single.form, {
      'username': 'tester',
      'password': 'cookie password',
    });
    expect(await client.getVersion(), 'v5.2.3');
    expect(seen.last.cookie, 'SID=$validSid');
    expect(seen.last.authorization, isNull);

    // HTTP Basic credentials remain available without a key.
    client.close();
    client = QbClient(
      profile(key: '', basicUser: 'proxy', basicPassword: 'proxy secret'),
    );
    await client.login();
    expect(
      seen.last.authorization,
      'Basic ${base64Encode(utf8.encode('proxy:proxy secret'))}',
    );
    expect(seen.last.path, loginPath);
  });
}
