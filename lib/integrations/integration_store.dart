import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'jackett_models.dart';
import 'jellyfin_models.dart';

/// A separate protected document: no qBittorrent credentials are reused.
/// A failed read must never turn into a write of an empty profile list.
class IntegrationStore extends ChangeNotifier {
  IntegrationStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
            mOptions: MacOsOptions(usesDataProtectionKeychain: false),
          );

  static const storageKey = 'integrations.v1';
  final FlutterSecureStorage _storage;
  List<JackettProfile> _jackett = const [];
  List<JellyfinProfile> _jellyfin = const [];
  bool loaded = false;
  bool _writing = false;
  bool _disposed = false;
  List<JackettProfile> get jackett => List.unmodifiable(_jackett);
  List<JellyfinProfile> get jellyfin => List.unmodifiable(_jellyfin);

  Future<void> load() async {
    loaded = false;
    final raw = await _storage.read(key: storageKey);
    final document = raw == null
        ? <String, dynamic>{}
        : jsonDecode(raw) as Map<String, dynamic>;
    final jackett = (document['jackett'] as List? ?? [])
        .map(
          (e) => JackettProfile.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
    final jellyfin = (document['jellyfin'] as List? ?? [])
        .map(
          (e) => JellyfinProfile.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
    _jackett = jackett;
    _jellyfin = jellyfin;
    loaded = true;
    if (!_disposed) notifyListeners();
  }

  Future<void> saveJackett(JackettProfile profile) =>
      _save([..._jackett.where((p) => p.id != profile.id), profile], _jellyfin);

  Future<void> saveJellyfin(JellyfinProfile profile) =>
      _save(_jackett, [..._jellyfin.where((p) => p.id != profile.id), profile]);

  Future<void> removeJackett(String id) =>
      _save(_jackett.where((p) => p.id != id).toList(), _jellyfin);
  Future<void> removeJellyfin(String id) =>
      _save(_jackett, _jellyfin.where((p) => p.id != id).toList());

  Future<void> _save(
    List<JackettProfile> jackett,
    List<JellyfinProfile> jellyfin,
  ) async {
    if (!loaded || _writing) {
      throw StateError('integration_storage_unavailable');
    }
    _writing = true;
    try {
      await _storage.write(
        key: storageKey,
        value: jsonEncode({
          'jackett': jackett.map((p) => p.toJson()).toList(),
          'jellyfin': jellyfin.map((p) => p.toJson()).toList(),
        }),
      );
      _jackett = List.of(jackett);
      _jellyfin = List.of(jellyfin);
      if (!_disposed) notifyListeners();
    } finally {
      _writing = false;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
