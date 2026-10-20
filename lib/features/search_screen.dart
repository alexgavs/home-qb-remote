import 'dart:async';

import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../l10n/error_messages.dart';
import '../l10n/l10n.dart';
import 'form_helpers.dart';

class TypedSearchScreen extends StatefulWidget {
  const TypedSearchScreen({super.key, required this.controller});
  final AppController controller;
  @override
  State<TypedSearchScreen> createState() => _TypedSearchScreenState();
}

class _TypedSearchScreenState extends State<TypedSearchScreen> {
  final query = TextEditingController();
  List<Map> results = [];
  List<Map> plugins = [];
  String plugin = 'all', category = 'all';
  LocalizedText? status;
  int? searchId;
  int generation = 0;
  bool busy = false, canceled = false;
  AppController get c => widget.controller;
  @override
  void initState() {
    super.initState();
    unawaited(loadPlugins());
  }

  Future<void> loadPlugins() async {
    try {
      final response = await c.apiGet('search/plugins');
      if (mounted) {
        setState(
          () => plugins = response is List
              ? response.whereType<Map>().toList()
              : [],
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => status = backendFailure(c.error, (l) => l.message0156));
      }
    }
  }

  @override
  void dispose() {
    generation++;
    canceled = true;
    final id = searchId;
    if (id != null) unawaited(_cleanup(id));
    query.dispose();
    super.dispose();
  }

  Future<void> _cleanup(int id) async {
    try {
      if (busy) await c.apiPost('search/stop', {'id': '$id'});
      await c.apiPost('search/delete', {'id': '$id'});
    } catch (_) {
      /* The server may have already removed this search. */
    }
  }

  Future<void> search() async {
    if (query.text.trim().isEmpty || busy) return;
    final token = ++generation;
    setState(() {
      busy = true;
      canceled = false;
      results = [];
      status = (l) => l.message0157;
    });
    try {
      if (searchId != null) await _cleanup(searchId!);
      final response = await c.apiPost('search/start', {
        'pattern': query.text.trim(),
        'plugins': plugin,
        'category': category,
      });
      final raw = response is Map ? response['id'] : null;
      final id = raw is num ? raw.toInt() : int.tryParse('$raw');
      if (id == null) throw const FormatException();
      if (!mounted || token != generation) {
        await _cleanup(id);
        return;
      }
      searchId = id;
      for (
        var attempt = 0;
        attempt < 120 && mounted && !canceled && token == generation;
        attempt++
      ) {
        await Future<void>.delayed(const Duration(seconds: 1));
        if (!mounted || canceled || token != generation) break;
        final response = await c.apiGet('search/results', {
          'id': '$id',
          'limit': '1000',
          'offset': '0',
        });
        if (!mounted || canceled || token != generation) break;
        if (response is! Map) throw const FormatException();
        final stopped = response['status'] == 'Stopped';
        setState(() {
          results = response['results'] is List
              ? (response['results'] as List).whereType<Map>().toList()
              : [];
          final count = results.length;
          status = (l) => l.message0158(count, stopped ? l.message0159 : '');
        });
        if (response['status'] == 'Stopped') break;
        if (attempt == 119) {
          await c.apiPost('search/stop', {'id': '$id'});
          if (mounted) {
            final count = results.length;
            setState(() => status = (l) => l.message0160(count));
          }
        }
      }
    } catch (_) {
      if (mounted && token == generation) {
        setState(() => status = backendFailure(c.error, (l) => l.message0161));
      }
    } finally {
      if (mounted && token == generation) setState(() => busy = false);
    }
  }

