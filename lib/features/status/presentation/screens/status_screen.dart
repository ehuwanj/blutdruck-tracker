import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/widgets/app_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/latest_reading_card.dart';
import 'package:blutdruck_tracker/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statusTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.backButtonTooltip,
          onPressed: () => context.go('/'),
        ),
      ),
      body: const StatusTabView(),
    );
  }
}

/// AppBar-less body for the Status view. The "What do the categories
/// mean?" expansion was removed at user request; the category explanation
/// is reachable by tapping the Category distribution on the Statistics
/// tab (it opens as a bottom sheet).
class StatusTabView extends StatelessWidget {
  const StatusTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xxl,
      ),
      children: const [
        LatestReadingCard(),
        SizedBox(height: AppSpacing.lg),
        InsightsCard(),
        SizedBox(height: AppSpacing.lg),
        _PersistentDisclaimer(),
      ],
    );
  }
}

class _PersistentDisclaimer extends StatelessWidget {
  const _PersistentDisclaimer();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      child: Text(
        l10n.disclaimerBody,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
