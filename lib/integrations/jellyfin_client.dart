import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'jellyfin_models.dart';

enum JellyfinErrorCode {
  invalidProfile,
  authentication,
  invalidResponse,
  redirect,
  connection,
}

/// Carries a localization code, never a server body, URL, token or socket error.
class JellyfinException implements Exception {
  const JellyfinException(this.code, {this.statusCode});
  final JellyfinErrorCode code;
  final int? statusCode;

  @override
  String toString() => 'Jellyfin request failed (${code.name}).';
}

/// Read-only user-scoped library client, independent of qBittorrent transport.
///
/// Primary protocol references:
/// https://github.com/jellyfin/jellyfin/blob/master/Jellyfin.Api/Controllers/UserController.cs
/// https://github.com/jellyfin/jellyfin/blob/master/Jellyfin.Api/Controllers/ItemsController.cs
/// https://github.com/jellyfin/jellyfin/blob/master/Jellyfin.Server.Implementations/Security/AuthorizationContext.cs
class JellyfinClient {
  JellyfinClient(this.profile, {this.timeout = const Duration(seconds: 15)})
    : _base = _baseUri(profile.url),
      _userId = _normalizeId(profile.userId) {
    if (_userId == null ||
        profile.accessToken.isEmpty ||
        profile.accessToken.length > 4096 ||
        RegExp(r'[\s\x00-\x1f\x7f]').hasMatch(profile.accessToken) ||
        timeout <= Duration.zero) {
      throw const JellyfinException(JellyfinErrorCode.invalidProfile);
    }
    _http = HttpClient()..connectionTimeout = timeout;
    // The default certificate/hostname validation stays enabled.
  }

  final JellyfinProfile profile;
  final Duration timeout;
  final Uri _base;
  final String? _userId;
  late final HttpClient _http;
  Future<JellyfinUser>? _identity;
  bool _closed = false;
  static const _maxBytes = 2 * 1024 * 1024;
  static const _maxItems = 100;

  static String? _normalizeId(String id) {
    if (!RegExp(
      r'^(?:[a-fA-F0-9]{32}|[a-fA-F0-9]{8}(?:-[a-fA-F0-9]{4}){3}-[a-fA-F0-9]{12})$',
    ).hasMatch(id)) {
      return null;
    }
    return id.replaceAll('-', '').toLowerCase();
  }

  static Uri _baseUri(String input) {
    try {
      final uri = Uri.parse(input);
      if (!['https', 'http'].contains(uri.scheme) ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty ||
          uri.authority.contains('@') ||
          uri.hasQuery ||
          uri.hasFragment ||
          uri.port < 1 ||
          uri.port > 65535 ||
          RegExp(r'[\s\x00-\x1f\x7f\\]').hasMatch(input) ||
          uri.pathSegments.any(
            (part) =>
                part == '..' ||
                part == '.' ||
                part.contains('/') ||
                RegExp(r'[\x00-\x1f\x7f\\]').hasMatch(part),
          )) {
        throw const FormatException();
      }
      return uri.replace(path: '${uri.path.replaceFirst(RegExp(r'/+$'), '')}/');
    } catch (_) {
      throw const JellyfinException(JellyfinErrorCode.invalidProfile);
    }
  }

  Future<void> validate() async {
    await currentUser();
  }

  /// Rejects application-wide API keys and mismatched user IDs before browsing.
  /// `/Users/Me` returns 400 for a token not owned by a user.
  Future<JellyfinUser> currentUser() {
    if (_closed) {
      return Future.error(
        const JellyfinException(JellyfinErrorCode.connection),
      );
    }
    return _identity ??= _loadUser();
  }

  Future<JellyfinUser> _loadUser() async {
    try {
      final data = await _get('Users/Me');
      final id = data['Id'];
      final name = data['Name'];
      if (id is! String || _normalizeId(id) == null || name is! String) {
        throw const JellyfinException(JellyfinErrorCode.invalidResponse);
      }
      if (_normalizeId(id) != _userId) {
        throw const JellyfinException(JellyfinErrorCode.authentication);
      }
      return JellyfinUser(id: id, name: name);
    } catch (_) {
      _identity = null;
      rethrow;
    }
  }

