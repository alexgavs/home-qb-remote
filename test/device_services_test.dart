import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/l10n/app_localizations.dart';
import 'package:home_qb_remote/services/device_services.dart';

Torrent torrent(double progress) => Torrent(
  hash: 'same-hash-on-two-servers',
  name: 'Fixture',
  size: 100,
  progress: progress,
  dlspeed: 0,
  upspeed: 0,
  state: progress == 1 ? 'uploading' : 'downloading',
  eta: 0,
  category: '',
  ratio: 0,
);

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'secure snapshots establish baselines, isolate servers and reset on re-enable',
    () async {
      // Match the notification adapter to the host-specific permission branch.
      // Desktop hosts never start Workmanager or a real periodic scheduler.
      final useMacAdapter = Platform.isMacOS;
      debugDefaultTargetPlatformOverride = useMacAdapter
          ? TargetPlatform.macOS
          : TargetPlatform.android;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      binding.platformDispatcher.localesTestValue = const [Locale('ru')];
      addTearDown(binding.platformDispatcher.clearLocalesTestValue);
      FlutterSecureStorage.setMockInitialValues({
        'device.notifications.enabled.v1': 'true',
        'device.notifications.epoch.v1': 'fixture',
        'device.polling.minutes.v1': '90',
        'device.notifications.snapshot.v1.old.orphan': '{}',
        'device.notifications.snapshot.v1.fixture.deleted-profile': '{}',
        'profiles.v1': jsonEncode([
          {'id': 'A'},
          {'id': 'B'},
          {'id': 'first-complete'},
        ]),
      });
      FlutterLocalNotificationsPlatform.instance = useMacAdapter
          ? MacOSFlutterLocalNotificationsPlugin()
          : AndroidFlutterLocalNotificationsPlugin();
      final shown = <Map<dynamic, dynamic>>[];
      final calls = <String>[];
      final permissionRequests = <Map<dynamic, dynamic>>[];
      // Both Android and macOS adapters use this channel in the pinned plugin.
      const channel = MethodChannel(
        'dexterous.com/flutter/local_notifications',
      );
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
            calls.add(call.method);
            if (call.method == 'show') {
              shown.add(call.arguments as Map<dynamic, dynamic>);
            }
            if (call.method == 'requestPermissions') {
              permissionRequests.add(call.arguments as Map<dynamic, dynamic>);
            }
            return true;
          });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, null),
      );
      await DeviceServices.initialize();
      expect(DeviceServices.backgroundPollingSupported, isFalse);
      expect(DeviceServices.backgroundIssue, contains('Desktop'));
      expect(DeviceServices.pollingIntervalMinutes, 90);
      expect(DeviceServices.authenticationInProgress, isFalse);
      const store = FlutterSecureStorage();
      expect(
        await store.read(key: 'device.notifications.snapshot.v1.old.orphan'),
        isNull,
      );
      expect(
        await store.read(
          key: 'device.notifications.snapshot.v1.fixture.deleted-profile',
        ),
        isNull,
      );
      for (final invalid in [14, 1441, -1]) {
        await expectLater(
          DeviceServices.setPollingIntervalMinutes(invalid),
          throwsA(isA<DeviceServiceException>()),
        );
      }
      expect(DeviceServices.pollingIntervalMinutes, 90);
      await DeviceServices.setPollingIntervalMinutes(15);
      await DeviceServices.setPollingIntervalMinutes(1440);
      await DeviceServices.setPollingIntervalMinutes(60);
      expect(DeviceServices.pollingIntervalMinutes, 60);
      expect(await store.read(key: 'device.polling.minutes.v1'), '60');

      await DeviceServices.onTorrentsChanged([], [
        torrent(1),
      ], profileId: 'first-complete');
      expect(
        shown,
        isEmpty,
      ); // Existing completion at first baseline is silent.
      await DeviceServices.onTorrentsChanged([], [
        torrent(0.5),
      ], profileId: 'A');
      await DeviceServices.onTorrentsChanged([], [torrent(1)], profileId: 'B');
      expect(
        shown,
        isEmpty,
      ); // A/B share a hash but never share baseline state.
      await DeviceServices.onTorrentsChanged(
        [torrent(0.5)],
        [torrent(1)],
        profileId: 'A',
      );
      expect(shown.length, 1);
      expect(shown.single['title'], 'Загрузка завершена');
      expect(jsonDecode(shown.single['payload'] as String)['profileId'], 'A');
      final notificationId = shown.single['id'];
      await DeviceServices.onTorrentsChanged(
        [torrent(1)],
        [torrent(1)],
        profileId: 'A',
      );
      expect(shown.length, 1); // No repeat while torrent remains complete.

      await DeviceServices.setNotificationsEnabled(false);
      await DeviceServices.setPollingIntervalMinutes(120);
      expect(DeviceServices.pollingIntervalMinutes, 120);
      await DeviceServices.onTorrentsChanged([], [
        torrent(0.2),
      ], profileId: 'A');
      await DeviceServices.setNotificationsEnabled(true);
      expect(
        (await store.readAll()).keys.any(
          (key) => key.startsWith('device.notifications.snapshot.v1.fixture.'),
        ),
        isFalse,
      );
      expect(await store.read(key: 'profiles.v1'), isNotNull);
      await DeviceServices.onTorrentsChanged([], [torrent(1)], profileId: 'A');
      expect(shown.length, 1); // Re-enable must not report stale completions.
      await DeviceServices.onTorrentsChanged([], [
        torrent(0.8),
      ], profileId: 'A');
      await DeviceServices.onTorrentsChanged([], [torrent(1)], profileId: 'A');
      expect(shown.length, 2);
      expect(shown.last['id'], notificationId); // Stable id replaces overlap.
      expect(shown.last['body'], 'Fixture');
      // Persisted policy changes must apply without reinitializing an isolate.
      // The same notification path is used by foreground and background polls.
      await store.write(key: 'device.lock.enabled.v1', value: 'true');
      binding.platformDispatcher.localesTestValue = const [Locale('he')];
      final hebrew = await AppLocalizations.delegate.load(const Locale('he'));
      await DeviceServices.onTorrentsChanged([], [
        torrent(0.5),
      ], profileId: 'A');
      await DeviceServices.onTorrentsChanged([], [torrent(1)], profileId: 'A');
      expect(shown.length, 3);
      expect(shown.last['title'], hebrew.downloadComplete);
      expect(shown.last['title'], matches(RegExp(r'[\u0590-\u05ff]')));
      expect(shown.last['body'], hebrew.downloadCompletePrivate);
      // Both adapters normalize an omitted payload to an empty string.
      expect(shown.last['payload'], isEmpty);
      expect(shown.last.toString(), isNot(contains('Fixture')));
      final platformSpecifics = shown.last['platformSpecifics'] as Map;
      if (useMacAdapter) {
        expect(permissionRequests, hasLength(1));
        expect(permissionRequests.single, containsPair('alert', true));
        expect(permissionRequests.single, containsPair('badge', true));
        expect(permissionRequests.single, containsPair('sound', true));
        expect(platformSpecifics, contains('presentAlert'));
        expect(platformSpecifics, isNot(contains('channelName')));
        expect(platformSpecifics, isNot(contains('visibility')));
      } else {
        expect(permissionRequests, isEmpty);
        expect(
          platformSpecifics['visibility'],
          NotificationVisibility.private.index,
        );
        expect(platformSpecifics['channelName'], hebrew.completionChannelName);
      }
      expect(calls.where((method) => method == 'initialize').length, 1);
      await store.write(key: 'auth.blocked.A', value: 'true');
      await DeviceServices.resetLocalData();
      expect(await store.readAll(), isEmpty);
      expect(DeviceServices.lockEnabled, isFalse);
      expect(DeviceServices.notificationsEnabled, isFalse);
      expect(DeviceServices.pollingIntervalMinutes, 15);
      expect(calls, contains('cancelAll'));
    },
    skip: !(Platform.isWindows || Platform.isMacOS)
        ? 'Desktop-host adapter test deliberately never starts a background scheduler.'
        : false,
  );
}
