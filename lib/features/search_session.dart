import 'dart:async';

import '../core/models.dart';
import '../core/qb_client.dart';

/// A transport captured for one server, independent of subsequent UI selection.
abstract interface class SearchServerApi {
  Future<dynamic> get(String endpoint, [Map<String, String> query = const {}]);
  Future<dynamic> post(String endpoint, Map<String, String> fields);
  Future<List<Torrent>> getTorrents();
  Future<void> addUrls(String urls, {Map<String, String> options = const {}});
  void close();
}

typedef SearchApiFactory = SearchServerApi Function(ServerProfile profile);

class QbSearchServerApi implements SearchServerApi {
  QbSearchServerApi(ServerProfile profile) : _client = QbClient(profile);
  final QbClient _client;
  Future<void>? _login;
  Future<void> _ready() => _login ??= _client.login();

  @override
  Future<dynamic> get(
    String endpoint, [
    Map<String, String> query = const {},
  ]) async {
    await _ready();
    return _client.get(endpoint, query);
  }

  @override
  Future<dynamic> post(String endpoint, Map<String, String> fields) async {
    await _ready();
    return _client.post(endpoint, fields);
  }

  @override
  Future<List<Torrent>> getTorrents() async {
    await _ready();
    return _client.getTorrents();
  }

  @override
  Future<void> addUrls(
    String urls, {
    Map<String, String> options = const {},
  }) async {
    await _ready();
    await _client.addUrls(urls, options: options);
  }

  @override
  void close() => _client.close();
}

/// Cleanup waits for a late start response, so cancellation never sends an old
/// search ID to a newly selected server or leaves a known job uncollected.
class BoundSearchJob {
  BoundSearchJob(this.api);
  final SearchServerApi api;
  Future<int>? _started;
  Future<void>? _cleanup;

  Future<int> start(Map<String, String> fields) {
    if (_started != null) return _started!;
    final completer = Completer<int>();
    _started = completer.future;
    unawaited(() async {
      try {
        completer.complete(await _start(fields));
      } catch (error, stack) {
        completer.completeError(error, stack);
      }
    }());
    return completer.future;
  }

  Future<int> _start(Map<String, String> fields) async {
    final response = await api.post('search/start', fields);
    final value = response is Map ? response['id'] : null;
    final id = value is num ? value.toInt() : int.tryParse('$value');
    if (id == null || id < 0) throw const FormatException();
    return id;
  }

  Future<dynamic> results(int id) =>
      api.get('search/results', {'id': '$id', 'limit': '1000', 'offset': '0'});

  Future<void> cleanup({bool stop = true}) => _cleanup ??= _clean(stop);
  Future<void> _clean(bool stop) async {
    try {
      final started = _started;
      if (started == null) return;
      final id = await started;
      if (stop) {
        try {
          await api.post('search/stop', {'id': '$id'});
        } catch (_) {
          /* Still try deleting. */
        }
      }
      try {
        await api.post('search/delete', {'id': '$id'});
      } catch (_) {
        /* Server may already have removed it. */
      }
    } catch (_) {
      // A failed start has no usable job ID. Never repeat the start mutation.
    } finally {
      api.close();
    }
  }
}

/// Search-provided URLs can embed credentials in every component; do not render
/// any URL, including a supposedly harmless origin or a title containing one.
String safeSearchTitle(Object? value, String fallback) {
  if (value is! String || value.trim().isEmpty) return fallback;
  var inspected = value;
  try {
    inspected = Uri.decodeComponent(value);
  } catch (_) {
    /* Keep the literal for validation. */
  }
  if (RegExp(
        r'https?://|magnet:|[a-z][a-z0-9+.-]*://',
        caseSensitive: false,
      ).hasMatch(value) ||
      RegExp(r'://|magnet:', caseSensitive: false).hasMatch(inspected)) {
    return fallback;
  }
  return value;
}

String safeSearchCount(Object? value) {
  final text = '$value';
  if (!RegExp(r'^\d{1,10}$').hasMatch(text)) return '—';
  return '${int.parse(text)}';
}

bool supportedSearchDownload(String value) {
  final uri = Uri.tryParse(value);
  if (uri == null ||
      value.trim() != value ||
      RegExp(r'[\x00-\x20\x7f]').hasMatch(value)) {
    return false;
  }
  if (uri.scheme.toLowerCase() == 'magnet') {
    return magnetInfoHashes(value).isNotEmpty;
  }
  return ['http', 'https'].contains(uri.scheme.toLowerCase()) &&
      uri.host.isNotEmpty &&
      uri.userInfo.isEmpty;
}

/// v1 hex/base32 and v2 SHA-256 multihashes are kept distinct. In particular a
/// v2 hash is never truncated into a v1 hash. Hybrid magnets may identify both.
Set<String> magnetInfoHashes(String value) {
  final uri = Uri.tryParse(value);
  if (uri == null || uri.scheme.toLowerCase() != 'magnet') return {};
  final hashes = <String>{};
  for (final xt in uri.queryParametersAll['xt'] ?? const <String>[]) {
    final normalized = xt.toLowerCase();
    if (normalized.startsWith('urn:btih:')) {
      final raw = xt.substring(9);
      if (RegExp(r'^[a-fA-F0-9]{40}$').hasMatch(raw)) {
        hashes.add(raw.toLowerCase());
      } else if (RegExp(r'^[a-zA-Z2-7]{32}$').hasMatch(raw)) {
        const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        var bits = 0, buffer = 0;
        final bytes = <int>[];
        for (final code in raw.toUpperCase().split('')) {
          buffer = (buffer << 5) | alphabet.indexOf(code);
          bits += 5;
          if (bits >= 8) {
            bits -= 8;
            bytes.add((buffer >> bits) & 255);
            buffer &= (1 << bits) - 1;
          }
        }
        hashes.add(
          bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(),
        );
      }
    } else if (RegExp(r'^urn:btmh:1220[a-f0-9]{64}$').hasMatch(normalized)) {
      hashes.add(normalized.substring(13));
    }
  }
  return hashes;
}
