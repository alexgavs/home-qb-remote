import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/integrations/jellyfin_client.dart';
import 'package:home_qb_remote/integrations/jellyfin_models.dart';

const userId = '0123456789abcdef0123456789abcdef';
const fakeToken = 'fictional-token-not-a-real-secret';

void main() {
  late HttpServer server;
  late JellyfinClient client;
  late String base;
  late List<HttpRequest> requests;
  late FutureOr<void> Function(HttpRequest) route;

  JellyfinProfile profile({
    String? url,
    String token = fakeToken,
    String? user,
  }) => JellyfinProfile(
    id: 'fixture',
    name: 'Fixture',
    url: url ?? base,
    accessToken: token,
    userId: user ?? userId,
  );

  Future<void> json(HttpRequest request, Object data) async {
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode(data));
    await request.response.close();
  }

  setUp(() async {
    requests = [];
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    base = 'http://127.0.0.1:${server.port}/media';
    route = (request) => request.uri.path == '/media/Users/Me'
        ? json(request, {'Id': userId, 'Name': 'Fixture user'})
        : json(request, {'Items': []});
    server.listen((request) async {
      requests.add(request);
      await route(request);
    });
    client = JellyfinClient(profile());
  });

  tearDown(() async {
    client.close();
    await server.close(force: true);
  });

  Matcher code(JellyfinErrorCode value) => isA<JellyfinException>().having(
    (error) => error.code,
    'safe code',
    value,
  );

  test('profile round trip preserves independent protected-store contract', () {
    final original = profile();
    final restored = JellyfinProfile.fromJson(original.toJson());
    expect(restored.toJson(), original.toJson());
    expect(restored.toString(), isNot(contains(fakeToken)));
  });

  test(
    'identity is coalesced and search is authenticated and user scoped',
    () async {
      route = (request) async {
        expect(request.method, 'GET');
        expect(
          request.headers.value(HttpHeaders.authorizationHeader),
          'MediaBrowser Token="$fakeToken"',
        );
        expect(request.headers.value(HttpHeaders.cookieHeader), isNull);
        expect(request.uri.query, isNot(contains(fakeToken)));
        if (request.uri.path.endsWith('/Users/Me')) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          await json(request, {
            'Id': userId.toUpperCase(),
            'Name': 'Library user',
          });
        } else {
          expect(request.uri.path, '/media/Items');
          expect(request.uri.queryParameters['UserId'], userId);
          expect(request.uri.queryParameters['SearchTerm'], 'A&B / עברית');
          expect(request.uri.queryParameters['Limit'], '100');
          expect(request.uri.queryParameters['Recursive'], 'true');
          expect(request.uri.queryParameters['Fields'], 'Overview');
          await json(request, {
            'Items': [
              {
                'Id': 'item-1',
                'Name': 'Fixture film',
                'ProductionYear': 2025,
                'Type': 'Movie',
                'Overview': '<b>Plain text only</b>',
              },
            ],
          });
        }
      };
      final result = await Future.wait([
        client.search(' A&B / עברית '),
        client.search(' A&B / עברית '),
      ]);
      expect(requests.where((r) => r.uri.path.endsWith('/Users/Me')).length, 1);
      expect(result.first.single.title, 'Fixture film');
      expect(result.first.single.year, 2025);
      expect(result.first.single.type, 'Movie');
      expect(result.first.single.overview, '<b>Plain text only</b>');
      expect(() => result.first.clear(), throwsUnsupportedError);
      await client.validate();
      expect(requests.length, 3);
    },
  );

  test('a mismatched token owner cannot trigger catalog access', () async {
    route = (request) => json(request, {
      'Id': 'ffffffffffffffffffffffffffffffff',
      'Name': 'Different user',
    });
    await expectLater(
      client.search('anything'),
      throwsA(code(JellyfinErrorCode.authentication)),
    );
    expect(requests.length, 1);
    expect(requests.single.uri.path, '/media/Users/Me');
  });

  test('user-less API keys and revoked credentials fail without retry or body leak', () async {
    for (final status in [400, 401, 403]) {
      route = (request) async {
        request.response.statusCode = status;
        request.response.write('PRIVATE $fakeToken /private/library');
        await request.response.close();
      };
      try {
        await client.validate();
        fail('Expected safe authentication failure');
      } on JellyfinException catch (error) {
        expect(error.code, JellyfinErrorCode.authentication);
        expect(error.statusCode, status);
        expect(error.toString(), isNot(contains(fakeToken)));
        expect(error.toString(), isNot(contains('/private')));
      }
    }
    expect(requests.length, 3);
  });

  test('foreign-origin redirects never receive a token', () async {
    final foreign = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    var foreignRequests = 0;
    foreign.listen((request) async {
      foreignRequests++;
      await request.response.close();
    });
    try {
      route = (request) async {
        request.response.statusCode = 302;
        request.response.headers.set(
          'Location',
          'http://127.0.0.1:${foreign.port}/steal',
        );
        await request.response.close();
      };
      await expectLater(
        client.validate(),
        throwsA(code(JellyfinErrorCode.redirect)),
      );
      expect(foreignRequests, 0);
      expect(requests.length, 1);
    } finally {
      await foreign.close(force: true);
    }
  });

  test(
    'same-host other applications and query-token redirects are refused',
    () async {
      for (final location in ['/other-app', '/media/Users/Me?ApiKey=private']) {
        route = (request) async {
          request.response.statusCode = 307;
          request.response.headers.set('Location', location);
          await request.response.close();
        };
        await expectLater(
          client.validate(),
          throwsA(code(JellyfinErrorCode.redirect)),
        );
      }
      expect(requests.length, 2);
    },
  );

  test(
    'slash normalization retains user scope and search parameters',
    () async {
      route = (request) async {
        if (request.uri.path == '/media/Users/Me') {
          await json(request, {'Id': userId, 'Name': 'User'});
        } else if (request.uri.path == '/media/Items') {
          request.response.statusCode = 301;
          request.response.headers.set('Location', '/media/Items/');
          await request.response.close();
        } else {
          expect(request.uri.path, '/media/Items/');
          expect(request.uri.queryParameters['UserId'], userId);
          expect(request.uri.queryParameters['SearchTerm'], 'test');
          await json(request, {'Items': []});
        }
      };
      expect(await client.search('test'), isEmpty);
      expect(requests.length, 3);
    },
  );

  test('invalid JSON and malformed item records fail closed', () async {
    await client.validate();
    for (final body in [
      'not json $fakeToken',
      '[]',
      '{"Items":null}',
      '{"Items":[{"Id":"x"}]}',
    ]) {
      route = (request) async {
        request.response.write(body);
        await request.response.close();
      };
      await expectLater(
        client.search(''),
        throwsA(code(JellyfinErrorCode.invalidResponse)),
      );
    }
  });

  test(
    'response limits cover chunked bodies and oversized result counts',
    () async {
      await client.validate();
      route = (request) async {
        request.response.write(
          jsonEncode({
            'Items': List.filled(101, {'Id': 'x', 'Name': 'x'}),
          }),
        );
        await request.response.close();
      };
      await expectLater(
        client.search(''),
        throwsA(code(JellyfinErrorCode.invalidResponse)),
      );
      route = (request) async {
        // No content length: the streaming bound must still reject this body.
        for (var i = 0; i < 34; i++) {
          request.response.write('x' * 65536);
        }
        await request.response.close();
      };
      await expectLater(
        client.search(''),
        throwsA(code(JellyfinErrorCode.invalidResponse)),
      );
    },
  );

  test('timeouts and close expose only safe errors', () async {
    client.close();
    client = JellyfinClient(
      profile(),
      timeout: const Duration(milliseconds: 40),
    );
    route = (request) async {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await request.response.close();
    };
    await expectLater(
      client.validate(),
      throwsA(code(JellyfinErrorCode.connection)),
    );
    client.close();
    final before = requests.length;
    await expectLater(
      client.search('test'),
      throwsA(code(JellyfinErrorCode.connection)),
    );
    expect(requests.length, before);
  });

  test(
    'URLs, identifiers and header injection are rejected before network use',
    () async {
      for (final url in [
        'file:///tmp/x',
        'http://user:secret@example.test',
        '$base?q=secret',
        '$base#secret',
        'http://example.test:0',
        'https://example.test/a/%2f../b',
        'https://example.test/a/%5cother',
        'https://example.test/a/%0aother',
      ]) {
        expect(
          () => JellyfinClient(profile(url: url)),
          throwsA(code(JellyfinErrorCode.invalidProfile)),
        );
      }
      expect(
        () => JellyfinClient(profile(user: '../../admin')),
        throwsA(code(JellyfinErrorCode.invalidProfile)),
      );
      expect(
        () => JellyfinClient(profile(token: 'secret\r\nX-Steal: yes')),
        throwsA(code(JellyfinErrorCode.invalidProfile)),
      );
      await expectLater(
        client.search('bad\nquery'),
        throwsA(code(JellyfinErrorCode.invalidProfile)),
      );
      expect(requests, isEmpty);
    },
  );
}
