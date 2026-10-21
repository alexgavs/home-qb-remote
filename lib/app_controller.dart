import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/models.dart';
import 'core/qb_client.dart';
import 'core/import_validation.dart';
import 'services/network_route_service.dart';

/// All profiles, including credentials, remain in the OS protected store.
class AppController extends ChangeNotifier {
  AppController({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
            mOptions: MacOsOptions(usesDataProtectionKeychain: false),
          );
  final FlutterSecureStorage _storage;
  List<ServerProfile> profiles = [];
  ServerProfile? currentProfile;
  List<Torrent> torrents = [];
  bool busy = false;
  String? error;
  String? version;
  String? connectionUrl;
  String? get currentConnectionUrl => connectionUrl;
  QbClient? _client;
  Timer? _timer;
  int _generation = 0;
  bool _refreshing = false;
  bool _disposed = false;
  bool _profilesLoaded = false;
  bool _active = true;
  bool requiresAuthentication = false;
  void Function(List<Torrent> previous, List<Torrent> current)?
  onTorrentsChanged;

  static Map<String, dynamic> encodeProfile(ServerProfile p) => {
    'id': p.id,
    'name': p.name,
    'url': p.url,
    'username': p.username,
    'password': p.password,
    'apiKey': p.apiKey,
    'basicAuthUsername': p.basicAuthUsername,
    'basicAuthPassword': p.basicAuthPassword,
    'customCaPem': p.customCaPem,
    'clientCertificatePem': p.clientCertificatePem,
    'clientKeyPem': p.clientKeyPem,
    'clientKeyPassword': p.clientKeyPassword,
    'localUrl': p.localUrl,
    'localSsid': p.localSsid,
  };
  static ServerProfile decodeProfile(Map<String, dynamic> p) => ServerProfile(
    id: p['id'] as String,
    name: p['name'] as String,
    url: p['url'] as String,
    username: p['username'] as String? ?? '',
    password: p['password'] as String? ?? '',
    apiKey: p['apiKey'] as String? ?? '',
    basicAuthUsername: p['basicAuthUsername'] as String? ?? '',
    basicAuthPassword: p['basicAuthPassword'] as String? ?? '',
    customCaPem: p['customCaPem'] as String? ?? '',
    clientCertificatePem: p['clientCertificatePem'] as String? ?? '',
    clientKeyPem: p['clientKeyPem'] as String? ?? '',
    clientKeyPassword: p['clientKeyPassword'] as String? ?? '',
    localUrl: p['localUrl'] as String? ?? '',
    localSsid: p['localSsid'] as String? ?? '',
  );
  Future<void> init() async {
    try {
      await _loadProfiles();
      final selected = await _storage.read(key: 'selected_profile');
      if (profiles.isNotEmpty) {
        await selectProfile(
          profiles.firstWhere(
            (p) => p.id == selected,
            orElse: () => profiles.first,
          ),
          resetAuthenticationBlock: false,
        );
      }
    } catch (_) {
      error = 'Не удалось прочитать защищённое хранилище профилей.';
      _notify();
    }
  }

  Future<void> _loadProfiles() async {
    _profilesLoaded = false;
    final saved = await _storage.read(key: 'profiles.v1');
    final loaded = saved == null
        ? <ServerProfile>[]
        : (jsonDecode(saved) as List)
              .map((p) => decodeProfile(Map<String, dynamic>.from(p as Map)))
              .toList();
    profiles = loaded;
    _profilesLoaded = true;
  }

  Future<void> _requireLoadedProfiles() async {
    if (_profilesLoaded) return;
    try {
      await _loadProfiles();
    } catch (_) {
      throw const QbException(
        'Хранилище профилей недоступно. Изменения не сохранены; существующие данные сохранены.',
      );
    }
  }

  Future<void> saveProfile(ServerProfile profile) async {
    await _requireLoadedProfiles();
    // Validate before writing any credentials.
    if (profile.apiKey.isNotEmpty &&
        (profile.basicAuthUsername.isNotEmpty ||
            profile.basicAuthPassword.isNotEmpty)) {
      // Both would occupy the single Authorization request header.
      throw const QbException(
        'API-ключ нельзя сочетать с Basic auth обратного прокси: оба используют заголовок Authorization.',
      );
    }
    final validator = QbClient(profile);
    validator.close();
    if (profile.localUrl.isNotEmpty) {
      QbClient(profile.withUrl(profile.localUrl)).close();
    }
    final updated = [...profiles];
    final index = updated.indexWhere((p) => p.id == profile.id);
    if (index < 0) {
      updated.add(profile);
    } else {
      updated[index] = profile;
    }
    await _storage.write(
      key: 'profiles.v1',
      value: jsonEncode(updated.map(encodeProfile).toList()),
    );
    profiles = updated;
    await selectProfile(profile);
  }

  Future<void> removeProfile(ServerProfile profile) async {
    await _requireLoadedProfiles();
    final updated = profiles.where((p) => p.id != profile.id).toList();
    await _storage.write(
      key: 'profiles.v1',
      value: jsonEncode(updated.map(encodeProfile).toList()),
    );
    profiles = updated;
    await _storage.delete(key: 'auth.blocked.${profile.id}');
    if (currentProfile?.id == profile.id) {
      _generation++;
      _client?.close();
      _client = null;
      _timer?.cancel();
      currentProfile = null;
      connectionUrl = null;
      torrents = [];
      version = null;
      if (profiles.isNotEmpty) await selectProfile(profiles.first);
    }
    _notify();
  }

  Future<void> selectProfile(
    ServerProfile profile, {
    bool resetAuthenticationBlock = true,
  }) async {
    final generation = ++_generation;
    _timer?.cancel();
    _client?.close();
    _client = null;
    _refreshing = false;
    requiresAuthentication = false;
    currentProfile = profile;
    connectionUrl = null;
    torrents = [];
    version = null;
    error = null;
    busy = true;
    _notify();
    QbClient? client;
    try {
      if (resetAuthenticationBlock) {
        await _storage.delete(key: 'auth.blocked.${profile.id}');
      } else {
        final blocked = await _storage.read(key: 'auth.blocked.${profile.id}');
        if (generation != _generation) return;
        if (blocked == 'true') {
          requiresAuthentication = true;
          error = 'Вход отклонён. Проверьте данные доступа и подключитесь к серверу ещё раз.';
          return;
        }
      }
      if (generation != _generation) return;
      final resolved = await NetworkRouteService.resolve(profile);
      if (generation != _generation) return;
      connectionUrl = resolved.url;
      client = _client = QbClient(resolved);
      await _storage.write(key: 'selected_profile', value: profile.id);
      await client.login();
      final serverVersion = await client.getVersion();
      if (generation != _generation) return;
      version = serverVersion;
      await refresh();
      _startTimer();
    } catch (e) {
      if (generation == _generation) {
        error = _safeError(e);
        if (e is QbAuthenticationException) {
          await _blockAuthentication(profile.id);
        }
      }
    } finally {
      if (generation == _generation) {
        busy = false;
        _notify();
      }
    }
  }

  Future<void> refresh() async {
    final client = _client;
    if (client == null || _refreshing || requiresAuthentication) return;
    final generation = _generation;
    _refreshing = true;
    try {
      final profile = currentProfile;
      if (profile != null) {
        final resolved = await NetworkRouteService.resolve(profile);
        if (generation != _generation) return;
        if (resolved.url != connectionUrl) {
          _refreshing = false;
          await selectProfile(profile, resetAuthenticationBlock: false);
          return;
        }
      }
      if (version == null) {
        await client.login();
        final serverVersion = await client.getVersion();
        if (generation != _generation) return;
        version = serverVersion;
      }
      final result = await client.getTorrents();
      if (generation != _generation) return;
      onTorrentsChanged?.call(torrents, result);
      torrents = result;
      error = null;
      _startTimer();
    } catch (e) {
      if (generation == _generation) {
        error = _safeError(e);
        if (e is QbAuthenticationException && currentProfile != null) {
          await _blockAuthentication(currentProfile!.id);
        } else {
          // A failed renewal may leave the session signed out. Network failures
          // can recover on a later active poll without repeating bad credentials.
          version = null;
        }
      }
    } finally {
      if (generation == _generation) {
        _refreshing = false;
        _notify();
      }
    }
  }

  QbClient get _api => _client ?? (throw StateError('Выберите сервер'));
  void _startTimer() {
    if (_active && !requiresAuthentication && _timer?.isActive != true) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) => refresh());
    }
  }

  Future<void> _blockAuthentication(String profileId) async {
    requiresAuthentication = true;
    _timer?.cancel();
    try {
      await _storage.write(key: 'auth.blocked.$profileId', value: 'true');
    } catch (_) {
      /* In-memory block still prevents retries. */
    }
  }

  Future<void> reconnect() async {
    final profile = currentProfile;
    if (profile != null) await selectProfile(profile);
  }

  /// Auxiliary, server-bound clients share the selected profile's definitive
  /// authentication block; reopening a search must not retry rejected secrets.
  Future<void> reportAuthenticationFailure(
    ServerProfile profile,
    Object error,
  ) async {
    if (error is! QbAuthenticationException ||
        !identical(currentProfile, profile)) {
      return;
    }
    this.error = _safeError(error);
    await _blockAuthentication(profile.id);
    _notify();
  }

  void setActive(bool active) {
    _active = active;
    if (!active) {
      _timer?.cancel();
    } else if (_client != null && !requiresAuthentication) {
      _startTimer();
    }
  }

  void clearLocalState() {
    _generation++;
    _timer?.cancel();
    _client?.close();
    _client = null;
    profiles = [];
    currentProfile = null;
    torrents = [];
    version = null;
    connectionUrl = null;
    error = null;
    busy = false;
    requiresAuthentication = false;
    _refreshing = false;
    _profilesLoaded = true;
    _notify();
  }

  Future<T> _run<T>(Future<T> Function(QbClient) action) async {
    final generation = _generation;
    final client = _api;
    busy = true;
    error = null;
    _notify();
    try {
      return await action(client);
    } catch (e) {
      if (generation == _generation) {
        error = _safeError(e);
        if (e is QbAuthenticationException && currentProfile != null) {
          await _blockAuthentication(currentProfile!.id);
        }
      }
      rethrow;
    } finally {
      if (generation == _generation) {
        busy = false;
        _notify();
      }
    }
  }

  Future<void> setPaused(List<String> hashes, {required bool paused}) async {
    await _run((c) => c.setPaused(hashes, paused: paused));
    await refresh();
  }

  Future<void> addUrls(
    String urls, {
    Map<String, String> options = const {},
  }) async {
    await _run((c) => c.addUrls(urls, options: options));
    await refresh();
  }

  Future<void> addTorrentFile(
    String name,
    List<int> bytes, {
    Map<String, String> options = const {},
  }) async {
    if (!isTorrentFile(bytes)) {
      throw const QbException(
        'Выбранный файл не является корректным .torrent. Данные не отправлены.',
      );
    }
    await _run((c) => c.addTorrentFile(name, bytes, options: options));
    await refresh();
  }

  Future<void> deleteTorrents(
    List<String> hashes, {
    bool deleteFiles = false,
  }) async {
    await _run((c) => c.deleteTorrents(hashes, deleteFiles: deleteFiles));
    await refresh();
  }

  Future<TorrentDetails> getDetails(String hash) =>
      _run((c) => c.getDetails(hash));
  Future<List<int>> exportTorrent(String hash) =>
      _run((c) => c.getBytes('torrents/export', {'hash': hash}));
  Future<dynamic> apiGet(
    String endpoint, [
    Map<String, String> query = const {},
  ]) => _run((c) => c.get(endpoint, query));
  Future<dynamic> apiPost(String endpoint, Map<String, String> fields) async {
    final result = await _run((c) => c.post(endpoint, fields));
    await refresh();
    return result;
  }

  String _safeError(Object e) => e is QbException
      ? e.message
      : 'Операция не выполнена. Проверьте соединение и настройки сервера.';
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _timer?.cancel();
    _client?.close();
    super.dispose();
  }
}
