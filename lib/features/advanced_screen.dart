import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../l10n/error_messages.dart';
import '../l10n/l10n.dart';
import 'search_screen.dart';
import 'rss_screen.dart';
import 'server_settings_screen.dart';
import 'server_info_screen.dart';

class AdvancedScreen extends StatefulWidget {
  const AdvancedScreen({super.key, required this.controller});
  final AppController controller;
  @override
  State<AdvancedScreen> createState() => _AdvancedScreenState();
}

/// UI-generated status. Kept symbolic so it is re-localized on language change.
enum _Notice { limitsSaved, magicSent, operationFailed }

class _AdvancedScreenState extends State<AdvancedScreen> {
  AppController get c => widget.controller;

  /// Raw backend error identifier (from [AppController.error]); localized at build.
  String? message;
  _Notice? notice;
  bool working = false;
  Future<void> run(Future<void> Function() action) async {
    setState(() {
      working = true;
      message = null;
      notice = null;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) {
        setState(() {
          message = c.error;
          notice = c.error == null ? _Notice.operationFailed : null;
        });
      }
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  String _statusText(AppLocalizations l10n) => switch (notice) {
    _Notice.limitsSaved => l10n.message0067,
    _Notice.magicSent => l10n.message0071,
    _Notice.operationFailed => l10n.message0042,
    null => localizeError(l10n, message),
  };

  Future<Map<String, String>?> form(
    String title,
    Map<String, String> fields, {
    String? explanation,
  }) async {
    final controllers = fields.map(
      (k, v) => MapEntry(k, TextEditingController(text: v)),
    );
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (explanation != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(explanation),
                  ),
                ...controllers.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TextField(
                      controller: e.value,
                      maxLines: e.key.contains('JSON') ? 8 : 1,
                      decoration: InputDecoration(labelText: e.key),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              controllers.map((k, v) => MapEntry(k, v.text)),
            ),
            child: Text(context.l10n.message0044),
          ),
        ],
      ),
    );
    // Controllers remain attached until the dialog's reverse animation finishes.
    Future<void>.delayed(const Duration(seconds: 1), () {
      for (final controller in controllers.values) {
        controller.dispose();
      }
    });
    return result;
  }

  Future<void> view(String title, dynamic data) async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: SelectionArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Text(const JsonEncoder.withIndent('  ').convert(data)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.message0045)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                c.currentProfile?.name ?? l10n.message0046,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(l10n.message0047),
              if (working) const LinearProgressIndicator(),
              if (notice != null || message != null)
                Text(
                  _statusText(l10n),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              tile(Icons.search, l10n.message0048, l10n.message0049, () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => TypedSearchScreen(controller: c),
                  ),
                );
              }),
              tile(Icons.rss_feed, l10n.message0050, l10n.message0051, rss),
              tile(Icons.speed, l10n.message0052, l10n.message0053, limits),
              tile(
                Icons.settings,
                l10n.message0054,
                l10n.message0055,
                () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => ServerSettingsScreen(controller: c),
                    ),
                  );
                },
              ),
              tile(
                Icons.category,
                l10n.message0056,
                l10n.message0057,
                () => serverInfo('categories'),
              ),
              tile(
                Icons.receipt_long,
                l10n.message0058,
                l10n.message0059,
                () async {
                  await serverInfo('logs');
                },
              ),
              tile(Icons.router, l10n.message0060, l10n.message0061, () async {
                await serverInfo('transfer');
              }),
              tile(
                Icons.power_settings_new,
                'Wake-on-LAN',
                l10n.message0062,
                wake,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tile(
    IconData icon,
    String title,
    String subtitle,
    Future<void> Function() action,
  ) => Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: working ? null : () => run(action),
    ),
  );
  Future<void> limits() async {
    final dl = await c.apiGet('transfer/downloadLimit');
    final ul = await c.apiGet('transfer/uploadLimit');
    final alt = await c.apiGet('transfer/speedLimitsMode');
    if (!mounted) return;
    final l10n = context.l10n;
    final input = await form(l10n.message0063, {
      l10n.message0064: '${(num.tryParse('$dl') ?? 0) ~/ 1024}',
      l10n.message0065: '${(num.tryParse('$ul') ?? 0) ~/ 1024}',
      l10n.message0066: '$alt',
    });
    if (input == null) return;
    final values = input.values.toList();
    final down = int.parse(values[0]);
    final up = int.parse(values[1]);
    if (down < 0 || up < 0) throw const FormatException();
    await c.apiPost('transfer/setDownloadLimit', {'limit': '${down * 1024}'});
    await c.apiPost('transfer/setUploadLimit', {'limit': '${up * 1024}'});
    if ((values[2] == 'true' || values[2] == 'false') && values[2] != '$alt') {
      await c.apiPost('transfer/toggleSpeedLimitsMode', {});
    }
    setState(() => notice = _Notice.limitsSaved);
  }

  Future<void> serverInfo(String kind) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ServerInfoScreen(controller: c, kind: kind),
      ),
    );
  }

  Future<void> rss() async {
    final data = await c.apiGet('rss/items', {'withData': 'true'});
    final rules = await c.apiGet('rss/rules');
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) =>
            TypedRssScreen(controller: c, items: data, rules: rules),
      ),
    );
  }

  Future<void> wake() async {
    final l10n = context.l10n;
    final input = await form('Wake-on-LAN', {
      l10n.message0068: '',
      l10n.message0069: '255.255.255.255',
      l10n.message0070: '9',
    });
    if (input == null) return;
    final v = input.values.toList();
    final raw = v[0].replaceAll(RegExp('[:-]'), '');
    if (!RegExp(r'^[0-9a-fA-F]{12}$').hasMatch(raw)) {
      throw const FormatException();
    }
    final mac = List<int>.generate(
      6,
      (i) => int.parse(raw.substring(i * 2, i * 2 + 2), radix: 16),
    );
    final address = InternetAddress(v[1]);
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    try {
      socket.broadcastEnabled = true;
      socket.send(
        [255, 255, 255, 255, 255, 255, for (var i = 0; i < 16; i++) ...mac],
        address,
        int.parse(v[2]),
      );
    } finally {
      socket.close();
    }
    setState(() => notice = _Notice.magicSent);
  }
}
