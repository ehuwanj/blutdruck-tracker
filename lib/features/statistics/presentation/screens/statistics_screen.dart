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
        // numeric and classification cards. The "What do the categories
        // mean?" expansion card was removed at user request; the
        // ClassificationCard's distribution bar is now tappable and opens
        // the same explanation as a bottom sheet.
        return Column(
          children: [
            KeyMetricsCard(stats: stats),
            const SizedBox(height: AppSpacing.lg),
            ClassificationCard(stats: stats),
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
    // Connected SegmentedButton matches the Overview tabs visual style.
    // The 14d preset was dropped at user request.
    return SegmentedButton<_PeriodChoice>(
      segments: [
        ButtonSegment(
          value: _PeriodChoice.days7,
          label: Text(l10n.period7Days),
        ),
        ButtonSegment(
          value: _PeriodChoice.days30,
          label: Text(l10n.period30Days),
        ),
        ButtonSegment(
          value: _PeriodChoice.days90,
          label: Text(l10n.period90Days),
        ),
        ButtonSegment(
          value: _PeriodChoice.custom,
          label: Text(l10n.periodCustom),
        ),
      ],
      selected: {_choiceFor(period, now)},
      showSelectedIcon: false,
      onSelectionChanged: (selection) async {
        final choice = selection.single;
        if (choice == _PeriodChoice.custom) {
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
          return;
        }
        ref
            .read(periodProvider.notifier)
            .setRange(_presetRange(now, _daysFor(choice)));
      },
    );
  }
}

enum _PeriodChoice { days7, days30, days90, custom }

int _daysFor(_PeriodChoice choice) {
  return switch (choice) {
    _PeriodChoice.days7 => 7,
    _PeriodChoice.days30 => 30,
    _PeriodChoice.days90 => 90,
    _PeriodChoice.custom => 0,
  };
}

_PeriodChoice _choiceFor(DateTimeRange period, DateTime now) {
  for (final choice in const [
    _PeriodChoice.days7,
    _PeriodChoice.days30,
    _PeriodChoice.days90,
  ]) {
    final preset = _presetRange(now, _daysFor(choice));
    if (isSameLocalDay(period.start, preset.start) &&
        isSameLocalDay(period.end, preset.end)) {
      return choice;
    }
  }
  return _PeriodChoice.custom;
}

DateTimeRange _presetRange(DateTime now, int days) {
  return DateTimeRange(
    start: startOfLocalDay(now).subtract(Duration(days: days - 1)),
    end: endOfLocalDay(now),
  );
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
      // The "open in Status" trailing icon was removed at user request —
      // the segmented button at the top of Overview already navigates
      // between tabs, so this was redundant. Tapping the distribution
      // now reveals the category-explanation bottom sheet (replacing the
      // standalone "What do the categories mean?" expansion card).
      child: stats.entryCount == 0
          ? Text(l10n.statusDistributionEmpty)
          : InkWell(
              onTap: () => _showCategoryExplanation(context),
              child: _DistributionBar(distribution: stats.categoryDistribution),
            ),
    );
  }
}

void _showCategoryExplanation(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) => const _CategoryExplanationSheet(),
  );
}

class _CategoryExplanationSheet extends StatelessWidget {
  const _CategoryExplanationSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.statusExplanationTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(l10n.statusExplanationIntro),
              const SizedBox(height: AppSpacing.md),
              for (final category in BloodPressureCategory.values)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          categoryLabel(l10n, category),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          _statusCategoryThresholdLabel(l10n, category),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _statusCategoryThresholdLabel(
  AppLocalizations l10n,
  BloodPressureCategory category,
) {
  return switch (category) {
    BloodPressureCategory.hypotension =>
      l10n.statusCategoryThresholdHypotension,
    BloodPressureCategory.optimal => l10n.statusCategoryThresholdOptimal,
    BloodPressureCategory.normal => l10n.statusCategoryThresholdNormal,
    BloodPressureCategory.highNormal => l10n.statusCategoryThresholdHighNormal,
    BloodPressureCategory.hypertensionGrade1 =>
      l10n.statusCategoryThresholdHypertensionGrade1,
    BloodPressureCategory.hypertensionGrade2 =>
      l10n.statusCategoryThresholdHypertensionGrade2,
    BloodPressureCategory.hypertensionGrade3 =>
      l10n.statusCategoryThresholdHypertensionGrade3,
    BloodPressureCategory.isolatedSystolic =>
      l10n.statusCategoryThresholdIsolatedSystolic,
  };
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
    // Single-value BMI now (weight is a setting, not per-reading), so the
    // card collapses to just the current value + WHO category + helper.
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
                _currentBmiLabel(l10n, bmi.bmi, bmi.category),
                style: Theme.of(context).textTheme.titleMedium,
              ),
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
