import 'add_torrent_dialog.dart';
import '../integrations/integrations_screen.dart';

import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_controller.dart';
import '../core/models.dart';
import '../features/advanced_screen.dart';
import '../features/device_settings_screen.dart';
import '../features/torrent_tools_screen.dart';
import '../features/form_helpers.dart';
import '../l10n/error_messages.dart';
import '../l10n/l10n.dart';
import '../services/network_route_service.dart';

const _background = Color(0xFF0C1423);
const _surface = Color(0xFF141F31);
const _border = Color(0xFF253247);
const _teal = Color(0xFF5CE0C1);
const _muted = Color(0xFF9DAEC4);

/// Stable internal filter identifiers. These are never shown directly; the
/// visible labels come from [_filterLabel].
const _filterIds = ['Все', 'Загрузка', 'Раздача', 'Пауза', 'Ошибки'];

class _PkcsPasswordDialog extends StatefulWidget {
  const _PkcsPasswordDialog();
  @override
  State<_PkcsPasswordDialog> createState() => _PkcsPasswordDialogState();
}

class _PkcsPasswordDialogState extends State<_PkcsPasswordDialog> {
  final password = TextEditingController();
  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.message0476),
      content: TextField(
        controller: password,
        obscureText: true,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(labelText: l10n.message0477),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.message0043),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, password.text),
          child: Text(l10n.message0478),
        ),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  String _filter = 'Все';
  final Set<String> _selected = {};

  AppController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _teal,
        brightness: Brightness.dark,
        surface: _surface,
      ).copyWith(primary: _teal),
      scaffoldBackgroundColor: _background,
      dividerColor: _border,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _background,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _border),
        ),
      ),
    );
    return Theme(
      data: theme,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final l10n = context.l10n;
          _selected.removeWhere(
            (hash) =>
                !controller.torrents.any((torrent) => torrent.hash == hash),
          );
          return LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 1050;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: _background,
                  title: Row(
                    children: [
                      if (constraints.maxWidth >= 600) ...[
                        const Icon(Icons.hub_rounded, color: _teal),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Text(
                          constraints.maxWidth < 600
                              ? 'Home qB'
                              : l10n.message0479,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    if (controller.currentProfile != null &&
                        constraints.maxWidth >= 600)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: IconButton(
                          tooltip: l10n.message0099,
                          onPressed: controller.busy
                              ? null
                              : () => _run(controller.reconnect),
                          icon: const Icon(Icons.refresh_rounded),
                        ),
                      ),
                    IconButton(
                      tooltip: l10n.message0045,
                      onPressed: controller.currentProfile == null
                          ? null
                          : _advanced,
                      icon: const Icon(Icons.tune_rounded),
                    ),
                    IconButton(
                      tooltip: l10n.message0480,
                      onPressed: _manageProfiles,
                      icon: const Icon(Icons.dns_outlined),
                    ),
                    IconButton(
                      tooltip: l10n.message0481,
                      onPressed: _deviceSettings,
                      icon: const Icon(Icons.settings_outlined),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                drawer: wide
                    ? null
                    : Drawer(
                        backgroundColor: _surface,
                        child: _sidebar(closeOnSelect: true),
                      ),
                body: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      if (wide)
                        SizedBox(
                          width: 250,
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                              border: BorderDirectional(
                                end: BorderSide(color: _border),
                              ),
                            ),
                            child: _sidebar(),
                          ),
                        ),
                      Expanded(child: _content()),
                    ],
                  ),
                ),
                floatingActionButton: controller.currentProfile == null
                    ? null
                    : FloatingActionButton.extended(
                        onPressed: controller.busy ? null : _addTorrent,
                        backgroundColor: _teal,
                        foregroundColor: _background,
                        icon: const Icon(Icons.add_rounded),
                        label: Text(l10n.message0111),
                      ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _sidebar({bool closeOnSelect = false}) {
    final l10n = context.l10n;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.message0482,
                style: const TextStyle(
                  fontSize: 11,
                  color: _muted,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              if (controller.currentProfile != null) ...[
                Text(
                  controller.currentProfile!.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _serverHost(
                    controller.currentConnectionUrl ??
                        controller.currentProfile!.url,
                    l10n,
                  ),
                  style: const TextStyle(color: _muted),
                ),
                if (controller.version != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'qBittorrent ${controller.version}',
                    style: const TextStyle(color: _teal, fontSize: 12),
                  ),
                ],
              ] else
                Text(l10n.message0483, style: const TextStyle(color: _muted)),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: _manageProfiles,
                icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                label: Text(l10n.message0484),
              ),
              const SizedBox(height: 28),
              ListTile(
                leading: const Icon(Icons.tune_rounded),
                title: Text(l10n.message0045),
                subtitle: Text(l10n.message0485),
                enabled: controller.currentProfile != null,
                onTap: () {
                  if (closeOnSelect) Navigator.of(context).pop();
                  _advanced();
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(l10n.message0481),
                onTap: () {
                  if (closeOnSelect) Navigator.of(context).pop();
                  _deviceSettings();
                },
              ),
              ListTile(
                leading: const Icon(Icons.hub_outlined),
                title: Text(l10n.integrationsTitle),
                onTap: () {
                  if (closeOnSelect) Navigator.of(context).pop();
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (_) =>
                          IntegrationsScreen(controller: controller),
                    ),
                  );
                },
              ),
              for (final entry in <String, IconData>{
                'Все': Icons.dashboard_outlined,
                'Загрузка': Icons.south_rounded,
                'Раздача': Icons.north_rounded,
                'Пауза': Icons.pause_circle_outline_rounded,
                'Ошибки': Icons.error_outline_rounded,
              }.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    dense: true,
                    selected: _filter == entry.key,
                    selectedColor: _teal,
                    selectedTileColor: _teal.withValues(alpha: .09),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: Icon(entry.value, size: 21),
                    title: Text(
                      _filterLabel(l10n, entry.key, allTorrents: true),
                    ),
                    onTap: () {
                      setState(() => _filter = entry.key);
                      if (closeOnSelect) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.home_outlined, color: _teal, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.message0491,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    final l10n = context.l10n;
    if (controller.currentProfile == null) {
      return _empty(
        Icons.dns_outlined,
        l10n.message0492,
        l10n.message0493,
        FilledButton.icon(
          onPressed: () => _editProfile(),
          icon: const Icon(Icons.add_rounded),
          label: Text(l10n.message0494),
        ),
      );
    }
    final torrents = controller.torrents.where((torrent) {
      if (!torrent.name.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }
      return _matchesFilter(torrent, _filter);
    }).toList();
    final download = controller.torrents.fold<int>(
      0,
      (sum, torrent) => sum + torrent.dlspeed,
    );
    final upload = controller.torrents.fold<int>(
      0,
      (sum, torrent) => sum + torrent.upspeed,
    );
    final compact = MediaQuery.sizeOf(context).width < 600;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1300),
        child: RefreshIndicator(
          onRefresh: () => _run(controller.reconnect),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (controller.busy)
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(minHeight: 2, color: _teal),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    compact ? 12 : 22,
                    compact ? 8 : 20,
                    compact ? 12 : 22,
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.message0495,
                              style: TextStyle(
                                fontSize: compact ? 22 : 27,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            tooltip: l10n.message0496,
                            onSelected: (id) {
                              final profile = controller.profiles.firstWhere(
                                (p) => p.id == id,
                              );
                              _selected.clear();
                              _run(() => controller.selectProfile(profile));
                            },
                            itemBuilder: (_) => controller.profiles
                                .map(
                                  (profile) => PopupMenuItem(
                                    value: profile.id,
                                    child: Text(profile.name),
                                  ),
                                )
                                .toList(),
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.keyboard_arrow_down_rounded),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.currentProfile!.name,
                        style: const TextStyle(color: _muted),
                      ),
                      SizedBox(height: compact ? 8 : 22),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final itemWidth = (width - 24) / 3;
                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: itemWidth,
                                child: _stat(
                                  Icons.south_rounded,
                                  l10n.message0486,
                                  l10n.message0497(_bytes(download, l10n)),
                                  _teal,
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: _stat(
                                  Icons.north_rounded,
                                  l10n.message0487,
                                  l10n.message0498(_bytes(upload, l10n)),
                                  const Color(0xFF99B6FF),
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: _stat(
                                  Icons.layers_outlined,
                                  l10n.message0499,
                                  '${controller.torrents.length}',
                                  const Color(0xFFFFD391),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: compact ? 8 : 20),
                      TextField(
                        onChanged: (value) => setState(() => _query = value),
                        decoration: InputDecoration(
                          hintText: l10n.message0500,
                          prefixIcon: const Icon(Icons.search_rounded),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (final id in _filterIds)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 8,
                                ),
                                child: ChoiceChip(
                                  label: Text(_filterLabel(l10n, id)),
                                  selected: _filter == id,
                                  onSelected: (_) =>
                                      setState(() => _filter = id),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (controller.error != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B242D),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFFFA5B3),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  localizeError(l10n, controller.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (_selected.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              l10n.message0501('${_selected.length}'),
                              style: const TextStyle(color: _teal),
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: l10n.message0502,
                              onPressed: controller.busy
                                  ? null
                                  : () => _run(
                                      () => controller.setPaused(
                                        _selected.toList(),
                                        paused: false,
                                      ),
                                    ),
                              icon: const Icon(Icons.play_arrow_rounded),
                            ),
                            IconButton(
                              tooltip: l10n.message0503,
                              onPressed: controller.busy
                                  ? null
                                  : () => _run(
                                      () => controller.setPaused(
                                        _selected.toList(),
                                        paused: true,
                                      ),
                                    ),
                              icon: const Icon(Icons.pause_rounded),
                            ),
                            IconButton(
                              tooltip: l10n.message0504,
                              onPressed: controller.busy
                                  ? null
                                  : () => _delete(_selected.toList()),
                              icon: const Icon(Icons.delete_outline),
                            ),
                            IconButton(
                              tooltip: l10n.message0505,
                              onPressed: () => setState(_selected.clear),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (torrents.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 280,
                    child: _empty(
                      Icons.inbox_outlined,
                      _query.isNotEmpty || _filter != 'Все'
                          ? l10n.message0506
                          : l10n.message0507,
                      l10n.message0508,
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    compact ? 12 : 22,
                    4,
                    compact ? 12 : 22,
                    100,
                  ),
                  sliver: SliverList.separated(
                    itemCount: torrents.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, index) => _torrentCard(torrents[index]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String label, String value, Color color) =>
      Container(
        padding: EdgeInsets.all(
          MediaQuery.sizeOf(context).width < 600 ? 10 : 16,
        ),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (MediaQuery.sizeOf(context).width >= 600) ...[
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 12),
            ],
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width < 600 ? 16 : 21,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
          ],
        ),
      );

  Widget _torrentCard(Torrent torrent) {
    final l10n = context.l10n;
    final paused = _isPaused(torrent);
    final progress = torrent.progress.clamp(0.0, 1.0).toDouble();
    final color = _isError(torrent)
        ? const Color(0xFFFFA5B3)
        : paused
        ? _muted
        : _teal;
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selected.contains(torrent.hash) ? _teal : _border,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetails(torrent),
        onLongPress: () => _toggleSelected(torrent.hash),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 12, 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 38,
                    height: 36,
                    child: Checkbox(
                      value: _selected.contains(torrent.hash),
                      onChanged: (_) => _toggleSelected(torrent.hash),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        torrent.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: paused ? l10n.message0509 : l10n.message0510,
                    onPressed: controller.busy
                        ? null
                        : () => _run(
                            () => controller.setPaused([
                              torrent.hash,
                            ], paused: !paused),
                          ),
                    icon: Icon(
                      paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                      size: 22,
                    ),
                  ),
                  PopupMenuButton<String>(
                    tooltip: l10n.message0511,
                    enabled: !controller.busy,
                    onSelected: (action) {
                      if (action == 'delete') {
                        _delete([torrent.hash]);
                      } else if (action == 'tools') {
                        _torrentTools(torrent);
                      } else {
                        _showDetails(torrent);
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'details',
                        child: Text(l10n.message0512),
                      ),
                      PopupMenuItem(
                        value: 'tools',
                        child: Text(l10n.message0307),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.message0513),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12, end: 6),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 5,
                        color: color,
                        backgroundColor: _border,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          _stateLabel(torrent, l10n),
                          style: TextStyle(color: color, fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${(progress * 100).toStringAsFixed(1)}% · ${_bytes(torrent.size, l10n)}',
                            style: const TextStyle(color: _muted, fontSize: 12),
                          ),
                        ),
                        Text(
                          l10n.message0514(_bytes(torrent.dlspeed, l10n)),
                          style: const TextStyle(color: _teal, fontSize: 12),
                        ),
                      ],
                    ),
                    if (torrent.upspeed > 0 || torrent.category.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              torrent.category,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Text(
                            l10n.message0515(_bytes(torrent.upspeed, l10n)),
                            style: const TextStyle(color: _muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _empty(
    IconData icon,
    String title,
    String description, [
    Widget? action,
  ]) => Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: _surface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: _teal, size: 40),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, height: 1.6),
            ),
            if (action != null) ...[const SizedBox(height: 24), action],
          ],
        ),
      ),
    ),
  );

  void _toggleSelected(String hash) => setState(() {
    if (!_selected.add(hash)) _selected.remove(hash);
  });

  void _advanced() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => AdvancedScreen(controller: controller),
    ),
  );

  void _deviceSettings() => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const DeviceSettingsScreen()));

  void _torrentTools(Torrent torrent) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) =>
          TorrentToolsScreen(controller: controller, torrent: torrent),
    ),
  );

  Future<void> _run(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.message0516)));
      }
    }
  }

  Future<void> _manageProfiles() async {
    final action = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final l10n = context.l10n;
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .75,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    l10n.message0517,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                for (final profile in controller.profiles)
                  ListTile(
                    leading: Icon(
                      profile.id == controller.currentProfile?.id
                          ? Icons.radio_button_checked
                          : Icons.dns_outlined,
                      color: _teal,
                    ),
                    title: Text(profile.name),
                    subtitle: Text(_serverHost(profile.url, l10n)),
                    onTap: controller.busy
                        ? null
                        : () => Navigator.pop(context, 'select:${profile.id}'),
                    trailing: PopupMenuButton<String>(
                      tooltip: l10n.message0518,
                      onSelected: (action) =>
                          Navigator.pop(context, '$action:${profile.id}'),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(l10n.message0519),
                        ),
                        PopupMenuItem(
                          value: 'remove',
                          child: Text(l10n.message0520),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context, 'add'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.message0521),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted || action == null) return;
    if (action == 'add') {
      await _editProfile();
      return;
    }
    final id = action.substring(action.indexOf(':') + 1);
    final profile = controller.profiles.firstWhere(
      (profile) => profile.id == id,
    );
    if (action.startsWith('select:')) {
      _selected.clear();
      await _run(() => controller.selectProfile(profile));
    } else if (action.startsWith('edit:')) {
      await _editProfile(profile);
    } else {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          final l10n = context.l10n;
          return AlertDialog(
            title: Text(l10n.message0522),
            content: Text(l10n.message0523(profile.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.message0043),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.message0369),
              ),
            ],
          );
        },
      );
      if (confirmed == true) {
        await _run(() => controller.removeProfile(profile));
      }
    }
  }

  Future<void> _editProfile([ServerProfile? profile]) async {
    final result = await showDialog<ServerProfile>(
      context: context,
      builder: (_) => _ProfileDialog(profile: profile),
    );
    if (result != null) {
      if (result.localSsid.isNotEmpty &&
          Uri.tryParse(result.localUrl)?.scheme == 'http') {
        if (!mounted) return;
        final l10n = context.l10n;
        final accepted = await confirmAction(
          context,
          l10n.message0524,
          l10n.message0525,
        );
        if (!accepted) return;
      }
      _selected.clear();
      await _run(() => controller.saveProfile(result));
    }
  }

  Future<void> _addTorrent() async {
    final request = await showDialog<AddTorrentRequest>(
      context: context,
      builder: (_) => AddTorrentDialog(controller: controller),
    );
    if (!mounted || request == null) return;
    if (!identical(controller.currentProfile, request.targetProfile)) return;
    if (!request.file) {
      await _run(
        () => controller.addUrls(request.urls, options: request.options),
      );
    } else {
      try {
        final type = XTypeGroup(
          label: context.l10n.torrentFile,
          extensions: const ['torrent'],
        );
        final file = await openFile(acceptedTypeGroups: [type]);
        if (file == null) return;
        if (await file.length() > 16 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(context.l10n.message0526)));
          }
          return;
        }
        final bytes = await file.readAsBytes();
        if (!mounted ||
            !identical(controller.currentProfile, request.targetProfile)) {
          return;
        }
        await _run(
          () => controller.addTorrentFile(
            file.name,
            bytes,
            options: request.options,
          ),
        );
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(context.l10n.message0527)));
        }
      }
    }
  }

  Future<void> _delete(List<String> hashes) async {
    var deleteFiles = false;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, update) {
          final l10n = context.l10n;
          return AlertDialog(
            title: Text(
              hashes.length == 1
                  ? l10n.message0528
                  : l10n.message0529(hashes.length),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.message0530),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: deleteFiles,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.message0531),
                  subtitle: Text(l10n.message0532),
                  onChanged: (value) =>
                      update(() => deleteFiles = value ?? false),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.message0043),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFB84459),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.message0369),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed == true) {
      await _run(
        () => controller.deleteTorrents(hashes, deleteFiles: deleteFiles),
      );
      if (mounted) setState(() => _selected.removeAll(hashes));
    }
  }

  Future<void> _showDetails(Torrent torrent) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (_) => _DetailsSheet(
      torrent: torrent,
      load: () => controller.getDetails(torrent.hash),
      post: (endpoint, fields) async {
        await controller.apiPost(endpoint, fields);
      },
    ),
  );
}

