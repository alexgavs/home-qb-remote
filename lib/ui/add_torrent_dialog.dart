import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../core/models.dart';
import '../features/search_session.dart' show safeSearchTitle;
import '../l10n/l10n.dart';

class AddTorrentRequest {
  const AddTorrentRequest(
    this.urls,
    this.file,
    this.options, {
    this.targetProfile,
  });
  final String urls;
  final bool file;
  final Map<String, String> options;
  final ServerProfile? targetProfile;
}

class AddTorrentDialog extends StatefulWidget {
  const AddTorrentDialog({
    super.key,
    required this.controller,
    this.initialUrls = '',
    this.downloadTitle,
    this.hideUrls = false,
    this.filePayload = false,
    this.showFilePicker = true,
    this.targetProfile,
    this.loadSuggestions,
  });
  final AppController controller;
  final String initialUrls;
  final String? downloadTitle;
  final bool hideUrls, filePayload, showFilePicker;
  final ServerProfile? targetProfile;
  final Future<dynamic> Function(String endpoint)? loadSuggestions;
  @override
  State<AddTorrentDialog> createState() => _AddTorrentDialogState();
}

class _AddTorrentDialogState extends State<AddTorrentDialog> {
  final form = GlobalKey<FormState>();
  final fields = <String, TextEditingController>{
    for (final key in [
      'urls',
      'savepath',
      'category',
      'tags',
      'rename',
      'dlLimit',
      'upLimit',
    ])
      key: TextEditingController(),
  };
  bool stopped = false, autoTmm = false, sequential = false, firstLast = false;
  String layout = 'Original';
  List<String> categories = [], tags = [];
  late final ServerProfile? target;
  bool profileChanged = false, submitted = false;

  @override
  void initState() {
    super.initState();
    target = widget.targetProfile ?? widget.controller.currentProfile;
    fields['urls']!.text = widget.initialUrls;
    widget.controller.addListener(_profileChanged);
    _defaults();
  }

  void _profileChanged() {
    if (!identical(widget.controller.currentProfile, target) &&
        !profileChanged) {
      setState(() => profileChanged = true);
    }
  }

  Future<void> _defaults() async {
    // Suggestions are optional; the form remains usable if any endpoint fails.
    await Future.wait([
      _suggest('app/defaultSavePath', (value) {
        if (fields['savepath']!.text.isEmpty) {
          fields['savepath']!.text = '$value';
        }
      }),
      _suggest('torrents/categories', (value) {
        if (value is Map) categories = value.keys.map((key) => '$key').toList();
      }),
      _suggest('torrents/tags', (value) {
        if (value is List) tags = value.map((tag) => '$tag').toList();
      }),
    ]);
  }

  Future<void> _suggest(String endpoint, void Function(dynamic) apply) async {
    try {
      if (profileChanged) return;
      final value =
          await (widget.loadSuggestions?.call(endpoint) ??
              widget.controller.apiGet(endpoint));
      if (mounted &&
          !profileChanged &&
          identical(widget.controller.currentProfile, target)) {
        setState(() => apply(value));
      }
    } catch (error) {
      if (target != null) {
        await widget.controller.reportAuthenticationFailure(target!, error);
      }
      // Older servers may not provide suggestions.
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_profileChanged);
    for (final field in fields.values) {
      field.dispose();
    }
    super.dispose();
  }

  void submit(bool file) {
    if (widget.controller.requiresAuthentication ||
        submitted ||
        profileChanged ||
        !identical(widget.controller.currentProfile, target)) {
      return;
    }
    if (!form.currentState!.validate()) return;
    if (!file && fields['urls']!.text.trim().isEmpty) return;
    final version = widget.controller.version ?? '';
    final major = int.tryParse(
      version.replaceFirst(RegExp(r'^[vV]'), '').split('.').first,
    );
    final options = <String, String>{
      (major != null && major >= 5 ? 'stopped' : 'paused'): '$stopped',
      'autoTMM': '$autoTmm',
      'sequentialDownload': '$sequential',
      'firstLastPiecePrio': '$firstLast',
      'contentLayout': layout,
      for (final entry in fields.entries)
        if (entry.key != 'urls' && entry.value.text.trim().isNotEmpty)
          entry.key: (entry.key == 'dlLimit' || entry.key == 'upLimit')
              ? '${int.parse(entry.value.text.trim()) * 1024}'
              : entry.value.text.trim(),
    };
    submitted = true;
    Navigator.pop(
      context,
      AddTorrentRequest(
        fields['urls']!.text.trim(),
        file,
        options,
        targetProfile: target,
      ),
    );
  }

