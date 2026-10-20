import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../core/import_validation.dart';
import 'torrent_export_service.dart';

/// Raised when an incoming document cannot be read. The message is safe to
/// show to the user: it never contains the URI, local paths, file names or
/// native error text.
class IncomingDocumentException implements Exception {
  const IncomingDocumentException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Reads a `.torrent` document that another app handed to this one.
///
/// iOS delivers an opened document as a `file:` URI through `app_links`
/// (either a copy in the app's own `Documents/Inbox` or a security-scoped
/// provider document). The URI is passed to the native bridge
/// `org.homeqb/export` → `importTorrent` (`AppDelegate.swift`), which alone
/// decides whether the location may be read; Dart never opens files itself
/// and never fetches anything from the network.
///
/// [read] returns `{'name': String, 'bytes': Uint8List}` — the exact shape
/// the import queue in `main.dart` expects — only after the bytes have been
/// verified to be complete bencode with an `info` dictionary. Everything else
/// throws [IncomingDocumentException]. Reading has no side effects: adding the
/// torrent to a server stays behind the explicit user confirmation.
class IncomingDocumentService {
  IncomingDocumentService({TargetPlatform? platform})
    : _platformOverride = platform;

  /// Upper bound shared with the native bridge and [isTorrentFile].
  static const int maxBytes = 16 * 1024 * 1024;

  /// Longest URI forwarded to native; container paths are far shorter.
  static const int maxUriLength = 8192;
  static const String fileExtension = '.torrent';

  static const MethodChannel _iosChannel = MethodChannel('org.homeqb/export');
  static const String _method = 'importTorrent';

  static final RegExp _control = RegExp(r'[\x00-\x1f\x7f]');

  final TargetPlatform? _platformOverride;

  TargetPlatform get _platform => _platformOverride ?? defaultTargetPlatform;

  /// `true` when [uri] names a local `.torrent` document this service would
  /// forward to native: `file` scheme, no authority (host, user info, port),
  /// no query or fragment, no `.`/`..` segments, no encoded separators or
  /// control characters, and a non-empty base name ending in `.torrent`.
  static bool isImportableDocumentUri(Uri uri) {
    final raw = uri.toString();
    if (raw.isEmpty || raw.length > maxUriLength || _control.hasMatch(raw)) {
      return false;
    }
    if (uri.scheme.toLowerCase() != 'file') return false;
    if (uri.host.isNotEmpty || uri.userInfo.isNotEmpty || uri.hasPort) {
      return false;
    }
    if (uri.hasQuery || uri.hasFragment) return false;
    if (!uri.hasAbsolutePath) return false;
    final segments = uri.pathSegments;
    if (segments.isEmpty) return false;
    for (final segment in segments) {
      if (segment == '.' || segment == '..') return false;
      if (segment.contains('/') || segment.contains('\\')) return false;
      if (_control.hasMatch(segment)) return false;
    }
    final name = segments.last;
    if (name.length <= fileExtension.length) return false;
    return name.toLowerCase().endsWith(fileExtension);
  }

  /// Reads the document behind [uri] and returns `{'name', 'bytes'}`.
  ///
  /// Throws [IncomingDocumentException] for a URI that is not a local
  /// `.torrent` document (native is not contacted), on unsupported platforms,
  /// when native refuses or fails, when the native payload is malformed, and
  /// when the bytes are empty, oversized or not a torrent.
  Future<Map<String, dynamic>> read(Uri uri) async {
    if (!isImportableDocumentUri(uri)) {
      throw const IncomingDocumentException(
        'Only a local .torrent document can be imported.',
      );
    }
    if (_platform != TargetPlatform.iOS) {
      throw const IncomingDocumentException(
        'Document import is not supported on this platform.',
      );
    }
    final payload = await _invokeNative(uri);
    return _validatedPayload(payload);
  }

  static Future<Object?> _invokeNative(Uri uri) async {
    try {
      return await _iosChannel.invokeMethod<Object?>(_method, <String, Object>{
        'uri': uri.toString(),
      });
    } on MissingPluginException {
      throw const IncomingDocumentException(
        'Document import is not available in this build of the app.',
      );
    } on PlatformException catch (error) {
      // Native text could mention locations or system details; only the code
      // is mapped to a generic, user-safe explanation.
      throw IncomingDocumentException(_describe(error.code));
    }
  }

  static String _describe(String code) => switch (code) {
    'invalid_import' => 'The document was rejected by the system.',
    _ => 'The torrent document could not be read.',
  };

  static Map<String, dynamic> _validatedPayload(Object? payload) {
    const malformed = IncomingDocumentException(
      'The torrent document could not be read.',
    );
    if (payload is! Map) throw malformed;
    final name = payload['name'];
    final bytes = payload['bytes'];
    if (name is! String || bytes is! Uint8List) throw malformed;
    if (bytes.isEmpty) {
      throw const IncomingDocumentException('The torrent document is empty.');
    }
    if (bytes.length > maxBytes) {
      throw const IncomingDocumentException(
        'The torrent document is larger than 16 MiB and cannot be imported.',
      );
    }
    if (!isTorrentFile(bytes)) {
      throw const IncomingDocumentException(
        'The document is not a valid .torrent file.',
      );
    }
    return <String, dynamic>{
      'name': TorrentExportService.safeFileName(name),
      'bytes': bytes,
    };
  }
}
