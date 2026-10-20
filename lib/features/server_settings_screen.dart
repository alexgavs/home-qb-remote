import 'dart:convert';

import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../l10n/l10n.dart';
import 'form_helpers.dart';

/// UI-generated status. Kept symbolic so it is re-localized on language change.
enum _Notice { loadFailed, saved, savedReconnect, saveFailed, invalidJson }

class ServerSettingsScreen extends StatefulWidget {
  const ServerSettingsScreen({super.key, required this.controller});
  final AppController controller;
  @override
  State<ServerSettingsScreen> createState() => _ServerSettingsScreenState();
}

class _ServerSettingsScreenState extends State<ServerSettingsScreen> {
  Map<String, dynamic>? values;
  final changes = <String, dynamic>{};
  bool busy = false;
  _Notice? notice;
  final form = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    load();
  }

  String _noticeText(AppLocalizations l10n) => switch (notice) {
    _Notice.loadFailed => l10n.message0235,
    _Notice.saved => l10n.message0239,
    _Notice.savedReconnect => l10n.message0238,
    _Notice.saveFailed => l10n.message0240,
    _Notice.invalidJson => l10n.message0248,
    null => '',
  };

  Future<void> load() async {
    try {
      final response = await widget.controller.apiGet('app/preferences');
      if (response is! Map) throw const FormatException();
      if (mounted) setState(() => values = Map<String, dynamic>.from(response));
    } catch (_) {
      if (mounted) setState(() => notice = _Notice.loadFailed);
    }
  }

  Future<void> save() async {
    if (!form.currentState!.validate() || changes.isEmpty) return;
    final l10n = context.l10n;
    if (changes.keys.any((key) => key.startsWith('web_ui_')) &&
        !await confirmAction(context, l10n.message0236, l10n.message0237)) {
      return;
    }
    setState(() => busy = true);
    final connectionChanged = changes.keys.any(
      (key) => key.startsWith('web_ui_'),
    );
    try {
      await widget.controller.apiPost('app/setPreferences', {
        'json': jsonEncode(changes),
      });
      if (mounted) {
        setState(() {
          values!.addAll(changes);
          changes.clear();
          notice = connectionChanged ? _Notice.savedReconnect : _Notice.saved;
        });
      }
    } catch (_) {
      if (mounted) setState(() => notice = _Notice.saveFailed);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget toggle(String key, String label) {
    if (!values!.containsKey(key) || values![key] is! bool) {
      return const SizedBox.shrink();
    }
    return SwitchListTile(
      title: Text(label),
      value: (changes[key] ?? values![key]) == true,
      onChanged: busy ? null : (value) => setState(() => changes[key] = value),
    );
  }

  Widget field(
    String key,
    String label, {
    bool number = false,
    bool secret = false,
  }) {
    if (!values!.containsKey(key)) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        initialValue: '${values![key] ?? ''}',
        obscureText: secret,
        enableSuggestions: !secret,
        autocorrect: false,
        keyboardType: number
            ? TextInputType.numberWithOptions(signed: true)
            : null,
        decoration: InputDecoration(labelText: label),
        validator: number
            ? (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null) return l10n.message0241;
                if (key.endsWith('_port') && (parsed < 1 || parsed > 65535)) {
                  return l10n.message0242;
                }
                if (key.endsWith('_hour') && (parsed < 0 || parsed > 23)) {
                  return l10n.message0243;
                }
                if (key.endsWith('_min') && (parsed < 0 || parsed > 59)) {
                  return l10n.message0244;
                }
                if (parsed < -1) {
                  return l10n.message0245;
                }
                return null;
              }
            : null,
        onChanged: (value) {
          final parsed = number ? int.tryParse(value) : value;
          if (parsed != null) changes[key] = parsed;
        },
      ),
    );
  }

  Widget section(String label, List<Widget> children) =>
      ExpansionTile(title: Text(label), children: children);
  Future<void> advanced() async {
    final l10n = context.l10n;
    final input = await askFields(context, l10n.message0246, [
      FormFieldSpec(
        'json',
        'JSON',
        value: const JsonEncoder.withIndent('  ')
            .convert({...values!, ...changes}),
        multiline: true,
        required: true,
      ),
    ], description: l10n.message0247);
    if (input == null) return;
    try {
      final decoded = jsonDecode(input['json']!);
      if (decoded is! Map) throw const FormatException();
      setState(() {
        for (final entry in decoded.entries) {
          if (entry.key is String &&
              jsonEncode(values![entry.key]) != jsonEncode(entry.value)) {
            changes[entry.key as String] = entry.value;
          }
        }
      });
      await save();
    } catch (_) {
      if (mounted) setState(() => notice = _Notice.invalidJson);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.message0054),
        actions: [
          IconButton(
            tooltip: l10n.message0083,
            onPressed: values == null || busy ? null : save,
            icon: const Icon(Icons.save_outlined),
          ),
        ],
      ),
      body: values == null
          ? Center(
              child: notice == null
                  ? const CircularProgressIndicator()
                  : Text(_noticeText(l10n)),
            )
          : Form(
              key: form,
              child: ListView(
                children: [
                  if (busy) const LinearProgressIndicator(),
                  if (notice != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(_noticeText(l10n)),
                    ),
                  section(l10n.message0249, [
                    field('save_path', l10n.message0250),
                    field('temp_path', l10n.message0251),
                    toggle('temp_path_enabled', l10n.message0252),
                    toggle('start_paused_enabled', l10n.message0253),
                    toggle('auto_tmm_enabled', l10n.message0254),
                    toggle('preallocate_all', l10n.message0255),
                    toggle('incomplete_files_ext', l10n.message0256),
                    field('export_dir', l10n.message0257),
                    field('export_dir_fin', l10n.message0258),
                  ]),
                  section(l10n.message0228, [
                    field('listen_port', l10n.message0259, number: true),
                    toggle('random_port', l10n.message0260),
                    toggle('upnp', 'UPnP / NAT-PMP'),
                    field('max_connec', l10n.message0261, number: true),
                    field(
                      'max_connec_per_torrent',
                      l10n.message0262,
                      number: true,
                    ),
                    field('max_uploads', l10n.message0263, number: true),
                    field('proxy_ip', l10n.message0264),
                    field('proxy_port', l10n.message0265, number: true),
                    field('proxy_username', l10n.message0266),
                    field('proxy_password', l10n.message0267, secret: true),
                  ]),
                  section(l10n.message0268, [
                    field('dl_limit', l10n.message0269, number: true),
                    field('up_limit', l10n.message0270, number: true),
                    field('alt_dl_limit', l10n.message0271, number: true),
                    field('alt_up_limit', l10n.message0272, number: true),
                    toggle('scheduler_enabled', l10n.message0273),
                    field('schedule_from_hour', l10n.message0274, number: true),
                    field('schedule_from_min', l10n.message0275, number: true),
                    field('schedule_to_hour', l10n.message0276, number: true),
                    field('schedule_to_min', l10n.message0277, number: true),
                    toggle('limit_tcp_overhead', l10n.message0278),
                    toggle('limit_lan_peers', l10n.message0279),
                  ]),
                  section('BitTorrent', [
                    toggle('dht', 'DHT'),
                    toggle('pex', l10n.message0280),
                    toggle('lsd', l10n.message0281),
                    toggle('anonymous_mode', l10n.message0282),
                    toggle('queueing_enabled', l10n.message0283),
                    field(
                      'max_active_downloads',
                      l10n.message0284,
                      number: true,
                    ),
                    field('max_active_uploads', l10n.message0285, number: true),
                    field(
                      'max_active_torrents',
                      l10n.message0286,
                      number: true,
                    ),
                    toggle('dont_count_slow_torrents', l10n.message0287),
                    toggle('add_trackers_enabled', l10n.message0288),
                    field('add_trackers', l10n.message0289),
                  ]),
                  section('WebUI', [
                    field('web_ui_address', l10n.message0290),
                    field('web_ui_port', l10n.message0291, number: true),
                    field('web_ui_username', l10n.message0292),
                    field('web_ui_password', l10n.message0293, secret: true),
                    toggle('web_ui_https_enabled', 'HTTPS'),
                    toggle('web_ui_local_auth', l10n.message0294),
                    toggle('web_ui_csrf_protection_enabled', l10n.message0295),
                    toggle(
                      'web_ui_clickjacking_protection_enabled',
                      l10n.message0296,
                    ),
                    field(
                      'web_ui_session_timeout',
                      l10n.message0297,
                      number: true,
                    ),
                  ]),
                  section('RSS', [
                    toggle('rss_processing_enabled', l10n.message0298),
                    toggle('rss_auto_downloading_enabled', l10n.message0299),
                    field(
                      'rss_refresh_interval',
                      l10n.message0300,
                      number: true,
                    ),
                    field(
                      'rss_max_articles_per_feed',
                      l10n.message0301,
                      number: true,
                    ),
                    field('rss_smart_episode_filters', l10n.message0302),
                  ]),
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: Text(l10n.message0303),
                    subtitle: Text(l10n.message0304),
                    onTap: busy ? null : advanced,
                  ),
                ],
              ),
            ),
    );
  }
}
