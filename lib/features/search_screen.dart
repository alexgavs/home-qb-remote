import 'dart:async';

import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../core/models.dart';
import '../core/qb_client.dart' show QbAuthenticationException;
import '../ui/add_torrent_dialog.dart';
import '../ui/search_results_layout.dart';
import '../integrations/integrations_screen.dart';
import 'search_session.dart';
import '../l10n/error_messages.dart';
import '../l10n/l10n.dart';
import 'form_helpers.dart';

class TypedSearchScreen extends StatefulWidget {
  const TypedSearchScreen({
    super.key,
    required this.controller,
    this.apiFactory,
  });
  final AppController controller;
  final SearchApiFactory? apiFactory;
  @override
  State<TypedSearchScreen> createState() => _TypedSearchScreenState();
}

class _TypedSearchScreenState extends State<TypedSearchScreen> {
  final query = TextEditingController();
  List<Map> results = [];
  List<Map> plugins = [];
  String plugin = 'all', category = 'all';
  LocalizedText? status;
  BoundSearchJob? job;
  ServerProfile? resultProfile;
  int generation = 0;
  bool busy = false, canceled = false, handoffBusy = false;
  bool profileChanged = false;
  bool pluginsLoaded = false;
  final hashesByProfile = <ServerProfile, Set<String>>{};
  final linksByProfile = <ServerProfile, Set<String>>{};
  ServerProfile? observedProfile;
  bool submissionAcknowledged = false;
  String? uncertainLink;
  Set<String> uncertainHashes = {};
  AppController get c => widget.controller;
  SearchServerApi api(ServerProfile profile) =>
      (widget.apiFactory ?? QbSearchServerApi.new)(profile);
  ServerProfile resolved(ServerProfile profile) =>
      profile.withUrl(c.currentConnectionUrl ?? profile.url);
  bool selected(ServerProfile? profile) => identical(c.currentProfile, profile);

  @override
  void initState() {
    super.initState();
    observedProfile = c.currentProfile;
    c.addListener(selectionChanged);
    unawaited(loadPlugins());
  }

  void selectionChanged() {
    if (!identical(observedProfile, c.currentProfile)) {
      observedProfile = c.currentProfile;
      plugins = [];
      plugin = 'all';
      pluginsLoaded = false;
      unawaited(loadPlugins());
    }
    final origin = resultProfile;
    if (origin == null || selected(origin) || profileChanged) return;
    generation++;
    canceled = true;
    final old = job;
    job = null;
    if (old != null) unawaited(old.cleanup());
    setState(() {
      busy = false;
      profileChanged = true;
      status = (l) => l.searchProfileChanged;
    });
  }

  Future<void> loadPlugins() async {
    final profile = c.currentProfile;
    if (profile == null || c.requiresAuthentication) return;
    SearchServerApi? client;
    try {
      client = api(resolved(profile));
      final response = await client.get('search/plugins');
      if (mounted && selected(profile)) {
        setState(() {
          plugins = response is List ? response.whereType<Map>().toList() : [];
          pluginsLoaded = true;
        });
      }
    } catch (error) {
      await c.reportAuthenticationFailure(profile, error);
      if (mounted && selected(profile)) {
        setState(() => status = (l) => l.message0156);
      }
    } finally {
      client?.close();
    }
  }

  @override
  void dispose() {
    c.removeListener(selectionChanged);
    generation++;
    canceled = true;
    final old = job;
    if (old != null) unawaited(old.cleanup());
    query.dispose();
    super.dispose();
  }

