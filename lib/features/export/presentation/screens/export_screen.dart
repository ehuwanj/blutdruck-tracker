import 'dart:io';

import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/utils/date_time_utils.dart';
import 'package:blutdruck_tracker/core/widgets/app_card.dart';
import 'package:blutdruck_tracker/core/widgets/app_empty_state.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/features/export/domain/entities/export_format.dart';
import 'package:blutdruck_tracker/features/export/domain/entities/export_record.dart';
import 'package:blutdruck_tracker/features/export/presentation/providers/export_form_provider.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class ExportScreen extends ConsumerWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final formState = ref.watch(exportFormProvider);
    final recents = ref.watch(recentExportsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exportTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.backButtonTooltip,
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          AppCard(
            title: l10n.exportPeriodLabel,
            child: _PeriodPicker(period: formState.period),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            title: l10n.exportFormatLabel,
            child: _FormatPicker(format: formState.format),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(child: _OptionsSection(state: formState)),
          const SizedBox(height: AppSpacing.lg),
          _GenerateButton(state: formState),
          const SizedBox(height: AppSpacing.xl),
          AppCard(
            title: l10n.exportHistoryTitle,
            child: recents.when(
              loading: () => const AppLoadingView(),
              error: (error, stackTrace) => AppErrorView(
                headline: l10n.statisticsLoadErrorTitle,
                body: l10n.statisticsLoadErrorBody,
              ),
              data: (records) {
                if (records.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.history,
                    headline: l10n.exportHistoryEmpty,
                    body: l10n.exportHistoryEmpty,
                  );
                }
                return Column(
                  children: [
                    for (final record in records) _HistoryTile(record: record),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodPicker extends ConsumerWidget {
  const _PeriodPicker({required this.period});

  final DateTimeRange period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return OutlinedButton.icon(
      icon: const Icon(Icons.date_range),
      label: Text(
        l10n.statisticsPeriodSummary(
          formatShortDate(l10n, period.start),
          formatShortDate(l10n, period.end),
        ),
      ),
      onPressed: () async {
        final now = ref.read(clockProvider).now().toLocal();
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(now.year - 5),
          lastDate: DateTime(now.year + 1, 12, 31),
          initialDateRange: period,
        );
        if (picked == null || !context.mounted) return;
        ref
            .read(exportFormProvider.notifier)
            .setPeriod(
              DateTimeRange(
                start: startOfLocalDay(picked.start),
                end: endOfLocalDay(picked.end),
              ),
            );
      },
    );
  }
}

class _FormatPicker extends ConsumerWidget {
  const _FormatPicker({required this.format});

  final ExportFormat format;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SegmentedButton<ExportFormat>(
      segments: [
        ButtonSegment(
          value: ExportFormat.csv,
          label: Text(l10n.exportFormatCsv),
        ),
        ButtonSegment(
          value: ExportFormat.pdf,
          label: Text(l10n.exportFormatPdf),
        ),
      ],
      selected: {format},
      onSelectionChanged: (selection) =>
          ref.read(exportFormProvider.notifier).setFormat(selection.single),
    );
  }
}

class _OptionsSection extends ConsumerWidget {
  const _OptionsSection({required this.state});

  final ExportFormState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        if (state.format == ExportFormat.csv)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.exportIncludeContextFields),
            value: state.includeContextFields,
            onChanged: (value) => ref
                .read(exportFormProvider.notifier)
                .setIncludeContextFields(value: value),
          )
        else
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.exportIncludeChartImage),
            value: state.includeChartImage,
            onChanged: (value) => ref
                .read(exportFormProvider.notifier)
                .setIncludeChartImage(value: value),
          ),
      ],
    );
  }
}

class _GenerateButton extends ConsumerWidget {
  const _GenerateButton({required this.state});

  final ExportFormState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return FilledButton.icon(
      onPressed: state.isGenerating
          ? null
          : () async {
              final messenger = ScaffoldMessenger.of(context);
              try {
                await ref
                    .read(exportFormProvider.notifier)
                    .generateAndShare(l10n);
                if (!context.mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.exportSavedMessage)),
                );
              } on Exception {
                if (!context.mounted) return;
                messenger.showSnackBar(
                  SnackBar(content: Text(l10n.statisticsLoadErrorBody)),
                );
              }
            },
      icon: state.isGenerating
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.ios_share),
      label: Text(
        state.isGenerating
            ? l10n.exportGeneratingMessage
            : l10n.exportGenerateAction,
      ),
    );
  }
}

class _HistoryTile extends ConsumerWidget {
  const _HistoryTile({required this.record});

  final ExportRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final formatLabel = record.format == ExportFormat.csv
        ? l10n.exportFormatCsv
        : l10n.exportFormatPdf;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        record.format == ExportFormat.csv
            ? Icons.description_outlined
            : Icons.picture_as_pdf_outlined,
      ),
      title: Text(
        '$formatLabel · '
        '${formatShortDate(l10n, record.periodFrom.toLocal())} – '
        '${formatShortDate(l10n, record.periodTo.toLocal())}',
      ),
      subtitle: Text(formatDateTime(l10n, record.createdAt.toLocal())),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: l10n.exportGenerateAction,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => Share.shareXFiles([XFile(record.filePath)]),
          ),
          IconButton(
            tooltip: l10n.deleteButton,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.exportDeleteRecordTitle),
          content: Text(l10n.exportDeleteRecordBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.deleteButton),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;
    final file = File(record.filePath);
    if (file.existsSync()) {
      try {
        await file.delete();
      } on FileSystemException {
        // Silent: the row is removed even if the file is gone or locked.
      }
    }
    await ref.read(exportHistoryRepositoryProvider).deleteById(record.id);
  }
}
