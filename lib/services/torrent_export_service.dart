import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Raised when an export cannot be performed. The message is safe to show to
/// the user: it never contains local paths, native error text or file names.
class TorrentExportException implements Exception {
  const TorrentExportException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Asks the user for a destination path. Returns `null` when cancelled.
typedef SaveLocationPicker = Future<String?> Function(String suggestedName);

/// Writes [bytes] to [path]; [name] is the sanitized `.torrent` file name.
typedef SaveFileWriter = Future<void> Function(
  String path,
  String name,
  Uint8List bytes,
);

/// Cross-platform export of a `.torrent` payload chosen by the user.
///
/// * Android: existing `org.homeqb/imports` → `exportTorrent` bridge
///   (system "create document" dialog). Native returns `true` when the file
///   was written, `false` when the dialog was dismissed.
/// * iOS: `org.homeqb/export` → `exportTorrent` bridge in `AppDelegate.swift`
///   (app-private temporary file shared through `UIActivityViewController`).
///   Native returns `true` only when an activity reports completion.
/// * Windows / macOS / Linux: `file_selector` save dialog, then
///   `XFile.saveTo`. A dismissed dialog yields `false`.
///
/// [export] returns `true` only for a completed save; cancellation is always
/// `false`; failures throw [TorrentExportException]. Only one export per
/// instance may be active at a time — the UI should share a single instance.
class TorrentExportService {
  TorrentExportService({
    TargetPlatform? platform,
    SaveLocationPicker? pickSaveLocation,
    SaveFileWriter? writeFile,
  }) : _platformOverride = platform,
       _pickSaveLocation = pickSaveLocation ?? _defaultPickSaveLocation,
       _writeFile = writeFile ?? _defaultWriteFile;

  /// Upper bound shared with both native bridges.
  static const int maxBytes = 16 * 1024 * 1024;

  /// Total length (base name + extension) of a generated file name.
  static const int maxFileNameLength = 140;
  static const String fileExtension = '.torrent';
  static const String defaultBaseName = 'export';

  static const MethodChannel _androidChannel = MethodChannel(
    'org.homeqb/imports',
  );
  static const MethodChannel _iosChannel = MethodChannel('org.homeqb/export');
  static const String _method = 'exportTorrent';

  static final RegExp _separators = RegExp(r'[/\\]');
  static final RegExp _unsafe = RegExp(r'[<>:"/\\|?*\x00-\x1f\x7f]');
  static final RegExp _edges = RegExp(r'^[.\s]+|[.\s]+$');
  static final RegExp _reserved = RegExp(
    r'^(con|prn|aux|nul|com[0-9]|lpt[0-9])$',
    caseSensitive: false,
  );

  final TargetPlatform? _platformOverride;
  final SaveLocationPicker _pickSaveLocation;
  final SaveFileWriter _writeFile;
  bool _busy = false;

  /// `true` while a dialog or share sheet from this instance is still open.
  bool get busy => _busy;

  TargetPlatform get _platform => _platformOverride ?? defaultTargetPlatform;

  /// Produces a safe `.torrent` base name from an arbitrary torrent title:
  /// directory components are dropped, unsafe characters replaced, Windows
  /// reserved device names escaped, length bounded and the extension forced.
  static String safeFileName(String name) {
    var base = name;
    final separator = base.lastIndexOf(_separators);
    if (separator >= 0) base = base.substring(separator + 1);
    base = base.replaceAll(_unsafe, '_').trim();
    while (base.toLowerCase().endsWith(fileExtension)) {
      base = base.substring(0, base.length - fileExtension.length);
    }
    base = base.replaceAll(_edges, '');
    if (base.isEmpty) base = defaultBaseName;
    if (_reserved.hasMatch(base)) base = '_$base';
    final maxBase = maxFileNameLength - fileExtension.length;
    if (base.length > maxBase) {
      base = base.substring(0, maxBase);
      final last = base.codeUnitAt(base.length - 1);
      if (last >= 0xD800 && last <= 0xDBFF) {
        base = base.substring(0, base.length - 1); // Never split a surrogate.
      }
      base = base.replaceAll(_edges, '');
      if (base.isEmpty) base = defaultBaseName;
    }
    return '$base$fileExtension';
  }

