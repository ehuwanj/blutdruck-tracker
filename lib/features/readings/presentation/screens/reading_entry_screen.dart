import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/features/readings/presentation/providers/reading_form_provider.dart';
import 'package:blutdruck_tracker/features/readings/presentation/widgets/reading_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReadingEntryScreen extends ConsumerWidget {
  const ReadingEntryScreen({this.readingId, super.key});

  final String? readingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(readingFormNotifierProvider(readingId));
    final isEdit = readingId != null;
    return asyncState.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? l10n.editReadingTitle : l10n.addReadingTitle),
        ),
        body: const AppLoadingView(),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? l10n.editReadingTitle : l10n.addReadingTitle),
        ),
        body: AppErrorView(
          headline: l10n.formLoadErrorTitle,
          body: l10n.formLoadErrorBody,
        ),
      ),
      data: (state) => Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? l10n.editReadingTitle : l10n.addReadingTitle),
          actions: [
            if (isEdit)
              IconButton(
                tooltip: l10n.deleteButton,
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, ref, l10n),
              ),
          ],
        ),
        body: ReadingForm(state: state, readingId: readingId),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: state.canSubmit
                  ? () async {
                      final saved = await ref
                          .read(readingFormNotifierProvider(readingId).notifier)
                          .submit();
                      if (!context.mounted || !saved) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.readingSavedMessage)),
                      );
                      // The entry screen was reached via context.go() (FAB,
                      // empty-state CTA, history-row tap), which replaces the
                      // route stack — Navigator.maybePop() has nothing to pop.
                      // Send the user back to the overview explicitly.
                      context.go('/');
                    }
                  : null,
              child: Text(l10n.saveButton),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final id = readingId;
    if (id == null) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteReadingTitle),
        content: Text(l10n.deleteReadingBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.deleteButton),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(deleteReadingProvider).call(id);
      if (context.mounted) {
        context.go('/');
      }
    }
  }
}
