import 'package:crypto/crypto.dart';

import '../core/import_validation.dart';

/// Hash the original encoded info dictionary, never a reconstructed dictionary.
/// Pure v2 returns SHA256, v1 SHA1; hybrid info dictionaries return both.
Set<String> torrentInfoHashes(List<int> validatedBytes) {
  if (!isTorrentFile(validatedBytes)) {
    throw const FormatException('Invalid torrent');
  }
  final reader = _InfoReader(validatedBytes);
  return reader.hashes();
}

/// qBittorrent may expose a truncated v2 identifier through some APIs. Enable
/// that compatibility explicitly; it is not proof of a full SHA256 match.
bool matchesTorrentIdentity(
  Set<String> identities,
  String candidate, {
  bool allowTruncatedV2 = false,
}) {
  final value = candidate.toLowerCase();
  if (!RegExp(r'^(?:[0-9a-f]{40}|[0-9a-f]{64})$').hasMatch(value)) return false;
  return identities.any(
    (hash) =>
        hash.toLowerCase() == value ||
        (allowTruncatedV2 &&
            value.length == 40 &&
            hash.length == 64 &&
            hash.toLowerCase().startsWith(value)),
  );
}

class _InfoReader {
  _InfoReader(this.bytes);
  final List<int> bytes;
  int position = 0;
  int nodes = 0;
  Never invalid() => throw const FormatException('Invalid torrent');
  int get peek => position < bytes.length ? bytes[position] : -1;

  String key() {
    final start = position;
    while (peek >= 48 && peek <= 57) {
      position++;
    }
    if (position == start || peek != 58) invalid();
    final length = int.parse(
      String.fromCharCodes(bytes.sublist(start, position)),
    );
    position++;
    if (length > bytes.length - position) invalid();
    // Only small ASCII metadata keys matter. Avoid materializing binary strings.
    final value = length <= 32
        ? String.fromCharCodes(bytes.sublist(position, position + length))
        : '';
    position += length;
    return value;
  }

  void skip(int depth) {
    if (depth > 64 || ++nodes > 1000000) invalid();
    if (peek == 100 || peek == 108) {
      final dictionary = peek == 100;
      position++;
      while (peek != 101) {
        if (peek < 0) invalid();
        if (dictionary) key();
        skip(depth + 1);
      }
      position++;
    } else if (peek == 105) {
      position++;
      while (peek != 101) {
        if (peek < 0) invalid();
        position++;
      }
      position++;
    } else {
      key();
    }
  }

  Set<String> hashes() {
    position++; // root dictionary
    int? start, end;
    var v2 = false;
    var pieces = false;
    while (peek != 101) {
      final name = key();
      if (name != 'info') {
        skip(1);
        continue;
      }
      if (start != null || peek != 100) invalid();
      start = position++;
      final seen = <String>{};
      while (peek != 101) {
        final name = key();
        if ((name == 'meta version' || name == 'pieces') && !seen.add(name)) {
          invalid();
        }
        final valueStart = position;
        skip(2);
        if (name == 'meta version') {
          v2 =
              position - valueStart == 3 &&
              bytes[valueStart] == 105 &&
              bytes[valueStart + 1] == 50 &&
              bytes[valueStart + 2] == 101;
        }
        if (name == 'pieces') pieces = true;
      }
      end = ++position;
    }
    if (start == null || end == null) invalid();
    final info = bytes.sublist(start, end);
    return Set.unmodifiable({
      if (!v2 || pieces) sha1.convert(info).toString(),
      if (v2) sha256.convert(info).toString(),
    });
  }
}
