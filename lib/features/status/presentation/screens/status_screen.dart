import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_colors.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/widgets/app_card.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.statusTitle)),
      body: const StatusTabView(),
    );
  }
}

/// AppBar-less body for the Status view. Used both by [StatusScreen] (when
/// reached via the /status route) and by the Overview segmented tabs.
class StatusTabView extends ConsumerWidget {
  const StatusTabView({super.key});

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
        return ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            _DistributionCard(distribution: stats.categoryDistribution),
            const SizedBox(height: AppSpacing.lg),
            const _CategoryExplanationCard(),
            const SizedBox(height: AppSpacing.lg),
            const _PersistentDisclaimer(),
          ],
        );
      },
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.distribution});

  final Map<BloodPressureCategory, int> distribution;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    final total = distribution.values.fold<int>(0, (a, b) => a + b);
    return AppCard(
      title: l10n.statusDistributionTitle,
      child: total == 0
          ? Text(l10n.statusDistributionEmpty)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(AppRadii.chip),
                  ),
                  child: SizedBox(
                    height: 16,
                    child: Row(
                      children: [
                        for (final category in BloodPressureCategory.values)
                          if ((distribution[category] ?? 0) > 0)
                            Expanded(
                              flex: distribution[category]!,
                              child: ColoredBox(
                                color: _colorFor(colors, category),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _Legend(distribution: distribution),
              ],
            ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.distribution});

  final Map<BloodPressureCategory, int> distribution;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.xs,
      children: [
        for (final category in BloodPressureCategory.values)
          if ((distribution[category] ?? 0) > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _colorFor(colors, category),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${categoryLabel(l10n, category)} · '
                  '${distribution[category]}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
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
