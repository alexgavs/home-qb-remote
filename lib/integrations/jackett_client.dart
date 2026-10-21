import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';
import 'package:xml/xml_events.dart';

import '../core/import_validation.dart';
import 'jackett_models.dart';

/// Independent Torznab transport. No qBittorrent cookies, headers, or TLS bypass.
class JackettClient {
  JackettClient(this.profile, {this.timeout = const Duration(seconds: 30)}) {
    try {
      _base = Uri.parse(profile.url);
      if (!{'http', 'https'}.contains(_base.scheme) ||
          _base.host.isEmpty ||
          _base.userInfo.isNotEmpty ||
          _base.hasQuery ||
          _base.hasFragment ||
          profile.apiKey.trim().isEmpty ||
          timeout <= Duration.zero) {
        throw const JackettException('invalid_profile');
      }
      final path = _base.path.replaceFirst(RegExp(r'/+$'), '');
      _endpoint = _base.replace(
        path: path.endsWith('/torznab/api')
            ? path
            : path.endsWith('/torznab')
            ? '$path/api'
            : '$path/api/v2.0/indexers/all/results/torznab/api',
      );
    } catch (_) {
      throw const JackettException('invalid_profile');
    }
    _http.connectionTimeout = timeout;
    _http.idleTimeout = const Duration(seconds: 10);
    _http.maxConnectionsPerHost = 2;
  }

  final JackettProfile profile;
  final Duration timeout;
  final HttpClient _http = HttpClient();
  late final Uri _base;
  late final Uri _endpoint;
  bool _closed = false;
  static const _xmlLimit = 4 * 1024 * 1024;
  static const _torrentLimit = 16 * 1024 * 1024;
  static const _namespace = 'http://torznab.com/schemas/2015/feed';

  bool _sameOrigin(Uri uri) =>
      uri.scheme == _base.scheme &&
      uri.host == _base.host &&
      uri.port == _base.port &&
      uri.userInfo.isEmpty &&
      !uri.hasFragment;

  Future<List<int>> _get(Uri uri, int limit) async {
    if (_closed) throw const JackettException('closed');
    if (!_sameOrigin(uri)) throw const JackettException('unsafe_download');
    HttpClientRequest? request;
    var timedOut = false;
    try {
      return await (() async {
        request = await _http.getUrl(uri);
        if (timedOut || _closed) {
          request!.abort();
          throw JackettException(_closed ? 'closed' : 'timeout');
        }
        request!.followRedirects = false;
        final response = await request!.close();
        if (response.statusCode >= 300 && response.statusCode < 400) {
          request!.abort();
          throw const JackettException('redirect_blocked');
        }
        if (response.statusCode < 200 || response.statusCode >= 300) {
          request!.abort();
          throw JackettException(
            response.statusCode == 401 || response.statusCode == 403
                ? 'authentication'
                : 'http',
            statusCode: response.statusCode,
          );
        }
        if (response.contentLength > limit) {
          request!.abort();
          throw const JackettException('response_too_large');
        }
        final bytes = <int>[];
        await for (final chunk in response) {
          if (bytes.length + chunk.length > limit) {
            request!.abort();
            throw const JackettException('response_too_large');
          }
          bytes.addAll(chunk);
        }
        if (_closed) throw const JackettException('closed');
        return bytes;
      })().timeout(
        timeout,
        onTimeout: () {
          timedOut = true;
          request?.abort();
          throw const JackettException('timeout');
        },
      );
    } on JackettException {
      rethrow;
    } catch (_) {
      throw JackettException(_closed ? 'closed' : 'network');
    }
  }

