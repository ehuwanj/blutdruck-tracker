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
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_pick.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_series.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TimeSlotChartCard extends ConsumerWidget {
  const TimeSlotChartCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pick = ref.watch(timeSlotPickProvider);
    final series = ref.watch(timeSlotSeriesProvider);
    return AppCard(
      title: l10n.timeSlotChartTitle,
      trailing: pick.valueOrNull == null
          ? null
          : IconButton(
              tooltip: l10n.timeSlotSettingsTooltip,
              icon: const Icon(Icons.tune),
              onPressed: () =>
                  _showTimeSlotSheet(context, ref, pick.valueOrNull!),
            ),
      child: pick.when(
        data: (selected) {
          if (selected == null || selected.matchingReadings < 5) {
            return _TimeSlotHint(body: l10n.timeSlotChartHint);
          }
          return series.when(
            data: (chartSeries) {
              if (chartSeries == null || chartSeries.points.isEmpty) {
                return _TimeSlotHint(body: l10n.timeSlotChartHint);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_headerText(l10n, selected)),
                  const SizedBox(height: AppSpacing.lg),
                  _TimeSlotLineChart(series: chartSeries),
                ],
              );
            },
            loading: () => const AppLoadingView(),
            error: (error, stackTrace) => AppErrorView(
              headline: l10n.overviewLoadErrorTitle,
              body: l10n.overviewLoadErrorBody,
            ),
          );
        },
        loading: () => const AppLoadingView(),
        error: (error, stackTrace) => AppErrorView(
          headline: l10n.overviewLoadErrorTitle,
          body: l10n.overviewLoadErrorBody,
        ),
      ),
    );
  }
}

class _TimeSlotHint extends StatelessWidget {
  const _TimeSlotHint({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      icon: Icons.schedule,
      headline: AppLocalizations.of(context).timeSlotChartEmptyTitle,
      body: body,
    );
  }
}

class _TimeSlotLineChart extends StatelessWidget {
  const _TimeSlotLineChart({required this.series});

  final TimeSlotSeries series;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final points = series.points;
    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];
    for (var index = 0; index < points.length; index++) {
      systolicSpots.add(
        FlSpot(index.toDouble(), points[index].systolicAverage.toDouble()),
      );
      diastolicSpots.add(
        FlSpot(index.toDouble(), points[index].diastolicAverage.toDouble()),
      );
    }
    final minValue = points
        .map((point) => point.diastolicAverage)
        .reduce(math.min);
    final maxValue = points
        .map((point) => point.systolicAverage)
        .reduce(math.max);
    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: (minValue - 20).toDouble(),
          maxY: (maxValue + 20).toDouble(),
          gridData: const FlGridData(horizontalInterval: 20),
          borderData: FlBorderData(show: false),
          titlesData: _timeSlotTitles(context, series),
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

FlTitlesData _timeSlotTitles(BuildContext context, TimeSlotSeries series) {
  final l10n = AppLocalizations.of(context);
  final points = series.points;
  final bottomInterval = math.max(1, (points.length / 4).ceil()).toDouble();
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
          if (index < 0 || index >= points.length) {
            return const SizedBox.shrink();
          }
          return Text(
            formatShortDate(l10n, points[index].localDay),
            style: Theme.of(context).textTheme.labelSmall,
          );
        },
      ),
    ),
  );
}

String _headerText(AppLocalizations l10n, TimeSlotPick pick) {
  final widthHours = pick.slot.widthMinutes ~/ 60;
  final source = pick.isAutoDetected
      ? l10n.timeSlotSourceAuto
      : l10n.timeSlotSourcePinned;
  return l10n.timeSlotHeader(
    formatSlotRange(l10n, pick.slot.startMinutes, pick.slot.widthMinutes),
    widthHours,
    source,
  );
}

void _showTimeSlotSheet(
  BuildContext context,
  WidgetRef ref,
  TimeSlotPick pick,
) {
  showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) {
      return Consumer(
        builder: (context, ref, child) {
          final l10n = AppLocalizations.of(context);
          final settings = ref.watch(settingsProvider).valueOrNull;
          final autoSelected = settings?.pinnedTimeSlotStartMinutes == null;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: Text(l10n.timeSlotAutoToggle),
                    value: autoSelected,
                    onChanged: settings == null
                        ? null
                        : (enabled) =>
                              _setAutoMode(ref, settings, pick, enabled),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: Text(l10n.timeSlotSettingsLink),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      context.go('/settings');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> _setAutoMode(
  WidgetRef ref,
  AppSettings settings,
  TimeSlotPick pick,
  bool enabled,
) {
  return ref
      .read(settingsProvider.notifier)
      .save(
        settings.copyWith(
          pinnedTimeSlotStartMinutes: enabled ? null : pick.slot.startMinutes,
        ),
      );
}