  Widget text(
    String key,
    String label, {
    String? hint,
    bool number = false,
    String? numberError,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: fields[key],
      keyboardType: number ? TextInputType.number : null,
      decoration: InputDecoration(labelText: label, helperText: hint),
      validator: number
          ? (value) {
              if (value == null || value.trim().isEmpty) return null;
              final parsed = int.tryParse(value.trim());
              return parsed == null || parsed < 0 ? numberError : null;
            }
          : null,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(
        widget.downloadTitle == null
            ? l10n.message0459
            : l10n.searchDownloadConfirmTitle,
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (target != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(l10n.searchDownloadTarget(target!.name)),
                  ),
                if (profileChanged) Text(l10n.searchProfileChanged),
                if (widget.downloadTitle != null)
                  Text(safeSearchTitle(widget.downloadTitle, l10n.message0109)),
                if (widget.hideUrls) ...[
                  const SizedBox(height: 12),
                  Text(l10n.searchDownloadDataNotice),
                ] else
                  TextFormField(
                    controller: fields['urls'],
                    minLines: 3,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: l10n.message0460,
                      hintText: l10n.message0461,
                    ),
                  ),
                const SizedBox(height: 12),
                if (widget.showFilePicker)
                  OutlinedButton.icon(
                    onPressed: profileChanged ? null : () => submit(true),
                    icon: const Icon(Icons.upload_file_outlined),
                    label: Text(l10n.message0462),
                  ),
                ExpansionTile(
                  initiallyExpanded: widget.hideUrls,
                  tilePadding: EdgeInsets.zero,
                  title: Text(l10n.message0463),
                  children: [
                    text('savepath', l10n.message0197),
                    text('category', l10n.message0148),
                    if (categories.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        children: categories
                            .map(
                              (value) => ActionChip(
                                label: Text(value),
                                onPressed: () =>
                                    fields['category']!.text = value,
                              ),
                            )
                            .toList(),
                      ),
                    text('tags', l10n.message0464),
                    if (tags.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        children: tags
                            .map(
                              (value) => ActionChip(
                                label: Text(value),
                                onPressed: () {
                                  final current =
                                      fields['tags']!.text
                                          .split(',')
                                          .map((e) => e.trim())
                                          .where((e) => e.isNotEmpty)
                                          .toSet()
                                        ..add(value);
                                  fields['tags']!.text = current.join(',');
                                },
                              ),
                            )
                            .toList(),
                      ),
                    text('rename', l10n.message0465),
                    text(
                      'dlLimit',
                      l10n.message0466,
                      hint: l10n.message0467,
                      number: true,
                      numberError: l10n.message0458,
                    ),
                    text(
                      'upLimit',
                      l10n.message0468,
                      hint: l10n.message0467,
                      number: true,
                      numberError: l10n.message0458,
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: layout,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: l10n.message0469),
                      items: [
                        DropdownMenuItem(
                          value: 'Original',
                          child: Text(l10n.message0470),
                        ),
                        DropdownMenuItem(
                          value: 'Subfolder',
                          child: Text(l10n.message0471),
                        ),
                        DropdownMenuItem(
                          value: 'NoSubfolder',
                          child: Text(l10n.message0472),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => layout = value ?? 'Original'),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.message0473),
                      value: stopped,
                      onChanged: (value) => setState(() => stopped = value),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.message0254),
                      value: autoTmm,
                      onChanged: (value) => setState(() => autoTmm = value),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.message0474),
                      value: sequential,
                      onChanged: (value) => setState(() => sequential = value),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.message0475),
                      value: firstLast,
                      onChanged: (value) => setState(() => firstLast = value),
                    ),
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
          onPressed:
              profileChanged ||
                  submitted ||
                  widget.controller.requiresAuthentication
              ? null
              : () => submit(widget.filePayload),
          child: Text(
            widget.downloadTitle == null
                ? l10n.message0100
                : l10n.searchConfirmAdd,
          ),
        ),
      ],
    );
  }
}
