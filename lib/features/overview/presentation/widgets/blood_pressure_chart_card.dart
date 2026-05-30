// fl_chart configuration is intentionally explicit so each axis and series
// option can be compared row-by-row with the other chart cards and with the
// fl_chart docs; default-matching arguments are kept for readability.
// ignore_for_file: avoid_redundant_argument_values

import 'dart:math' as math;

import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_colors.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/widgets/app_card.dart';
import 'package:blutdruck_tracker/core/widgets/app_empty_state.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BloodPressureChartCard extends ConsumerWidget {
  const BloodPressureChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final period = ref.watch(periodProvider);
    return AppCard(
      title: l10n.bloodPressureChartTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PeriodSelector(),
          const SizedBox(height: AppSpacing.lg),
          ref
              .watch(readingsStreamProvider)
              .when(
                data: (all) {
                  final readings = _filterReadings(all, period);
                  if (readings.isEmpty) {
                    return AppEmptyState(
                      icon: Icons.show_chart,
                      headline: l10n.chartEmptyTitle,
                      body: l10n.chartEmptyBody,
                    );
                  }
                  return _BloodPressureLineChart(readings: readings);
                },
                loading: () => const AppLoadingView(),
                error: (error, stackTrace) => AppErrorView(
                  headline: l10n.overviewLoadErrorTitle,
                  body: l10n.overviewLoadErrorBody,
                ),
              ),
        ],
      ),
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
    // Connected SegmentedButton (matches the Overview tabs visual style).
    // 14d was dropped at user request; 7/30/90/Custom remain.
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
          ref.read(periodProvider.notifier).setRange(_fullLocalDays(picked));
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
    if (_sameLocalDay(period.start, preset.start) &&
        _sameLocalDay(period.end, preset.end)) {
      return choice;
    }
  }
  return _PeriodChoice.custom;
}

class _BloodPressureLineChart extends StatelessWidget {
  const _BloodPressureLineChart({required this.readings});

  final List<BloodPressureReading> readings;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final sorted = readings.toList()
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];
    for (var index = 0; index < sorted.length; index++) {
      systolicSpots.add(
        FlSpot(index.toDouble(), sorted[index].systolic.toDouble()),
      );
      diastolicSpots.add(
        FlSpot(index.toDouble(), sorted[index].diastolic.toDouble()),
      );
    }
    final minValue = sorted
        .map((reading) => reading.diastolic)
        .reduce(math.min);
    final maxValue = sorted.map((reading) => reading.systolic).reduce(math.max);
    final systolicAverage =
        sorted.map((reading) => reading.systolic).reduce((a, b) => a + b) /
        sorted.length;
    final diastolicAverage =
        sorted.map((reading) => reading.diastolic).reduce((a, b) => a + b) /
        sorted.length;
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: (minValue - 20).toDouble(),
          maxY: (maxValue + 20).toDouble(),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (spots) {
                final l10n = AppLocalizations.of(context);
                return spots.map((spot) {
                  final reading = sorted[spot.x.toInt()];
                  return LineTooltipItem(
                    '${formatDateTime(l10n, reading.measuredAt.toLocal())}\n'
                    '${l10n.systolicLabel}: ${reading.systolic}\n'
                    '${l10n.diastolicLabel}: ${reading.diastolic}',
                    Theme.of(context).textTheme.bodySmall!,
                  );
                }).toList();
              },
            ),
          ),
          gridData: const FlGridData(horizontalInterval: 20),
          titlesData: _chartTitles(context, sorted),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: systolicAverage,
                color: colors.info,
                strokeWidth: 1,
              ),
              HorizontalLine(
                y: diastolicAverage,
                color: colors.textMuted,
                strokeWidth: 1,
                dashArray: [6, 4],
              ),
            ],
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: systolicSpots,
              color: colors.info,
              isCurved: false,
              barWidth: 2,
              dotData: const FlDotData(show: true),
            ),
            LineChartBarData(
              spots: diastolicSpots,
              color: colors.textMuted,
              isCurved: false,
              barWidth: 2,
              dashArray: [8, 5],
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
        duration: Duration.zero,
      ),
    );
  }
}

FlTitlesData _chartTitles(
  BuildContext context,
  List<BloodPressureReading> readings,
) {
  final l10n = AppLocalizations.of(context);
  final bottomInterval = math.max(1, (readings.length / 4).ceil()).toDouble();
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 20),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 28,
        interval: bottomInterval,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          if (index < 0 || index >= readings.length) {
            return const SizedBox.shrink();
          }
          return Text(
            formatShortDate(l10n, readings[index].measuredAt.toLocal()),
            style: Theme.of(context).textTheme.labelSmall,
          );
        },
      ),
    ),
  );
}

List<BloodPressureReading> _filterReadings(
  List<BloodPressureReading> readings,
  DateTimeRange period,
) {
  return readings.where((reading) {
    return !reading.measuredAt.isBefore(period.start.toUtc()) &&
        !reading.measuredAt.isAfter(period.end.toUtc());
  }).toList();
}

DateTimeRange _presetRange(DateTime now, int days) {
  return DateTimeRange(
    start: DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: days - 1)),
    end: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
  );
}

DateTimeRange _fullLocalDays(DateTimeRange range) {
  return DateTimeRange(
    start: DateTime(range.start.year, range.start.month, range.start.day),
    end: DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
      23,
      59,
      59,
      999,
    ),
  );
}

bool _sameLocalDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
