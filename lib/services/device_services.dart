import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:local_auth_darwin/types/auth_messages_macos.dart';
import 'package:workmanager/workmanager.dart';

import '../core/models.dart';
import '../core/qb_client.dart';
import '../l10n/app_localizations.dart';
import 'locale_controller.dart';
import 'network_route_service.dart';

@pragma('vm:entry-point')
void homeQbBackgroundDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  Workmanager().executeTask((taskName, inputData) async {
    // Credentials and snapshots stay in the OS protected store. No controller,
    // analytics, remote notification service, or application singleton is needed.
    await DeviceServices._pollInBackground();
    return true;
  });
}

class DeviceServiceException implements Exception {
  const DeviceServiceException(this.message);
  final String message;
  @override
  String toString() => message;
}

class DeviceServices {
  static Future<AppLocalizations> _strings({bool background = false}) async {
    final locales = LocaleController.instance;
    final locale = background
        ? await locales.backgroundLocale()
        : locales.effectiveLocale;
    return AppLocalizations.delegate.load(locale);
  }

  static const _taskId = 'org.homeqb.home_qb_remote.refresh';
  static const _notificationKey = 'device.notifications.enabled.v1';
  static const _lockKey = 'device.lock.enabled.v1';
  static const _epochKey = 'device.notifications.epoch.v1';
  static const _pollingKey = 'device.polling.minutes.v1';
  static const _cursorKey = 'device.notifications.cursor.v1';
  static const _snapshotPrefix = 'device.notifications.snapshot.v1.';
  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(usesDataProtectionKeychain: false),
  );
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final _auth = LocalAuthentication();
  static Future<void>? _initialization;
  static Future<void> _queue = Future<void>.value();
  static bool _notificationsEnabled = false;
  static bool _lockEnabled = false;
  static bool _notificationReady = false;
  static bool _schedulerReady = false;
  static bool _authenticationInProgress = false;
  static int _pollingIntervalMinutes = 15;
  static String _epoch = 'initial';
  static String? _notificationIssue;
  static String? _backgroundIssue;
  static String? _privacyIssue;

  static bool get notificationsEnabled => _notificationsEnabled;
  static bool get lockEnabled => _lockEnabled;
  static bool get authenticationInProgress => _authenticationInProgress;
  static int get pollingIntervalMinutes => _pollingIntervalMinutes;
  static String? get notificationIssue => _notificationIssue;
  static String? get backgroundIssue => _backgroundIssue;
  static String? get privacyIssue => _privacyIssue;
  static bool get backgroundPollingSupported =>
      Platform.isAndroid || Platform.isIOS;

  static Future<void> initialize() => _initialization ??= _initialize();

  static Future<void> _initialize() async {
    try {
      _notificationsEnabled =
          await _storage.read(key: _notificationKey) == 'true';
      _lockEnabled = await _storage.read(key: _lockKey) == 'true';
      _epoch = await _storage.read(key: _epochKey) ?? 'initial';
      final savedInterval = int.tryParse(
        await _storage.read(key: _pollingKey) ?? '',
      );
      _pollingIntervalMinutes =
          savedInterval != null && savedInterval >= 15 && savedInterval <= 1440
          ? savedInterval
          : 15;
      await _pruneSnapshots();
    } catch (_) {
      // A storage failure must not silently disable a previously configured lock.
      _lockEnabled = true;
      _notificationIssue =
          'Device settings could not be read from secure storage.';
    }
    await _applyPrivacyMode();
    await _initializeNotifications();
    if (backgroundPollingSupported) {
      try {
        await Workmanager().initialize(homeQbBackgroundDispatcher);
        _schedulerReady = true;
        if (_notificationsEnabled) await _schedule(updateInterval: true);
      } catch (_) {
        _backgroundIssue =
            'Background polling could not be scheduled on this device.';
      }
    } else {
      _backgroundIssue = 'Background polling is available on Android and iOS. Desktop notifications require the app to remain open.';
    }
  }

  static Future<void> _initializeNotifications() async {
    if (!(Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isWindows)) {
      _notificationIssue = 'Notifications are not configured on this platform.';
      return;
    }
    try {
      final initialized = await _notifications.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
          macOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
          windows: WindowsInitializationSettings(
            appName: 'Home qB Remote',
            appUserModelId: 'HomeQb.HomeQbRemote',
            guid: '67b98e82-b08b-4e0f-a825-a006e8e0d501',
          ),
        ),
      );
      _notificationReady = initialized == true;
      if (!_notificationReady) {
        _notificationIssue = 'System notifications are unavailable.';
      }
    } catch (_) {
      _notificationReady = false;
      _notificationIssue = 'System notifications could not be initialized.';
    }
  }

  static Future<void> _schedule({bool updateInterval = false}) async {
    if (!_schedulerReady || !backgroundPollingSupported) return;
    await Workmanager().registerPeriodicTask(
      _taskId,
      _taskId,
      frequency: Duration(minutes: _pollingIntervalMinutes),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: updateInterval
          ? ExistingPeriodicWorkPolicy.update
          : ExistingPeriodicWorkPolicy.keep,
    );
    // Android minimum periodic interval is 15 minutes. iOS chooses when/if to
    // run; BGTaskScheduler registration must also exist in the native project.
    _backgroundIssue = Platform.isIOS
        ? 'iOS controls background timing; polling is not continuous or guaranteed.'
        : 'Android may delay polling because of battery, network, or background restrictions.';
  }

  static Future<void> setPollingIntervalMinutes(int minutes) async {
    if (minutes < 15 || minutes > 1440) {
      throw const DeviceServiceException(
        'Choose a polling interval between 15 and 1440 minutes.',
      );
    }
    await initialize();
    await _storage.write(key: _pollingKey, value: '$minutes');
    _pollingIntervalMinutes = minutes;
    if (_notificationsEnabled &&
        _schedulerReady &&
        backgroundPollingSupported) {
      try {
        await _schedule(updateInterval: true);
      } catch (_) {
        _backgroundIssue = 'The new interval was saved, but the background schedule could not be updated.';
      }
    }
  }

  static Future<void> _pruneSnapshots() async {
    final saved = await _storage.read(key: 'profiles.v1');
    final profiles = saved == null ? const [] : jsonDecode(saved) as List;
    final allowedKeys = profiles
        .whereType<Map>()
        .map((item) => item['id'])
        .whereType<String>()
        .map(
          (id) =>
              '$_snapshotPrefix$_epoch.${base64Url.encode(utf8.encode(id))}',
        )
        .toSet();
    final all = await _storage.readAll();
    for (final key in all.keys.toList(growable: false)) {
      if (key.startsWith(_snapshotPrefix) && !allowedKeys.contains(key)) {
        await _storage.delete(key: key);
      }
    }
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    await initialize();
    if (enabled) {
      if (!_notificationReady) {
        throw DeviceServiceException(
          _notificationIssue ?? 'Notifications are unavailable.',
        );
      }
      bool allowed = true;
      if (Platform.isAndroid) {
        allowed =
            await _notifications
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >()
                ?.requestNotificationsPermission() ??
            false;
      } else if (Platform.isIOS) {
        allowed =
            await _notifications
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >()
                ?.requestPermissions(alert: true, badge: true, sound: true) ??
            false;
      } else if (Platform.isMacOS) {
        allowed =
            await _notifications
                .resolvePlatformSpecificImplementation<
                  MacOSFlutterLocalNotificationsPlugin
                >()
                ?.requestPermissions(alert: true, badge: true, sound: true) ??
            false;
      }
      if (!allowed) {
        throw const DeviceServiceException(
          'Notification permission was not granted.',
        );
      }
      if (!_notificationsEnabled) {
        // A newly enabled period establishes fresh baselines, not old alerts.
        _epoch = DateTime.now().microsecondsSinceEpoch.toString();
        await _storage.write(key: _epochKey, value: _epoch);
        await _pruneSnapshots();
      }
    }
    await _storage.write(key: _notificationKey, value: '$enabled');
    _notificationsEnabled = enabled;
    if (backgroundPollingSupported && _schedulerReady) {
      try {
        if (enabled) {
          await _schedule();
        } else {
          await Workmanager().cancelByUniqueName(_taskId);
        }
      } catch (_) {
        _backgroundIssue = 'The background schedule could not be updated. Foreground notification checks still work.';
      }
    }
  }

  static Future<bool> authenticate() async {
    if (!(Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isWindows)) {
      return false;
    }
    if (_authenticationInProgress) return false;
    _authenticationInProgress = true;
    try {
      if (!await _auth.isDeviceSupported()) return false;
      final strings = await _strings();
      return await _auth.authenticate(
        localizedReason: strings.unlockReason,
        authMessages: [
          AndroidAuthMessages(
            signInTitle: strings.appLocked,
            signInHint: strings.unlockReason,
            cancelButton: strings.cancel,
          ),
          IOSAuthMessages(cancelButton: strings.cancel),
          MacOSAuthMessages(cancelButton: strings.cancel),
        ],
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException {
      return false;
    } catch (_) {
      return false;
    } finally {
      _authenticationInProgress = false;
    }
  }

  static Future<void> setLockEnabled(bool enabled) async {
    await initialize();
    if ((enabled || _lockEnabled) && !await authenticate()) {
      throw const DeviceServiceException(
        'Device authentication was not completed.',
      );
    }
    await _storage.write(key: _lockKey, value: '$enabled');
    _lockEnabled = enabled;
    await _applyPrivacyMode();
  }

  static Future<void> _applyPrivacyMode() async {
    if (!Platform.isAndroid) return;
    try {
      await const MethodChannel('org.homeqb/imports')
          .invokeMethod<void>('setPrivacyMode', {'enabled': _lockEnabled});
      _privacyIssue = null;
    } catch (_) {
      // Preserve the lock setting even when native screenshot protection fails.
      _privacyIssue = 'Не удалось включить защиту снимков экрана.';
    }
  }

  /// Irreversible local recovery; the caller must obtain explicit confirmation.
  /// Never called automatically after unsuccessful device authentication.
  static Future<void> resetLocalData() async {
    await initialize();
    // Stop new foreground/background alerts before clearing protected data.
    await _storage.write(key: _notificationKey, value: 'false');
    _notificationsEnabled = false;
    await _queue;
    await _storage
        .deleteAll(); // A failure must not unlock retained credentials.
    _lockEnabled = false;
    _epoch = DateTime.now().microsecondsSinceEpoch.toString();
    _pollingIntervalMinutes = 15;
    try {
      await _notifications.cancelAll();
    } catch (_) {
      _notificationIssue = 'Не удалось удалить системные уведомления.';
    }
    if (backgroundPollingSupported && _schedulerReady) {
      try {
        await Workmanager().cancelByUniqueName(_taskId);
      } catch (_) {
        _backgroundIssue = 'Не удалось отменить фоновую проверку.';
      }
    }
    await _applyPrivacyMode();
  }

  static Future<void> onTorrentsChanged(
    List<Torrent> previous,
    List<Torrent> current, {
    String? profileId,
  }) async {
    await initialize();
    if (!_notificationsEnabled) return;
    final id = profileId ?? await _storage.read(key: 'selected_profile');
    if (id == null || id.isEmpty) return;
    // Serializes reads/writes within an isolate. A stable system notification id
    // also replaces duplicates if foreground and background isolates overlap.
    final task = _queue.then((_) => _recordSnapshot(id, current));
    _queue = task.catchError((Object _) {});
    await task;
  }

  static Future<void> _recordSnapshot(
    String profileId,
    List<Torrent> current, {
    bool background = false,
  }) async {
    final key =
        '$_snapshotPrefix$_epoch.${base64Url.encode(utf8.encode(profileId))}';
    final saved = await _storage.read(key: key);
    Map<String, dynamic>? previous;
    if (saved != null) {
      try {
        previous = jsonDecode(saved) as Map<String, dynamic>;
      } catch (_) {
        previous = null;
      }
    }
    final now = {
      for (final torrent in current) torrent.hash: torrent.progress >= 1,
    };
    await _storage.write(key: key, value: jsonEncode(now));
    if (previous == null ||
        !_notificationReady ||
        await _storage.read(key: _notificationKey) != 'true') {
      return; // First poll is baseline.
    }
    // Read persisted policy here as well as during background initialization:
    // a second isolate may have enabled the lock since this isolate started.
    final hideNames =
        _lockEnabled || await _storage.read(key: _lockKey) == 'true';
    final strings = await _strings(background: background);
    for (final torrent in current) {
      if (previous[torrent.hash] == false && now[torrent.hash] == true) {
        try {
          await _notifications.show(
            id: _notificationId('$profileId:${torrent.hash}'),
            title: strings.downloadComplete,
            body: hideNames ? strings.downloadCompletePrivate : torrent.name,
            payload: hideNames
                ? null
                : jsonEncode({'profileId': profileId, 'hash': torrent.hash}),
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                'torrent_completion',
                strings.completionChannelName,
                channelDescription: strings.completionChannelDescription,
                importance: Importance.defaultImportance,
                onlyAlertOnce: true,
                visibility: NotificationVisibility.private,
              ),
              iOS: const DarwinNotificationDetails(),
              macOS: const DarwinNotificationDetails(),
            ),
          );
        } catch (_) {
          _notificationIssue =
              'A completion notification could not be displayed.';
        }
      }
    }
  }

  static int _notificationId(String text) {
    var value = 2166136261;
    for (final byte in utf8.encode(text)) {
      value = ((value ^ byte) * 16777619) & 0x7fffffff;
    }
    return value;
  }

  static ServerProfile _decodeProfile(Map<String, dynamic> item) =>
      ServerProfile(
        id: item['id'] as String,
        name: item['name'] as String,
        url: item['url'] as String,
        username: item['username'] as String? ?? '',
        password: item['password'] as String? ?? '',
        apiKey: item['apiKey'] as String? ?? '',
        basicAuthUsername: item['basicAuthUsername'] as String? ?? '',
        basicAuthPassword: item['basicAuthPassword'] as String? ?? '',
        customCaPem: item['customCaPem'] as String? ?? '',
        clientCertificatePem: item['clientCertificatePem'] as String? ?? '',
        clientKeyPem: item['clientKeyPem'] as String? ?? '',
        clientKeyPassword: item['clientKeyPassword'] as String? ?? '',
        localUrl: item['localUrl'] as String? ?? '',
        localSsid: item['localSsid'] as String? ?? '',
      );

  static Future<void> _pollInBackground() async {
    if (!backgroundPollingSupported) return;
    try {
      if (await _storage.read(key: _notificationKey) != 'true') return;
      _lockEnabled = await _storage.read(key: _lockKey) == 'true';
      _epoch = await _storage.read(key: _epochKey) ?? 'initial';
      await _pruneSnapshots();
      await _initializeNotifications();
      final saved = await _storage.read(key: 'profiles.v1');
      if (saved == null) return;
      final values = jsonDecode(saved) as List;
      if (values.isEmpty) return;
      final savedCursor =
          int.tryParse(await _storage.read(key: _cursorKey) ?? '') ?? 0;
      final start = savedCursor % values.length;
      final deadline = DateTime.now().add(const Duration(seconds: 20));
      for (var offset = 0; offset < values.length; offset++) {
        if (DateTime.now().isAfter(deadline)) break;
        final index = (start + offset) % values.length;
        final item = values[index];
        // Advance before the network attempt so an offline or slow server cannot
        // consume every future background run's entire budget.
        await _storage.write(
          key: _cursorKey,
          value: '${(index + 1) % values.length}',
        );
        QbClient? client;
        String? authenticationBlockKey;
        try {
          final profile = _decodeProfile(item as Map<String, dynamic>);
          authenticationBlockKey = 'auth.blocked.${profile.id}';
          // A definitive rejection must not become a periodic password retry
          // that can trigger qBittorrent's IP ban. Explicit profile actions in
          // the foreground clear this shared block after user intervention.
          if (await _storage.read(key: authenticationBlockKey) == 'true') {
            continue;
          }
          final routeBudget = deadline.difference(DateTime.now());
          if (routeBudget <= Duration.zero) break;
          final routedProfile = await NetworkRouteService.resolve(profile)
              .timeout(
                routeBudget < const Duration(seconds: 2)
                    ? routeBudget
                    : const Duration(seconds: 2),
                onTimeout: () => profile,
              );
          client = QbClient(routedProfile, timeout: const Duration(seconds: 7));
          final remaining = deadline.difference(DateTime.now());
          if (remaining <= Duration.zero) break;
          final activeClient = client;
          final torrents =
              await (() async {
                await activeClient.login();
                return activeClient.getTorrents();
              })().timeout(
                remaining,
                onTimeout: () {
                  activeClient.close();
                  throw TimeoutException('Background scan budget exhausted.');
                },
              );
          await _recordSnapshot(profile.id, torrents, background: true);
        } on QbAuthenticationException {
          if (authenticationBlockKey != null) {
            await _storage.write(key: authenticationBlockKey, value: 'true');
          }
        } catch (_) {
          // Unreachable server or locked keychain: keep its old baseline. No
          // notification is fabricated and credentials/errors are never logged.
        } finally {
          client?.close();
        }
      }
    } catch (_) {
      // iOS credentials remain inaccessible until first unlock after reboot;
      // a skipped scan never fabricates completion alerts or bypasses the OS.
    }
  }
}
