import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_colors.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/utils/date_time_utils.dart';
import 'package:blutdruck_tracker/core/widgets/app_card.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/core/widgets/trend_icon.dart';
import 'package:blutdruck_tracker/features/insights/domain/entities/insight.dart';
import 'package:blutdruck_tracker/features/insights/domain/entities/insight_severity.dart';
import 'package:blutdruck_tracker/features/insights/domain/services/rule_based_insight_engine.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/bmi_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/metric_summary.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/statistics_result.dart';
import 'package:blutdruck_tracker/features/statistics/presentation/widgets/statistics_formatters.dart';
import 'package:blutdruck_tracker/features/status/presentation/screens/status_screen.dart'
    show CategoryExplanationCard;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statisticsTitle)),
      body: const StatisticsTabView(),
    );
  }
}

/// AppBar-less body for the Statistics view. Used both by [StatisticsScreen]
/// (when reached via the /statistics route) and by the Overview segmented
/// tabs (which swap content in place instead of pushing a route).
class StatisticsTabView extends StatelessWidget {
  const StatisticsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: const [
        _PeriodSelector(),
        SizedBox(height: AppSpacing.lg),
        _StatisticsBody(),
      ],
    );
  }
}

class _StatisticsBody extends ConsumerWidget {
  const _StatisticsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncStats = ref.watch(statisticsProvider);
    return asyncStats.when(
      loading: () => const AppLoadingView(),
      error: (error, stackTrace) => AppErrorView(
        headline: l10n.statisticsLoadErrorTitle,
        body: l10n.statisticsLoadErrorBody,
      ),
      data: (stats) {
        // Insights live on the Status tab now — Statistics keeps just the
        // numeric and classification cards.
        // The period date-range / entry-count summary card was removed at
        // user request: the period chips above already make the range
        // obvious, and the entry count was not actionable on its own.
        return Column(
          children: [
            KeyMetricsCard(stats: stats),
            const SizedBox(height: AppSpacing.lg),
            ClassificationCard(stats: stats),
            const SizedBox(height: AppSpacing.lg),
            const CategoryExplanationCard(),
            const SizedBox(height: AppSpacing.lg),
            const BmiCard(),
          ],
        );
      },
    );
  }
}

class _PeriodSelector extends ConsumerWidget {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final period = ref.watch(periodProvider);
    final now = ref.watch(clockProvider).now().toLocal();
    // Horizontal scroll keeps every chip on a single row at any width.
    // Wrap was previously breaking 'Custom' onto its own line on narrow
    // phones, which the user found confusing.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _PeriodChip(label: l10n.period7Days, days: 7, now: now),
          const SizedBox(width: AppSpacing.sm),
          _PeriodChip(label: l10n.period14Days, days: 14, now: now),
          const SizedBox(width: AppSpacing.sm),
          _PeriodChip(label: l10n.period30Days, days: 30, now: now),
          const SizedBox(width: AppSpacing.sm),
          _PeriodChip(label: l10n.period90Days, days: 90, now: now),
          const SizedBox(width: AppSpacing.sm),
          FilterChip(
            label: Text(l10n.periodCustom),
            selected: !_matchesPreset(period, now),
            onSelected: (_) async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 1, 12, 31),
                initialDateRange: period,
              );
              if (picked == null || !context.mounted) return;
              ref
                  .read(periodProvider.notifier)
                  .setRange(
                    DateTimeRange(
                      start: startOfLocalDay(picked.start),
                      end: endOfLocalDay(picked.end),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}

class _PeriodChip extends ConsumerWidget {
  const _PeriodChip({
    required this.label,
    required this.days,
    required this.now,
  });

  final String label;
  final int days;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = _presetRange(now, days);
    final period = ref.watch(periodProvider);
    return FilterChip(
      label: Text(label),
      selected:
          isSameLocalDay(period.start, range.start) &&
          isSameLocalDay(period.end, range.end),
      onSelected: (_) => ref.read(periodProvider.notifier).setRange(range),
    );
  }
}

DateTimeRange _presetRange(DateTime now, int days) {
  return DateTimeRange(
    start: startOfLocalDay(now).subtract(Duration(days: days - 1)),
    end: endOfLocalDay(now),
  );
}

bool _matchesPreset(DateTimeRange period, DateTime now) {
  return [7, 14, 30, 90].any((days) {
    final preset = _presetRange(now, days);
    return isSameLocalDay(period.start, preset.start) &&
        isSameLocalDay(period.end, preset.end);
  });
}