  /// Exports [bytes] under a sanitized version of [name].
  ///
  /// Returns `true` when the user completed the save/share, `false` when the
  /// user cancelled. Throws [TorrentExportException] for invalid input,
  /// concurrent use or platform failures.
  Future<bool> export(String name, List<int> bytes) async {
    final data = _validatedBytes(bytes);
    final fileName = safeFileName(name);
    if (_busy) {
      throw const TorrentExportException(
        'Another export is still in progress.',
      );
    }
    _busy = true;
    try {
      switch (_platform) {
        case TargetPlatform.android:
          return await _invokeNative(_androidChannel, fileName, data);
        case TargetPlatform.iOS:
          return await _invokeNative(_iosChannel, fileName, data);
        case TargetPlatform.windows:
        case TargetPlatform.macOS:
        case TargetPlatform.linux:
          return await _saveWithDialog(fileName, data);
        case TargetPlatform.fuchsia:
          throw const TorrentExportException(
            'Export is not supported on this platform.',
          );
      }
    } finally {
      _busy = false;
    }
  }

  static Uint8List _validatedBytes(List<int> bytes) {
    if (bytes.isEmpty) {
      throw const TorrentExportException('There is no torrent data to export.');
    }
    if (bytes.length > maxBytes) {
      throw const TorrentExportException(
        'The torrent file is larger than 16 MiB and cannot be exported.',
      );
    }
    if (bytes is Uint8List) return bytes;
    for (final value in bytes) {
      if (value < 0 || value > 255) {
        throw const TorrentExportException(
          'The torrent data is not a valid byte sequence.',
        );
      }
    }
    return Uint8List.fromList(bytes);
  }

  static Future<bool> _invokeNative(
    MethodChannel channel,
    String fileName,
    Uint8List data,
  ) async {
    final bool? saved;
    try {
      saved = await channel.invokeMethod<bool>(_method, <String, Object>{
        'name': fileName,
        'bytes': data,
      });
    } on MissingPluginException {
      throw const TorrentExportException(
        'Export is not available in this build of the app.',
      );
    } on PlatformException catch (error) {
      // Native messages may mention destinations or system details; only the
      // code is mapped to a generic, user-safe explanation.
      throw TorrentExportException(_describe(error.code));
    }
    // Anything but an explicit `true` (cancelled, null, malformed) is "not saved".
    return saved == true;
  }

  static String _describe(String code) => switch (code) {
    'export_busy' => 'Another export is still in progress.',
    'invalid_export' => 'The torrent data was rejected by the system.',
    _ => 'The torrent file could not be saved.',
  };

  Future<bool> _saveWithDialog(String fileName, Uint8List data) async {
    final String? path;
    try {
      path = await _pickSaveLocation(fileName);
    } catch (_) {
      throw const TorrentExportException(
        'The save dialog could not be opened.',
      );
    }
    if (path == null || path.isEmpty) return false;
    try {
      await _writeFile(path, fileName, data);
    } catch (_) {
      throw const TorrentExportException(
        'The torrent file could not be written to the chosen location.',
      );
    }
    return true;
  }

  static Future<String?> _defaultPickSaveLocation(String suggestedName) async {
    final location = await getSaveLocation(
      suggestedName: suggestedName,
      acceptedTypeGroups: const [
        XTypeGroup(label: 'Torrent', extensions: ['torrent']),
      ],
    );
    return location?.path;
  }

  static Future<void> _defaultWriteFile(
    String path,
    String name,
    Uint8List bytes,
  ) => XFile.fromData(bytes, name: name).saveTo(path);
}