  Future<List<JackettResult>> search(String query) async {
    if (query.trim().isEmpty || query.length > 2048) {
      throw const JackettException('invalid_query');
    }
    final bytes = await _get(
      _endpoint.replace(
        queryParameters: {
          't': 'search',
          'q': query.trim(),
          'apikey': profile.apiKey,
        },
      ),
      _xmlLimit,
    );
    try {
      final text = utf8.decode(bytes);
      var depth = 0;
      var events = 0;
      var entries = 0;
      for (final event in parseEvents(
        text,
        validateNesting: true,
        validateDocument: true,
      )) {
        if (++events > 50000 || event is XmlDoctypeEvent) {
          throw const JackettException('invalid_xml');
        }
        if (event is XmlStartElementEvent) {
          if (++depth > 32 || (event.localName == 'item' && ++entries > 1000)) {
            throw const JackettException('invalid_xml');
          }
          if (event.isSelfClosing) depth--;
        } else if (event is XmlEndElementEvent) {
          depth--;
        }
      }
      final document = XmlDocument.parse(text);
      if (document.rootElement.name.local == 'error') {
        throw const JackettException('service_error');
      }
      if (document.rootElement.name.local != 'rss') {
        throw const JackettException('invalid_xml');
      }
      final channel = document.rootElement.getElement('channel');
      if (channel == null) throw const JackettException('invalid_xml');
      final results = <JackettResult>[];
      for (final item in channel.findElements('item')) {
        final title = item.getElement('title')?.innerText.trim() ?? '';
        if (title.isEmpty ||
            title.length > 4096 ||
            title.contains(profile.apiKey)) {
          continue;
        }
        final attributes = <String, String>{
          for (final element in item.childElements)
            if (element.name.local == 'attr' &&
                element.namespaceUri == _namespace &&
                element.getAttribute('name') != null)
              element.getAttribute('name')!:
                  element.getAttribute('value') ?? '',
        };
        final enclosure = item.getElement('enclosure');
        final magnet = _magnet(attributes['magneturl']);
        final raw =
            enclosure?.getAttribute('url') ??
            item.getElement('link')?.innerText;
        final candidate = _download(raw);
        final download = candidate ?? magnet;
        if (download == null) continue;
        final indexer = _safeIndexer(
          item.getElement('jackettindexer')?.innerText.trim(),
        );
        results.add(
          JackettResult(
            title: title,
            downloadUri: download,
            magnetUri:
                magnet ?? (download.scheme == 'magnet' ? download : null),
            size: _number(
              attributes['size'] ??
                  item.getElement('size')?.innerText ??
                  enclosure?.getAttribute('length'),
            ),
            seeders: _number(attributes['seeders']),
            indexer: indexer == null || indexer.isEmpty ? null : indexer,
          ),
        );
      }
      return List.unmodifiable(results);
    } on JackettException {
      rethrow;
    } catch (_) {
      throw const JackettException('invalid_xml');
    }
  }

  String? _safeIndexer(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.length > 128 ||
        value.contains(profile.apiKey) ||
        RegExp(r'[\x00-\x1f\x7f]').hasMatch(value) ||
        RegExp(
          r'://|magnet:|apikey\s*=|token\s*=',
          caseSensitive: false,
        ).hasMatch(value)) {
      return null;
    }
    return value;
  }

  int? _number(String? value) {
    final number = int.tryParse(value ?? '');
    return number == null || number < 0 ? null : number;
  }

  Uri? _magnet(String? value) {
    if (value == null ||
        value.length > 16384 ||
        RegExp(r'[\x00-\x20\x7f]').hasMatch(value) ||
        value.contains(profile.apiKey)) {
      return null;
    }
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.scheme != 'magnet' ||
        uri.userInfo.isNotEmpty ||
        uri.hasFragment ||
        uri.hasAuthority ||
        uri.path.isNotEmpty ||
        uri.queryParameters.keys.any((key) => key.toLowerCase() == 'apikey') ||
        uri.queryParametersAll.values
            .expand((values) => values)
            .any(
              (value) =>
                  value.contains(profile.apiKey) ||
                  RegExp(r'[\x00-\x1f\x7f]').hasMatch(value),
            )) {
      return null;
    }
    final xt = uri.queryParametersAll['xt'] ?? [];
    return xt.any(
          (value) =>
              RegExp(r'^urn:btih:(?:[0-9a-fA-F]{40}|[a-zA-Z2-7]{32})$')
                  .hasMatch(value) ||
              RegExp(r'^urn:btmh:1220[0-9a-fA-F]{64}$').hasMatch(value),
        )
        ? uri
        : null;
  }

  Uri? _download(String? value) {
    if (value == null || value.length > 16384) return null;
    final magnet = _magnet(value);
    if (magnet != null) return magnet;
    final uri = _endpoint.resolve(value);
    return _sameOrigin(uri) ? uri : null;
  }

  Future<List<int>> downloadTorrent(JackettResult result) async {
    final bytes = await _get(result.downloadUri, _torrentLimit);
    if (!isTorrentFile(bytes)) throw const JackettException('invalid_torrent');
    return bytes;
  }

  /// Cancels in-flight requests; this client cannot be reopened.
  void close() {
    _closed = true;
    _http.close(force: true);
  }
}