  Future<void> search() async {
    final profile = c.currentProfile;
    if (query.text.trim().isEmpty ||
        busy ||
        handoffBusy ||
        profile == null ||
        c.requiresAuthentication ||
        (pluginsLoaded && plugins.isEmpty)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    final token = ++generation;
    final old = job;
    if (old != null) unawaited(old.cleanup());
    BoundSearchJob? activeJob;
    resultProfile = profile;
    final pattern = query.text.trim();
    setState(() {
      busy = true;
      canceled = false;
      profileChanged = false;
      results = [];
      uncertainLink = null;
      submissionAcknowledged = false;
      status = (l) => l.message0157;
    });
    try {
      activeJob = BoundSearchJob(api(resolved(profile)));
      job = activeJob;
      final id = await activeJob.start({
        'pattern': pattern,
        'plugins': plugin,
        'category': category,
      });
      if (!mounted || token != generation || !selected(profile)) return;
      for (
        var attempt = 0;
        attempt < 120 && mounted && !canceled && token == generation;
        attempt++
      ) {
        await Future<void>.delayed(const Duration(seconds: 1));
        if (!mounted || canceled || token != generation || !selected(profile)) {
          break;
        }
        final response = await activeJob.results(id);
        if (!mounted || canceled || token != generation || !selected(profile)) {
          break;
        }
        if (response is! Map) throw const FormatException();
        final stopped = response['status'] == 'Stopped';
        setState(() {
          results = response['results'] is List
              ? (response['results'] as List).whereType<Map>().toList()
              : [];
          final count = results.length;
          status = (l) => l.message0158(count, stopped ? l.message0159 : '');
        });
        if (stopped) {
          await activeJob.cleanup(stop: false);
          break;
        }
        if (attempt == 119) {
          await activeJob.cleanup();
          if (mounted && token == generation) {
            final count = results.length;
            setState(() => status = (l) => l.message0160(count));
          }
        }
      }
    } catch (error) {
      await c.reportAuthenticationFailure(profile, error);
      if (activeJob != null) unawaited(activeJob.cleanup());
      if (mounted && token == generation) {
        setState(() => status = (l) => l.message0161);
      }
    } finally {
      if (!mounted || token != generation || !selected(profile)) {
        if (activeJob != null) unawaited(activeJob.cleanup());
      }
      if (mounted && token == generation) setState(() => busy = false);
    }
  }

  Future<void> stop() async {
    generation++;
    canceled = true;
    final activeJob = job;
    job = null;
    if (activeJob != null) unawaited(activeJob.cleanup());
    if (mounted) {
      final count = results.length;
      setState(() {
        busy = false;
        status = (l) => l.message0163(count);
      });
    }
  }

  Future<void> download(Map result) async {
    final profile = resultProfile;
    if (handoffBusy ||
        profileChanged ||
        profile == null ||
        c.requiresAuthentication ||
        !selected(profile)) {
      return;
    }
    final link = result['fileUrl'] is String ? result['fileUrl'] as String : '';
    if (!supportedSearchDownload(link)) {
      setState(() => status = (l) => l.searchUnsupportedDownload);
      return;
    }
    final hashes = magnetInfoHashes(link);
    final submittedHashes = hashesByProfile.putIfAbsent(
      profile,
      () => <String>{},
    );
    final submittedLinks = linksByProfile.putIfAbsent(
      profile,
      () => <String>{},
    );
    if (submittedLinks.contains(link) ||
        hashes.any(submittedHashes.contains) ||
        c.torrents.any((t) => hashes.contains(t.hash.toLowerCase()))) {
      setState(() => status = (l) => l.searchAlreadyAdded);
      return;
    }
    setState(() => handoffBusy = true);
    SearchServerApi? client;
    var sent = false;
    try {
      client = api(resolved(profile));
      final downloadClient = client;
      final request = await showDialog<AddTorrentRequest>(
        context: context,
        builder: (_) => AddTorrentDialog(
          controller: c,
          targetProfile: profile,
          initialUrls: link,
          downloadTitle: safeSearchTitle(
            result['fileName'],
            context.l10n.message0109,
          ),
          hideUrls: true,
          showFilePicker: false,
          loadSuggestions: downloadClient.get,
        ),
      );
      if (request == null || !mounted || !selected(profile)) return;
      // Read-only fresh check, never an automatic replay of an add mutation.
      if (hashes.isNotEmpty) {
        final torrents = await client.getTorrents();
        if (!mounted || !selected(profile)) return;
        if (torrents.any((t) => hashes.contains(t.hash.toLowerCase()))) {
          setState(() => status = (l) => l.searchAlreadyAdded);
          return;
        }
      }
      if (!selected(profile)) return;
      submittedLinks.add(link);
      submittedHashes.addAll(hashes);
      sent = true;
      await client.addUrls(link, options: request.options);
      if (mounted && selected(profile)) {
        setState(() {
          submissionAcknowledged = true;
          status = (l) => l.torrentSubmitted;
        });
        unawaited(c.refresh());
      }
    } catch (error) {
      await c.reportAuthenticationFailure(profile, error);
      if (error is QbAuthenticationException) {
        submittedLinks.remove(link);
        submittedHashes.removeAll(hashes);
        sent = false;
      }
      if (sent) {
        uncertainLink = link;
        uncertainHashes = hashes;
      }
      if (mounted && selected(profile)) {
        setState(
          () => status = sent
              ? (l) => l.searchAddOutcomeUnknown
              : (l) => l.message0182,
        );
      }
    } finally {
      client?.close();
      if (mounted) setState(() => handoffBusy = false);
    }
  }

  Future<void> checkUncertainSubmission() async {
    final profile = resultProfile;
    final link = uncertainLink;
    if (profile == null ||
        link == null ||
        !selected(profile) ||
        c.requiresAuthentication ||
        handoffBusy) {
      return;
    }
    setState(() => handoffBusy = true);
    SearchServerApi? client;
    try {
      client = api(resolved(profile));
      final torrents = await client.getTorrents();
      if (!mounted || !selected(profile)) return;
      final present = torrents.any(
        (t) => uncertainHashes.contains(t.hash.toLowerCase()),
      );
      if (present) {
        setState(() {
          status = (l) => l.searchAlreadyAdded;
          uncertainLink = null;
        });
      } else if (uncertainHashes.isNotEmpty) {
        // Only a fresh explicit confirmation may follow a successful read.
        // Unknown identities remain blocked: absence cannot be established.
        linksByProfile[profile]?.remove(link);
        hashesByProfile[profile]?.removeAll(uncertainHashes);
      }
    } catch (error) {
      await c.reportAuthenticationFailure(profile, error);
    } finally {
      client?.close();
      if (mounted) setState(() => handoffBusy = false);
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
      body: SearchResultsLayout(
        header: Column(
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
                        onPressed:
                            handoffBusy || (pluginsLoaded && plugins.isEmpty)
                            ? null
                            : busy
                            ? stop
                            : search,
                        child: Text(busy ? l10n.message0167 : l10n.message0168),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (pluginsLoaded && plugins.isEmpty) ...[
                    Text(l10n.message0190),
                    TextButton.icon(
                      onPressed: () => Navigator.push<void>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IntegrationsScreen(controller: c),
                        ),
                      ),
                      icon: const Icon(Icons.hub_outlined),
                      label: Text(l10n.integrationsTitle),
                    ),
                  ],
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: busy
                          ? null
                          : () async {
                              await Navigator.push<void>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SearchPluginsScreen(controller: c),
                                ),
                              );
                              await loadPlugins();
                            },
                      icon: const Icon(Icons.extension_outlined),
                      label: Text(l10n.message0165),
                    ),
                  ),
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
              child: Column(
                children: [
                  Text(status?.call(l10n) ?? ''),
                  Text(l10n.searchResultUrlHidden),
                  if (submissionAcknowledged && !profileChanged)
                    TextButton(
                      onPressed: () {
                        final target = resultProfile;
                        if (target != null && c.requestShowDownloads(target)) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }
                      },
                      child: Text(l10n.viewDownloads),
                    ),
                  if (uncertainLink != null && !profileChanged)
                    TextButton(
                      onPressed: handoffBusy ? null : checkUncertainSubmission,
                      child: Text(l10n.searchCheckServer),
                    ),
                ],
              ),
            ),
          ],
        ),
        empty: !busy ? Center(child: Text(l10n.message0179)) : null,
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return ListTile(
            title: Text(
              safeSearchTitle(result['fileName'], context.l10n.message0109),
            ),
            subtitle: Text(
              context.l10n.message0180(
                humanBytes(
                  result['fileSize'] is num ? result['fileSize'] as num : 0,
                  l10n: context.l10n,
                ),
                safeSearchCount(result['nbSeeders']),
                '',
              ),
            ),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: context.l10n.message0181,
              icon: const Icon(Icons.add_circle_outline),
              onPressed:
                  handoffBusy || profileChanged || c.requiresAuthentication
                  ? null
                  : () => download(result),
            ),
          );
        },
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
                            l10n.message0191('${plugin['version'] ?? 'â€”'}'),
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
