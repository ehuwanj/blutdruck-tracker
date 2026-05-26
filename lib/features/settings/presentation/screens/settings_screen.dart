import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/locale_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/theme_mode_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/weight_unit.dart';
import 'package:blutdruck_tracker/features/settings/presentation/widgets/delete_all_data_dialog.dart';
import 'package:blutdruck_tracker/features/settings/presentation/widgets/height_setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(settingsProvider);
    final settings = settingsAsync.valueOrNull ?? AppSettings.defaults();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(l10n.settingsGroupProfile),
          HeightSettingTile(settings: settings),
          _SectionHeader(l10n.settingsGroupAppearance),
          _ThemeTile(settings: settings),
          _LanguageTile(settings: settings),
          _SectionHeader(l10n.settingsGroupUnits),
          _WeightUnitTile(settings: settings),
          _SectionHeader(l10n.settingsGroupTimeSlot),
          _SlotWidthTile(settings: settings),
          _SlotAutoToggle(settings: settings),
          _SlotStartTile(settings: settings),
          _SectionHeader(l10n.settingsGroupReminders),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: Text(l10n.remindersTitle),
            subtitle: Text(l10n.settingsRemindersOpen),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/reminders'),
          ),
          _SectionHeader(l10n.settingsGroupData),
          ListTile(
            leading: const Icon(Icons.ios_share),
            title: Text(l10n.exportTitle),
            subtitle: Text(l10n.settingsExportOpen),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/export'),
          ),
          ListTile(
            leading: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              l10n.settingsDeleteAllAction,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => showDeleteAllDataDialog(context, ref),
          ),
          _SectionHeader(l10n.settingsGroupPrivacy),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyTitle),
            subtitle: Text(l10n.settingsPrivacyOpen),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/privacy'),
          ),
          _SectionHeader(l10n.settingsGroupIntegrations),
          const _IntegrationTile(
            icon: Icons.health_and_safety_outlined,
            titleKey: _IntegrationTileKey.healthConnect,
          ),
          const _IntegrationTile(
            icon: Icons.watch_outlined,
            titleKey: _IntegrationTileKey.fitbit,
          ),
          const _IntegrationTile(
            icon: Icons.auto_awesome_outlined,
            titleKey: _IntegrationTileKey.llm,
          ),
          _SectionHeader(l10n.settingsGroupAbout),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.settingsAboutVersion),
            subtitle: Text(l10n.settingsAboutAppVersion),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: Text(l10n.settingsAboutLicenses),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appTitle,
              applicationVersion: l10n.settingsAboutAppVersion,
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ThemeTile extends ConsumerWidget {
  const _ThemeTile({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(Icons.brightness_6_outlined),
      title: Text(l10n.settingsThemeLabel),
      trailing: SegmentedButton<ThemeModeSetting>(
        segments: [
          ButtonSegment(
            value: ThemeModeSetting.system,
            label: Text(l10n.settingsThemeSystem),
          ),
          ButtonSegment(
            value: ThemeModeSetting.light,
            label: Text(l10n.settingsThemeLight),
          ),
          ButtonSegment(
            value: ThemeModeSetting.dark,
            label: Text(l10n.settingsThemeDark),
          ),
        ],
        selected: {settings.themeMode},
        onSelectionChanged: (selection) {
          ref
              .read(settingsProvider.notifier)
              .save(settings.copyWith(themeMode: selection.single));
        },
      ),
    );
  }
}

class _LanguageTile extends ConsumerWidget {
  const _LanguageTile({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(Icons.translate),
      title: Text(l10n.settingsLanguageLabel),
      trailing: DropdownButton<LocaleSetting>(
        value: settings.locale,
        onChanged: (locale) {
          if (locale == null) return;
          ref
              .read(settingsProvider.notifier)
              .save(settings.copyWith(locale: locale));
        },
        items: [
          DropdownMenuItem(
            value: LocaleSetting.system,
            child: Text(l10n.languageSystem),
          ),
          DropdownMenuItem(
            value: LocaleSetting.en,
            child: Text(l10n.languageEnglish),
          ),
          DropdownMenuItem(
            value: LocaleSetting.de,
            child: Text(l10n.languageGerman),
          ),
          DropdownMenuItem(
            value: LocaleSetting.zh,
            child: Text(l10n.languageChinese),
          ),
        ],
      ),
    );
  }
}

