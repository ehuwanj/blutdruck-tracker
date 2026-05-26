import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Two-step destructive-confirmation flow per docs/specs/12-privacy-and-medical.md.
/// Both dialogs must be confirmed before any DB write happens.
Future<void> showDeleteAllDataDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = AppLocalizations.of(context);
  final firstOk = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.settingsDeleteAllConfirmTitle),
        content: Text(l10n.settingsDeleteAllConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.settingsDeleteAllConfirmAction),
          ),
        ],
      );
    },
  );
  if (firstOk != true || !context.mounted) return;

  final secondOk = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => const _DeleteAllChallengeDialog(),
  );
  if (secondOk != true) return;

  // Both confirmations passed. Wipe in a transaction, cancel pending
  // notifications, then invalidate the settings provider so the in-memory
  // AppSettings re-reads defaults from the now-empty table.
  await ref.read(dataWiperProvider).wipeAll();
  await ref.read(reminderSchedulerProvider).cancelAll();
  ref.invalidate(settingsProvider);

  if (!context.mounted) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(l10n.settingsDeleteAllCompleted)));
}

class _DeleteAllChallengeDialog extends StatefulWidget {
  const _DeleteAllChallengeDialog();

  @override
  State<_DeleteAllChallengeDialog> createState() =>
      _DeleteAllChallengeDialogState();
}

class _DeleteAllChallengeDialogState extends State<_DeleteAllChallengeDialog> {
  late final TextEditingController _controller;
  bool _matches = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() {
    final l10n = AppLocalizations.of(context);
    final matches = _controller.text.trim() == l10n.settingsDeleteAllChallenge;
    if (matches != _matches) {
      setState(() => _matches = matches);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.settingsDeleteAllSecondTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.settingsDeleteAllSecondBody),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: l10n.settingsDeleteAllChallenge,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancelButton),
        ),
        FilledButton(
          onPressed: _matches ? () => Navigator.of(context).pop(true) : null,
          child: Text(l10n.deleteButton),
        ),
      ],
    );
  }
}
