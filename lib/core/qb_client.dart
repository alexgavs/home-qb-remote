import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'models.dart';

class QbException implements Exception {
  const QbException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// A definitive sign-in rejection: the WebUI answered `Fails.`, the login
/// request itself was refused with HTTP 401/403 (wrong credentials, banned IP,
/// reverse-proxy Basic auth failure), or — in API key mode — a request was
/// refused with HTTP 401, the `app/version` probe with HTTP 403, or any other
/// 403 was confirmed to be a key rejection by a follow-up `app/version` probe
/// (qBittorrent 5.2.x also answers 403 when a valid key may not perform the
/// operation, which stays an ordinary [QbException]).
///
/// After this exception the owning [QbClient] reports
/// [QbClient.authenticationBlocked] and refuses every further sign-in attempt
/// without touching the network, so a polling timer can never hammer
/// qBittorrent with a wrong password or key and trigger its IP ban.
/// Reconnecting means creating a fresh [QbClient]. Network, TLS and timeout
/// failures are ordinary [QbException]s and never block.
class QbAuthenticationException extends QbException {
  const QbAuthenticationException(super.message, {super.statusCode});
}

class QbClient {
  QbClient(this.profile, {this.timeout = const Duration(seconds: 20)})
    : _base = _validateBase(profile.url),
      _apiKey = _validateApiKey(profile) {
    if (profile.basicAuthUsername.contains(':')) {
      throw const QbException(
        'The HTTP Basic username cannot contain a colon.',
      );
    }
    _http = _createHttpClient(profile);
    _http.connectionTimeout = timeout;
    // HttpClient's default certificate and hostname verification stays enabled.
  }

  final ServerProfile profile;
  final Duration timeout;
  final Uri _base;
  late final HttpClient _http;

  /// The qBittorrent 5.2+ WebUI API key, or null in cookie-session mode.
  ///
  /// In key mode every request (sign-in probe, reads, form posts, multipart
  /// uploads, binary downloads) carries `Authorization: Bearer <key>`, no
  /// cookie is ever sent or stored, `auth/login` is never called, and because
  /// the server never expires key sessions there is no automatic re-login:
  /// a 401 (or a 403 on `app/version`) is a final verdict on the key, never a
  /// prompt to fall back to password or cookie authentication. A 403 elsewhere
  /// may be an operation refusal; see [_confirmApiKey].
  final String? _apiKey;

  /// Visible ASCII only (RFC 9110 token68 is a subset): no spaces, CR/LF,
  /// control or non-ASCII characters can ever reach the header line.
  static final _safeHeaderValue = RegExp(r'^[\x21-\x7e]+$');

  /// What `app/version` answers: `v5.2.3`, `v5.2.3beta1`, `5.2.3.1`, ...
  static final _versionShape = RegExp(r'^v?[0-9][0-9A-Za-z.+_-]{0,63}$');

  static String? _validateApiKey(ServerProfile profile) {
    final key = profile.apiKey;
    if (key.isEmpty) return null;
    if (profile.basicAuthUsername.isNotEmpty ||
        profile.basicAuthPassword.isNotEmpty) {
      // Both travel in the single Authorization header; silently preferring
      // one would leave the other misconfiguration undetected.
      throw const QbException(
        'Use either an API key or HTTP Basic credentials, not both.',
      );
    }
    if (key.length > 1024 || !_safeHeaderValue.hasMatch(key)) {
      throw const QbException(
        'The API key contains spaces, line breaks or other unsupported characters.',
      );
    }
    return key;
  }

  /// The current session generation, or null while signed out. Every
  /// successful login creates a new object; requests capture the object they
  /// were sent with and only ever invalidate that exact generation, so a late
  /// 401/403 for an older session cannot wipe a freshly renewed one.
  _Session? _session;

  /// The single in-flight login shared by every concurrent caller.
  Future<void>? _loginInFlight;

  /// The single in-flight key confirmation probe (see [_confirmApiKey]) shared
  /// by every request that received a 403 at the same time.
  Future<QbAuthenticationException?>? _keyConfirmInFlight;

