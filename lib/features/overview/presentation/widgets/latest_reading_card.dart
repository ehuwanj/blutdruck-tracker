import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/widgets/app_card.dart';
import 'package:blutdruck_tracker/core/widgets/app_empty_state.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/core/widgets/category_dot.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
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
              // Tap surface opens the last-7-entries bottom sheet. InkWell
              // (instead of GestureDetector) gives the standard Material
              // ripple feedback so the affordance is obvious.
              final count =
                  ref.watch(settingsProvider).valueOrNull?.recentEntriesCount ??
                  10;
              return InkWell(
                onTap: () => _showRecentEntriesSheet(context, count),
                borderRadius: BorderRadius.circular(AppRadii.card),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Semantics(
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
                        Row(
                          children: [
                            CategoryDot(
                              category: category,
                              label: categoryLabel(l10n, category),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _LatestNumbers(
                                reading: reading,
                                l10n: l10n,
                              ),
                            ),
                          ],
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
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.latestReadingTapHint(count),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
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

  void _showRecentEntriesSheet(BuildContext context, int count) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => _RecentEntriesSheet(count: count),
    );
  }
}

/// Inline "118 (Sys.) / 82 (Dia.)  67 (Pulse)" rendering. Pulse is
/// omitted when null. Uses headlineSmall so the values are still the
/// dominant visual element of the card.
class _LatestNumbers extends StatelessWidget {
  const _LatestNumbers({required this.reading, required this.l10n});

  final BloodPressureReading reading;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.headlineSmall;
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    Widget pair(int value, String label) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$value ', style: valueStyle),
            TextSpan(text: '($label)', style: labelStyle),
          ],
        ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      children: [
        pair(reading.systolic, l10n.latestReadingSystolicShort),
        Text('/', style: valueStyle),
        pair(reading.diastolic, l10n.latestReadingDiastolicShort),
        if (reading.pulse != null)
          pair(reading.pulse!, l10n.latestReadingPulseShort),
      ],
    );
  }
}

/// Bottom sheet listing the [count] most recent readings (count is the
/// `recentEntriesCount` setting, default 10). Tappable rows open the edit
/// screen for that reading. Reads directly from the readings stream so
/// the sheet stays in sync if data changes while it's open.
class _RecentEntriesSheet extends ConsumerWidget {
  const _RecentEntriesSheet({required this.count});

  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final readingsAsync = ref.watch(readingsStreamProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.lastRecentEntriesTitle(count),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            readingsAsync.when(
              data: (all) {
                if (all.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    child: Text(l10n.lastRecentEntriesEmpty),
                  );
                }
                // readingsStreamProvider already emits desc-by-measuredAt.
                final recent = all.take(count).toList();
                return Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: recent.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final reading = recent[index];
                      return _SheetRow(reading: reading, l10n: l10n);
                    },
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: AppLoadingView(),
              ),
              error: (error, stackTrace) => Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: AppErrorView(
                  headline: l10n.overviewLoadErrorTitle,
                  body: l10n.overviewLoadErrorBody,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetRow extends ConsumerWidget {
  const _SheetRow({required this.reading, required this.l10n});

  final BloodPressureReading reading;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(clockProvider).now().toLocal();
    final measuredAt = reading.measuredAt.toLocal();
    final pulse = reading.pulse;
    final summary = pulse == null
        ? '${reading.systolic} (${l10n.latestReadingSystolicShort}) / '
              '${reading.diastolic} (${l10n.latestReadingDiastolicShort})'
        : '${reading.systolic} (${l10n.latestReadingSystolicShort}) / '
              '${reading.diastolic} (${l10n.latestReadingDiastolicShort})  '
              '$pulse (${l10n.latestReadingPulseShort})';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(summary),
      subtitle: Text(formatRelativeTime(l10n, measuredAt, now)),
      trailing: Text(
        formatDateTime(l10n, measuredAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () {
        Navigator.of(context).pop();
        context.go('/readings/${reading.id}/edit');
      },
    );
  }
}