class _ProfileDialog extends StatefulWidget {
  const _ProfileDialog({this.profile});
  final ServerProfile? profile;

  @override
  State<_ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<_ProfileDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile?.name ?? '');
  late final _url = TextEditingController(text: widget.profile?.url ?? '');
  late final _user = TextEditingController(
    text: widget.profile?.username ?? '',
  );
  late final _password = TextEditingController(
    text: widget.profile?.password ?? '',
  );
  late final _apiKey = TextEditingController(
    text: widget.profile?.apiKey ?? '',
  );
  late final _basicUser = TextEditingController(
    text: widget.profile?.basicAuthUsername ?? '',
  );
  late final _basicPassword = TextEditingController(
    text: widget.profile?.basicAuthPassword ?? '',
  );
  late final _ca = TextEditingController(
    text: widget.profile?.customCaPem ?? '',
  );
  late final _certificate = TextEditingController(
    text: widget.profile?.clientCertificatePem ?? '',
  );
  late final _key = TextEditingController(
    text: widget.profile?.clientKeyPem ?? '',
  );
  late final _keyPassword = TextEditingController(
    text: widget.profile?.clientKeyPassword ?? '',
  );
  var _visible = false;
  var _defaultNameApplied = false;
  late final _localUrl = TextEditingController(
    text: widget.profile?.localUrl ?? '',
  );
  late final _localSsid = TextEditingController(
    text: widget.profile?.localSsid ?? '',
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The suggested default name depends on the locale, which is not available
    // in initState; apply it exactly once for new profiles.
    if (_defaultNameApplied) return;
    _defaultNameApplied = true;
    if (widget.profile == null && _name.text.isEmpty) {
      _name.text = context.l10n.message0533;
    }
  }

  Future<void> _importPkcs12() async {
    try {
      final file = await openFile(
        acceptedTypeGroups: const [
          XTypeGroup(label: 'PKCS#12', extensions: ['p12', 'pfx']),
        ],
      );
      if (file == null || !mounted) return;
      if (await file.length() > 4 * 1024 * 1024) {
        throw const FormatException();
      }
      if (!mounted) return;
      final password = await showDialog<String>(
        context: context,
        builder: (_) => const _PkcsPasswordDialog(),
      );
      if (password == null) return;
      final bytes = await file.readAsBytes();
      final result = await const MethodChannel('org.homeqb/imports')
          .invokeMapMethod<String, dynamic>('importPkcs12', {
            'bytes': bytes,
            'password': password,
          });
      final certificate = result?['certChainPem'];
      final key = result?['keyPkcs8Pem'];
      if (certificate is! String ||
          key is! String ||
          certificate.isEmpty ||
          key.isEmpty) {
        throw const FormatException();
      }
      if (!mounted) return;
      setState(() {
        _certificate.text = certificate;
        _key.text = key;
        _keyPassword.clear();
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.message0534)));
      }
    }
  }

  @override
  void dispose() {
    for (final field in [
      _name,
      _url,
      _user,
      _password,
      _apiKey,
      _basicUser,
      _basicPassword,
      _ca,
      _certificate,
      _key,
      _keyPassword,
      _localUrl,
      _localSsid,
    ]) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.profile == null ? l10n.message0494 : l10n.message0518),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(labelText: l10n.message0196),
                  validator: (value) =>
                      (value?.trim().isEmpty ?? true) ? l10n.message0535 : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _url,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: l10n.message0536,
                    hintText: 'https://qb.example.local:8080',
                    helperText: l10n.message0537,
                  ),
                  validator: (value) {
                    final uri = Uri.tryParse(value?.trim() ?? '');
                    if (uri == null ||
                        !['http', 'https'].contains(uri.scheme) ||
                        uri.host.isEmpty) {
                      return l10n.message0538;
                    }
                    if (uri.userInfo.isNotEmpty ||
                        uri.hasQuery ||
                        uri.hasFragment) {
                      return l10n.message0539;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _user,
                  autocorrect: false,
                  decoration: InputDecoration(labelText: l10n.message0292),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _password,
                  obscureText: !_visible,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: l10n.message0540,
                    suffixIcon: IconButton(
                      tooltip: _visible ? l10n.message0541 : l10n.message0542,
                      onPressed: () => setState(() => _visible = !_visible),
                      icon: Icon(
                        _visible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _apiKey,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: l10n.message0543,
                    helperText: l10n.message0544,
                    helperMaxLines: 3,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    // Both would occupy the single Authorization request header.
                    if (_basicUser.text.isNotEmpty ||
                        _basicPassword.text.isNotEmpty) {
                      return l10n.message0545;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(l10n.message0546),
                  children: [
                    Text(l10n.message0547),
                    TextFormField(
                      controller: _localUrl,
                      decoration: InputDecoration(labelText: l10n.message0548),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return null;
                        final uri = Uri.tryParse(value.trim());
                        return uri == null ||
                                !['http', 'https'].contains(uri.scheme) ||
                                uri.host.isEmpty ||
                                uri.userInfo.isNotEmpty ||
                                uri.hasQuery ||
                                uri.hasFragment
                            ? l10n.message0549
                            : null;
                      },
                    ),
                    TextField(
                      controller: _localSsid,
                      decoration: InputDecoration(labelText: l10n.message0550),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final ssid = await NetworkRouteService.currentSsid(
                          requestPermission: true,
                        );
                        if (!context.mounted) return;
                        if (ssid != null) {
                          _localSsid.text = ssid;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.message0551)),
                          );
                        }
                      },
                      icon: const Icon(Icons.wifi),
                      label: Text(l10n.message0552),
                    ),
                  ],
                ),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(l10n.message0553),
                  children: [
                    Text(
                      l10n.message0554,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _basicUser,
                      decoration: InputDecoration(labelText: l10n.message0555),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _basicPassword,
                      obscureText: true,
                      decoration: InputDecoration(labelText: l10n.message0556),
                    ),
                    const SizedBox(height: 14),
                    _pemField(l10n.message0557, _ca),
                    _pemField(l10n.message0558, _certificate),
                    _pemField(l10n.message0559, _key),
                    if (Platform.isAndroid)
                      OutlinedButton.icon(
                        onPressed: _importPkcs12,
                        icon: const Icon(Icons.key_outlined),
                        label: Text(l10n.message0560),
                      ),
                    TextField(
                      controller: _keyPassword,
                      obscureText: true,
                      decoration: InputDecoration(labelText: l10n.message0561),
                    ),
                    const SizedBox(height: 12),
                  ],
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
            if (!_form.currentState!.validate()) return;
            Navigator.pop(
              context,
              ServerProfile(
                id:
                    widget.profile?.id ??
                    DateTime.now().microsecondsSinceEpoch.toString(),
                name: _name.text.trim(),
                url: _url.text.trim(),
                username: _user.text,
                password: _password.text,
                apiKey: _apiKey.text.trim(),
                basicAuthUsername: _basicUser.text,
                basicAuthPassword: _basicPassword.text,
                customCaPem: _ca.text,
                clientCertificatePem: _certificate.text,
                localUrl: _localUrl.text.trim(),
                localSsid: _localSsid.text,
                clientKeyPem: _key.text,
                clientKeyPassword: _keyPassword.text,
              ),
            );
          },
          child: Text(l10n.message0083),
        ),
      ],
    );
  }

  Widget _pemField(String label, TextEditingController field) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: field,
          minLines: 2,
          maxLines: 4,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            labelText: label,
            alignLabelWithHint: true,
          ),
        ),
        TextButton.icon(
          onPressed: () async {
            try {
              final file = await openFile();
              if (file == null || !mounted) return;
              if (await file.length() > 1024 * 1024) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.message0562)),
                  );
                }
                return;
              }
              final contents = await file.readAsString();
              if (mounted) field.text = contents;
            } catch (_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.message0563)),
                );
              }
            }
          },
          icon: const Icon(Icons.file_open_outlined, size: 17),
          label: Text(context.l10n.message0564),
        ),
      ],
    ),
  );
}