  /// Searches server-side within the authenticated user, never an admin catalog.
  /// Empty text browses the first 100 visible video library items.
  Future<List<JellyfinItem>> search(String query) async {
    if (query.length > 500 || RegExp(r'[\x00-\x1f\x7f]').hasMatch(query)) {
      throw const JellyfinException(JellyfinErrorCode.invalidProfile);
    }
    await currentUser();
    final data = await _get('Items', {
      'UserId': _userId!,
      'SearchTerm': query.trim(),
      'Recursive': 'true',
      'IncludeItemTypes': 'Movie,Series,Episode,Video',
      'Fields': 'Overview',
      'Limit': '$_maxItems',
      'StartIndex': '0',
      'EnableImages': 'false',
      'EnableTotalRecordCount': 'false',
    });
    try {
      final items = data['Items'];
      if (items is! List || items.length > _maxItems) {
        throw const FormatException();
      }
      return List.unmodifiable(
        items.map((item) {
          final parsed = JellyfinItem.fromJson(item as Map<String, dynamic>);
          if (parsed.id.isEmpty || parsed.title.isEmpty) {
            throw const FormatException();
          }
          return parsed;
        }),
      );
    } catch (_) {
      throw const JellyfinException(JellyfinErrorCode.invalidResponse);
    }
  }

  Future<Map<String, dynamic>> _get(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async {
    if (_closed) {
      throw const JellyfinException(JellyfinErrorCode.connection);
    }
    final uri = _base.resolve(endpoint).replace(queryParameters: query);
    HttpClientRequest? pending;
    var cancelled = false;
    try {
      return await (() async {
        var target = uri;
        for (var redirects = 0; redirects <= 3; redirects++) {
          final request = await _http.getUrl(target);
          pending = request;
          if (cancelled || _closed) {
            request.abort();
            throw const JellyfinException(JellyfinErrorCode.connection);
          }
          request.followRedirects = false;
          request.headers.set(HttpHeaders.acceptHeader, 'application/json');
          // Modern Jellyfin authorization; no legacy/query token fallback.
          request.headers.set(
            HttpHeaders.authorizationHeader,
            'MediaBrowser Token="${Uri.encodeComponent(profile.accessToken)}"',
          );
          final response = await request.close();
          if ([301, 302, 303, 307, 308].contains(response.statusCode)) {
            final location = response.headers.value(HttpHeaders.locationHeader);
            request.abort();
            if (location == null || redirects == 3) {
              throw const JellyfinException(JellyfinErrorCode.redirect);
            }
            final next = target.resolve(location);
            if (next.scheme != _base.scheme ||
                next.host != _base.host ||
                next.port != _base.port ||
                next.userInfo.isNotEmpty ||
                next.authority.contains('@')) {
              throw const JellyfinException(JellyfinErrorCode.redirect);
            }
            // Keep query tokens out of requests even if a server redirects there.
            if (next.hasQuery ||
                next.hasFragment ||
                (next.path != uri.path && next.path != '${uri.path}/')) {
              throw const JellyfinException(JellyfinErrorCode.redirect);
            }
            // Redirects may normalize a trailing slash but cannot move this
            // credential to another same-host application or drop user scope.
            target = next.replace(queryParameters: query);
            continue;
          }
          if ([400, 401, 403].contains(response.statusCode)) {
            request.abort();
            throw JellyfinException(
              response.statusCode == 400 && endpoint != 'Users/Me'
                  ? JellyfinErrorCode.invalidResponse
                  : JellyfinErrorCode.authentication,
              statusCode: response.statusCode,
            );
          }
          if (response.statusCode != 200) {
            request.abort();
            throw JellyfinException(
              JellyfinErrorCode.connection,
              statusCode: response.statusCode,
            );
          }
          if (response.contentLength > _maxBytes) {
            request.abort();
            throw const JellyfinException(JellyfinErrorCode.invalidResponse);
          }
          final bytes = <int>[];
          await for (final chunk in response) {
            if (bytes.length + chunk.length > _maxBytes) {
              request.abort();
              throw const JellyfinException(JellyfinErrorCode.invalidResponse);
            }
            bytes.addAll(chunk);
          }
          final json = jsonDecode(utf8.decode(bytes));
          if (json is! Map<String, dynamic>) {
            throw const FormatException();
          }
          return json;
        }
        throw const JellyfinException(JellyfinErrorCode.redirect);
      })().timeout(
        timeout,
        onTimeout: () {
          cancelled = true;
          pending?.abort();
          throw const JellyfinException(JellyfinErrorCode.connection);
        },
      );
    } on JellyfinException {
      rethrow;
    } on FormatException {
      throw const JellyfinException(JellyfinErrorCode.invalidResponse);
    } catch (_) {
      throw const JellyfinException(JellyfinErrorCode.connection);
    }
  }

  void close() {
    _closed = true;
    _identity = null;
    _http.close(force: true);
  }
}
