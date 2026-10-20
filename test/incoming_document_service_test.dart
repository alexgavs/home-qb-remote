import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/services/incoming_document_service.dart';

// Channel name and method are spelled out here on purpose: the test verifies
// the contract with AppDelegate.swift, not the Dart constants.
const iosChannel = MethodChannel('org.homeqb/export');
const exportMethod = 'exportTorrent';

const inboxUri =
    'file:///private/var/mobile/Containers/Data/Application/'
    '1D2E3F40-0000-4000-8000-000000000001/Documents/Inbox/Ubuntu%2024.04.torrent';

/// Complete bencode with an `info` dictionary and a binary `pieces` string
/// covering every byte class that a text-oriented transport could corrupt.
final torrent = Uint8List.fromList([
  ...utf8.encode('d8:announce16:http://t.invalid4:infod6:lengthi1e4:name'),
  ...utf8.encode('4:test6:pieces20:'),
  0x00,
  0xff,
  0x7f,
  0x80,
  0x0a,
  0x0d,
  0x1a,
  0x09,
  0x22,
  0x5c,
  0xc3,
  0xa9,
  0xe2,
  0x82,
  0xac,
  0xf0,
  0x9f,
  0x98,
  0x80,
  0x00,
  ...utf8.encode('ee'),
]);

/// Installs a mock handler and records every call made on [channel].
List<MethodCall> record(
  MethodChannel channel,
  Future<Object?> Function(MethodCall call) handler,
) {
  final calls = <MethodCall>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) {
        calls.add(call);
        return handler(call);
      });
  addTearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );
  return calls;
}

Matcher throwsImport([String? containing]) => throwsA(
  isA<IncomingDocumentException>().having(
    (e) => e.message,
    'message',
    containing == null ? isNotEmpty : contains(containing),
  ),
);

