import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import 'jellyfin_client.dart';
import 'jellyfin_models.dart';

/// Read-only catalog. The caller persists/configures [profile] independently.
class JellyfinLibraryScreen extends StatefulWidget {
  const JellyfinLibraryScreen({
    super.key,
    required this.profile,
    this.clientFactory,
  });
  final JellyfinProfile profile;

  /// Allows an independently configured transport or local fixture in tests.
  final JellyfinClient Function(JellyfinProfile)? clientFactory;

  @override
  State<JellyfinLibraryScreen> createState() => _JellyfinLibraryScreenState();
}

class _JellyfinLibraryScreenState extends State<JellyfinLibraryScreen> {
  final _query = TextEditingController();
  JellyfinClient? _client;
  List<JellyfinItem> _items = const [];
  JellyfinErrorCode? _error;
  bool _loading = false;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void didUpdateWidget(covariant JellyfinLibraryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _client?.close();
      _client = null;
      _items = const [];
      _query.clear();
      _search();
    }
  }

  Future<void> _search() async {
    final generation = ++_generation;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final client = _client ??= (widget.clientFactory ?? JellyfinClient.new)(
        widget.profile,
      );
      final items = await client.search(_query.text);
      if (!mounted || generation != _generation) return;
      setState(() => _items = items);
    } catch (error) {
      if (!mounted || generation != _generation) return;
      setState(() {
        _items = const [];
        _error = error is JellyfinException
            ? error.code
            : JellyfinErrorCode.connection;
      });
    } finally {
      if (mounted && generation == _generation) {
        setState(() => _loading = false);
      }
    }
  }

  String _errorText(BuildContext context, JellyfinErrorCode code) =>
      switch (code) {
        JellyfinErrorCode.authentication =>
          context.l10n.jellyfinAuthenticationFailed,
        JellyfinErrorCode.invalidProfile => context.l10n.jellyfinInvalidProfile,
        JellyfinErrorCode.invalidResponse =>
          context.l10n.jellyfinInvalidResponse,
        JellyfinErrorCode.redirect => context.l10n.jellyfinRedirectBlocked,
        JellyfinErrorCode.connection => context.l10n.jellyfinConnectionFailed,
      };

  void _details(JellyfinItem item) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.title),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.year != null) Text('${item.year}'),
                if (item.overview?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  // Server content is plain text, never interpreted as HTML.
                  SelectableText(item.overview!),
                ],
                const SizedBox(height: 12),
                Text(context.l10n.jellyfinReadOnlyNotice),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.jellyfinClose),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.jellyfinLibraryTitle)),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.profile.name),
                const SizedBox(height: 8),
                Text(context.l10n.jellyfinReadOnlyNotice),
                const SizedBox(height: 12),
                TextField(
                  controller: _query,
                  maxLength: 500,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) {
                    if (!_loading) _search();
                  },
                  decoration: InputDecoration(
                    labelText: context.l10n.jellyfinSearchHint,
                    suffixIcon: IconButton(
                      onPressed: _loading ? null : _search,
                      tooltip: context.l10n.jellyfinSearchAction,
                      icon: const Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(
            child: _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_errorText(context, _error!)),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: _loading ? null : _search,
                            child: Text(context.l10n.jellyfinRetry),
                          ),
                        ],
                      ),
                    ),
                  )
                : _items.isEmpty && !_loading
                ? Center(child: Text(context.l10n.jellyfinEmptyLibrary))
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: item.year == null
                            ? null
                            : Text('${item.year}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _details(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    ),
  );

  @override
  void dispose() {
    _generation++;
    _client?.close();
    _query.dispose();
    super.dispose();
  }
}
