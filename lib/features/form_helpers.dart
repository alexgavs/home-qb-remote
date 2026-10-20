import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

class FormFieldSpec {
  const FormFieldSpec(
    this.keyName,
    this.label, {
    this.value = '',
    this.multiline = false,
    this.required = false,
    this.numeric = false,
    this.validate,
  });
  final String keyName;
  final String label;
  final String value;
  final bool multiline;
  final bool required;
  final bool numeric;
  final String? Function(String)? validate;
}

Future<Map<String, String>?> askFields(
  BuildContext context,
  String title,
  List<FormFieldSpec> fields, {
  String? description,
}) => showDialog<Map<String, String>>(
  context: context,
  builder: (_) =>
      _FieldsDialog(title: title, fields: fields, description: description),
);

class _FieldsDialog extends StatefulWidget {
  const _FieldsDialog({
    required this.title,
    required this.fields,
    this.description,
  });
  final String title;
  final List<FormFieldSpec> fields;
  final String? description;
  @override
  State<_FieldsDialog> createState() => _FieldsDialogState();
}

class _FieldsDialogState extends State<_FieldsDialog> {
  final _key = GlobalKey<FormState>();
  late final _controllers = {
    for (final field in widget.fields)
      field.keyName: TextEditingController(text: field.value),
  };
  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.description != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Text(widget.description!),
                  ),
                for (final field in widget.fields)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TextFormField(
                      controller: _controllers[field.keyName],
                      minLines: field.multiline ? 3 : 1,
                      maxLines: field.multiline ? 7 : 1,
                      keyboardType: field.numeric
                          ? const TextInputType.numberWithOptions(
                              signed: true,
                              decimal: true,
                            )
                          : field.multiline
                          ? TextInputType.multiline
                          : TextInputType.text,
                      decoration: InputDecoration(
                        labelText: field.label,
                        alignLabelWithHint: field.multiline,
                      ),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (field.required && text.isEmpty) {
                          return l10n.message0090;
                        }
                        return field.validate?.call(text);
                      },
                    ),
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
            if (!_key.currentState!.validate()) return;
            Navigator.pop(
              context,
              _controllers.map(
                (key, value) => MapEntry(key, value.text.trim()),
              ),
            );
          },
          child: Text(l10n.message0044),
        ),
      ],
    );
  }
}

Future<bool> confirmAction(
  BuildContext context,
  String title,
  String text,
) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.message0043),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.message0091),
          ),
        ],
      ),
    ) ??
    false;

/// Validates a non-negative integer. UI callers must pass [l10n]; the English
/// fallback exists only for pure (non-widget) tests.
String? nonnegativeInteger(String value, {AppLocalizations? l10n}) =>
    (int.tryParse(value) ?? -1) < 0
    ? (l10n?.message0092 ?? 'Enter a whole number of zero or more')
    : null;

/// Formats a byte count with binary units. UI callers must pass [l10n]; the
/// English fallback exists only for pure (non-widget) tests.
String humanBytes(num value, {AppLocalizations? l10n}) {
  final units = l10n == null
      ? const ['B', 'KiB', 'MiB', 'GiB', 'TiB']
      : [
          l10n.message0093,
          l10n.message0094,
          l10n.message0095,
          l10n.message0096,
          l10n.message0097,
        ];
  var size = value.toDouble();
  var index = 0;
  while (size >= 1024 && index < units.length - 1) {
    size /= 1024;
    index++;
  }
  return '${size.toStringAsFixed(index == 0 ? 0 : 1)} ${units[index]}';
}