class _WeightUnitTile extends ConsumerWidget {
  const _WeightUnitTile({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(Icons.fitness_center_outlined),
      title: Text(l10n.settingsWeightUnitLabel),
      trailing: SegmentedButton<WeightUnit>(
        segments: [
          ButtonSegment(
            value: WeightUnit.kg,
            label: Text(l10n.settingsWeightUnitKg),
          ),
          ButtonSegment(
            value: WeightUnit.lb,
            label: Text(l10n.settingsWeightUnitLb),
          ),
        ],
        selected: {settings.weightUnit},
        onSelectionChanged: (selection) {
          ref
              .read(settingsProvider.notifier)
              .save(settings.copyWith(weightUnit: selection.single));
        },
      ),
    );
  }
}

class _SlotWidthTile extends ConsumerWidget {
  const _SlotWidthTile({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(Icons.schedule),
      title: Text(l10n.settingsSlotWidthLabel),
      trailing: DropdownButton<int>(
        value: settings.timeSlotWidthMinutes,
        onChanged: (value) {
          if (value == null) return;
          ref
              .read(settingsProvider.notifier)
              .save(settings.copyWith(timeSlotWidthMinutes: value));
        },
        items: [
          DropdownMenuItem(value: 60, child: Text(l10n.settingsSlotWidth1h)),
          DropdownMenuItem(value: 120, child: Text(l10n.settingsSlotWidth2h)),
          DropdownMenuItem(value: 180, child: Text(l10n.settingsSlotWidth3h)),
        ],
      ),
    );
  }
}

class _SlotAutoToggle extends ConsumerWidget {
  const _SlotAutoToggle({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final autoSelected = settings.pinnedTimeSlotStartMinutes == null;
    return SwitchListTile(
      secondary: const Icon(Icons.auto_mode),
      title: Text(l10n.settingsSlotAutoToggle),
      value: autoSelected,
      onChanged: (value) {
        // Clearing the pinned start re-enables auto-detect; the dependent
        // _SlotStartTile disables itself when auto is on.
        final updated = settings.copyWith(
          pinnedTimeSlotStartMinutes: value ? null : 7 * 60,
        );
        ref.read(settingsProvider.notifier).save(updated);
      },
    );
  }
}

class _SlotStartTile extends ConsumerWidget {
  const _SlotStartTile({required this.settings});
  final AppSettings settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pinned = settings.pinnedTimeSlotStartMinutes;
    final enabled = pinned != null;
    final subtitle = pinned == null
        ? l10n.settingsSlotStartUnset
        : _formatTime(pinned);
    return ListTile(
      leading: const Icon(Icons.alarm_on_outlined),
      title: Text(l10n.settingsSlotStartLabel),
      subtitle: Text(subtitle),
      enabled: enabled,
      onTap: enabled
          ? () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(hour: pinned ~/ 60, minute: pinned % 60),
              );
              if (picked == null || !context.mounted) return;
              await ref
                  .read(settingsProvider.notifier)
                  .save(
                    settings.copyWith(
                      pinnedTimeSlotStartMinutes:
                          picked.hour * 60 + picked.minute,
                    ),
                  );
            }
          : null,
    );
  }

  String _formatTime(int minutes) {
    final hh = (minutes ~/ 60).toString().padLeft(2, '0');
    final mm = (minutes % 60).toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

enum _IntegrationTileKey { healthConnect, fitbit, llm }

class _IntegrationTile extends StatelessWidget {
  const _IntegrationTile({required this.icon, required this.titleKey});

  final IconData icon;
  final _IntegrationTileKey titleKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (titleKey) {
      _IntegrationTileKey.healthConnect =>
        l10n.settingsIntegrationsHealthConnect,
      _IntegrationTileKey.fitbit => l10n.settingsIntegrationsFitbit,
      _IntegrationTileKey.llm => l10n.settingsIntegrationsLlm,
    };
    return ListTile(
      enabled: false,
      leading: Icon(icon),
      title: Text(title),
      trailing: Chip(
        label: Text(l10n.settingsIntegrationsComingSoon),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
