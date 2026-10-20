/// External intents accept exactly one visible URL. The in-app add form is the
/// explicit place for bulk URLs; a shared link cannot smuggle a second request.
String? singleIncomingUrl(String value) {
  if (value.length > 16384 || RegExp(r'[\x00-\x20\x7f]').hasMatch(value)) {
    return null;
  }
  try {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.userInfo.isNotEmpty) return null;
    if (uri.scheme == 'magnet' && uri.queryParameters.containsKey('xt')) {
      return value;
    }
    if ((uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty) {
      return value;
    }
  } on FormatException {
    return null;
  }
  return null;
}

/// Validate complete bencode and an info dictionary before a document can be
/// uploaded. This prevents an exported intent from treating arbitrary private
/// bytes as a torrent based only on a caller-supplied MIME type/file extension.
bool isTorrentFile(List<int> bytes) {
  if (bytes.isEmpty || bytes.length > 16 * 1024 * 1024 || bytes.first != 100) {
    return false;
  }
  try {
    return _BencodeReader(bytes).torrent();
  } catch (_) {
    return false;
  }
}

class _BencodeReader {
  _BencodeReader(this.bytes);
  final List<int> bytes;
  int position = 0;
  int nodes = 0;
  int get peek => position < bytes.length ? bytes[position] : -1;
  Never invalid() => throw const FormatException('Invalid torrent');
  List<int> string() {
    final start = position;
    while (peek >= 48 && peek <= 57) {
      position++;
    }
    if (position == start || position - start > 9 || peek != 58) invalid();
    if (position - start > 1 && bytes[start] == 48) invalid();
    final length = int.parse(
      String.fromCharCodes(bytes.sublist(start, position)),
    );
    position++;
    if (length > bytes.length - position) invalid();
    final result = bytes.sublist(position, position + length);
    position += length;
    return result;
  }

  void value(int depth) {
    if (depth > 64 || ++nodes > 1000000) invalid();
    if (peek == 105) {
      position++;
      final start = position;
      if (peek == 45) position++;
      final digits = position;
      while (peek >= 48 && peek <= 57) {
        position++;
      }
      if (position == digits || position - start > 21 || peek != 101) invalid();
      if (bytes[digits] == 48 && (position - digits > 1 || digits != start)) {
        invalid();
      }
      position++;
    } else if (peek == 108 || peek == 100) {
      final dictionary = peek == 100;
      position++;
      while (peek != 101) {
        if (peek == -1) invalid();
        if (dictionary) string();
        value(depth + 1);
      }
      position++;
    } else {
      string();
    }
  }

  bool torrent() {
    position++;
    var info = false;
    while (peek != 101) {
      if (peek == -1) invalid();
      final key = string();
      if (key.length == 4 &&
          key[0] == 105 &&
          key[1] == 110 &&
          key[2] == 102 &&
          key[3] == 111) {
        if (info || peek != 100) invalid();
        info = true;
      }
      value(1);
    }
    position++;
    return info && position == bytes.length;
  }
}
