// fl_chart configuration is intentionally explicit so each axis and series
// option can be compared row-by-row with the other chart cards and with the
// fl_chart docs; default-matching arguments are kept for readability.
// ignore_for_file: avoid_redundant_argument_values

import 'dart:math' as math;

import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_colors.dart';
import 'package:blutdruck_tracker/core/widgets/app_card.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightChartCard extends ConsumerWidget {
  const WeightChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final period = ref.watch(periodProvider);
    return ref
        .watch(readingsStreamProvider)
        .when(
          data: (all) {
            final readings = all.where((reading) {
              return reading.weightKg != null &&
                  !reading.measuredAt.isBefore(period.start.toUtc()) &&
                  !reading.measuredAt.isAfter(period.end.toUtc());
            }).toList();
            if (readings.length < 2) {
              return const SizedBox.shrink();
            }
            return AppCard(
              title: l10n.weightChartTitle,
              child: _WeightLineChart(readings: readings),
            );
          },
          loading: () => const AppCard(child: AppLoadingView()),
          error: (error, stackTrace) => AppCard(
            child: AppErrorView(
              headline: l10n.overviewLoadErrorTitle,
              body: l10n.overviewLoadErrorBody,
            ),
          ),
        );
  }
}

class _WeightLineChart extends StatelessWidget {
  const _WeightLineChart({required this.readings});

  final List<BloodPressureReading> readings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    final sorted = readings.toList()
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));
    final spots = <FlSpot>[];
    for (var index = 0; index < sorted.length; index++) {
      spots.add(FlSpot(index.toDouble(), sorted[index].weightKg!));
    }
    final weights = sorted.map((reading) => reading.weightKg!).toList();
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minY: weights.reduce(math.min) - 1,
          maxY: weights.reduce(math.max) + 1,
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 44),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: math.max(1, (sorted.length / 4).ceil()).toDouble(),
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sorted.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    formatShortDate(l10n, sorted[index].measuredAt.toLocal()),
                    style: Theme.of(context).textTheme.labelSmall,
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              color: colors.info,
              isCurved: false,
              barWidth: 2,
              dotData: const FlDotData(show: true),
            ),
          ],
        ),
        duration: Duration.zero,
      ),
    );
  }
}
