import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/integrations/integration_store.dart';
import 'package:home_qb_remote/integrations/jackett_models.dart';
import 'package:home_qb_remote/integrations/jellyfin_models.dart';

class _BrokenStorage extends FlutterSecureStorage {
  _BrokenStorage({this.breakReads = false, this.breakWrites = false});
  final bool breakReads, breakWrites;
  String? value;
  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
  }) async {
    if (breakReads) throw PlatformException(code: 'locked');
    return value;
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
  }) async {
    if (breakWrites) throw PlatformException(code: 'locked');
    this.value = value;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const jackett = JackettProfile(
    id: 'j',
    name: 'Search',
    url: 'https://search.invalid',
    apiKey: 'private-jackett-key',
  );
  const jellyfin = JellyfinProfile(
    id: 'm',
    name: 'Library',
    url: 'https://media.invalid',
    accessToken: 'private-user-token',
    userId: '0123456789abcdef0123456789abcdef',
  );

  test(
    'read failure refuses every write and preserves stored document',
    () async {
      final storage = _BrokenStorage(breakReads: true)
        ..value = 'existing document';
      final store = IntegrationStore(storage: storage);
      await expectLater(store.load(), throwsA(isA<PlatformException>()));
      await expectLater(store.saveJackett(jackett), throwsStateError);
      expect(storage.value, 'existing document');
      expect(store.loaded, false);
      store.dispose();
    },
  );

  test(
    'malformed document cannot silently become an empty profile list',
    () async {
      final storage = _BrokenStorage()..value = '{"jackett":[{"id":5}]}';
      final store = IntegrationStore(storage: storage);
      await expectLater(store.load(), throwsA(anything));
      await expectLater(store.saveJellyfin(jellyfin), throwsStateError);
      expect(storage.value, '{"jackett":[{"id":5}]}');
      store.dispose();
    },
  );

  test('write failure does not mutate in-memory profiles', () async {
    final store = IntegrationStore(storage: _BrokenStorage(breakWrites: true));
    await store.load();
    await expectLater(
      store.saveJackett(jackett),
      throwsA(isA<PlatformException>()),
    );
    expect(store.jackett, isEmpty);
    store.dispose();
  });

  test(
    'independent profiles roundtrip and deletion retains the other service',
    () async {
      final storage = _BrokenStorage();
      final store = IntegrationStore(storage: storage);
      await store.load();
      await store.saveJackett(jackett);
      await store.saveJellyfin(jellyfin);
      final restored = IntegrationStore(storage: storage);
      await restored.load();
      expect(restored.jackett.single.apiKey, jackett.apiKey);
      expect(restored.jellyfin.single.accessToken, jellyfin.accessToken);
      expect(() => restored.jackett.clear(), throwsUnsupportedError);
      await restored.removeJackett('j');
      expect(restored.jackett, isEmpty);
      expect(restored.jellyfin.single.id, 'm');
      store.dispose();
      restored.dispose();
    },
  );
}
