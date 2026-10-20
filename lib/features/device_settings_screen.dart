import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../services/device_services.dart';
import '../ui/language_picker.dart';

class DeviceSettingsScreen extends StatefulWidget {
  const DeviceSettingsScreen({super.key});
  @override
  State<DeviceSettingsScreen> createState() => _DeviceSettingsScreenState();
}

class _DeviceSettingsScreenState extends State<DeviceSettingsScreen> {
  bool failed = false;
  bool busy = false;
  Future<void> change(Future<void> Function() action) async {
    setState(() {
      busy = true;
      failed = false;
    });
    try {
      await action();
    } catch (_) {
      if (mounted) {
        setState(() => failed = true);
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.message0073)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const LanguagePicker(),
              if (busy) const LinearProgressIndicator(),
              if (failed)
                Text(
                  l10n.message0072,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              SwitchListTile(
                title: Text(l10n.message0074),
                subtitle: Text(l10n.message0075),
                value: DeviceServices.lockEnabled,
                onChanged: busy
                    ? null
                    : (value) => change(() async {
                        await DeviceServices.setLockEnabled(value);
                      }),
              ),
              SwitchListTile(
                title: Text(l10n.message0076),
                subtitle: Text(
                  Platform.isWindows || Platform.isMacOS
                      ? l10n.message0077
                      : l10n.message0078,
                ),
                value: DeviceServices.notificationsEnabled,
                onChanged: busy
                    ? null
                    : (value) => change(
                        () => DeviceServices.setNotificationsEnabled(value),
                      ),
              ),
              ListTile(
                title: Text(l10n.message0079),
                subtitle: Text(
                  l10n.message0080('${DeviceServices.pollingIntervalMinutes}'),
                ),
                trailing: const Icon(Icons.schedule),
                onTap: busy
                    ? null
                    : () async {
                        final input = TextEditingController(
                          text: '${DeviceServices.pollingIntervalMinutes}',
                        );
                        final value = await showDialog<int>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(ctx.l10n.message0081),
                            content: TextField(
                              controller: input,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                helperText: ctx.l10n.message0082,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(ctx.l10n.cancel),
                              ),
                              FilledButton(
                                onPressed: () {
                                  final n = int.tryParse(input.text);
                                  if (n != null && n >= 15 && n <= 1440) {
                                    Navigator.pop(ctx, n);
                                  }
                                },
                                child: Text(ctx.l10n.message0083),
                              ),
                            ],
                          ),
                        );
                        Future<void>.delayed(
                          const Duration(seconds: 1),
                          input.dispose,
                        );
                        if (value != null) {
                          await change(
                            () =>
                                DeviceServices.setPollingIntervalMinutes(value),
                          );
                        }
                      },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: Text(l10n.message0084),
                subtitle: Text(l10n.message0085),
              ),
              ListTile(
                leading: const Icon(Icons.lan_outlined),
                title: Text(l10n.message0086),
                subtitle: Text(l10n.message0087),
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(l10n.message0088),
                subtitle: Text(l10n.message0089),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
