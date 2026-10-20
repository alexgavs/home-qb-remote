// Explicitly invoked local integration check. No credentials are persisted.
import 'dart:convert';
import 'dart:io';

import 'package:home_qb_remote/core/models.dart';
import 'package:home_qb_remote/core/qb_client.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty || args.length > 2) {
    throw ArgumentError('Supply the authorized WebUI URL and an optional torrent SHA1.');
  }
  if (args.length == 2 && !RegExp(r'^[0-9a-fA-F]{40}$').hasMatch(args[1])) {
    throw ArgumentError('Expected a SHA1 infohash.');
  }
  final base = Uri.parse(
    args.first.endsWith('/') ? args.first : '${args.first}/',
  );
  if (!{'http', 'https'}.contains(base.scheme) || base.userInfo.isNotEmpty) {
    throw ArgumentError('Expected HTTP(S) URL without embedded credentials.');
  }
  final http = HttpClient()..connectionTimeout = const Duration(seconds: 10);
  final cookies = <String, Cookie>{};
  Future<String> api(String endpoint, {bool post = false}) async {
    final request = await http.openUrl(
      post ? 'POST' : 'GET',
      base.resolve('api/v2/$endpoint'),
    );
    request.followRedirects = false;
    request.headers.set('Origin', base.origin);
    request.headers.set('Referer', base.toString());
    request.cookies.addAll(cookies.values);
    if (post) request.contentLength = 0;
    final response = await request.close().timeout(const Duration(seconds: 10));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      await response.drain<void>();
      throw StateError('Integration API returned HTTP ${response.statusCode}.');
    }
    for (final cookie in response.cookies) {
      cookies[cookie.name] = cookie;
    }
    final bytes = <int>[];
    await for (final chunk in response) {
      if (bytes.length + chunk.length > 1024 * 1024) {
        throw StateError('Integration response exceeded its size limit.');
      }
      bytes.addAll(chunk);
    }
    return utf8.decode(bytes);
  }

  final result = <String, Object?>{};
  QbClient? passwordClient;
  QbClient? keyClient;
  QbClient? invalidClient;
  String? temporaryKey;
  try {
    // This environment explicitly allows the LAN address without a password.
    // The actual saved username/password flow is checked separately on-device.
    passwordClient = QbClient(
      ServerProfile(
        id: 'local-check',
        name: 'Local check',
        url: base.toString(),
        username: '',
        password: '',
      ),
    );
    await passwordClient.login();
    result['cookie_mode_version'] = await passwordClient.getVersion();
    final preferences =
        jsonDecode(await api('app/preferences')) as Map<String, dynamic>;
    var key = preferences['web_ui_api_key'] as String? ?? '';
    result['existing_api_key'] = key.isNotEmpty;
    if (key.isEmpty) {
      final generated = jsonDecode(
        await api('app/rotateAPIKey', post: true),
      ) as Map<String, dynamic>;
      key = generated['apiKey'] as String? ?? '';
      if (key.isEmpty) throw StateError('No temporary API key was returned.');
      temporaryKey = key;
    }
    keyClient = QbClient(
      ServerProfile(
        id: 'key-check',
        name: 'Key check',
        url: base.toString(),
        username: '',
        password: '',
        apiKey: key,
      ),
    );
    await keyClient.login();
    result['bearer_mode_version'] = await keyClient.getVersion();
    if (args.length == 2) {
      final target = await keyClient.get('torrents/info', {'hashes': args[1]});
      result['target_present'] = target is List && target.isNotEmpty;
    }
    invalidClient = QbClient(
      ServerProfile(
        id: 'invalid-check',
        name: 'Invalid check',
        url: base.toString(),
        username: '',
        password: '',
        apiKey: '${key}invalid',
      ),
    );
    try {
      await invalidClient.login();
      throw StateError('An invalid API key was accepted.');
    } on QbAuthenticationException catch (error) {
      result['invalid_key_status'] = error.statusCode;
      result['invalid_key_blocked'] = invalidClient.authenticationBlocked;
    }
    result['passed'] = true;
  } finally {
    passwordClient?.close();
    keyClient?.close();
    invalidClient?.close();
    if (temporaryKey != null) {
      final current =
          jsonDecode(await api('app/preferences')) as Map<String, dynamic>;
      if (current['web_ui_api_key'] == temporaryKey) {
        await api('app/deleteAPIKey', post: true);
        final restored =
            jsonDecode(await api('app/preferences')) as Map<String, dynamic>;
        result['temporary_key_removed'] =
            (restored['web_ui_api_key'] as String? ?? '').isEmpty;
      } else {
        result['temporary_key_removed'] = false;
        result['cleanup_note'] =
            'Key changed concurrently; did not delete another key.';
      }
    }
    http.close(force: true);
    stdout.writeln(jsonEncode(result));
  }
}
