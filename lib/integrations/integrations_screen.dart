import 'package:flutter/material.dart';

import '../app_controller.dart';
import '../l10n/l10n.dart';
import 'integration_store.dart';
import 'jackett_models.dart';
import 'jackett_screen.dart';
import 'jellyfin_models.dart';
import 'jellyfin_screen.dart';

class IntegrationsScreen extends StatefulWidget {
  const IntegrationsScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

class _IntegrationsScreenState extends State<IntegrationsScreen> {
  final store = IntegrationStore();
  bool loading = true;
  bool failed = false;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      failed = false;
    });
    try {
      await store.load();
    } catch (_) {
      failed = true;
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  Future<void> _write(Future<void> Function() action) async {
    setState(() => saving = true);
    try {
      await action();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.integrationStorageFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  Future<void> _edit({
    JackettProfile? jackett,
    JellyfinProfile? jellyfin,
    required bool isJackett,
  }) async {
    final result = await showDialog<_ProfileFields>(
      context: context,
      builder: (_) => _IntegrationProfileDialog(
        isJackett: isJackett,
        jackett: jackett,
        jellyfin: jellyfin,
      ),
    );
    if (result == null || !mounted) return;
    final id =
        jackett?.id ??
        jellyfin?.id ??
        DateTime.now().microsecondsSinceEpoch.toString();
    await _write(
      () => isJackett
          ? store.saveJackett(
              JackettProfile(
                id: id,
                name: result.name,
                url: result.url,
                apiKey: result.secret,
              ),
            )
          : store.saveJellyfin(
              JellyfinProfile(
                id: id,
                name: result.name,
                url: result.url,
                accessToken: result.secret,
                userId: result.userId,
              ),
            ),
    );
  }

  Future<void> _remove({
    JackettProfile? jackett,
    JellyfinProfile? jellyfin,
  }) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.integrationRemove),
        content: Text(l10n.integrationRemoveConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.integrationCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.integrationRemove),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await _write(
        () => jackett != null
            ? store.removeJackett(jackett.id)
            : store.removeJellyfin(jellyfin!.id),
      );
    }
  }

  Widget _entry({JackettProfile? jackett, JellyfinProfile? jellyfin}) {
    final l10n = context.l10n;
    return Card(
      child: ListTile(
        leading: Icon(
          jackett != null ? Icons.travel_explore : Icons.video_library_outlined,
        ),
        title: Text(jackett?.name ?? jellyfin!.name),
        // Never display connection URLs: their path can contain a proxy secret.
        subtitle: Text(jackett != null ? 'Jackett' : 'Jellyfin'),
        onTap: saving
            ? null
            : () => Navigator.push<void>(
                context,
                MaterialPageRoute(
                  builder: (_) => jackett != null
                      ? JackettSearchScreen(
                          profile: jackett,
                          controller: widget.controller,
                        )
                      : JellyfinLibraryScreen(profile: jellyfin!),
                ),
              ),
        trailing: PopupMenuButton<String>(
          enabled: !saving,
          onSelected: (value) {
            if (value == 'edit') {
              _edit(
                jackett: jackett,
                jellyfin: jellyfin,
                isJackett: jackett != null,
              );
            } else {
              _remove(jackett: jackett, jellyfin: jellyfin);
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'edit', child: Text(l10n.integrationEdit)),
            PopupMenuItem(value: 'remove', child: Text(l10n.integrationRemove)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.integrationsTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(l10n.integrationsNotice),
              const SizedBox(height: 16),
              if (loading || saving) const LinearProgressIndicator(),
              if (failed) ...[
                Text(l10n.integrationStorageFailed),
                TextButton(
                  onPressed: loading ? null : _load,
                  child: Text(l10n.integrationRetry),
                ),
              ],
              if (!loading && !failed) ...[
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: saving ? null : () => _edit(isJackett: true),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.integrationAddJackett),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: saving ? null : () => _edit(isJackett: false),
                      icon: const Icon(Icons.add),
                      label: Text(l10n.integrationAddJellyfin),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (store.jackett.isEmpty && store.jellyfin.isEmpty)
                  Text(l10n.integrationNoProfiles),
                for (final profile in store.jackett) _entry(jackett: profile),
                for (final profile in store.jellyfin) _entry(jellyfin: profile),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileFields {
  const _ProfileFields(this.name, this.url, this.secret, this.userId);
  final String name, url, secret, userId;
}

class _IntegrationProfileDialog extends StatefulWidget {
  const _IntegrationProfileDialog({
    required this.isJackett,
    this.jackett,
    this.jellyfin,
  });
  final bool isJackett;
  final JackettProfile? jackett;
  final JellyfinProfile? jellyfin;
  @override
  State<_IntegrationProfileDialog> createState() =>
      _IntegrationProfileDialogState();
}

class _IntegrationProfileDialogState extends State<_IntegrationProfileDialog> {
  final form = GlobalKey<FormState>();
  late final name = TextEditingController(
    text: widget.jackett?.name ?? widget.jellyfin?.name ?? '',
  );
  late final url = TextEditingController(
    text: widget.jackett?.url ?? widget.jellyfin?.url ?? '',
  );
  late final secret = TextEditingController(
    text: widget.jackett?.apiKey ?? widget.jellyfin?.accessToken ?? '',
  );
  late final userId = TextEditingController(
    text: widget.jellyfin?.userId ?? '',
  );

  @override
  void dispose() {
    for (final field in [name, url, secret, userId]) {
      field.dispose();
    }
    super.dispose();
  }

  bool get validUrl {
    final uri = Uri.tryParse(url.text.trim());
    return uri != null &&
        ['http', 'https'].contains(uri.scheme) &&
        uri.host.isNotEmpty &&
        uri.userInfo.isEmpty &&
        !uri.hasQuery &&
        !uri.hasFragment;
  }

  Widget field(
    TextEditingController controller,
    String label, {
    bool isSecret = false,
    bool isUrl = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextFormField(
      controller: controller,
      obscureText: isSecret,
      autocorrect: false,
      enableSuggestions: false,
      textDirection: isSecret || isUrl ? TextDirection.ltr : null,
      keyboardType: isUrl ? TextInputType.url : null,
      decoration: InputDecoration(labelText: label),
      validator: (value) => (value ?? '').trim().isEmpty || (isUrl && !validUrl)
          ? context.l10n.integrationInvalidProfile
          : null,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(
        widget.isJackett
            ? l10n.integrationAddJackett
            : l10n.integrationAddJellyfin,
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
                field(name, l10n.integrationName),
                field(url, l10n.integrationServerUrl, isUrl: true),
                field(
                  secret,
                  widget.isJackett
                      ? l10n.integrationApiKey
                      : l10n.integrationAccessToken,
                  isSecret: true,
                ),
                if (!widget.isJackett) field(userId, l10n.integrationUserId),
                Text(l10n.integrationSecretNotice),
                const SizedBox(height: 12),
                Text(l10n.integrationHttpNotice),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.integrationCancel),
        ),
        FilledButton(
          onPressed: () {
            if (form.currentState!.validate()) {
              Navigator.pop(
                context,
                _ProfileFields(
                  name.text.trim(),
                  url.text.trim(),
                  secret.text.trim(),
                  userId.text.trim(),
                ),
              );
            }
          },
          child: Text(l10n.integrationSave),
        ),
      ],
    );
  }
}
