import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/utils/date_time_utils.dart';
import 'package:blutdruck_tracker/core/widgets/app_empty_state.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/core/widgets/category_dot.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/blood_pressure_classifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Screen-local filter state. Independent of the global `periodProvider`
/// (see step 8 prompt): the history screen has its own filter so changing
/// the overview's date-range chips does not silently shift the history view.
final historyDateRangeProvider =
    NotifierProvider.autoDispose<HistoryDateRangeNotifier, DateTimeRange?>(
      HistoryDateRangeNotifier.new,
    );

class HistoryDateRangeNotifier extends AutoDisposeNotifier<DateTimeRange?> {
  @override
  DateTimeRange? build() => null;

  // ignore: use_setters_to_change_properties, action reads clearer at call sites.
  void setRange(DateTimeRange? range) => state = range;
}

class ReadingHistoryScreen extends ConsumerWidget {
  const ReadingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      // TODO(huangwj): category filter chips are out of scope for step 8.
      body: const Column(
        children: [
          _HistoryFilterBar(),
          Expanded(child: _HistoryList()),
        ],
      ),
    );
  }
}

class _HistoryFilterBar extends ConsumerWidget {
  const _HistoryFilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final range = ref.watch(historyDateRangeProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.date_range),
              label: Text(_filterLabel(l10n, range)),
              onPressed: () => _pickRange(context, ref, range),
            ),
          ),
          if (range != null) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: () =>
                  ref.read(historyDateRangeProvider.notifier).setRange(null),
              child: Text(l10n.historyFilterClear),
            ),
          ],
        ],
      ),
    );
  }

  String _filterLabel(AppLocalizations l10n, DateTimeRange? range) {
    if (range == null) {
      return l10n.historyFilterAllTime;
    }
    return l10n.historyFilterRange(
      formatShortDate(l10n, range.start),
      formatShortDate(l10n, range.end),
    );
  }

  Future<void> _pickRange(
    BuildContext context,
    WidgetRef ref,
    DateTimeRange? current,
  ) async {
    final now = ref.read(clockProvider).now().toLocal();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1, 12, 31),
      initialDateRange: current,
    );
    if (picked == null || !context.mounted) {
      return;
    }
    ref
        .read(historyDateRangeProvider.notifier)
        .setRange(
          DateTimeRange(
            start: startOfLocalDay(picked.start),
            end: endOfLocalDay(picked.end),
          ),
        );
  }
}

class _HistoryList extends ConsumerWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncReadings = ref.watch(readingsStreamProvider);
    final range = ref.watch(historyDateRangeProvider);
    return asyncReadings.when(
      loading: () => const AppLoadingView(),
      error: (error, stackTrace) => AppErrorView(
        headline: l10n.historyLoadErrorTitle,
        body: l10n.historyLoadErrorBody,
      ),
      data: (all) {
        final filtered = _applyFilter(all, range);
        if (filtered.isEmpty) {
          return AppEmptyState(
            icon: Icons.history,
            headline: l10n.historyEmptyTitle,
            body: l10n.historyEmptyBody,
            action: FilledButton(
              onPressed: () => context.go('/readings/new'),
              child: Text(l10n.historyEmptyAction),
            ),
          );
        }
        final groups = _groupByLocalDay(filtered);
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final entry = groups.entries.elementAt(index);
            return _HistoryDaySection(day: entry.key, readings: entry.value);
          },
        );
      },
    );
  }

  List<BloodPressureReading> _applyFilter(
    List<BloodPressureReading> readings,
    DateTimeRange? range,
  ) {
    if (range == null) {
      return readings;
    }
    final fromUtc = range.start.toUtc();
    final toUtc = range.end.toUtc();
    return readings.where((reading) {
      return !reading.measuredAt.isBefore(fromUtc) &&
          !reading.measuredAt.isAfter(toUtc);
    }).toList();
  }

  /// Returns a newest-day-first map of local-day → readings (each list
  /// sorted by measured time, newest first within the day).
  Map<DateTime, List<BloodPressureReading>> _groupByLocalDay(
    List<BloodPressureReading> readings,
  ) {
    final sorted = readings.toList()
      ..sort((a, b) {
        final byMeasured = b.measuredAt.compareTo(a.measuredAt);
        if (byMeasured != 0) return byMeasured;
        return b.createdAt.compareTo(a.createdAt);
      });
    final result = <DateTime, List<BloodPressureReading>>{};
    for (final reading in sorted) {
      final day = startOfLocalDay(reading.measuredAt);
      result.putIfAbsent(day, () => []).add(reading);
    }
    return result;
  }
}

class _HistoryDaySection extends StatelessWidget {
  const _HistoryDaySection({required this.day, required this.readings});

  final DateTime day;
  final List<BloodPressureReading> readings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dayLabel = DateFormat.yMMMMd(l10n.localeName).format(day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dayLabel, style: Theme.of(context).textTheme.titleMedium),
              Text(
                l10n.historyEntriesCount(readings.length),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        for (final reading in readings)
          _HistoryRow(key: ValueKey(reading.id), reading: reading),
        const Divider(height: 1),
      ],
    );
  }
}

class _HistoryRow extends ConsumerWidget {
  const _HistoryRow({required Key key, required this.reading})
    : super(key: key);

  final BloodPressureReading reading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final category = const BloodPressureClassifier().classify(
      systolic: reading.systolic,
      diastolic: reading.diastolic,
    );
    final time = formatTime(l10n, reading.measuredAt.toLocal());
    return Dismissible(
      key: ValueKey('dismiss-${reading.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.errorContainer,
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: AppSpacing.lg),
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      confirmDismiss: (_) => _confirmDelete(context, l10n),
      onDismissed: (_) async {
        await ref.read(deleteReadingProvider).call(reading.id);
      },
      child: ListTile(
        onTap: () => context.go('/readings/${reading.id}/edit'),
        title: Text('${reading.systolic} / ${reading.diastolic}'),
        subtitle: Text(
          reading.pulse == null
              ? time
              : '$time · ${l10n.historyPulseLabel(reading.pulse!)}',
        ),
        trailing: CategoryDot(
          category: category,
          label: categoryLabel(l10n, category),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteReadingTitle),
          content: Text(l10n.deleteReadingBody),
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
    return result ?? false;
  }
}
