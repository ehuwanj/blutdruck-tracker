import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/widgets/app_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/latest_reading_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
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

/// AppBar-less body for the Status view. Holds the at-a-glance pieces:
/// the latest reading card, the rule-based insights, the category
/// explanation, and the persistent disclaimer. Category distribution
/// lives in the Statistics tab now to avoid duplicating the same chart.
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
        _CategoryExplanationCard(),
        SizedBox(height: AppSpacing.lg),
        _PersistentDisclaimer(),
      ],
    );
  }
}

class _CategoryExplanationCard extends StatelessWidget {
  const _CategoryExplanationCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
            ),
            title: Text(
              l10n.statusExplanationTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(l10n.statusExplanationIntro),
              ),
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
                          _thresholdLabel(l10n, category),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
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

String _thresholdLabel(AppLocalizations l10n, BloodPressureCategory category) {
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