Future<Object?> okPayload(MethodCall _) async => <String, Object?>{
  'name': 'Ubuntu 24.04.torrent',
  'bytes': torrent,
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('iOS channel contract', () {
    test(
      'sends importTorrent on org.homeqb/export with the uri string only',
      () async {
        final calls = record(iosChannel, okPayload);
        final service = IncomingDocumentService(platform: TargetPlatform.iOS);
        final result = await service.read(Uri.parse(inboxUri));

        final call = calls.single;
        expect(call.method, 'importTorrent');
        expect(call.method, isNot(exportMethod));
        final arguments = call.arguments as Map<Object?, Object?>;
        expect(arguments.keys, ['uri']);
        expect(arguments['uri'], inboxUri);
        expect(result.keys, unorderedEquals(['name', 'bytes']));
      },
    );

    test(
      'preserves every byte and returns the sanitized native name',
      () async {
        record(iosChannel, okPayload);
        final service = IncomingDocumentService(platform: TargetPlatform.iOS);
        final result = await service.read(Uri.parse(inboxUri));
        expect(result['bytes'], isA<Uint8List>());
        expect(result['bytes'], equals(torrent));
        expect((result['bytes'] as Uint8List).length, torrent.length);
        expect(result['name'], 'Ubuntu 24.04.torrent');
      },
    );

    test(
      'native name is sanitized but never trusted for directories',
      () async {
        record(
          iosChannel,
          (_) async => {'name': '../../Library/evil: "x"?', 'bytes': torrent},
        );
        final service = IncomingDocumentService(platform: TargetPlatform.iOS);
        final result = await service.read(Uri.parse(inboxUri));
        expect(result['name'], 'evil_ _x__.torrent');
        expect(result['name'], isNot(contains('/')));
      },
    );

    test(
      'honours debugDefaultTargetPlatformOverride when no platform is injected',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final calls = record(iosChannel, okPayload);
        final result = await IncomingDocumentService().read(
          Uri.parse(inboxUri),
        );
        expect(calls.single.method, 'importTorrent');
        expect(result['bytes'], equals(torrent));
      },
    );

    test('non-iOS platforms never reach the native bridge', () async {
      final calls = record(iosChannel, okPayload);
      for (final platform in [
        TargetPlatform.android,
        TargetPlatform.windows,
        TargetPlatform.macOS,
        TargetPlatform.linux,
        TargetPlatform.fuchsia,
      ]) {
        final service = IncomingDocumentService(platform: platform);
        await expectLater(
          service.read(Uri.parse(inboxUri)),
          throwsImport('not supported'),
          reason: '$platform must not use the iOS import bridge',
        );
      }
      expect(calls, isEmpty);
    });
  });

  group('URI validation', () {
    test('accepts local file URIs naming a .torrent document', () {
      for (final text in [
        inboxUri,
        'file:///private/var/mobile/Containers/Shared/AppGroup/x/File%20Provider%20Storage/a.torrent',
        'file:///Inbox/UPPER.TORRENT',
        'file:///Inbox/Show..S01.torrent',
        'file:///Inbox/%D0%A4%D0%B8%D0%BB%D1%8C%D0%BC.torrent',
      ]) {
        expect(
          IncomingDocumentService.isImportableDocumentUri(Uri.parse(text)),
          isTrue,
          reason: text,
        );
      }
    });

    test('rejects non-file, remote, authenticated and malformed URIs', () {
      for (final text in [
        'https://example.invalid/file.torrent',
        'http://127.0.0.1/file.torrent',
        'magnet:?xt=urn:btih:abc',
        'content://com.android.providers/document/1.torrent',
        'data:application/x-bittorrent;base64,ZDQ6aW5mb2RlZQ==',
        'ftp://host/x.torrent',
        'file://evil.example/share/x.torrent',
        'file://localhost/Inbox/x.torrent',
        'file://user@/Inbox/x.torrent',
        'file://user:pass@/Inbox/x.torrent',
        'file://:8080/Inbox/x.torrent',
        'file:///Inbox/x.torrent?download=1',
        'file:///Inbox/x.torrent#frag',
        'file:///Inbox/x.torrent.txt',
        'file:///Inbox/x.torrentx',
        'file:///Inbox/x.torren',
        'file:///Inbox/.torrent',
        'file:///Inbox/',
        'file:///',
        'file:///Inbox/..%2F..%2FLibrary%2Fsecret.torrent',
        'file:///Inbox/a%5Cb.torrent',
        'file:///Inbox/x%00.torrent',
        'file:///Inbox/x%0A.torrent',
        'file:///Inbox/${'a' * 9000}.torrent',
        '',
      ]) {
        expect(
          IncomingDocumentService.isImportableDocumentUri(Uri.parse(text)),
          isFalse,
          reason: 'must be rejected: $text',
        );
      }
    });

    test('rejected URIs never call native and give a generic error', () async {
      final calls = record(iosChannel, okPayload);
      final service = IncomingDocumentService(platform: TargetPlatform.iOS);
      for (final text in [
        'https://tracker.example/secret-list.torrent',
        'file://nas.local/share/x.torrent',
        'file://admin:hunter2@/Inbox/x.torrent',
        'file:///Inbox/../Library/Preferences/org.homeqb.plist',
        'file:///Inbox/notes.txt',
        'magnet:?xt=urn:btih:abc',
      ]) {
        await expectLater(
          service.read(Uri.parse(text)),
          throwsA(
            isA<IncomingDocumentException>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('local .torrent'),
                isNot(contains('tracker')),
                isNot(contains('nas.local')),
                isNot(contains('hunter2')),
                isNot(contains('Preferences')),
                isNot(contains('notes')),
              ),
            ),
          ),
          reason: text,
        );
      }
      expect(calls, isEmpty);
    });
  });

  group('native payload validation', () {
    final service = IncomingDocumentService(platform: TargetPlatform.iOS);
    final uri = Uri.parse(inboxUri);

    test('malformed shapes are rejected', () async {
      for (final payload in <Object?>[
        null,
        true,
        'd4:infodee',
        torrent,
        <Object?>[torrent],
        <String, Object?>{},
        <String, Object?>{'name': 'x.torrent'},
        <String, Object?>{'bytes': torrent},
        <String, Object?>{'name': 'x.torrent', 'bytes': 'd4:infodee'},
        <String, Object?>{
          'name': 'x.torrent',
          'bytes': List<int>.from(torrent),
        },
        <String, Object?>{'name': 'x.torrent', 'bytes': null},
        <String, Object?>{'name': 7, 'bytes': torrent},
        <String, Object?>{'name': null, 'bytes': torrent},
      ]) {
        record(iosChannel, (_) async => payload);
        await expectLater(
          service.read(uri),
          throwsImport('could not be read'),
          reason: 'payload must be rejected: $payload',
        );
      }
    });

    test('empty bytes are rejected', () async {
      record(
        iosChannel,
        (_) async => {'name': 'x.torrent', 'bytes': Uint8List(0)},
      );
      await expectLater(service.read(uri), throwsImport('empty'));
    });

    test('oversized bytes are rejected before parsing', () async {
      final big = Uint8List(IncomingDocumentService.maxBytes + 1);
      big[0] = 0x64;
      record(iosChannel, (_) async => {'name': 'x.torrent', 'bytes': big});
      await expectLater(service.read(uri), throwsImport('16 MiB'));
    });

    test('exactly 16 MiB of valid bencode is accepted', () async {
      // d4:infod1:p<N>:<padding>ee with the padding sized to hit the cap.
      final head = utf8.encode('d4:infod1:p');
      const tail = 'ee';
      final overhead = head.length + tail.length;
      // length prefix "NNNNNNNN:" is 9 bytes for an 8-digit length.
      final padding = IncomingDocumentService.maxBytes - overhead - 9;
      final prefix = utf8.encode('$padding:');
      expect(prefix.length, 9);
      final full = Uint8List(IncomingDocumentService.maxBytes);
      var offset = 0;
      full.setAll(offset, head);
      offset += head.length;
      full.setAll(offset, prefix);
      offset += prefix.length;
      offset += padding; // zero-filled payload
      full.setAll(offset, utf8.encode(tail));
      expect(offset + tail.length, full.length);
      record(iosChannel, (_) async => {'name': 'big.torrent', 'bytes': full});
      final result = await service.read(uri);
      expect(
        (result['bytes'] as Uint8List).length,
        IncomingDocumentService.maxBytes,
      );
    });

    test(
      'non-torrent and truncated bencode is rejected even with .torrent uri',
      () async {
        for (final text in [
          'password=secret',
          '{"json": true}',
          'd8:password6:secrete',
          'd4:info6:secrete',
          'd4:infod1:ni1e',
          'd4:infodeetrailing',
          'de',
          'li1ee',
        ]) {
          record(
            iosChannel,
            (_) async => {
              'name': 'x.torrent',
              'bytes': Uint8List.fromList(utf8.encode(text)),
            },
          );
          await expectLater(
            service.read(uri),
            throwsA(
              isA<IncomingDocumentException>().having(
                (e) => e.message,
                'message',
                allOf(
                  contains('not a valid .torrent'),
                  isNot(contains('secret')),
                ),
              ),
            ),
            reason: text,
          );
        }
      },
    );
  });

  group('native errors', () {
    final service = IncomingDocumentService(platform: TargetPlatform.iOS);
    final uri = Uri.parse(inboxUri);

    test('missing native handler fails with a safe message', () async {
      // No mock handler is installed, so invokeMethod raises
      // MissingPluginException exactly like a build without the bridge.
      await expectLater(service.read(uri), throwsImport('not available'));
    });

    test(
      'native error codes map to generic text without native detail',
      () async {
        record(iosChannel, (_) async {
          throw PlatformException(
            code: 'invalid_import',
            message: '/private/var/mobile/Containers/Data/Application/X/Library/Preferences',
            details: 'EACCES',
          );
        });
        await expectLater(
          service.read(uri),
          throwsA(
            isA<IncomingDocumentException>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('rejected'),
                isNot(contains('/private')),
                isNot(contains('Preferences')),
                isNot(contains('EACCES')),
              ),
            ),
          ),
        );
        record(iosChannel, (_) async {
          throw PlatformException(
            code: 'import_failed',
            message: 'NSCocoaErrorDomain 257 Inbox/x.torrent',
          );
        });
        await expectLater(
          service.read(uri),
          throwsA(
            isA<IncomingDocumentException>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('could not be read'),
                isNot(contains('NSCocoa')),
                isNot(contains('Inbox')),
              ),
            ),
          ),
        );
        record(iosChannel, (_) async {
          throw PlatformException(
            code: 'unexpected',
            message: 'stack trace here',
          );
        });
        await expectLater(
          service.read(uri),
          throwsA(
            isA<IncomingDocumentException>().having(
              (e) => e.message,
              'message',
              isNot(contains('stack')),
            ),
          ),
        );
      },
    );

    test('exception text never echoes the uri', () async {
      record(
        iosChannel,
        (_) async => throw PlatformException(code: 'import_failed'),
      );
      try {
        await service.read(uri);
        fail('expected an IncomingDocumentException');
      } on IncomingDocumentException catch (error) {
        expect('$error', isNot(contains('Containers')));
        expect('$error', isNot(contains('Ubuntu')));
      }
    });
  });
}