  /// Set once by a definitive credential rejection; never cleared.
  QbAuthenticationException? _rejection;
  bool _closed = false;

  /// True after the server definitively rejected the credentials. Automatic
  /// re-authentication, [login] and every authenticated request then throw
  /// the stored [QbAuthenticationException] immediately without any network
  /// traffic. Create a new [QbClient] to try again.
  bool get authenticationBlocked => _rejection != null;

  static HttpClient _createHttpClient(ServerProfile profile) {
    if (profile.clientCertificatePem.isEmpty != profile.clientKeyPem.isEmpty) {
      throw const QbException(
        'Provide both the client certificate and its private key.',
      );
    }
    if (profile.customCaPem.isEmpty && profile.clientCertificatePem.isEmpty) {
      return HttpClient();
    }
    try {
      final context = SecurityContext(withTrustedRoots: true);
      if (profile.customCaPem.isNotEmpty) {
        context.setTrustedCertificatesBytes(utf8.encode(profile.customCaPem));
      }
      if (profile.clientCertificatePem.isNotEmpty) {
        context.useCertificateChainBytes(
          utf8.encode(profile.clientCertificatePem),
        );
        context.usePrivateKeyBytes(
          utf8.encode(profile.clientKeyPem),
          password: profile.clientKeyPassword.isEmpty
              ? null
              : profile.clientKeyPassword,
        );
      }
      return HttpClient(context: context);
    } catch (_) {
      throw const QbException(
        'The custom CA or client certificate could not be loaded.',
      );
    }
  }

  static Uri _validateBase(String value) {
    try {
      final uri = Uri.parse(value.trim());
      if (!{'http', 'https'}.contains(uri.scheme) ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty ||
          uri.authority.contains('@') ||
          uri.hasQuery ||
          uri.hasFragment ||
          uri.port <= 0 ||
          uri.port > 65535 ||
          RegExp(r'[\x00-\x1f\x7f]').hasMatch(value)) {
        throw const FormatException();
      }
      return uri.path.endsWith('/') ? uri : Uri.parse('${uri.toString()}/');
    } on FormatException {
      throw const QbException(
        'Use an HTTP or HTTPS server URL without embedded credentials, query, or fragment.',
      );
    }
  }

  Uri _apiUri(String endpoint, Map<String, String> query) {
    // No URL resolution supplied by callers: exactly one API group and method.
    if (!RegExp(r'^[A-Za-z][A-Za-z0-9_]*/[A-Za-z][A-Za-z0-9_]*$')
        .hasMatch(endpoint)) {
      throw const QbException('Invalid API endpoint.');
    }
    return _base
        .resolve('api/v2/$endpoint')
        .replace(queryParameters: query.isEmpty ? null : query);
  }

  bool _sameOrigin(Uri uri) =>
      uri.scheme == _base.scheme &&
      uri.host == _base.host &&
      uri.port == _base.port &&
      uri.userInfo.isEmpty;

  /// Signs in with the profile credentials, or in API key mode proves the key
  /// with one harmless `GET app/version` (no `auth/login` call, no cookie).
  ///
  /// Concurrent calls (explicit or from automatic GET re-authentication) share
  /// one network login. An existing session stays usable until the new one
  /// replaces it. A definitive rejection throws [QbAuthenticationException],
  /// sets [authenticationBlocked] and makes this method itself refuse without
  /// network traffic from then on; reconnecting requires a new [QbClient].
  Future<void> login() async {
    if (_closed) throw const QbException('The server connection is closed.');
    final rejection = _rejection;
    if (rejection != null) throw rejection;
    final inflight = _loginInFlight;
    if (inflight != null) return inflight;
    final attempt = _performLogin();
    _loginInFlight = attempt;
    try {
      await attempt;
    } finally {
      if (identical(_loginInFlight, attempt)) _loginInFlight = null;
    }
  }

  Future<void> _performLogin() =>
      _apiKey == null ? _performCookieLogin() : _performApiKeyLogin();

