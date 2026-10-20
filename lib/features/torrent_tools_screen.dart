import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../core/models.dart';
import '../core/qb_client.dart';
import '../l10n/error_messages.dart';
import '../l10n/l10n.dart';
import '../services/torrent_export_service.dart';
import 'form_helpers.dart';

class TorrentToolsScreen extends StatefulWidget {
  const TorrentToolsScreen({
    super.key,
    required this.controller,
    required this.torrent,
  });
  final AppController controller;
  final Torrent torrent;
  @override
  State<TorrentToolsScreen> createState() => _TorrentToolsScreenState();
}

class _TorrentToolsScreenState extends State<TorrentToolsScreen> {
  static final _exportService = TorrentExportService();
  bool busy = false;
  LocalizedText? message;
  AppController get c => widget.controller;
  String get hash => widget.torrent.hash;
  Future<void> run(Future<void> Function() action) async {
    setState(() {
      busy = true;
      message = null;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) {
        setState(() => message = backendFailure(c.error, (l) => l.message0305));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> post(String method, Map<String, String> fields) async {
    await c.apiPost('torrents/$method', fields);
    if (mounted) setState(() => message = (l) => l.message0306);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.message0307)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                widget.torrent.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              if (busy) const LinearProgressIndicator(),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(message!(l10n)),
                ),
              _section(l10n.message0308, [
                _item(
                  Icons.edit_outlined,
                  l10n.message0309,
                  () => _editOne(
                    l10n.message0310,
                    'rename',
                    'name',
                    l10n.message0138,
                    widget.torrent.name,
                    singleHash: true,
                  ),
                ),
                _item(
                  Icons.drive_file_move_outlined,
                  l10n.message0311,
                  () => _editOne(
                    l10n.message0312,
                    'setLocation',
                    'location',
                    l10n.message0313,
                    '',
                  ),
                  subtitle: l10n.message0314,
                ),
                _item(Icons.category_outlined, l10n.message0148, _category),
                _item(
                  Icons.sell_outlined,
                  l10n.message0315,
                  () => _editOne(
                    l10n.message0315,
                    'addTags',
                    'tags',
                    l10n.message0316,
                    '',
                  ),
                ),
                _item(
                  Icons.label_off_outlined,
                  l10n.message0317,
                  () => _editOne(
                    l10n.message0317,
                    'removeTags',
                    'tags',
                    l10n.message0316,
                    '',
                  ),
                ),
              ]),
              _section(l10n.message0318, [
                _item(Icons.speed, l10n.message0319, _speedLimits),
                _item(Icons.timelapse, l10n.message0320, _shareLimits),
                _item(
                  Icons.play_circle_outline,
                  l10n.message0321,
                  () => _boolean('setForceStart', l10n.message0321),
                ),
                _item(
                  Icons.public,
                  l10n.message0322,
                  () => _boolean('setSuperSeeding', l10n.message0322),
                ),
                _item(
                  Icons.linear_scale,
                  l10n.message0323,
                  () => post('toggleSequentialDownload', {'hashes': hash}),
                ),
                _item(
                  Icons.first_page,
                  l10n.message0324,
                  () => post('toggleFirstLastPiecePrio', {'hashes': hash}),
                ),
                _item(Icons.verified_outlined, l10n.message0325, () async {
                  if (await confirmAction(
                    context,
                    l10n.message0326,
                    l10n.message0327,
                  )) {
                    await post('recheck', {'hashes': hash});
                  }
                }),
                _item(
                  Icons.sync,
                  l10n.message0328,
                  () => post('reannounce', {'hashes': hash}),
                ),
              ]),
              _section(l10n.message0329, [
                for (final entry in {
                  'topPrio': l10n.message0330,
                  'increasePrio': l10n.message0331,
                  'decreasePrio': l10n.message0332,
                  'bottomPrio': l10n.message0333,
                }.entries)
                  _item(
                    Icons.swap_vert,
                    entry.value,
                    () => post(entry.key, {'hashes': hash}),
                  ),
              ]),
              _section(l10n.message0334, [
                _item(Icons.download_outlined, l10n.message0335, _export),
                _item(Icons.folder_open_outlined, l10n.message0336, _files),
                _item(Icons.folder_copy_outlined, l10n.message0337, () async {
                  final data = await askFields(context, l10n.message0337, [
                    FormFieldSpec('oldPath', l10n.message0338, required: true),
                    FormFieldSpec('newPath', l10n.message0339, required: true),
                  ]);
                  if (data != null) {
                    await post('renameFolder', {'hash': hash, ...data});
                  }
                }),
                _item(Icons.hub_outlined, l10n.message0340, _trackers),
                _item(Icons.people_outline, l10n.message0341, _peers),
                _item(Icons.http_outlined, l10n.message0342, _webSeeds),
                _item(Icons.grid_view, l10n.message0343, _pieces),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) => Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 8, bottom: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Card(child: Column(children: children)),
      ],
    ),
  );
  Widget _item(
    IconData icon,
    String title,
    Future<void> Function() action, {
    String? subtitle,
  }) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle),
    trailing: const Icon(Icons.chevron_right),
    onTap: busy ? null : () => run(action),
  );

  Future<void> _editOne(
    String title,
    String method,
    String key,
    String label,
    String value, {
    bool singleHash = false,
  }) async {
    final data = await askFields(context, title, [
      FormFieldSpec(
        key,
        label,
        value: value,
        required: !['category'].contains(key),
      ),
    ]);
    if (data != null) {
      await post(method, {singleHash ? 'hash' : 'hashes': hash, ...data});
    }
  }

  Future<void> _category() async {
    final response = await c.apiGet('torrents/categories');
    if (!mounted) return;
    final categories = response is Map
        ? response.keys.map((e) => '$e').toList()
        : <String>[];
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(context.l10n.message0148),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ''),
            child: Text(context.l10n.message0344),
          ),
          for (final category in categories)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, category),
              child: Text(category),
            ),
        ],
      ),
    );
    if (selected != null) {
      await post('setCategory', {'hashes': hash, 'category': selected});
    }
  }

  Future<void> _speedLimits() async {
    final down = await c.apiGet('torrents/downloadLimit', {'hashes': hash});
    final up = await c.apiGet('torrents/uploadLimit', {'hashes': hash});
    if (!mounted) return;
    final l10n = context.l10n;
    int limit(dynamic data) => data is Map && data[hash] is num
        ? (data[hash] as num).toInt() ~/ 1024
        : 0;
    final input = await askFields(context, l10n.message0319, [
      FormFieldSpec(
        'download',
        l10n.message0345,
        value: '${limit(down)}',
        numeric: true,
        validate: (s) => nonnegativeInteger(s, l10n: l10n),
      ),
      FormFieldSpec(
        'upload',
        l10n.message0346,
        value: '${limit(up)}',
        numeric: true,
        validate: (s) => nonnegativeInteger(s, l10n: l10n),
      ),
    ], description: l10n.message0347);
    if (input == null) return;
    await post('setDownloadLimit', {
      'hashes': hash,
      'limit': '${int.parse(input['download']!) * 1024}',
    });
    await post('setUploadLimit', {
      'hashes': hash,
      'limit': '${int.parse(input['upload']!) * 1024}',
    });
  }

  Future<void> _shareLimits() async {
    final l10n = context.l10n;
    final data = await askFields(context, l10n.message0320, [
      FormFieldSpec(
        'ratioLimit',
        l10n.message0348,
        value: '-2',
        numeric: true,
        validate: (s) => num.tryParse(s) == null ? l10n.message0349 : null,
      ),
      FormFieldSpec(
        'seedingTimeLimit',
        l10n.message0350,
        value: '-2',
        numeric: true,
        validate: (s) => int.tryParse(s) == null ? l10n.message0351 : null,
      ),
      FormFieldSpec(
        'inactiveSeedingTimeLimit',
        l10n.message0352,
        value: '-2',
        numeric: true,
        validate: (s) => int.tryParse(s) == null ? l10n.message0351 : null,
      ),
    ], description: l10n.message0353);
    if (data != null) await post('setShareLimits', {'hashes': hash, ...data});
  }

  Future<void> _boolean(String method, String title) async {
    final selected = await showDialog<bool>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.message0354),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.message0355),
          ),
        ],
      ),
    );
    if (selected != null) {
      await post(method, {'hashes': hash, 'value': '$selected'});
    }
  }

  Future<void> _view(String title, Widget child, {List<Widget>? actions}) =>
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => Scaffold(
            appBar: AppBar(title: Text(title), actions: actions),
            body: child,
          ),
        ),
      );
  Future<void> _files() async {
    final response = await c.apiGet('torrents/files', {'hash': hash});
    final files = response is List
        ? response.whereType<Map>().toList()
        : <Map>[];
    if (!mounted) return;
    await _view(
      context.l10n.message0356,
      ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return ListTile(
            title: Text('${file['name']}'),
            subtitle: Text(
              context.l10n.message0357(
                humanBytes(
                  file['size'] is num ? file['size'] as num : 0,
                  l10n: context.l10n,
                ),
                '${file['priority'] ?? 1}',
              ),
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (action) async {
                try {
                  if (action == 'rename') {
                    final input = await askFields(
                      context,
                      context.l10n.message0358,
                      [
                        FormFieldSpec(
                          'newPath',
                          context.l10n.message0339,
                          value: '${file['name']}',
                          required: true,
                        ),
                      ],
                    );
                    if (input != null) {
                      await post('renameFile', {
                        'hash': hash,
                        'oldPath': '${file['name']}',
                        ...input,
                      });
                    }
                  } else {
                    await post('filePrio', {
                      'hash': hash,
                      'id': '${file['index'] ?? index}',
                      'priority': action,
                    });
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.message0359)),
                    );
                  }
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.l10n.message0360)),
                    );
                  }
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'rename',
                  child: Text(context.l10n.message0120),
                ),
                PopupMenuItem(
                  value: '0',
                  child: Text(context.l10n.message0361),
                ),
                PopupMenuItem(
                  value: '1',
                  child: Text(context.l10n.message0362),
                ),
                PopupMenuItem(
                  value: '6',
                  child: Text(context.l10n.message0363),
                ),
                PopupMenuItem(
                  value: '7',
                  child: Text(context.l10n.message0364),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _trackers() async {
    final response = await c.apiGet('torrents/trackers', {'hash': hash});
    final trackers = response is List
        ? response.whereType<Map>().toList()
        : <Map>[];
    if (!mounted) return;
    await _view(
      context.l10n.message0340,
      ListView.builder(
        itemCount: trackers.length,
        itemBuilder: (context, index) {
          final tracker = trackers[index];
          final url = '${tracker['url'] ?? ''}';
          return ListTile(
            title: Text(url),
            subtitle: Text('${tracker['msg'] ?? ''}'),
            trailing: url.startsWith('**')
                ? null
                : PopupMenuButton<String>(
                    onSelected: (action) async {
                      try {
                        if (action == 'edit') {
                          final input = await askFields(
                            context,
                            context.l10n.message0365,
                            [
                              FormFieldSpec(
                                'newUrl',
                                context.l10n.message0366,
                                value: url,
                                required: true,
                              ),
                            ],
                          );
                          if (input != null) {
                            await post('editTracker', {
                              'hash': hash,
                              'origUrl': url,
                              ...input,
                            });
                          }
                        } else if (await confirmAction(
                          context,
                          context.l10n.message0367,
                          url,
                        )) {
                          await post('removeTrackers', {
                            'hash': hash,
                            'urls': url,
                          });
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.message0368)),
                          );
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(context.l10n.message0119),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        child: Text(context.l10n.message0369),
                      ),
                    ],
                  ),
          );
        },
      ),
      actions: [
        IconButton(
          tooltip: context.l10n.message0370,
          icon: const Icon(Icons.add),
          onPressed: () async {
            try {
              final input = await askFields(context, context.l10n.message0370, [
                FormFieldSpec(
                  'urls',
                  context.l10n.message0371,
                  multiline: true,
                  required: true,
                ),
              ]);
              if (input != null) {
                await post('addTrackers', {'hash': hash, ...input});
              }
            } catch (_) {
              if (mounted) {
                setState(
                  () => message = backendFailure(c.error, (l) => l.message0372),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Future<void> _peers() async {
    final response = await c.apiGet('sync/torrentPeers', {
      'hash': hash,
      'rid': '0',
    });
    final peers = response is Map && response['peers'] is Map
        ? (response['peers'] as Map).values.whereType<Map>().toList()
        : <Map>[];
    if (!mounted) return;
    await _view(
      context.l10n.message0341,
      ListView(
        children: [
          if (peers.isEmpty) ListTile(title: Text(context.l10n.message0373)),
          for (final peer in peers)
            ListTile(
              title: Text('${peer['ip']}:${peer['port']}'),
              subtitle: Text(
                context.l10n.message0374(
                  '${peer['client'] ?? ''}',
                  humanBytes(
                    peer['dl_speed'] is num ? peer['dl_speed'] as num : 0,
                    l10n: context.l10n,
                  ),
                ),
              ),
            ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: context.l10n.message0375,
          icon: const Icon(Icons.person_add_outlined),
          onPressed: () async {
            try {
              final input = await askFields(context, context.l10n.message0375, [
                FormFieldSpec(
                  'peers',
                  context.l10n.message0376,
                  required: true,
                ),
              ]);
              if (input != null) {
                await post('addPeers', {'hashes': hash, ...input});
              }
            } catch (_) {
              if (mounted) {
                setState(
                  () => message = backendFailure(c.error, (l) => l.message0377),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Future<void> _webSeeds() => Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (_) => WebSeedsScreen(controller: c, hash: hash),
    ),
  );

  Future<void> _pieces() async {
    final response = await c.apiGet('torrents/pieceStates', {'hash': hash});
    final states = response is List ? response : <dynamic>[];
    if (!mounted) return;
    await _view(
      context.l10n.message0378(states.length),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Text(context.l10n.message0379),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 20,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
              ),
              itemCount: states.length.clamp(0, 4096),
              itemBuilder: (itemContext, i) => Tooltip(
                message: itemContext.l10n.message0380('$i'),
                child: ColoredBox(
                  color: switch (states[i]) {
                    2 => Colors.teal,
                    1 => Colors.blue,
                    _ => Colors.blueGrey.shade800,
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _export() async {
    final data = await c.exportTorrent(hash);
    if (!mounted) return;
    final saved = await _exportService.export(widget.torrent.name, data);
    if (mounted) {
      setState(() => message = (l) => saved ? l.message0381 : l.message0382);
    }
  }
}

/// Splits multi-line user input into trimmed, non-empty URLs.
List<String> splitWebSeedUrls(String text) => text
    .split('\n')
    .map((line) => line.trim())
    .where((line) => line.isNotEmpty)
    .toList();

/// Validates a single HTTP source URL; returns a localized error or null.
/// Without [l10n] the English catalog is used (pure, non-UI callers).
String? validateWebSeedUrl(String url, {AppLocalizations? l10n}) {
  final text = l10n ?? englishL10n();
  if (url.isEmpty) return text.message0383;
  if (RegExp(r'[\s\x00-\x1f\x7f|]').hasMatch(url)) {
    return text.message0384;
  }
  final uri = Uri.tryParse(url);
  if (uri == null ||
      !{'http', 'https'}.contains(uri.scheme) ||
      uri.host.isEmpty) {
    return text.message0385;
  }
  return null;
}

/// Validates one URL per line; returns the first error with its line.
/// Without [l10n] the English catalog is used (pure, non-UI callers).
String? validateWebSeedUrls(String text, {AppLocalizations? l10n}) {
  final strings = l10n ?? englishL10n();
  final urls = splitWebSeedUrls(text);
  if (urls.isEmpty) return strings.message0386;
  for (final url in urls) {
    final error = validateWebSeedUrl(url, l10n: strings);
    if (error != null) return '$error: $url';
  }
  return null;
}

/// Web seed editing was added in qBittorrent 5.2. Returns null when the
/// version is unknown or unparsable, so callers only warn when sure.
bool? webSeedEditingSupported(String? version) {
  final match = RegExp(r'(\d+)\.(\d+)').firstMatch(version ?? '');
  if (match == null) return null;
  final major = int.parse(match[1]!);
  final minor = int.parse(match[2]!);
  return major > 5 || (major == 5 && minor >= 2);
}

String _webSeedsUnsupportedText(AppLocalizations l10n) =>
    '${l10n.message0387}${l10n.message0388}';

/// HTTP sources (web seeds) of one torrent: list, add, edit and remove.
/// URLs are only ever sent to the configured qBittorrent server.
class WebSeedsScreen extends StatefulWidget {
  const WebSeedsScreen({
    super.key,
    required this.controller,
    required this.hash,
  });
  final AppController controller;
  final String hash;
  @override
  State<WebSeedsScreen> createState() => _WebSeedsScreenState();
}

class _WebSeedsScreenState extends State<WebSeedsScreen> {
  List<String>? urls;
  bool loading = true;
  bool busy = false;
  LocalizedText? loadError;
  LocalizedText? message;
  AppController get c => widget.controller;
  String get hash => widget.hash;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!loading || loadError != null) {
      setState(() {
        loading = true;
        loadError = null;
      });
    }
    try {
      final response = await c.apiGet('torrents/webseeds', {'hash': hash});
      if (!mounted) return;
      setState(() {
        urls = response is List
            ? response
                  .map((v) => v is Map ? '${v['url'] ?? ''}' : '$v')
                  .where((url) => url.isNotEmpty)
                  .toList()
            : <String>[];
      });
    } catch (_) {
      if (mounted) {
        setState(
          () => loadError = backendFailure(c.error, (l) => l.message0389),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _mutate(
    String endpoint,
    Map<String, String> fields,
    LocalizedText failure,
  ) async {
    setState(() {
      busy = true;
      message = null;
    });
    try {
      await c.apiPost(endpoint, {'hash': hash, ...fields});
      if (!mounted) return;
      setState(() => message = (l) => l.message0306);
      await _load();
    } on QbException catch (e) {
      if (!mounted) return;
      final unsupported = e.statusCode == 404 || e.statusCode == 405;
      setState(
        () => message = unsupported
            ? _webSeedsUnsupportedText
            : backendFailure(c.error, failure),
      );
    } catch (_) {
      if (mounted) {
        setState(() => message = backendFailure(c.error, failure));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _add() async {
    final l10n = context.l10n;
    final input = await askFields(context, l10n.message0390, [
      FormFieldSpec(
        'urls',
        l10n.message0371,
        multiline: true,
        required: true,
        validate: (s) => validateWebSeedUrls(s, l10n: l10n),
      ),
    ], description: l10n.message0391);
    if (input == null || !mounted) return;
    await _mutate('torrents/addWebSeeds', {
      'urls': splitWebSeedUrls(input['urls']!).join('|'),
    }, (l) => l.message0392);
  }

  Future<void> _edit(String url) async {
    final l10n = context.l10n;
    final input = await askFields(context, l10n.message0393, [
      FormFieldSpec(
        'newUrl',
        l10n.message0366,
        value: url,
        required: true,
        validate: (s) => validateWebSeedUrl(s, l10n: l10n),
      ),
    ]);
    if (input == null || !mounted) return;
    final newUrl = input['newUrl']!;
    if (newUrl == url) {
      setState(() => message = (l) => l.message0394);
      return;
    }
    await _mutate('torrents/editWebSeed', {
      'origUrl': url,
      'newUrl': newUrl,
    }, (l) => l.message0395);
  }

  Future<void> _remove(String url) async {
    final l10n = context.l10n;
    final confirmed = await confirmAction(context, l10n.message0396, url);
    if (!confirmed || !mounted) return;
    await _mutate('torrents/removeWebSeeds', {
      'urls': url,
    }, (l) => l.message0397);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locked = loading || busy;
    final items = urls;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.message0342),
        actions: [
          IconButton(
            tooltip: l10n.message0099,
            icon: const Icon(Icons.refresh),
            onPressed: locked ? null : _load,
          ),
          IconButton(
            tooltip: l10n.message0398,
            icon: const Icon(Icons.add),
            onPressed: locked ? null : _add,
          ),
        ],
      ),
      body: Column(
        children: [
          if (locked && items != null) const LinearProgressIndicator(),
          if (webSeedEditingSupported(c.version) == false)
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text('${l10n.message0399}${l10n.message0400}'),
            ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(message!(l10n)),
            ),
          Expanded(
            child: loadError != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            loadError!(l10n),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        FilledButton(
                          onPressed: locked ? null : _load,
                          child: Text(l10n.message0401),
                        ),
                      ],
                    ),
                  )
                : items == null
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      if (items.isEmpty)
                        ListTile(title: Text(l10n.message0402)),
                      for (final url in items)
                        ListTile(
                          leading: const Icon(Icons.http),
                          title: SelectableText(url),
                          trailing: PopupMenuButton<String>(
                            enabled: !locked,
                            onSelected: (action) =>
                                action == 'edit' ? _edit(url) : _remove(url),
                            itemBuilder: (_) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text(l10n.message0119),
                              ),
                              PopupMenuItem(
                                value: 'remove',
                                child: Text(l10n.message0369),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