class _DetailsSheet extends StatefulWidget {
  const _DetailsSheet({
    required this.torrent,
    required this.load,
    required this.post,
  });
  final Torrent torrent;
  final Future<TorrentDetails> Function() load;
  final Future<void> Function(String, Map<String, String>) post;

  @override
  State<_DetailsSheet> createState() => _DetailsSheetState();
}

class _DetailsSheetState extends State<_DetailsSheet> {
  late Future<TorrentDetails> _future = widget.load();
  bool _acting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .83,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.torrent.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  enabled: !_acting,
                  tooltip: l10n.message0565,
                  onSelected: _torrentAction,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'rename',
                      child: Text(l10n.message0120),
                    ),
                    PopupMenuItem(
                      value: 'recheck',
                      child: Text(l10n.message0566),
                    ),
                    PopupMenuItem(
                      value: 'reannounce',
                      child: Text(l10n.message0567),
                    ),
                    PopupMenuItem(
                      value: 'force',
                      child: Text(l10n.message0568),
                    ),
                    PopupMenuItem(
                      value: 'sequential',
                      child: Text(l10n.message0474),
                    ),
                    PopupMenuItem(
                      value: 'firstLast',
                      child: Text(l10n.message0569),
                    ),
                  ],
                ),
                IconButton(
                  tooltip: l10n.message0141,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<TorrentDetails>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l10n.message0570),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () =>
                              setState(() => _future = widget.load()),
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.message0401),
                        ),
                      ],
                    ),
                  );
                }
                final details = snapshot.data!;
                return DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: l10n.message0571),
                          Tab(text: l10n.message0356),
                          Tab(text: l10n.message0340),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _summary(details, l10n),
                            details.files.isEmpty
                                ? Center(child: Text(l10n.message0572))
                                : ListView.separated(
                                    padding: const EdgeInsets.all(18),
                                    itemCount: details.files.length,
                                    separatorBuilder: (_, _) => const Divider(),
                                    itemBuilder: (_, i) {
                                      final file = details.files[i];
                                      final progress =
                                          ((file['progress'] as num?)
                                                      ?.toDouble() ??
                                                  0)
                                              .clamp(0, 1);
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Icons.insert_drive_file_outlined,
                                          color: _teal,
                                        ),
                                        title: Text(
                                          '${file['name'] ?? l10n.message0573}',
                                        ),
                                        subtitle: Text(
                                          '${_bytes((file['size'] as num?)?.toInt() ?? 0, l10n)} · ${(progress * 100).toStringAsFixed(1)}%',
                                        ),
                                        trailing: PopupMenuButton<int>(
                                          tooltip: l10n.message0574,
                                          enabled: !_acting,
                                          onSelected: (priority) => _post(
                                            '/api/v2/torrents/filePrio',
                                            {
                                              'hash': widget.torrent.hash,
                                              'id': '${file['index'] ?? i}',
                                              'priority': '$priority',
                                            },
                                          ),
                                          itemBuilder: (_) => [
                                            PopupMenuItem(
                                              value: 0,
                                              child: Text(l10n.message0361),
                                            ),
                                            PopupMenuItem(
                                              value: 1,
                                              child: Text(l10n.message0209),
                                            ),
                                            PopupMenuItem(
                                              value: 6,
                                              child: Text(l10n.message0575),
                                            ),
                                            PopupMenuItem(
                                              value: 7,
                                              child: Text(l10n.message0576),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                            details.trackers.isEmpty
                                ? Center(child: Text(l10n.message0577))
                                : ListView.separated(
                                    padding: const EdgeInsets.all(18),
                                    itemCount: details.trackers.length,
                                    separatorBuilder: (_, _) => const Divider(),
                                    itemBuilder: (_, i) {
                                      final tracker = details.trackers[i];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const Icon(
                                          Icons.hub_outlined,
                                          color: _teal,
                                        ),
                                        title: Text(
                                          '${tracker['url'] ?? l10n.message0578}',
                                        ),
                                        subtitle: Text(
                                          _trackerStatus(tracker, l10n),
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _post(String endpoint, Map<String, String> fields) async {
    setState(() => _acting = true);
    try {
      await widget.post(endpoint, fields);
      if (mounted) setState(() => _future = widget.load());
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.message0579)));
      }
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _torrentAction(String action) async {
    if (action == 'rename') {
      final input = TextEditingController(text: widget.torrent.name);
      final name = await showDialog<String>(
        context: context,
        builder: (context) {
          final l10n = context.l10n;
          return AlertDialog(
            title: Text(l10n.message0310),
            content: TextField(
              controller: input,
              decoration: InputDecoration(labelText: l10n.message0138),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.message0043),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, input.text.trim()),
                child: Text(l10n.message0083),
              ),
            ],
          );
        },
      );
      if (name != null && name.isNotEmpty && mounted) {
        await _post('/api/v2/torrents/rename', {
          'hash': widget.torrent.hash,
          'name': name,
        });
      }
      return;
    }
    final endpoint = switch (action) {
      'force' => 'setForceStart',
      'sequential' => 'toggleSequentialDownload',
      'firstLast' => 'toggleFirstLastPiecePrio',
      _ => action,
    };
    await _post('/api/v2/torrents/$endpoint', {
      'hashes': widget.torrent.hash,
      if (action == 'force') 'value': 'true',
    });
  }

  Widget _summary(TorrentDetails details, AppLocalizations l10n) {
    final properties = details.properties;
    final fields = <String, String>{
      l10n.message0580: _stateLabel(widget.torrent, l10n),
      l10n.message0581: _bytes(widget.torrent.size, l10n),
      l10n.message0582:
          '${(widget.torrent.progress * 100).toStringAsFixed(1)}%',
      l10n.message0583: _bytes(
        (properties['total_downloaded'] as num?)?.toInt() ?? 0,
        l10n,
      ),
      l10n.message0584: _bytes(
        (properties['total_uploaded'] as num?)?.toInt() ?? 0,
        l10n,
      ),
      l10n.message0348: widget.torrent.ratio.toStringAsFixed(2),
      l10n.message0148: widget.torrent.category.isEmpty
          ? l10n.message0344
          : widget.torrent.category,
      l10n.message0149: '${properties['save_path'] ?? '—'}',
      l10n.message0585: '${properties['comment'] ?? '—'}',
      l10n.message0586: widget.torrent.hash,
    };
    return ListView.separated(
      padding: const EdgeInsets.all(22),
      itemCount: fields.length,
      separatorBuilder: (_, _) => const Divider(height: 25),
      itemBuilder: (_, index) {
        final entry = fields.entries.elementAt(index);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
            const SizedBox(height: 6),
            SelectableText(entry.value),
          ],
        );
      },
    );
  }
}