  /// API key mode: the key authenticates every request on its own, so the
  /// sign-in is a read-only probe. A 401/403 is turned into the permanent
  /// rejection inside [_request]; anything that is not a version string (proxy
  /// portal, misconfigured WebUI) is an ordinary, retryable failure.
  Future<void> _performApiKeyLogin() async {
    final response = await _request('GET', 'app/version', authenticated: false);
    if (response.statusCode != 200 ||
        !_versionShape.hasMatch(response.text.trim())) {
      throw const QbException(
        'The server did not answer the API key check. Check the server URL and WebUI access settings.',
      );
    }
    if (_closed) throw const QbException('The server connection is closed.');
    _session = _Session(null);
  }

  Future<void> _performCookieLogin() async {
    _QbResponse response;
    try {
      response = await _request(
        'POST',
        'auth/login',
        authenticated: false,
        fields: {'username': profile.username, 'password': profile.password},
      );
    } on QbException catch (error) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        throw _rejectCredentials(statusCode: error.statusCode);
      }
      rethrow;
    }
    final text = response.text.trim();
    if (text.startsWith('Fails.')) throw _rejectCredentials();
    // Two genuine success shapes only: qBittorrent <= 5.1 answers HTTP 200
    // with the body `Ok.`, qBittorrent 5.2+ answers HTTP 204 with no body.
    // Both must carry a recognised, non-empty session cookie (see
    // [_SessionCookie.recognises]); an HTML page, an empty 200 or a 204
    // without a session cookie is not a sign-in.
    final legacyOk = response.statusCode == 200 && text == 'Ok.';
    final modernOk = response.statusCode == 204 && response.bytes.isEmpty;
    final cookie = response.sessionCookie;
    if (cookie == null || !(legacyOk || modernOk)) {
      // Not a credential verdict (proxy page, misconfigured WebUI): ordinary
      // failure that may be retried later.
      throw const QbException(
        'Sign-in failed. Check the server credentials and WebUI access settings.',
      );
    }
    if (_closed) throw const QbException('The server connection is closed.');
    _session = _Session(cookie);
  }

  /// Settles a key-mode 403 from an endpoint other than `app/version`, where
  /// qBittorrent 5.2.x may mean "operation forbidden" (e.g. `torrents/
  /// setSavePath` to an unwritable directory) rather than "bad key": one
  /// harmless `GET app/version` with the same Bearer header (no cookie, no
  /// `auth/login`, the original request is never replayed). Returns the
  /// permanent rejection when the probe answers 401/403, or null when the key
  /// is confirmed or the probe fails for an ordinary reason (network, TLS,
  /// timeout, server error, proxy page), in which case the caller surfaces its
  /// original 403 and the client stays usable. Concurrent callers share one
  /// probe; a closed or already blocked client never touches the network.
  Future<QbAuthenticationException?> _confirmApiKey() async {
    final rejection = _rejection;
    if (rejection != null) return rejection;
    if (_closed) return null;
    final inflight = _keyConfirmInFlight;
    if (inflight != null) return inflight;
    final attempt = _performKeyConfirmation();
    _keyConfirmInFlight = attempt;
    try {
      return await attempt;
    } finally {
      if (identical(_keyConfirmInFlight, attempt)) _keyConfirmInFlight = null;
    }
  }

  Future<QbAuthenticationException?> _performKeyConfirmation() async {
    try {
      // A 401/403 here is turned into the permanent rejection by [_request]
      // itself (app/version is the probe endpoint); any 2xx, including a
      // non-version body, leaves the key unjudged.
      await _request('GET', 'app/version', authenticated: false);
    } on QbAuthenticationException catch (error) {
      return error;
    } on QbException {
      // Inconclusive: never block on a network, TLS, timeout or server error.
    }
    return _rejection;
  }

  QbAuthenticationException _rejectCredentials({int? statusCode}) {
    _session = null;
    // Constant messages only: neither the key nor the password is ever
    // included in an exception.
    return _rejection ??= QbAuthenticationException(
      _apiKey != null
          ? 'The server rejected the API key. Check the key and WebUI access settings, then reconnect.'
          : 'Sign-in was rejected. Check the server credentials and WebUI access settings, then reconnect.',
      statusCode: statusCode,
    );
  }

  /// The current session for an authenticated request. A blocked client throws
  /// its stored rejection before any network work; a signed-out one asks for
  /// an explicit [login] (automatic sign-in only happens after an expiry).
  _Session _requireSession() {
    final rejection = _rejection;
    if (rejection != null) throw rejection;
    return _session ??
        (throw const QbException('Sign in to the server first.'));
  }

  /// Re-authenticates after [rejected] received 401/403. Does nothing when
  /// another caller already renewed the session; otherwise joins or starts the
  /// single in-flight login. Throws immediately when blocked.
  Future<void> _reauthenticate(_Session rejected) {
    final current = _session;
    if (current != null && !identical(current, rejected)) {
      return Future<void>.value();
    }
    return login();
  }

  /// Endpoint examples: app/preferences, rss/items, search/results.
  /// Returns decoded JSON, or plain text for endpoints such as app/version.
  Future<dynamic> get(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async {
    final response = await _getResponse(endpoint, query);
    try {
      return jsonDecode(response.text);
    } on FormatException {
      if (response.contentType.contains('json')) {
        throw const QbException('The server returned invalid JSON.');
      }
      return response.text;
    }
  }

  /// Idempotent read: after a 401/403 it re-authenticates once (single-flight
  /// across concurrent reads) and retries exactly once. Mutations never do.
  Future<_QbResponse> _getResponse(
    String endpoint,
    Map<String, String> query,
  ) async {
    try {
      return await _request('GET', endpoint, query: query);
    } on _SessionExpiredException catch (error) {
      await _reauthenticate(error.session);
      return _request('GET', endpoint, query: query);
    }
  }

  Future<List<int>> getBytes(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async =>
      List<int>.unmodifiable((await _getResponse(endpoint, query)).bytes);

  Future<dynamic> post(String endpoint, Map<String, String> fields) async {
    final response = await _request('POST', endpoint, fields: fields);
    if (response.text.trim() == 'Fails.') {
      throw const QbException('The server could not complete the action.');
    }
    try {
      return jsonDecode(response.text);
    } on FormatException {
      if (response.contentType.contains('json')) {
        throw const QbException('The server returned invalid JSON.');
      }
      return response.text;
    }
  }

  Future<List<Torrent>> getTorrents() async {
    final value = await get('torrents/info');
    if (value is! List) {
      throw const QbException('The server returned an invalid torrent list.');
    }
    return value
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const QbException(
              'The server returned an invalid torrent list.',
            );
          }
          return Torrent.fromJson(item);
        })
        .toList(growable: false);
  }

  Future<String> getVersion() async {
    final response = await _getResponse('app/version', const {});
    return response.text.trim();
  }

  String _hashes(List<String> hashes) {
    if (hashes.isEmpty ||
        hashes.any(
          (hash) =>
              !RegExp(r'^(?:[a-fA-F0-9]{40}|[a-fA-F0-9]{64})$').hasMatch(hash),
        )) {
      throw const QbException('Select valid torrents first.');
    }
    return hashes.join('|');
  }

  Future<void> setPaused(List<String> hashes, {required bool paused}) async {
    final fields = {'hashes': _hashes(hashes)};
    try {
      await post(paused ? 'torrents/stop' : 'torrents/start', fields);
    } on QbException catch (error) {
      if (error.statusCode != 404 && error.statusCode != 405) rethrow;
      await post(paused ? 'torrents/pause' : 'torrents/resume', fields);
    }
  }

  Future<void> addUrls(
    String urls, {
    Map<String, String> options = const {},
  }) async {
    if (urls.trim().isEmpty) {
      throw const QbException('Enter a torrent URL or magnet link.');
    }
    await post('torrents/add', {...options, 'urls': urls.trim()});
  }

  Future<void> addTorrentFile(
    String name,
    List<int> bytes, {
    Map<String, String> options = const {},
  }) async {
    if (bytes.isEmpty) {
      throw const QbException('Choose a non-empty torrent file.');
    }
    final safeName = name
        .split(RegExp(r'[/\\]'))
        .last
        .replaceAll(RegExp(r'[\r\n"\\]'), '_');
    if (safeName.isEmpty) {
      throw const QbException('Choose a named torrent file.');
    }
    if (options.keys.any(
      (key) =>
          !RegExp(r'^[A-Za-z][A-Za-z0-9_]*$').hasMatch(key) ||
          key == 'torrents',
    )) {
      throw const QbException('Invalid torrent option field.');
    }
    final random = Random.secure();
    final boundary =
        'home-qb-${List.generate(24, (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0')).join()}';
    final body = <int>[
      for (final entry in options.entries)
        ...utf8.encode(
          '--$boundary\r\nContent-Disposition: form-data; name="${entry.key}"\r\n\r\n${entry.value}\r\n',
        ),
      ...utf8.encode(
        '--$boundary\r\nContent-Disposition: form-data; name="torrents"; filename="$safeName"\r\nContent-Type: application/x-bittorrent\r\n\r\n',
      ),
      ...bytes,
      ...utf8.encode('\r\n--$boundary--\r\n'),
    ];
    final response = await _request(
      'POST',
      'torrents/add',
      body: body,
      contentType: 'multipart/form-data; boundary=$boundary',
    );
    if (response.text.trim() == 'Fails.') {
      throw const QbException('The server rejected the torrent file.');
    }
  }

  Future<void> deleteTorrents(
    List<String> hashes, {
    bool deleteFiles = false,
  }) async {
    await post('torrents/delete', {
      'hashes': _hashes(hashes),
      'deleteFiles': '$deleteFiles',
    });
  }

  Future<TorrentDetails> getDetails(String hash) async {
    _hashes([hash]);
    final values = await Future.wait([
      get('torrents/properties', {'hash': hash}),
      get('torrents/files', {'hash': hash}),
      get('torrents/trackers', {'hash': hash}),
    ]);
    if (values[0] is! Map<String, dynamic> ||
        values[1] is! List ||
        values[2] is! List) {
      throw const QbException('The server returned invalid torrent details.');
    }
    List<Map<String, dynamic>> rows(dynamic value) => (value as List)
        .map((row) {
          if (row is! Map<String, dynamic>) {
            throw const QbException(
              'The server returned invalid torrent details.',
            );
          }
          return row;
        })
        .toList(growable: false);
    return TorrentDetails(
      properties: values[0] as Map<String, dynamic>,
      files: rows(values[1]),
      trackers: rows(values[2]),
    );
  }

  Future<_QbResponse> _request(
    String method,
    String endpoint, {
    Map<String, String> query = const {},
    Map<String, String>? fields,
    List<int>? body,
    String? contentType,
    bool authenticated = true,
  }) async {
    if (_closed) throw const QbException('The server connection is closed.');
    // Capture the session synchronously, before any asynchronous work, so the
    // cookie, the invalidation and the retry all refer to one generation.
    final session = authenticated ? _requireSession() : null;
    var uri = _apiUri(endpoint, query);
    var requestMethod = method;
    var data =
        body ??
        (fields == null
            ? null
            : utf8.encode(Uri(queryParameters: fields).query));
    var media =
        contentType ?? 'application/x-www-form-urlencoded; charset=utf-8';
    HttpClientRequest? pending;
    var cancelled = false;
    try {
      final result =
          await (() async {
            for (var redirects = 0; redirects <= 3; redirects++) {
              final request = await _http.openUrl(requestMethod, uri);
              pending = request;
              if (cancelled) {
                request.abort();
                throw const QbException('The server request timed out.');
              }
              request.followRedirects = false;
              request.headers.set('Origin', _base.origin);
              request.headers.set(HttpHeaders.refererHeader, _base.toString());
              request.headers.set(
                HttpHeaders.acceptHeader,
                'application/json, text/plain',
              );
              final apiKey = _apiKey;
              if (apiKey != null) {
                // qBittorrent 5.2+: the key goes on every request, including
                // the sign-in probe, uploads and binary downloads. Only sent
                // after the same-origin check above, never to another host.
                request.headers.set(
                  HttpHeaders.authorizationHeader,
                  'Bearer $apiKey',
                );
              } else if (profile.basicAuthUsername.isNotEmpty ||
                  profile.basicAuthPassword.isNotEmpty) {
                request.headers.set(
                  HttpHeaders.authorizationHeader,
                  'Basic ${base64Encode(utf8.encode('${profile.basicAuthUsername}:${profile.basicAuthPassword}'))}',
                );
              }
              final cookie = session?.cookie;
              if (cookie != null) {
                // Echo the exact cookie name the server issued (`SID` or
                // `QBT_SID_<port>`); the port is the server's own listening
                // port, which may differ from the public reverse-proxy port.
                request.cookies.add(Cookie(cookie.name, cookie.value));
              }
              if (data != null) {
                request.headers.set(HttpHeaders.contentTypeHeader, media);
                request.contentLength = data!.length;
                request.add(data!);
              }
              final response = await request.close();
              if ({301, 302, 303, 307, 308}.contains(response.statusCode)) {
                final location = response.headers.value(
                  HttpHeaders.locationHeader,
                );
                await response.drain<void>();
                if (location == null) {
                  throw const QbException(
                    'The server returned an invalid redirect.',
                  );
                }
                final next = uri.resolve(location);
                if (!_sameOrigin(next)) {
                  throw const QbException(
                    'A redirect to another server was blocked.',
                  );
                }
                if (redirects == 3) {
                  throw const QbException(
                    'The server returned too many redirects.',
                  );
                }
                if (response.statusCode == 303 ||
                    ((response.statusCode == 301 ||
                            response.statusCode == 302) &&
                        requestMethod == 'POST')) {
                  requestMethod = 'GET';
                  data = null;
                  media = '';
                }
                uri = next;
                continue;
              }
              if (response.statusCode < 200 || response.statusCode >= 300) {
                await response.drain<void>();
                final denied =
                    response.statusCode == 401 || response.statusCode == 403;
                if (denied && _apiKey != null) {
                  if (response.statusCode == 401 || endpoint == 'app/version') {
                    // A refused key is final (key sessions never expire, and
                    // the server does not fall back to cookie or whitelist
                    // auth for a bad Bearer): block the client instead of
                    // retrying the request or attempting a password login.
                    throw _rejectCredentials(statusCode: response.statusCode);
                  }
                  // A 403 elsewhere may be an operation refusal for a valid
                  // key. Settled outside this request's timeout by one shared
                  // app/version probe; the request itself is never replayed.
                  throw const _KeyForbiddenException();
                }
                if (denied && session != null) {
                  // Only the generation this request was sent with is dropped;
                  // a session renewed meanwhile stays intact.
                  if (identical(_session, session)) _session = null;
                  throw _SessionExpiredException(session, response.statusCode);
                }
                throw QbException(
                  'The server rejected the request (HTTP ${response.statusCode}).',
                  statusCode: response.statusCode,
                );
              }
              final bytes = <int>[];
              await for (final chunk in response) {
                if (bytes.length + chunk.length > 16 * 1024 * 1024) {
                  throw const QbException('The server response is too large.');
                }
                bytes.addAll(chunk);
              }
              // Only a recognised session cookie is retained; unrelated
              // cookies are never stored or replayed. In API key mode no
              // cookie is ever retained: the key alone is the session.
              _SessionCookie? sessionCookie;
              if (_apiKey == null) {
                for (final cookie in response.cookies) {
                  if (_SessionCookie.recognises(cookie.name) &&
                      cookie.value.isNotEmpty) {
                    sessionCookie = _SessionCookie(cookie.name, cookie.value);
                  }
                }
              }
              return _QbResponse(
                response.statusCode,
                bytes,
                response.headers.contentType?.mimeType ?? '',
                sessionCookie,
              );
            }
            throw const QbException('The server returned too many redirects.');
          })().timeout(
            timeout,
            onTimeout: () {
              cancelled = true;
              pending?.abort();
              throw const QbException('The server request timed out.');
            },
          );
      final renewed = result.sessionCookie;
      final current = session?.cookie;
      if (current != null &&
          renewed != null &&
          !renewed.sameAs(current) &&
          !_closed &&
          identical(_session, session)) {
        // A server-issued replacement cookie (name and value as sent by the
        // server) only supersedes the generation it answered; a stale response
        // never overrides a newer login.
        _session = _Session(renewed);
      }
      return result;
    } on _KeyForbiddenException catch (error) {
      final rejection = await _confirmApiKey();
      // Confirmed or inconclusive: the ordinary 403, client still usable.
      throw rejection ??
          QbException(error.message, statusCode: error.statusCode);
    } on QbException {
      rethrow;
    } on HandshakeException {
      throw const QbException(
        'TLS verification failed. Check the server certificate and hostname.',
      );
    } on SocketException {
      throw const QbException(
        'Cannot reach the server. Check its address and connection.',
      );
    } on HttpException {
      throw const QbException('The server connection failed.');
    } on FormatException {
      throw const QbException('The server returned an invalid response.');
    } catch (_) {
      throw const QbException('The server request failed.');
    }
  }

  void close() {
    _closed = true;
    _session = null;
    // An in-flight login fails through the forced socket close and clears
    // itself; nothing can be stored afterwards because _closed is checked.
    _http.close(force: true);
  }
}