class KeyMetricsCard extends StatelessWidget {
  const KeyMetricsCard({required this.stats, super.key});

  final StatisticsResult stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      title: l10n.statisticsKeyMetricsTitle,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
          4: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              _HeaderCell(l10n.statisticsMetricLabel),
              _HeaderCell(l10n.statisticsMetricAverage),
              _HeaderCell(l10n.statisticsMetricMin),
              _HeaderCell(l10n.statisticsMetricMax),
              _HeaderCell(l10n.statisticsMetricTrend),
            ],
          ),
          _row(context, l10n.systolicLabel, stats.systolic),
          _row(context, l10n.diastolicLabel, stats.diastolic),
          _row(context, l10n.pulseLabel, stats.pulse),
          _row(context, l10n.pulsePressureLabel, stats.pulsePressure),
          _row(
            context,
            l10n.meanArterialPressureLabel,
            stats.meanArterialPressure,
          ),
        ],
      ),
    );
  }

  TableRow _row(BuildContext context, String label, MetricSummary summary) {
    final l10n = AppLocalizations.of(context);
    return TableRow(
      children: [
        _BodyCell(label),
        _BodyCell(formatMetricInt(l10n, summary.average)),
        _BodyCell(formatMetricInt(l10n, summary.min)),
        _BodyCell(formatMetricInt(l10n, summary.max)),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: TrendIcon(
              trend: summary.trend,
              label: trendLabel(l10n, summary.trend),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

class _BodyCell extends StatelessWidget {
  const _BodyCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class ClassificationCard extends StatelessWidget {
  const ClassificationCard({required this.stats, super.key});

  final StatisticsResult stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      title: l10n.statisticsClassificationTitle,
      trailing: IconButton(
        tooltip: l10n.statisticsClassificationOpenStatus,
        icon: const Icon(Icons.open_in_new),
        onPressed: () => context.go('/status'),
      ),
      child: stats.entryCount == 0
          ? Text(l10n.statusDistributionEmpty)
          : InkWell(
              onTap: () => context.go('/status'),
              child: _DistributionBar(distribution: stats.categoryDistribution),
            ),
    );
  }
}

class _DistributionBar extends StatelessWidget {
  const _DistributionBar({required this.distribution});

  final Map<BloodPressureCategory, int> distribution;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    final total = distribution.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) {
      return Text(l10n.statusDistributionEmpty);
    }
    const orderedCategories = BloodPressureCategory.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(AppRadii.chip)),
          child: SizedBox(
            height: 12,
            child: Row(
              children: [
                for (final category in orderedCategories)
                  if ((distribution[category] ?? 0) > 0)
                    Expanded(
                      flex: distribution[category]!,
                      child: ColoredBox(color: _colorFor(colors, category)),
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          children: [
            for (final category in orderedCategories)
              if ((distribution[category] ?? 0) > 0)
                _LegendEntry(
                  color: _colorFor(colors, category),
                  label: categoryLabel(l10n, category),
                  count: distribution[category]!,
                ),
          ],
        ),
      ],
    );
  }
}

class _LegendEntry extends StatelessWidget {
  const _LegendEntry({
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text('$label · $count', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

Color _colorFor(AppColors colors, BloodPressureCategory category) {
  return switch (category) {
    BloodPressureCategory.optimal ||
    BloodPressureCategory.normal => colors.success,
    BloodPressureCategory.highNormal => colors.caution,
    BloodPressureCategory.hypertensionGrade1 ||
    BloodPressureCategory.isolatedSystolic => colors.warn,
    BloodPressureCategory.hypertensionGrade2 ||
    BloodPressureCategory.hypertensionGrade3 ||
    BloodPressureCategory.hypotension => colors.alert,
  };
}

class BmiCard extends ConsumerWidget {
  const BmiCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(statisticsProvider).valueOrNull;
    final settings =
        ref.watch(settingsProvider).valueOrNull ?? AppSettings.defaults();
    if (stats == null) {
      return const SizedBox.shrink();
    }
    final bmi = stats.bmi;
    if (bmi == null) {
      if (settings.heightCm == null) {
        return AppCard(
          title: l10n.statisticsBmiProfileTitle,
          child: InkWell(
            onTap: () => context.go('/settings'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                l10n.statisticsBmiProfileLink,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }
    return AppCard(
      title: l10n.statisticsBmiTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.statisticsBmiCurrent),
              Text(
                _currentBmiLabel(l10n, bmi.currentBmi, bmi.category),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.statisticsBmiAverage),
              Text(formatBmi(bmi.averageBmi, l10n)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.statisticsBmiHelper,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

String _currentBmiLabel(
  AppLocalizations l10n,
  double? value,
  BmiCategory? category,
) {
  final formatted = formatBmi(value, l10n);
  if (category == null) return formatted;
  return '$formatted · ${_bmiCategoryLabel(l10n, category)}';
}

String _bmiCategoryLabel(AppLocalizations l10n, BmiCategory category) {
  return switch (category) {
    BmiCategory.underweight => l10n.bmiUnderweight,
    BmiCategory.normal => l10n.bmiNormal,
    BmiCategory.overweight => l10n.bmiOverweight,
    BmiCategory.obese => l10n.bmiObese,
  };
}

class InsightsCard extends ConsumerWidget {
  const InsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final asyncStats = ref.watch(statisticsProvider);
    final asyncReadings = ref.watch(readingsStreamProvider);
    final period = ref.watch(periodProvider);
    final stats = asyncStats.valueOrNull;
    final readings = asyncReadings.valueOrNull;
    if (stats == null || readings == null) {
      return const SizedBox.shrink();
    }
    final inPeriod = readings.where((reading) {
      return !reading.measuredAt.isBefore(period.start.toUtc()) &&
          !reading.measuredAt.isAfter(period.end.toUtc());
    }).toList();
    final insights = const RuleBasedInsightEngine().generate(
      stats: stats,
      readings: inPeriod,
      periodLength: period.end.difference(period.start),
      messages: _insightMessages(l10n),
    );
    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }
    return AppCard(
      title: l10n.statisticsInsightsTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final insight in insights)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _InsightTile(insight: insight),
            ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.insight});

  final Insight insight;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = switch (insight.severity) {
      InsightSeverity.warning => colors.warn,
      InsightSeverity.info => colors.info,
      InsightSeverity.neutral => colors.textMuted,
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                insight.title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(insight.body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

Map<String, String> _insightMessages(AppLocalizations l10n) {
  return {
    'insight.noData.title': l10n.insightNoDataTitle,
    'insight.noData.body': l10n.insightNoDataBody,
    'insight.fewEntries.title': l10n.insightFewEntriesTitle,
    'insight.fewEntries.body': l10n.insightFewEntriesBody,
    'insight.measureMoreOften.title': l10n.insightMeasureMoreOftenTitle,
    'insight.measureMoreOften.body': l10n.insightMeasureMoreOftenBody,
    'insight.bpRising.title': l10n.insightBpRisingTitle,
    'insight.bpRising.body': l10n.insightBpRisingBody,
    'insight.bpFalling.title': l10n.insightBpFallingTitle,
    'insight.bpFalling.body': l10n.insightBpFallingBody,
    'insight.frequentlyElevated.title': l10n.insightFrequentlyElevatedTitle,
    // Engine substitutes {count} and {total}; raw template intentional.
    'insight.frequentlyElevated.body': _insightFrequentlyElevatedTemplate(l10n),
    'insight.frequentlyLow.title': l10n.insightFrequentlyLowTitle,
    'insight.frequentlyLow.body': _insightFrequentlyLowTemplate(l10n),
    'insight.wellDocumented.title': l10n.insightWellDocumentedTitle,
    'insight.wellDocumented.body': l10n.insightWellDocumentedBody,
  };
}

// Templates with `{count}` / `{total}` placeholders are intentionally not
// resolved by AppLocalizations — the rule engine resolves them. We look up
// the resolved string with sentinel values, then revert them back to the
// placeholder form for the engine.
String _insightFrequentlyElevatedTemplate(AppLocalizations l10n) {
  final resolved = l10n.insightFrequentlyElevatedBody(
    _countSentinel,
    _totalSentinel,
  );
  return resolved
      .replaceAll('$_countSentinel', '{count}')
      .replaceAll('$_totalSentinel', '{total}');
}

String _insightFrequentlyLowTemplate(AppLocalizations l10n) {
  final resolved = l10n.insightFrequentlyLowBody(
    _countSentinel,
    _totalSentinel,
  );
  return resolved
      .replaceAll('$_countSentinel', '{count}')
      .replaceAll('$_totalSentinel', '{total}');
}

const int _countSentinel = 90001;
const int _totalSentinel = 90002;