String _bytes(int value, AppLocalizations l10n) {
  if (value < 0) return '—';
  final units = [
    l10n.message0093,
    l10n.message0587,
    l10n.message0588,
    l10n.message0589,
    l10n.message0590,
  ];
  var amount = value.toDouble();
  var unit = 0;
  while (amount >= 1024 && unit < units.length - 1) {
    amount /= 1024;
    unit++;
  }
  return '${amount.toStringAsFixed(unit == 0
      ? 0
      : amount >= 100
      ? 0
      : 1)} ${units[unit]}';
}

bool _isPaused(Torrent torrent) =>
    torrent.state.startsWith('paused') || torrent.state.startsWith('stopped');
bool _isError(Torrent torrent) =>
    ['error', 'missingFiles', 'unknown'].contains(torrent.state);
bool _matchesFilter(Torrent torrent, String filter) => switch (filter) {
  'Загрузка' =>
    !_isPaused(torrent) && !_isError(torrent) && torrent.progress < 1,
  'Раздача' =>
    !_isPaused(torrent) && !_isError(torrent) && torrent.progress >= 1,
  'Пауза' => _isPaused(torrent),
  'Ошибки' => _isError(torrent),
  _ => true,
};

/// Visible label for a stable filter identifier from [_filterIds].
String _filterLabel(
  AppLocalizations l10n,
  String filter, {
  bool allTorrents = false,
}) => switch (filter) {
  'Загрузка' => l10n.message0486,
  'Раздача' => l10n.message0487,
  'Пауза' => l10n.message0488,
  'Ошибки' => l10n.message0489,
  _ => allTorrents ? l10n.message0490 : l10n.message0172,
};

String _stateLabel(Torrent torrent, AppLocalizations l10n) {
  if (_isError(torrent)) return l10n.message0591;
  if (_isPaused(torrent)) return l10n.message0488;
  if (torrent.state.startsWith('checking')) return l10n.message0592;
  if (torrent.state == 'moving') return l10n.message0593;
  if (torrent.state.startsWith('queued')) return l10n.message0594;
  if (torrent.state == 'metaDL' || torrent.state == 'forcedMetaDL') {
    return l10n.message0595;
  }
  return torrent.progress >= 1 ? l10n.message0487 : l10n.message0486;
}

String _serverHost(String value, AppLocalizations l10n) =>
    Uri.tryParse(value)?.authority.split('@').last ?? l10n.message0596;
String _trackerStatus(Map<String, dynamic> tracker, AppLocalizations l10n) {
  final status = switch (tracker['status']) {
    0 => l10n.message0597,
    1 => l10n.message0598,
    2 => l10n.message0599,
    3 => l10n.message0600,
    4 => l10n.message0598,
    _ => l10n.message0601,
  };
  final message = '${tracker['msg'] ?? ''}';
  return message.isEmpty ? status : '$status · $message';
}