/// One signed-in generation. Identity (not the cookie) distinguishes
/// generations, so a re-login that happens to yield the same cookie is still a
/// new generation.
class _Session {
  _Session(this.cookie);

  /// The cookie to replay, or null for an API key generation, which carries
  /// no cookie at all (the Bearer header is added to every request instead).
  final _SessionCookie? cookie;
}

/// The session cookie exactly as the server issued it: the legacy `SID` or the
/// qBittorrent 5.2+ `QBT_SID_<port>` name together with its value.
class _SessionCookie {
  const _SessionCookie(this.name, this.value);
  final String name;
  final String value;

  static const _modernPrefix = 'QBT_SID_';
  static final _portDigits = RegExp(r'^[1-9][0-9]{0,4}$');

  /// True only for `SID` or `QBT_SID_<port>` with a strictly numeric port in
  /// 1..65535 (no leading zeros, no sign, no other suffix). The port is taken
  /// from the server, never derived from the client URL, because a reverse
  /// proxy may publish qBittorrent on a different port.
  static bool recognises(String name) {
    if (name == 'SID') return true;
    if (!name.startsWith(_modernPrefix)) return false;
    final port = name.substring(_modernPrefix.length);
    return _portDigits.hasMatch(port) && int.parse(port) <= 65535;
  }

  bool sameAs(_SessionCookie other) =>
      name == other.name && value == other.value;
}

/// 401/403 for an authenticated request, carrying the generation that was
/// rejected so idempotent reads can decide whether a re-login is still needed.
class _SessionExpiredException extends QbException {
  _SessionExpiredException(this.session, int statusCode)
    : super('The session expired. Sign in again.', statusCode: statusCode);
  final _Session session;
}

/// Key-mode 403 from an endpoint other than `app/version`; only ever thrown
/// inside [QbClient._request], which settles it via [QbClient._confirmApiKey].
class _KeyForbiddenException extends QbException {
  const _KeyForbiddenException()
    : super('The server rejected the request (HTTP 403).', statusCode: 403);
}

class _QbResponse {
  const _QbResponse(
    this.statusCode,
    this.bytes,
    this.contentType,
    this.sessionCookie,
  );
  String get text => utf8.decode(bytes, allowMalformed: true);
  final int statusCode;
  final String contentType;

  /// The recognised session cookie set by this response, if any.
  final _SessionCookie? sessionCookie;
  final List<int> bytes;
}
