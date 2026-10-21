import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../core/qb_client.dart';
import '../core/models.dart';
import '../features/search_session.dart' show magnetInfoHashes, safeSearchTitle;
import '../l10n/l10n.dart';
import '../ui/add_torrent_dialog.dart';
import '../ui/search_results_layout.dart';
import 'jackett_client.dart';
import 'jackett_models.dart';
import 'torrent_identity.dart';

enum _Notice {
  searchFailed,
  downloadFailed,
  profileChanged,
  noTarget,
  duplicate,
  unknown,
  added,
}

class JackettSearchScreen extends StatefulWidget {
  const JackettSearchScreen({
    super.key,
    required this.profile,
    required this.controller,
    this.jackettFactory,
    this.qbFactory,
  });
  final JackettProfile profile;
  final AppController controller;
  final JackettClient Function(JackettProfile)? jackettFactory;
  final QbClient Function(ServerProfile)? qbFactory;
  @override
  State<JackettSearchScreen> createState() => _JackettSearchScreenState();
}

class _JackettSearchScreenState extends State<JackettSearchScreen> {
  final query = TextEditingController();
  JackettClient? client;
  QbClient? activeQb;
  List<JackettResult> results = const [];
  final submitted = <String>{};
  final submittedHashes = <String>{};
  final blocked = <String>{};
  bool searching = false;
  bool adding = false;
  bool searched = false;
  _Notice? notice;
  ServerProfile? submissionTarget;
  int generation = 0;

