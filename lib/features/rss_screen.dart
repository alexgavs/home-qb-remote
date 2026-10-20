import 'dart:convert';

import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../l10n/error_messages.dart';
import '../l10n/l10n.dart';
import 'form_helpers.dart';

class TypedRssScreen extends StatefulWidget {
  const TypedRssScreen({
    super.key,
    required this.controller,
    required this.items,
    required this.rules,
  });
  final AppController controller;
  final dynamic items, rules;
  @override
  State<TypedRssScreen> createState() => _TypedRssScreenState();
}

class _TypedRssScreenState extends State<TypedRssScreen> {
  late dynamic items = widget.items;
  late Map<String, dynamic> rules = widget.rules is Map
      ? Map<String, dynamic>.from(widget.rules as Map)
      : {};
  bool busy = false;
  LocalizedText? error;
  AppController get c => widget.controller;
  Future<void> run(Future<void> Function() callback) async {
    if (busy) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await callback();
    } catch (_) {
      if (mounted) {
        setState(() => error = backendFailure(c.error, (l) => l.message0098));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> reload() async {
    final feedData = await c.apiGet('rss/items', {'withData': 'true'});
    final ruleData = await c.apiGet('rss/rules');
    if (mounted) {
      setState(() {
        items = feedData;
        rules = ruleData is Map ? Map<String, dynamic>.from(ruleData) : {};
      });
    }
  }

  Iterable<({String path, Map feed})> feeds(
    dynamic node, [
    String parent = '',
  ]) sync* {
    if (node is! Map) return;
    for (final entry in node.entries) {
      if (entry.value is! Map) continue;
      final path = parent.isEmpty ? '${entry.key}' : '$parent\\${entry.key}';
      final item = entry.value as Map;
      if (item.containsKey('url') || item.containsKey('articles')) {
        yield (path: path, feed: item);
      } else {
        yield* feeds(item, path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final feedList = feeds(items).toList();
    final articles = <({String path, Map article})>[
      for (final feed in feedList)
        if (feed.feed['articles'] is List)
          for (final article in feed.feed['articles'] as List)
            if (article is Map) (path: feed.path, article: article),
    ];
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('RSS'),
          actions: [
            IconButton(
              tooltip: l10n.message0099,
              onPressed: busy ? null : () => run(reload),
              icon: const Icon(Icons.refresh),
            ),
            PopupMenuButton<String>(
              enabled: !busy,
              tooltip: l10n.message0100,
              onSelected: (action) => run(() => add(action)),
              itemBuilder: (_) => [
                PopupMenuItem(value: 'feed', child: Text(l10n.message0101)),
                PopupMenuItem(value: 'folder', child: Text(l10n.message0102)),
                PopupMenuItem(value: 'rule', child: Text(l10n.message0103)),
                PopupMenuItem(
                  value: 'folderAction',
                  child: Text(l10n.message0104),
                ),
              ],
              icon: const Icon(Icons.add),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.message0105),
              Tab(text: l10n.message0106),
              Tab(text: l10n.message0107),
            ],
          ),
        ),
        body: Column(
          children: [
            if (busy) const LinearProgressIndicator(),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(error!(l10n)),
              ),
            Expanded(
              child: TabBarView(
                children: [
                  articles.isEmpty
                      ? Center(child: Text(l10n.message0108))
                      : ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final entry = articles[index];
                            final article = entry.article;
                            return Card(
                              child: ListTile(
                                title: Text(
                                  '${article['title'] ?? l10n.message0109}',
                                ),
                                subtitle: Text(
                                  '${entry.path}\n${article['date'] ?? ''}',
                                ),
                                isThreeLine: true,
                                trailing: PopupMenuButton<String>(
                                  enabled: !busy,
                                  onSelected: (action) => run(() async {
                                    if (action == 'read') {
                                      await c.apiPost('rss/markAsRead', {
                                        'itemPath': entry.path,
                                        'articleId': '${article['id'] ?? ''}',
                                      });
                                      await reload();
                                    } else {
                                      final link =
                                          '${article['torrentURL'] ?? article['link'] ?? ''}';
                                      if (link.isEmpty) {
                                        throw const FormatException();
                                      }
                                      await c.addUrls(link);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  context.l10n.message0110,
                                                ),
                                              ),
                                            );
                                      }
                                    }
                                  }),
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      value: 'download',
                                      child: Text(l10n.message0111),
                                    ),
                                    PopupMenuItem(
                                      value: 'read',
                                      child: Text(l10n.message0112),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  feedList.isEmpty
                      ? Center(child: Text(l10n.message0113))
                      : ListView(
                          children: [
                            for (final entry in feedList)
                              ListTile(
                                leading: const Icon(Icons.rss_feed),
                                title: Text(entry.path),
                                subtitle: Text('${entry.feed['url'] ?? ''}'),
                                trailing: PopupMenuButton<String>(
                                  enabled: !busy,
                                  onSelected: (action) =>
                                      run(() => feedAction(action, entry.path)),
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      value: 'refresh',
                                      child: Text(l10n.message0114),
                                    ),
                                    PopupMenuItem(
                                      value: 'read',
                                      child: Text(l10n.message0115),
                                    ),
                                    PopupMenuItem(
                                      value: 'move',
                                      child: Text(l10n.message0116),
                                    ),
                                    PopupMenuItem(
                                      value: 'remove',
                                      child: Text(l10n.message0117),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                  rules.isEmpty
                      ? Center(child: Text(l10n.message0118))
                      : ListView(
                          children: [
                            for (final entry in rules.entries)
                              ListTile(
                                leading: Icon(
                                  entry.value is Map &&
                                          (entry.value as Map)['enabled'] ==
                                              true
                                      ? Icons.auto_awesome
                                      : Icons.pause_circle_outline,
                                ),
                                title: Text(entry.key),
                                subtitle: Text(
                                  entry.value is Map
                                      ? '${(entry.value as Map)['mustContain'] ?? ''}'
                                      : '',
                                ),
                                trailing: PopupMenuButton<String>(
                                  enabled: !busy,
                                  onSelected: (action) =>
                                      run(() => ruleAction(action, entry.key)),
                                  itemBuilder: (_) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text(l10n.message0119),
                                    ),
                                    PopupMenuItem(
                                      value: 'rename',
                                      child: Text(l10n.message0120),
                                    ),
                                    PopupMenuItem(
                                      value: 'matching',
                                      child: Text(l10n.message0121),
                                    ),
                                    PopupMenuItem(
                                      value: 'remove',
                                      child: Text(l10n.message0122),
                                    ),
                                  ],
                                ),
                                onTap: busy
                                    ? null
                                    : () => run(() => editRule(entry.key)),
                              ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> add(String action) async {
    if (action == 'rule') {
      await editRule();
      return;
    }
    if (action == 'folderAction') {
      final data = await askFields(context, context.l10n.message0123, [
        FormFieldSpec('path', context.l10n.message0124, required: true),
      ]);
      if (data == null || !mounted) return;
      final operation = await showDialog<String>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(context.l10n.message0125),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'move'),
              child: Text(context.l10n.message0116),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'remove'),
              child: Text(context.l10n.message0126),
            ),
          ],
        ),
      );
      if (operation != null) await feedAction(operation, data['path']!);
      return;
    }
    final l10n = context.l10n;
    final data = await askFields(
      context,
      action == 'feed' ? l10n.message0127 : l10n.message0128,
      [
        if (action == 'feed')
          FormFieldSpec('url', l10n.message0129, required: true),
        FormFieldSpec(
          'path',
          action == 'feed' ? l10n.message0130 : l10n.message0131,
          required: action != 'feed',
        ),
      ],
    );
    if (data == null) return;
    await c.apiPost(action == 'feed' ? 'rss/addFeed' : 'rss/addFolder', data);
    await reload();
  }

  Future<void> feedAction(String action, String path) async {
    if (action == 'refresh') {
      await c.apiPost('rss/refreshItem', {'itemPath': path});
    } else if (action == 'read') {
      await c.apiPost('rss/markAsRead', {'itemPath': path});
    } else if (action == 'move') {
      final data = await askFields(context, context.l10n.message0132, [
        FormFieldSpec(
          'destPath',
          context.l10n.message0133,
          value: path,
          required: true,
        ),
      ]);
      if (data == null) return;
      await c.apiPost('rss/moveItem', {'itemPath': path, ...data});
    } else if (await confirmAction(
      context,
      context.l10n.message0134,
      context.l10n.message0135(path),
    )) {
      await c.apiPost('rss/removeItem', {'path': path});
    }
    await reload();
  }

  Future<void> editRule([String? name]) async {
    final existing = name != null && rules[name] is Map
        ? Map<String, dynamic>.from(rules[name] as Map)
        : <String, dynamic>{};
    final result =
        await showDialog<({String name, Map<String, dynamic> definition})>(
          context: context,
          builder: (_) => _RuleDialog(name: name, initial: existing),
        );
    if (result == null) return;
    await c.apiPost('rss/setRule', {
      'ruleName': result.name,
      'ruleDef': jsonEncode(result.definition),
    });
    await reload();
  }

  Future<void> ruleAction(String action, String name) async {
    if (action == 'edit') {
      await editRule(name);
      return;
    }
    if (action == 'remove') {
      if (!await confirmAction(context, context.l10n.message0136, name)) {
        return;
      }
      await c.apiPost('rss/removeRule', {'ruleName': name});
    } else if (action == 'rename') {
      final data = await askFields(context, context.l10n.message0137, [
        FormFieldSpec(
          'newRuleName',
          context.l10n.message0138,
          value: name,
          required: true,
        ),
      ]);
      if (data == null) return;
      await c.apiPost('rss/renameRule', {'ruleName': name, ...data});
    } else {
      final response = await c.apiGet('rss/matchingArticles', {
        'ruleName': name,
      });
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.message0139(name)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (response is Map)
                    for (final entry in response.entries) ...[
                      Text(
                        '${entry.key}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (entry.value is List)
                        for (final article in entry.value as List)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text('$article'),
                          ),
                    ],
                  if (response is! Map || response.isEmpty)
                    Text(context.l10n.message0140),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.message0141),
            ),
          ],
        ),
      );
    }
    await reload();
  }
}

class _RuleDialog extends StatefulWidget {
  const _RuleDialog({this.name, required this.initial});
  final String? name;
  final Map<String, dynamic> initial;
  @override
  State<_RuleDialog> createState() => _RuleDialogState();
}

class _RuleDialogState extends State<_RuleDialog> {
  final form = GlobalKey<FormState>();
  Map get torrentParams => widget.initial['torrentParams'] is Map
      ? widget.initial['torrentParams'] as Map
      : const {};
  dynamic initialValue(String key) => switch (key) {
    'assignedCategory' => torrentParams['category'] ?? widget.initial[key],
    'savePath' => torrentParams['save_path'] ?? widget.initial[key],
    _ => widget.initial[key],
  };
  late final fields = <String, TextEditingController>{
    'name': TextEditingController(text: widget.name ?? ''),
    for (final key in [
      'mustContain',
      'mustNotContain',
      'episodeFilter',
      'assignedCategory',
      'savePath',
      'ignoreDays',
    ])
      key: TextEditingController(
        text: '${initialValue(key) ?? (key == 'ignoreDays' ? 0 : '')}',
      ),
    'affectedFeeds': TextEditingController(
      text:
          (widget.initial['affectedFeeds'] is List
                  ? widget.initial['affectedFeeds'] as List
                  : [])
              .join('\n'),
    ),
  };
  late bool enabled = widget.initial['enabled'] as bool? ?? true;
  late bool regex = widget.initial['useRegex'] as bool? ?? false;
  late bool smart = widget.initial['smartFilter'] as bool? ?? false;
  late bool paused =
      (torrentParams['stopped'] ?? widget.initial['addPaused']) as bool? ??
      false;
  @override
  void dispose() {
    for (final field in fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.name == null ? l10n.message0142 : l10n.message0143),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final entry in {
                  'name': l10n.message0137,
                  'mustContain': l10n.message0144,
                  'mustNotContain': l10n.message0145,
                  'episodeFilter': l10n.message0146,
                  'affectedFeeds': l10n.message0147,
                  'assignedCategory': l10n.message0148,
                  'savePath': l10n.message0149,
                  'ignoreDays': l10n.message0150,
                }.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextFormField(
                      controller: fields[entry.key],
                      readOnly: entry.key == 'name' && widget.name != null,
                      minLines: entry.key == 'affectedFeeds' ? 2 : 1,
                      maxLines: entry.key == 'affectedFeeds' ? 5 : 1,
                      decoration: InputDecoration(labelText: entry.value),
                      validator: (value) {
                        if (entry.key == 'name' &&
                            (value?.trim().isEmpty ?? true)) {
                          return l10n.message0151;
                        }
                        if (entry.key == 'ignoreDays') {
                          return nonnegativeInteger(value ?? '', l10n: l10n);
                        }
                        return null;
                      },
                    ),
                  ),
                SwitchListTile(
                  title: Text(l10n.message0152),
                  value: enabled,
                  onChanged: (v) => setState(() => enabled = v),
                ),
                SwitchListTile(
                  title: Text(l10n.message0153),
                  value: regex,
                  onChanged: (v) => setState(() => regex = v),
                ),
                SwitchListTile(
                  title: Text(l10n.message0154),
                  value: smart,
                  onChanged: (v) => setState(() => smart = v),
                ),
                SwitchListTile(
                  title: Text(l10n.message0155),
                  value: paused,
                  onChanged: (v) => setState(() => paused = v),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.message0043),
        ),
        FilledButton(
          onPressed: () {
            if (!form.currentState!.validate()) return;
            final definition = <String, dynamic>{
              ...widget.initial,
              for (final key in [
                'mustContain',
                'mustNotContain',
                'episodeFilter',
                'assignedCategory',
                'savePath',
              ])
                key: fields[key]!.text,
              'affectedFeeds': fields['affectedFeeds']!.text
                  .split(RegExp(r'[\r\n]+'))
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
              'ignoreDays': int.parse(fields['ignoreDays']!.text),
              'enabled': enabled,
              'useRegex': regex,
              'smartFilter': smart,
              'addPaused': paused,
              if (widget.initial['torrentParams'] is Map)
                'torrentParams': <String, dynamic>{
                  ...Map<String, dynamic>.from(torrentParams),
                  'category': fields['assignedCategory']!.text,
                  'save_path': fields['savePath']!.text,
                  'stopped': paused,
                },
            };
            Navigator.pop(context, (
              name: fields['name']!.text.trim(),
              definition: definition,
            ));
          },
          child: Text(l10n.message0083),
        ),
      ],
    );
  }
}
