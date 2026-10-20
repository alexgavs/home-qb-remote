import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../l10n/l10n.dart';
import 'form_helpers.dart';

class ServerInfoScreen extends StatefulWidget {
  const ServerInfoScreen({
    super.key,
    required this.controller,
    required this.kind,
  });
  final AppController controller;
  final String kind;
  @override
  State<ServerInfoScreen> createState() => _ServerInfoScreenState();
}

class _ServerInfoScreenState extends State<ServerInfoScreen> {
  dynamic data;
  List tags = [];
  bool busy = false;
  bool failed = false;
  String severity = 'all';
  bool peers = false;
  AppController get c => widget.controller;
  @override
  void initState() {
    super.initState();
    run(load);
  }

  Future<void> run(Future<void> Function() action) async {
    setState(() {
      busy = true;
      failed = false;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) setState(() => failed = true);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> load() async {
    final response = await c.apiGet(
      switch (widget.kind) {
        'categories' => 'torrents/categories',
        'logs' => peers ? 'log/peers' : 'log/main',
        _ => 'transfer/info',
      },
      widget.kind == 'logs'
          ? {
              'normal': 'true',
              'info': 'true',
              'warning': 'true',
              'critical': 'true',
            }
          : {},
    );
    final tagData = widget.kind == 'categories'
        ? await c.apiGet('torrents/tags')
        : null;
    if (mounted) {
      setState(() {
        data = response;
        tags = tagData is List ? tagData : [];
      });
    }
  }

  Future<void> editCategory([String? name, String path = '']) async {
    final l10n = context.l10n;
    final input = await askFields(
      context,
      name == null ? l10n.message0194 : l10n.message0195,
      [
        if (name == null)
          FormFieldSpec('category', l10n.message0196, required: true),
        FormFieldSpec('savePath', l10n.message0197, value: path),
      ],
    );
    if (input == null) return;
    await c.apiPost(
      name == null ? 'torrents/createCategory' : 'torrents/editCategory',
      {...input, 'category': ?name},
    );
    await load();
  }

  Widget categories() {
    final l10n = context.l10n;
    return ListView(
      children: [
        ListTile(
          title: Text(l10n.message0198),
          trailing: IconButton(
            tooltip: l10n.message0194,
            onPressed: busy ? null : () => run(() => editCategory()),
            icon: const Icon(Icons.add),
          ),
        ),
        if (data is Map)
          for (final entry in (data as Map).entries)
            ListTile(
              title: Text('${entry.key}'),
              subtitle: Text(
                entry.value is Map ? '${entry.value['savePath'] ?? ''}' : '',
              ),
              onTap: busy
                  ? null
                  : () => run(
                      () => editCategory(
                        '${entry.key}',
                        entry.value is Map
                            ? '${entry.value['savePath'] ?? ''}'
                            : '',
                      ),
                    ),
              trailing: IconButton(
                tooltip: l10n.message0199,
                icon: const Icon(Icons.delete_outline),
                onPressed: busy
                    ? null
                    : () => run(() async {
                        if (await confirmAction(
                          context,
                          l10n.message0200,
                          l10n.message0201('${entry.key}'),
                        )) {
                          await c.apiPost('torrents/removeCategories', {
                            'categories': '${entry.key}',
                          });
                          await load();
                        }
                      }),
              ),
            ),
        ListTile(
          title: Text(l10n.message0202),
          trailing: IconButton(
            tooltip: l10n.message0203,
            icon: const Icon(Icons.add),
            onPressed: busy
                ? null
                : () => run(() async {
                    final input = await askFields(context, l10n.message0204, [
                      FormFieldSpec('tags', l10n.message0205, required: true),
                    ]);
                    if (input != null) {
                      await c.apiPost('torrents/createTags', input);
                      await load();
                    }
                  }),
          ),
        ),
        for (final tag in tags)
          ListTile(
            title: Text('$tag'),
            trailing: IconButton(
              tooltip: l10n.message0206,
              icon: const Icon(Icons.delete_outline),
              onPressed: busy
                  ? null
                  : () => run(() async {
                      if (await confirmAction(
                        context,
                        l10n.message0207,
                        l10n.message0208('$tag'),
                      )) {
                        await c.apiPost('torrents/deleteTags', {
                          'tags': '$tag',
                        });
                        await load();
                      }
                    }),
            ),
          ),
      ],
    );
  }

  String level(dynamic raw) {
    final l10n = context.l10n;
    return switch (raw) {
      1 => l10n.message0209,
      2 => l10n.message0210,
      4 => l10n.message0211,
      8 => l10n.message0212,
      _ => l10n.message0213,
    };
  }

  /// Date and time via the active locale's Material wrappers (not raw toString).
  String _formatLogTime(DateTime when) {
    final strings = MaterialLocalizations.of(context);
    return '${strings.formatMediumDate(when)} '
        '${strings.formatTimeOfDay(TimeOfDay.fromDateTime(when))}';
  }

  Widget logs() {
    final l10n = context.l10n;
    return Column(
      children: [
        SwitchListTile(
          title: Text(l10n.message0214),
          value: peers,
          onChanged: busy
              ? null
              : (value) {
                  setState(() => peers = value);
                  run(load);
                },
        ),
        if (!peers)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonFormField<String>(
              initialValue: severity,
              decoration: InputDecoration(labelText: l10n.message0215),
              items: [
                DropdownMenuItem(value: 'all', child: Text(l10n.message0216)),
                DropdownMenuItem(value: '4', child: Text(l10n.message0217)),
                DropdownMenuItem(value: '8', child: Text(l10n.message0218)),
              ],
              onChanged: (value) => setState(() => severity = value ?? 'all'),
            ),
          ),
        Expanded(
          child: data is! List
              ? const SizedBox()
              : ListView(
                  children: [
                    for (final row
                        in (data as List).whereType<Map>().toList().reversed)
                      if (peers ||
                          severity == 'all' ||
                          '${row['type']}' == severity)
                        ListTile(
                          leading: Icon(
                            peers
                                ? Icons.people_outline
                                : row['type'] == 8
                                ? Icons.error_outline
                                : row['type'] == 4
                                ? Icons.warning_amber
                                : Icons.info_outline,
                          ),
                          title: SelectableText(
                            '${peers ? row['ip'] : row['message']}',
                          ),
                          subtitle: Text(
                            '${peers ? (row['blocked'] == true ? l10n.message0219 : l10n.message0220) : level(row['type'])} · ${_formatLogTime(DateTime.fromMillisecondsSinceEpoch(((row['timestamp'] as num?)?.toInt() ?? 0) * 1000).toLocal())}',
                          ),
                        ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget dashboard() {
    final l10n = context.l10n;
    final info = data is Map ? data as Map : {};
    final labels = <String, String>{
      'dl_info_speed': l10n.message0221,
      'up_info_speed': l10n.message0222,
      'dl_info_data': l10n.message0223,
      'up_info_data': l10n.message0224,
      'dl_rate_limit': l10n.message0225,
      'up_rate_limit': l10n.message0226,
      'dht_nodes': l10n.message0227,
      'connection_status': l10n.message0228,
    };
    return ListView(
      children: [
        for (final entry in labels.entries)
          if (info.containsKey(entry.key))
            ListTile(
              title: Text(entry.value),
              trailing: Text(
                entry.key.contains('speed') || entry.key.contains('limit')
                    ? l10n.message0229(
                        humanBytes(
                          (info[entry.key] as num?)?.toInt() ?? 0,
                          l10n: l10n,
                        ),
                      )
                    : entry.key.endsWith('_data')
                    ? humanBytes(
                        (info[entry.key] as num?)?.toInt() ?? 0,
                        l10n: l10n,
                      )
                    : entry.key == 'connection_status'
                    ? switch (info[entry.key]) {
                        'connected' => l10n.message0230,
                        'firewalled' => l10n.message0231,
                        _ => l10n.message0232,
                      }
                    : '${info[entry.key]}',
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (widget.kind) {
          'categories' => l10n.message0233,
          'logs' => l10n.message0058,
          _ => l10n.message0234,
        }),
        actions: [
          IconButton(
            tooltip: l10n.message0099,
            onPressed: busy ? null : () => run(load),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          if (busy) const LinearProgressIndicator(),
          if (failed)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.message0042),
            ),
          Expanded(
            child: switch (widget.kind) {
              'categories' => categories(),
              'logs' => logs(),
              _ => dashboard(),
            },
          ),
        ],
      ),
    );
  }
}
