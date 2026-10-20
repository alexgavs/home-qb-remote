import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/services/network_route_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const profile = ServerProfile(
    id: 'home',
    name: 'Home',
    url: 'https://remote.example.invalid/qb/',
    localUrl: 'http://192.168.1.5:8080/',
    localSsid: 'Home Wi-Fi',
    username: 'user',
    password: 'secret',
    basicAuthUsername: 'proxy-user',
    basicAuthPassword: 'proxy-secret',
    customCaPem: 'custom-ca',
    clientCertificatePem: 'client-cert',
    clientKeyPem: 'private-key',
    clientKeyPassword: 'key-password',
  );

  test(
    'exact SSID selects local URL and preserves the entire credential profile',
    () {
      final selected = NetworkRouteService.choose(profile, 'Home Wi-Fi');
      expect(selected.url, 'http://192.168.1.5:8080/');
      expect(selected.id, profile.id);
      expect(selected.name, profile.name);
      expect(selected.username, profile.username);
      expect(selected.password, profile.password);
      expect(selected.basicAuthUsername, profile.basicAuthUsername);
      expect(selected.basicAuthPassword, profile.basicAuthPassword);
      expect(selected.customCaPem, profile.customCaPem);
      expect(selected.clientCertificatePem, profile.clientCertificatePem);
      expect(selected.clientKeyPem, profile.clientKeyPem);
      expect(selected.clientKeyPassword, profile.clientKeyPassword);
      expect(selected.localUrl, profile.localUrl);
      expect(selected.localSsid, profile.localSsid);
      expect(profile.url, 'https://remote.example.invalid/qb/');
    },
  );

  test(
    'unavailable SSID and permission fallback never change the primary URL',
    () {
      for (final ssid in [null, '', '<unknown ssid>', 'Other network']) {
        expect(NetworkRouteService.choose(profile, ssid), same(profile));
      }
    },
  );

  test(
    'case, meaningful spaces and quotes are not normalized by selection',
    () {
      for (final ssid in [
        'home wi-fi',
        'Home Wi-Fi ',
        ' Home Wi-Fi',
        '"Home Wi-Fi"',
      ]) {
        expect(NetworkRouteService.choose(profile, ssid), same(profile));
      }
      const quoted = ServerProfile(
        id: 'quotes',
        name: 'Quotes',
        url: 'https://remote.example.invalid/',
        localUrl: 'http://192.168.1.5/',
        localSsid: '"named-network"',
        username: '',
        password: '',
      );
      expect(
        NetworkRouteService.choose(quoted, '"named-network"').url,
        quoted.localUrl,
      );
    },
  );

  test(
    'incomplete local configuration stays primary without an SSID lookup',
    () async {
      const noLocal = ServerProfile(
        id: 'plain',
        name: 'Plain',
        url: 'https://remote.example.invalid/',
        username: '',
        password: '',
      );
      expect(NetworkRouteService.choose(noLocal, 'Home Wi-Fi'), same(noLocal));
      expect(await NetworkRouteService.resolve(noLocal), same(noLocal));
      const noSsid = ServerProfile(
        id: 'plain',
        name: 'Plain',
        url: 'https://remote.example.invalid/',
        localUrl: 'http://192.168.1.5/',
        username: '',
        password: '',
      );
      expect(NetworkRouteService.choose(noSsid, 'Home Wi-Fi'), same(noSsid));
      expect(await NetworkRouteService.resolve(noSsid), same(noSsid));
    },
  );

  test('SSID platform read requests only a name and safely handles unavailable data', () async {
    const wifi = MethodChannel('dev.fluttercommunity.plus/network_info');
    const permissions = MethodChannel(
      'flutter.baseflow.com/permissions/methods',
    );
    const macPermission = MethodChannel('org.homeqb/wifi');
    final calls = <String>[];
    final permissionCalls = <String>[];
    String? current = 'Home Wi-Fi';
    var unavailable = false;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(wifi, (call) async {
      calls.add(call.method);
      if (call.method != 'wifiName') {
        throw StateError('Unexpected network identifier/coordinate request');
      }
      if (unavailable) throw PlatformException(code: 'not_available');
      return current;
    });
    messenger.setMockMethodCallHandler(permissions, (call) async {
      permissionCalls.add(call.method);
      if (call.method != 'checkPermissionStatus') {
        throw StateError('Unexpected permission prompt');
      }
      return 1; // granted status without requesting new permission.
    });
    messenger.setMockMethodCallHandler(macPermission, (call) async {
      throw StateError(
        'Background/default routing must not request macOS permission',
      );
    });
    addTearDown(() {
      messenger.setMockMethodCallHandler(wifi, null);
      messenger.setMockMethodCallHandler(permissions, null);
      messenger.setMockMethodCallHandler(macPermission, null);
    });
    expect((await NetworkRouteService.resolve(profile)).url, profile.localUrl);
    current = null;
    expect(await NetworkRouteService.resolve(profile), same(profile));
    current = '<unknown ssid>';
    expect(await NetworkRouteService.resolve(profile), same(profile));
    unavailable = true;
    expect(await NetworkRouteService.resolve(profile), same(profile));
    expect(calls, everyElement('wifiName'));
    expect(calls.length, 4);
    expect(permissionCalls, everyElement('checkPermissionStatus'));
  });
}
