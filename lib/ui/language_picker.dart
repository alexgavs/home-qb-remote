import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/locale_controller.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({super.key});

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: LocaleController.instance,
    builder: (context, _) {
      final controller = LocaleController.instance;
      final selected = controller.languageCode;
      return ListTile(
        leading: const Icon(Icons.language),
        title: Text(context.l10n.languageTitle),
        subtitle: Text(
          selected == null
              ? context.l10n.systemLanguage
              : LocaleController.languageNames[selected]!,
        ),
        trailing: _saving
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
        onTap: _saving
            ? null
            : () async {
                final choice = await showDialog<String>(
                  context: context,
                  builder: (dialogContext) => SimpleDialog(
                    title: Text(dialogContext.l10n.languageTitle),
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(dialogContext, ''),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(dialogContext.l10n.systemLanguage),
                          subtitle: Text(
                            dialogContext.l10n.languageFollowSystemDescription,
                          ),
                          trailing: selected == null
                              ? const Icon(Icons.check)
                              : null,
                        ),
                      ),
                      for (final entry
                          in LocaleController.languageNames.entries)
                        SimpleDialogOption(
                          onPressed: () =>
                              Navigator.pop(dialogContext, entry.key),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.value,
                                  textDirection:
                                      {'he', 'ar'}.contains(entry.key)
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                ),
                              ),
                              if (selected == entry.key)
                                const Icon(Icons.check),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
                if (choice == null || !mounted) return;
                setState(() => _saving = true);
                try {
                  await controller.setLanguage(choice.isEmpty ? null : choice);
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.languageChangeFailed),
                      ),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _saving = false);
                }
              },
      );
    },
  );
}
