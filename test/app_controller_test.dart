import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/app_controller.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/core/qb_client.dart';

class UnavailableProfileStorage extends FlutterSecureStorage {
  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (key == 'profiles.v1') {
      throw StateError('Simulated unavailable keystore');
    }
    return super.read(
      key: key,
      iOptions: iOptions,
      aOptions: aOptions,
      lOptions: lOptions,
      webOptions: webOptions,
      mOptions: mOptions,
      wOptions: wOptions,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    // This integration test uses real loopback sockets, not widget HTTP mocks.
    HttpOverrides.global = null;
  });

  test('switching servers discards delayed responses and restores the selected profile', () async {
    final firstListSeen = Completer<void>();
    final releaseFirst = Completer<void>();
    final servers = <HttpServer>[];
    Future<HttpServer> fixture(String name, {bool delayed = false}) async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      servers.add(server);
      server.listen((request) async {
        await request.drain<void>();
        final response = request.response;
        if (request.uri.path.endsWith('auth/login')) {
          response.cookies.add(Cookie('SID', name.replaceAll(' ', '-')));
          response.write('Ok.');
        } else if (request.uri.path.endsWith('app/version')) {
          response.write('v5.1.0');
        } else if (request.uri.path.endsWith('torrents/info')) {
          if (delayed) {
            if (!firstListSeen.isCompleted) firstListSeen.complete();
            await releaseFirst.future;
          }
          response.headers.contentType = ContentType.json;
          response.write(
            jsonEncode([
              {'hash': 'a' * 40, 'name': name, 'progress': 0.5},
            ]),
          );
        } else {
          response.statusCode = 404;
        }
        try {
          await response.close();
        } catch (_) {
          /* Closed stale client. */
        }
      });
      return server;
    }

    addTearDown(() async {
      for (final server in servers) {
        await server.close(force: true);
      }
    });
    final a = await fixture('Server A', delayed: true);
    final b = await fixture('Server B');
    ServerProfile profile(String id, HttpServer server) => ServerProfile(
      id: id,
      name: id,
      url: 'http://127.0.0.1:${server.port}',
      username: 'user',
      password: 'do-not-log',
    );
    final controller = AppController();
    addTearDown(controller.dispose);
    final first = controller.saveProfile(profile('A', a));
    await firstListSeen.future;
    await controller.saveProfile(profile('B', b));
    expect(
      controller.torrents.single.name,
      'Server B',
      reason: 'No wait for the old generation is required',
    );
    releaseFirst.complete();
    await first;
    await controller.refresh();
    expect(controller.currentProfile?.id, 'B');
    expect(controller.torrents.single.name, 'Server B');
    final restored = AppController();
    addTearDown(restored.dispose);
    await restored.init();
    expect(restored.currentProfile?.id, 'B');
    expect(restored.profiles.map((p) => p.id), ['A', 'B']);
    expect(restored.torrents.single.name, 'Server B');
    await restored.removeProfile(restored.profiles.first);
    expect(restored.profiles.single.id, 'B');
    final storage = const FlutterSecureStorage();
    final saved = jsonDecode((await storage.read(key: 'profiles.v1'))!) as List;
    expect(saved.length, 1);
    expect(saved.single['id'], 'B');
  });

  test(
    'a failed keystore read cannot overwrite existing credentials',
    () async {
      final original = jsonEncode([
        {
          'id': 'existing',
          'name': 'NAS',
          'url': 'http://127.0.0.1:8080',
          'username': 'user',
          'password': 'keep-existing-secret',
        },
      ]);
      FlutterSecureStorage.setMockInitialValues({'profiles.v1': original});
      final controller = AppController(storage: UnavailableProfileStorage());
      addTearDown(controller.dispose);
      await controller.init();
      expect(controller.error, isNotNull);
      await expectLater(
        controller.saveProfile(
          const ServerProfile(
            id: 'new',
            name: 'New',
            url: 'http://127.0.0.1:8081',
            username: 'new',
            password: 'new-secret',
          ),
        ),
        throwsA(isA<QbException>()),
      );
      expect(
        await const FlutterSecureStorage().read(key: 'profiles.v1'),
        original,
      );
    },
  );

  test('rejected login stops foreground and persisted background retries until explicit reconnect', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    var logins = 0;
    var accepted = false;
    server.listen((request) async {
      await request.drain<void>();
      if (request.uri.path.endsWith('auth/login')) {
        logins++;
        if (accepted) {
          request.response.cookies.add(Cookie('SID', 'accepted'));
          request.response.write('Ok.');
        } else {
          request.response.write('Fails.');
        }
      } else if (request.uri.path.endsWith('app/version')) {
        request.response.write('v5.1.0');
      } else {
        request.response.headers.contentType = ContentType.json;
        request.response.write('[]');
      }
      await request.response.close();
    });
    final profile = ServerProfile(
      id: 'home',
      name: 'NAS',
      url: 'http://127.0.0.1:${server.port}',
      username: 'user',
      password: 'old',
    );
    final controller = AppController();
    addTearDown(controller.dispose);
    await controller.saveProfile(profile);
    expect(controller.requiresAuthentication, isTrue);
    expect(logins, 1);
    for (var i = 0; i < 3; i++) {
      await controller.refresh();
    }
    expect(logins, 1);
    expect(
      await const FlutterSecureStorage().read(key: 'auth.blocked.home'),
      'true',
    );
    final restored = AppController();
    addTearDown(restored.dispose);
    await restored.init();
    expect(restored.requiresAuthentication, isTrue);
    expect(logins, 1, reason: 'Restarting must preserve the rejection block');
    await restored.reconnect();
    expect(logins, 2);
    accepted = true;
    await restored.reconnect();
    expect(logins, 3);
    expect(restored.requiresAuthentication, isFalse);
    expect(
      await const FlutterSecureStorage().read(key: 'auth.blocked.home'),
      isNull,
    );
    await restored.refresh();
    expect(logins, 3);
  });
}
