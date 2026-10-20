import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/services/torrent_export_service.dart';

// Channel names and method are spelled out here on purpose: the test verifies
// the contract with MainActivity.kt / AppDelegate.swift, not the Dart constants.
const androidChannel = MethodChannel('org.homeqb/imports');
const iosChannel = MethodChannel('org.homeqb/export');

final sample = Uint8List.fromList([
  0x64,
  0x38,
  0x3a,
  0x61,
  0x6e,
  0x6e,
  0x6f,
  0x75,
  0x6e,
  0x63,
  0x65, // d8:announce
  0x00, 0xff, 0x7f, 0x80, 0x0a, 0x0d, 0x65, // binary payload + 'e'
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

Matcher throwsExport([String? containing]) => throwsA(
  isA<TorrentExportException>().having(
    (e) => e.message,
    'message',
    containing == null ? isNotEmpty : contains(containing),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('file name sanitizing', () {
    const safe = TorrentExportService.safeFileName;

    test('keeps ordinary names, forces a single .torrent extension', () {
      expect(safe('Ubuntu 24.04 LTS'), 'Ubuntu 24.04 LTS.torrent');
      expect(safe('Фильм (2020) [1080p]'), 'Фильм (2020) [1080p].torrent');
      expect(safe('already.torrent'), 'already.torrent');
      expect(safe('UPPER.TORRENT'), 'UPPER.torrent');
      expect(safe('double.torrent.torrent'), 'double.torrent');
      expect(safe('archive.tar.gz'), 'archive.tar.gz.torrent');
    });

    test('drops directory components and traversal', () {
      expect(safe('../../etc/passwd'), 'passwd.torrent');
      expect(safe(r'C:\Users\someone\movie'), 'movie.torrent');
      expect(safe('/var/tmp/'), 'export.torrent');
      expect(safe('..'), 'export.torrent');
      expect(safe('a/../b'), 'b.torrent');
    });

    test('replaces unsafe characters and trims edge dots/spaces', () {
      expect(safe('a<b>c:d"e|f?g*h'), 'a_b_c_d_e_f_g_h.torrent');
      expect(safe('tab\there\x00null\x7fdel'), 'tab_here_null_del.torrent');
      expect(safe('  padded . '), 'padded.torrent');
      expect(safe('.hidden'), 'hidden.torrent');
      expect(safe(''), 'export.torrent');
      expect(safe('   '), 'export.torrent');
    });

    test('escapes Windows reserved device names', () {
      expect(safe('CON'), '_CON.torrent');
      expect(safe('con.torrent'), '_con.torrent');
      expect(safe('lpt1'), '_lpt1.torrent');
      expect(safe('console'), 'console.torrent');
    });

    test('bounds length without splitting surrogate pairs', () {
      final long = safe('x' * 500);
      expect(long.length, TorrentExportService.maxFileNameLength);
      expect(long, endsWith('.torrent'));
      final emoji = safe('${'y' * 131}😀rest');
      expect(emoji, endsWith('.torrent'));
      expect(emoji.contains('\uD83D'), isFalse);
      expect(emoji.length, lessThanOrEqualTo(140));
      final dotted = safe('${'z' * 130}......end');
      expect(dotted, '${'z' * 130}.torrent');
    });
  });

  group('validation', () {
    test(
      'rejects empty, oversized and non-byte payloads before any dialog',
      () async {
        final calls = record(androidChannel, (_) async => true);
        final service = TorrentExportService(platform: TargetPlatform.android);
        await expectLater(
          service.export('x', const []),
          throwsExport('no torrent'),
        );
        await expectLater(
          service.export('x', Uint8List(TorrentExportService.maxBytes + 1)),
          throwsExport('16 MiB'),
        );
        await expectLater(
          service.export('x', const [1, 256, 2]),
          throwsExport('byte sequence'),
        );
        await expectLater(
          service.export('x', const [-1]),
          throwsExport('byte sequence'),
        );
        expect(calls, isEmpty);
        expect(service.busy, isFalse);
      },
    );

    test('accepts exactly 16 MiB', () async {
      final calls = record(androidChannel, (_) async => true);
      final service = TorrentExportService(platform: TargetPlatform.android);
      final full = Uint8List(TorrentExportService.maxBytes);
      full[0] = 0x64;
      full[full.length - 1] = 0x65;
      expect(await service.export('big', full), isTrue);
      final sent = calls.single.arguments['bytes'] as Uint8List;
      expect(sent.length, TorrentExportService.maxBytes);
      expect(sent.first, 0x64);
      expect(sent.last, 0x65);
    });

    test('unsupported platform fails safely', () async {
      final service = TorrentExportService(platform: TargetPlatform.fuchsia);
      await expectLater(
        service.export('x', sample),
        throwsExport('not supported'),
      );
      expect(service.busy, isFalse);
    });
  });

  group('Android bridge', () {
    test(
      'dispatches exportTorrent on org.homeqb/imports with bytes intact',
      () async {
        final android = record(androidChannel, (_) async => true);
        final ios = record(iosChannel, (_) async => true);
        final service = TorrentExportService(platform: TargetPlatform.android);
        final plainList = List<int>.from(
          sample,
        ); // Non-typed input is converted.
        expect(await service.export('../Some: "Movie"?', plainList), isTrue);
        expect(ios, isEmpty);
        final call = android.single;
        expect(call.method, 'exportTorrent');
        final arguments = call.arguments as Map<Object?, Object?>;
        expect(arguments.keys, unorderedEquals(['name', 'bytes']));
        expect(arguments['name'], 'Some_ _Movie__.torrent');
        expect(arguments['bytes'], isA<Uint8List>());
        expect(arguments['bytes'], equals(sample));
        expect(service.busy, isFalse);
      },
    );

    test('cancelled or missing native result is never success', () async {
      final service = TorrentExportService(platform: TargetPlatform.android);
      record(androidChannel, (_) async => false);
      expect(await service.export('a', sample), isFalse);
      record(androidChannel, (_) async => null);
      expect(await service.export('a', sample), isFalse);
    });

    test(
      'native errors become generic exceptions without native detail',
      () async {
        final service = TorrentExportService(platform: TargetPlatform.android);
        record(androidChannel, (_) async {
          throw PlatformException(
            code: 'export_failed',
            message: r'EACCES content://media/C:\Users\secret\x.torrent',
          );
        });
        await expectLater(
          service.export('a', sample),
          throwsA(
            isA<TorrentExportException>().having(
              (e) => e.message,
              'message',
              allOf(contains('could not be saved'), isNot(contains('secret'))),
            ),
          ),
        );
        record(androidChannel, (_) async {
          throw PlatformException(code: 'export_busy');
        });
        await expectLater(
          service.export('a', sample),
          throwsExport('in progress'),
        );
        record(androidChannel, (_) async {
          throw PlatformException(code: 'invalid_export');
        });
        await expectLater(
          service.export('a', sample),
          throwsExport('rejected'),
        );
        expect(service.busy, isFalse);
      },
    );
  });

  group('iOS bridge', () {
    test(
      'dispatches exportTorrent on org.homeqb/export with Uint8List',
      () async {
        final android = record(androidChannel, (_) async => true);
        final ios = record(iosChannel, (_) async => true);
        final service = TorrentExportService(platform: TargetPlatform.iOS);
        expect(await service.export('Share me', sample), isTrue);
        expect(android, isEmpty);
        final call = ios.single;
        expect(call.method, 'exportTorrent');
        final arguments = call.arguments as Map<Object?, Object?>;
        expect(arguments['name'], 'Share me.torrent');
        expect(arguments['bytes'], isA<Uint8List>());
        expect(arguments['bytes'], equals(sample));
      },
    );

    test('share sheet dismissal is reported as cancellation', () async {
      record(iosChannel, (_) async => false);
      final service = TorrentExportService(platform: TargetPlatform.iOS);
      expect(await service.export('a', sample), isFalse);
      expect(service.busy, isFalse);
    });

    test('missing native handler fails with a safe message', () async {
      // No mock handler is installed, so invokeMethod raises
      // MissingPluginException exactly like an app build without the bridge.
      final service = TorrentExportService(platform: TargetPlatform.iOS);
      await expectLater(
        service.export('a', sample),
        throwsExport('not available'),
      );
      expect(service.busy, isFalse);
    });

    test('native busy/failure codes map to generic errors', () async {
      final service = TorrentExportService(platform: TargetPlatform.iOS);
      record(iosChannel, (_) async {
        throw PlatformException(code: 'export_busy', message: 'sheet open');
      });
      await expectLater(
        service.export('a', sample),
        throwsExport('in progress'),
      );
      record(iosChannel, (_) async {
        throw PlatformException(
          code: 'export_failed',
          message: '/private/var/mobile/Containers/tmp/x.torrent',
        );
      });
      await expectLater(
        service.export('a', sample),
        throwsA(
          isA<TorrentExportException>().having(
            (e) => e.message,
            'message',
            isNot(contains('/private')),
          ),
        ),
      );
    });

    test(
      'honours debugDefaultTargetPlatformOverride when no platform is injected',
      () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final android = record(androidChannel, (_) async => true);
        final ios = record(iosChannel, (_) async => true);
        expect(await TorrentExportService().export('n', sample), isTrue);
        expect(android, isEmpty);
        expect(ios.single.method, 'exportTorrent');
      },
    );
  });

  group('desktop file_selector flow', () {
    for (final platform in [TargetPlatform.windows, TargetPlatform.macOS]) {
      test(
        '$platform: cancelled dialog returns false and writes nothing',
        () async {
          var writes = 0;
          String? suggested;
          final service = TorrentExportService(
            platform: platform,
            pickSaveLocation: (name) async {
              suggested = name;
              return null;
            },
            writeFile: (_, _, _) async => writes++,
          );
          expect(await service.export('Movie: Part 2', sample), isFalse);
          expect(suggested, 'Movie_ Part 2.torrent');
          expect(writes, 0);
          expect(service.busy, isFalse);
        },
      );

      test('$platform: chosen location receives the exact bytes', () async {
        String? writtenPath;
        String? writtenName;
        Uint8List? writtenBytes;
        final service = TorrentExportService(
          platform: platform,
          pickSaveLocation: (name) async => '/chosen/by/user/$name',
          writeFile: (path, name, bytes) async {
            writtenPath = path;
            writtenName = name;
            writtenBytes = bytes;
          },
        );
        expect(await service.export('Movie', List<int>.from(sample)), isTrue);
        expect(writtenPath, '/chosen/by/user/Movie.torrent');
        expect(writtenName, 'Movie.torrent');
        expect(writtenBytes, equals(sample));
      });
    }

    test('write failures hide the destination path', () async {
      final service = TorrentExportService(
        platform: TargetPlatform.windows,
        pickSaveLocation: (name) async => r'C:\Users\alex\Downloads\x.torrent',
        writeFile: (path, _, _) async =>
            throw FileSystemException('Access denied', path),
      );
      await expectLater(
        service.export('x', sample),
        throwsA(
          isA<TorrentExportException>().having(
            (e) => e.message,
            'message',
            allOf(
              contains('could not be written'),
              isNot(contains('Users')),
              isNot(contains('Downloads')),
            ),
          ),
        ),
      );
      expect(service.busy, isFalse);
    });

    test('dialog failures are generic and never success', () async {
      final service = TorrentExportService(
        platform: TargetPlatform.macOS,
        pickSaveLocation: (_) async => throw StateError('no window server'),
        writeFile: (_, _, _) async {},
      );
      await expectLater(service.export('x', sample), throwsExport('dialog'));
      expect(service.busy, isFalse);
    });

    test('desktop never touches the mobile channels', () async {
      final android = record(androidChannel, (_) async => true);
      final ios = record(iosChannel, (_) async => true);
      final service = TorrentExportService(
        platform: TargetPlatform.windows,
        pickSaveLocation: (_) async => 'C:/out/file.torrent',
        writeFile: (_, _, _) async {},
      );
      expect(await service.export('x', sample), isTrue);
      expect(android, isEmpty);
      expect(ios, isEmpty);
    });
  });

  group('concurrency', () {
    test(
      'a second export is rejected while the first dialog is open',
      () async {
        final gate = Completer<bool>();
        final calls = record(androidChannel, (_) => gate.future);
        final service = TorrentExportService(platform: TargetPlatform.android);
        final first = service.export('first', sample);
        expect(service.busy, isTrue);
        await expectLater(
          service.export('second', sample),
          throwsExport('in progress'),
        );
        expect(calls.length, 1);
        gate.complete(true);
        expect(await first, isTrue);
        expect(service.busy, isFalse);
        expect(await service.export('third', sample), isTrue);
        expect(calls.length, 2);
      },
    );

    test('busy flag is released after cancellation and failure', () async {
      final service = TorrentExportService(platform: TargetPlatform.iOS);
      record(iosChannel, (_) async => false);
      expect(await service.export('a', sample), isFalse);
      expect(service.busy, isFalse);
      record(iosChannel, (_) async => throw PlatformException(code: 'x'));
      await expectLater(service.export('a', sample), throwsExport());
      expect(service.busy, isFalse);
      record(iosChannel, (_) async => true);
      expect(await service.export('a', sample), isTrue);
    });
  });
}
