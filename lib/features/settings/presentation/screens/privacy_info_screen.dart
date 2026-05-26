import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacyInfoScreen extends ConsumerWidget {
  const PrivacyInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            l10n.disclaimerTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.disclaimerBody),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            icon: const Icon(Icons.replay),
            label: Text(l10n.privacyResetDisclaimerAction),
            onPressed: () => _resetDisclaimer(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _resetDisclaimer(BuildContext context, WidgetRef ref) async {
    final current = ref.read(settingsProvider).valueOrNull;
    if (current == null) return;
    // Construct fresh AppSettings so disclaimerAcceptedVersion becomes
    // explicit null (freezed copyWith can't pass null on nullable fields).
    final reset = AppSettings(
      locale: current.locale,
      themeMode: current.themeMode,
      weightUnit: current.weightUnit,
      remindersEnabled: current.remindersEnabled,
      timeSlotWidthMinutes: current.timeSlotWidthMinutes,
      heightCm: current.heightCm,
      pinnedTimeSlotStartMinutes: current.pinnedTimeSlotStartMinutes,
      lastExportDirectoryHint: current.lastExportDirectoryHint,
    );
    await ref.read(settingsProvider.notifier).save(reset);
  }
}
