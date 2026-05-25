import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/blood_pressure_chart_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/latest_reading_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/time_slot_chart_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/weight_chart_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.overviewTitle),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: SegmentedButton<_OverviewTab>(
              segments: [
                ButtonSegment(
                  value: _OverviewTab.history,
                  label: Text(l10n.overviewTabHistory),
                ),
                ButtonSegment(
                  value: _OverviewTab.statistics,
                  label: Text(l10n.overviewTabStatistics),
                ),
                ButtonSegment(
                  value: _OverviewTab.status,
                  label: Text(l10n.overviewTabStatus),
                ),
              ],
              selected: const {_OverviewTab.history},
              onSelectionChanged: (selection) {
                switch (selection.single) {
                  case _OverviewTab.history:
                    break;
                  case _OverviewTab.statistics:
                    context.go('/statistics');
                  case _OverviewTab.status:
                    context.go('/status');
                }
              },
            ),
          ),
          const Expanded(child: _HistoryTabContent()),
        ],
      ),
    );
  }
}

enum _OverviewTab { history, statistics, status }

class _HistoryTabContent extends StatelessWidget {
  const _HistoryTabContent();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: const [
        LatestReadingCard(),
        SizedBox(height: AppSpacing.lg),
        BloodPressureChartCard(),
        SizedBox(height: AppSpacing.lg),
        TimeSlotChartCard(),
        SizedBox(height: AppSpacing.lg),
        WeightChartCard(),
      ],
    );
  }
}
