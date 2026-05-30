import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/blood_pressure_chart_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/time_slot_chart_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/weight_chart_card.dart';
import 'package:blutdruck_tracker/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:blutdruck_tracker/features/status/presentation/screens/status_screen.dart';
import 'package:flutter/material.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  _OverviewTab _selected = _OverviewTab.status;

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
                  value: _OverviewTab.status,
                  label: Text(l10n.overviewTabStatus),
                ),
                ButtonSegment(
                  value: _OverviewTab.history,
                  label: Text(l10n.overviewTabHistory),
                ),
                ButtonSegment(
                  value: _OverviewTab.statistics,
                  label: Text(l10n.overviewTabStatistics),
                ),
              ],
              selected: {_selected},
              onSelectionChanged: (selection) {
                setState(() => _selected = selection.single);
              },
            ),
          ),
          // IndexedStack keeps the three tab subtrees alive so switching tabs
          // doesn't rebuild and lose scroll position / form state.
          Expanded(
            child: IndexedStack(
              index: _selected.index,
              children: const [
                StatusTabView(),
                _HistoryTabContent(),
                StatisticsTabView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum _OverviewTab { status, history, statistics }

class _HistoryTabContent extends StatelessWidget {
  const _HistoryTabContent();

  @override
  Widget build(BuildContext context) {
    // LatestReadingCard moved to the Status tab; History now focuses on
    // the trend charts (BP, time-slot, weight).
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: const [
        BloodPressureChartCard(),
        SizedBox(height: AppSpacing.lg),
        TimeSlotChartCard(),
        SizedBox(height: AppSpacing.lg),
        WeightChartCard(),
      ],
    );
  }
}