  Future<void> stop() async {
    generation++;
    canceled = true;
    try {
      if (searchId != null) await c.apiPost('search/stop', {'id': '$searchId'});
    } catch (_) {
      if (mounted) {
        setState(() => status = backendFailure(c.error, (l) => l.message0162));
      }
    }
    if (mounted) {
      final count = results.length;
      setState(() {
        busy = false;
        status = (l) => l.message0163(count);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final categoryLabels = <String, String>{
      'all': l10n.message0172,
      'books': l10n.message0173,
      'games': l10n.message0174,
      'movies': l10n.message0175,
      'music': l10n.message0176,
      'software': l10n.message0177,
      'tv': l10n.message0178,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.message0164),
        actions: [
          IconButton(
            tooltip: l10n.message0165,
            icon: const Icon(Icons.extension_outlined),
            onPressed: busy
                ? null
                : () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => SearchPluginsScreen(controller: c),
                      ),
                    );
                    await loadPlugins();
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: query,
                        onSubmitted: (_) => search(),
                        decoration: InputDecoration(
                          labelText: l10n.message0166,
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: busy ? stop : search,
                      child: Text(busy ? l10n.message0167 : l10n.message0168),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: plugin,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.message0169,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text(l10n.message0170),
                          ),
                          DropdownMenuItem(
                            value: 'enabled',
                            child: Text(l10n.message0171),
                          ),
                          for (final p in plugins)
                            DropdownMenuItem(
                              value: '${p['name']}',
                              child: Text(
                                '${p['fullName'] ?? p['name']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                        onChanged: busy
                            ? null
                            : (value) =>
                                  setState(() => plugin = value ?? 'all'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: category,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: l10n.message0148,
                        ),
                        items: [
                          for (final e in categoryLabels.entries)
                            DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ),
                        ],
                        onChanged: busy
                            ? null
                            : (value) =>
                                  setState(() => category = value ?? 'all'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (busy) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(status?.call(l10n) ?? ''),
          ),
          Expanded(
            child: results.isEmpty && !busy
                ? Center(child: Text(l10n.message0179))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return ListTile(
                        title: Text(
                          '${result['fileName'] ?? context.l10n.message0109}',
                        ),
                        subtitle: Text(
                          context.l10n.message0180(
                            humanBytes(
                              result['fileSize'] is num
                                  ? result['fileSize'] as num
                                  : 0,
                              l10n: context.l10n,
                            ),
                            '${result['nbSeeders'] ?? 0}',
                            '${result['siteUrl'] ?? ''}',
                          ),
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          tooltip: context.l10n.message0181,
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () async {
                            try {
                              final url = '${result['fileUrl'] ?? ''}';
                              if (url.isEmpty) throw const FormatException();
                              await c.addUrls(url);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.l10n.message0110),
                                  ),
                                );
                              }
                            } catch (_) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.l10n.message0182),
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class SearchPluginsScreen extends StatefulWidget {
  const SearchPluginsScreen({super.key, required this.controller});
  final AppController controller;
  @override
  State<SearchPluginsScreen> createState() => _SearchPluginsScreenState();
}

class _SearchPluginsScreenState extends State<SearchPluginsScreen> {
  List<Map> plugins = [];
  bool busy = false;
  LocalizedText? error;
  AppController get c => widget.controller;
  @override
  void initState() {
    super.initState();
    unawaited(run(load));
  }

  Future<void> run(Future<void> Function() action) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) {
        setState(() => error = backendFailure(c.error, (l) => l.message0183));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> load() async {
    final response = await c.apiGet('search/plugins');
    if (mounted) {
      setState(
        () => plugins = response is List
            ? response.whereType<Map>().toList()
            : [],
      );
    }
  }

  Future<void> install() async {
    final l10n = context.l10n;
    final fields = await askFields(context, l10n.message0184, [
      FormFieldSpec('sources', l10n.message0185, required: true),
    ], description: l10n.message0186);
    if (fields == null) return;
    await c.apiPost('search/installPlugin', fields);
    await load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.message0187),
        actions: [
          IconButton(
            tooltip: l10n.message0188,
            onPressed: busy
                ? null
                : () => run(() async {
                    await c.apiPost('search/updatePlugins', {});
                    await load();
                  }),
            icon: const Icon(Icons.system_update_alt),
          ),
          IconButton(
            tooltip: l10n.message0189,
            onPressed: busy ? null : () => run(install),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          if (busy) const LinearProgressIndicator(),
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(error!(l10n)),
            ),
          Expanded(
            child: plugins.isEmpty && !busy
                ? Center(child: Text(l10n.message0190))
                : ListView(
                    children: [
                      for (final plugin in plugins)
                        SwitchListTile(
                          title: Text(
                            '${plugin['fullName'] ?? plugin['name']}',
                          ),
                          subtitle: Text(
                            l10n.message0191('${plugin['version'] ?? '—'}'),
                          ),
                          value: plugin['enabled'] == true,
                          onChanged: busy
                              ? null
                              : (value) => run(() async {
                                  await c.apiPost('search/enablePlugin', {
                                    'names': '${plugin['name']}',
                                    'enable': '$value',
                                  });
                                  await load();
                                }),
                          secondary: IconButton(
                            tooltip: l10n.message0192,
                            icon: const Icon(Icons.delete_outline),
                            onPressed: busy
                                ? null
                                : () => run(() async {
                                    if (await confirmAction(
                                      context,
                                      l10n.message0193,
                                      '${plugin['fullName'] ?? plugin['name']}',
                                    )) {
                                      await c.apiPost(
                                        'search/uninstallPlugin',
                                        {'names': '${plugin['name']}'},
                                      );
                                      await load();
                                    }
                                  }),
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
