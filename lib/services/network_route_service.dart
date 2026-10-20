import 'dart:io';

import 'package:flutter/services.dart';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/models.dart';

/// SSID is used locally to choose a saved URL. Coordinates are never requested
/// from a location API, recorded, or transmitted.
class NetworkRouteService {
  static const _macWifiPermission = MethodChannel('org.homeqb/wifi');

  static Future<String?> currentSsid({bool requestPermission = false}) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final status = requestPermission
            ? await Permission.locationWhenInUse.request()
            : await Permission.locationWhenInUse.status;
        if (!status.isGranted) return null;
      } else if (Platform.isMacOS && requestPermission) {
        final granted = await _macWifiPermission.invokeMethod<bool>(
          'requestPermission',
        );
        if (granted != true) return null;
      }
      var name = await NetworkInfo().getWifiName();
      if (name == null || name.isEmpty || name == '<unknown ssid>') return null;
      if (Platform.isAndroid &&
          name.length >= 2 &&
          name.startsWith('"') &&
          name.endsWith('"')) {
        name = name.substring(1, name.length - 1);
      }
      return name;
    } catch (_) {
      return null;
    }
  }

  static Future<ServerProfile> resolve(ServerProfile profile) async {
    if (profile.localUrl.isEmpty || profile.localSsid.isEmpty) return profile;
    final ssid = await currentSsid();
    return choose(profile, ssid);
  }

  /// Missing permission or an unavailable SSID keeps the primary saved URL.
  /// Matching is exact and case-sensitive: spaces/quotes can belong to an SSID.
  /// Android's platform wrapping quotes are removed only by [currentSsid].
  static ServerProfile choose(ServerProfile profile, String? currentSsid) {
    if (profile.localUrl.isEmpty ||
        profile.localSsid.isEmpty ||
        currentSsid == null ||
        currentSsid.isEmpty ||
        currentSsid == '<unknown ssid>') {
      return profile;
    }
    return currentSsid == profile.localSsid
        ? profile.withUrl(profile.localUrl)
        : profile;
  }
}