  @override
  void dispose() {
    generation++;
    client?.close();
    activeQb?.close();
    query.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    if (searching || adding || query.text.trim().isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    final epoch = ++generation;
    setState(() {
      searching = true;
      searched = false;
      notice = null;
      results = const [];
    });
    try {
      client?.close();
      final service = client =
          widget.jackettFactory?.call(widget.profile) ??
          JackettClient(widget.profile);
      final found = await service.search(query.text.trim());
      if (mounted && epoch == generation) {
        setState(() {
          results = found;
          searched = true;
        });
      }
    } catch (_) {
      if (mounted && epoch == generation) {
        setState(() => notice = _Notice.searchFailed);
      }
    } finally {
      if (mounted && epoch == generation) setState(() => searching = false);
    }
  }

  void _message(_Notice value) {
    if (mounted) setState(() => notice = value);
  }

  Future<void> _add(JackettResult result) async {
    if (adding) return;
    final c = widget.controller;
    final target = c.currentProfile;
    if (target == null) {
      _message(_Notice.noTarget);
      return;
    }
    // Capture the exact endpoint and identity before any asynchronous work.
    final endpoint = c.connectionUrl ?? target.url;
    if (c.requiresAuthentication ||
        blocked.contains('${target.id}\n$endpoint')) {
      _message(_Notice.downloadFailed);
      return;
    }
    final key =
        '${target.id}\n$endpoint\n${result.magnetUri ?? result.downloadUri}';
    if (submitted.contains(key)) {
      _message(_Notice.duplicate);
      return;
    }
    final QbClient qb;
    try {
      qb = activeQb =
          widget.qbFactory?.call(target.withUrl(endpoint)) ??
          QbClient(target.withUrl(endpoint));
    } catch (_) {
      _message(_Notice.downloadFailed);
      return;
    }
    Future<void>? login;
    Future<void> ready() => login ??= (() async {
      try {
        await qb.login();
      } catch (error) {
        await c.reportAuthenticationFailure(target, error);
        rethrow;
      }
    })();
    var posted = false;
    setState(() {
      adding = true;
      notice = null;
    });
    bool sameTarget() =>
        mounted &&
        identical(c.currentProfile, target) &&
        (c.connectionUrl ?? target.url) == endpoint;
    try {
      final request = await showDialog<AddTorrentRequest>(
        context: context,
        builder: (_) => AddTorrentDialog(
          controller: c,
          downloadTitle: safeSearchTitle(
            result.title,
            context.l10n.jackettUnknownValue,
          ),
          hideUrls: true,
          initialUrls: result.magnetUri?.toString() ?? '',
          filePayload: result.magnetUri == null,
          showFilePicker: false,
          targetProfile: target,
          loadSuggestions: (path) async {
            await ready();
            return qb.get(path);
          },
        ),
      );
      if (request == null || !mounted) return;
      if (!sameTarget()) {
        _message(_Notice.profileChanged);
        return;
      }
      await ready();
      final magnet = result.magnetUri;
      final bytes = magnet == null
          ? await client!.downloadTorrent(result)
          : null;
      if (!sameTarget()) {
        _message(_Notice.profileChanged);
        return;
      }
      final hashes = bytes == null
          ? magnetInfoHashes(magnet!.toString())
          : torrentInfoHashes(bytes);
      final identities = hashes
          .map((hash) => '${target.id}\n$endpoint\n$hash')
          .toSet();
      if (identities.any(submittedHashes.contains)) {
        _message(_Notice.duplicate);
        return;
      }
      final existing = await qb.getTorrents();
      if (!sameTarget()) {
        _message(_Notice.profileChanged);
        return;
      }
      if (existing.any(
        (torrent) => matchesTorrentIdentity(
          hashes,
          torrent.hash,
          allowTruncatedV2: true,
        ),
      )) {
        _message(_Notice.duplicate);
        return;
      }
      // Retain this marker even on a timeout: a mutation must never be replayed.
      submitted.add(key);
      submittedHashes.addAll(identities);
      posted = true;
      submissionTarget = target;
      if (bytes == null) {
        await qb.addUrls(magnet.toString(), options: request.options);
      } else {
        await qb.addTorrentFile(
          'download.torrent',
          bytes,
          options: request.options,
        );
      }
      _message(_Notice.added);
      if (sameTarget()) await c.refresh();
    } catch (error) {
      await c.reportAuthenticationFailure(target, error);
      if (error is QbAuthenticationException) {
        blocked.add('${target.id}\n$endpoint');
      }
      _message(posted ? _Notice.unknown : _Notice.downloadFailed);
    } finally {
      qb.close();
      activeQb = null;
      if (mounted) setState(() => adding = false);
    }
  }

  String _status(AppLocalizations l10n) => switch (notice) {
    _Notice.searchFailed => l10n.jackettSearchFailed,
    _Notice.downloadFailed => l10n.jackettDownloadFailed,
    _Notice.profileChanged => l10n.searchProfileChanged,
    _Notice.noTarget => l10n.jackettNoTarget,
    _Notice.duplicate => l10n.searchAlreadyAdded,
    _Notice.unknown => l10n.searchAddOutcomeUnknown,
    _Notice.added => l10n.torrentSubmitted,
    null => '',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.jackettSearchTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SearchResultsLayout(
            header: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.profile.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(l10n.searchResultUrlHidden),
                  const SizedBox(height: 12),
                  TextField(
                    controller: query,
                    decoration: InputDecoration(
                      labelText: l10n.jackettSearchHint,
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: searching || adding ? null : _search,
                    icon: const Icon(Icons.search),
                    label: Text(l10n.jackettSearchAction),
                  ),
                  if (searching || adding) const LinearProgressIndicator(),
                  if (notice != null) Text(_status(l10n)),
                  if (notice == _Notice.unknown || notice == _Notice.added)
                    TextButton(
                      onPressed: () {
                        final target = submissionTarget;
                        if (target != null &&
                            widget.controller.requestShowDownloads(target)) {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        } else {
                          _message(_Notice.profileChanged);
                        }
                      },
                      child: Text(l10n.viewDownloads),
                    ),
                  if (searched && results.isEmpty)
                    Text(l10n.jackettSearchEmpty),
                ],
              ),
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                title: Text(
                  safeSearchTitle(result.title, l10n.jackettUnknownValue),
                ),
                subtitle: Text(
                  l10n.message0180(
                    result.size?.toString() ?? l10n.jackettUnknownValue,
                    result.seeders?.toString() ?? l10n.jackettUnknownValue,
                    safeSearchTitle(result.indexer, l10n.jackettUnknownValue),
                  ),
                ),
                trailing: IconButton(
                  onPressed: adding || searching ? null : () => _add(result),
                  tooltip: l10n.jackettDownloadAction,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
