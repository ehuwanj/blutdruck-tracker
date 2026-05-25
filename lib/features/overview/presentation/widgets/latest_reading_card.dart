import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/widgets/app_card.dart';
import 'package:blutdruck_tracker/core/widgets/app_empty_state.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/core/widgets/blood_pressure_value_display.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/blood_pressure_classifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LatestReadingCard extends ConsumerWidget {
  const LatestReadingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      title: l10n.latestReadingTitle,
      child: ref
          .watch(latestReadingProvider)
          .when(
            data: (reading) {
              if (reading == null) {
                return AppEmptyState(
                  icon: Icons.monitor_heart_outlined,
                  headline: l10n.latestReadingEmptyTitle,
                  body: l10n.latestReadingEmptyBody,
                  action: FilledButton(
                    onPressed: () => context.go('/readings/new'),
                    child: Text(l10n.latestReadingEmptyAction),
                  ),
                );
              }
              final category = const BloodPressureClassifier().classify(
                systolic: reading.systolic,
                diastolic: reading.diastolic,
              );
              final now = ref.watch(clockProvider).now().toLocal();
              final measuredAt = reading.measuredAt.toLocal();
              final absoluteTime = formatDateTime(l10n, measuredAt);
              return Semantics(
                label: l10n.latestReadingSemanticLabel(
                  reading.systolic,
                  reading.diastolic,
                  reading.pulse ?? 0,
                  categoryLabel(l10n, category),
                  formatRelativeTime(l10n, measuredAt, now),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BloodPressureValueDisplay(
                      systolic: reading.systolic,
                      diastolic: reading.diastolic,
                      pulse: reading.pulse,
                      pulseLabel: l10n.pulseLabel,
                      category: category,
                      categoryLabel: categoryLabel(l10n, category),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      categoryLabel(l10n, category),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Tooltip(
                      message: absoluteTime,
                      child: Text(
                        formatRelativeTime(l10n, measuredAt, now),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
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
