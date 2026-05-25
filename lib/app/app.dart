import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/router.dart';
import 'package:blutdruck_tracker/app/theme/app_theme.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/locale_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/theme_mode_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlutdruckTrackerApp extends ConsumerWidget {
  const BlutdruckTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).valueOrNull;
    // Re-schedule notifications whenever the reminder list emits a new
    // value (initial app-start emission, plus any add/edit/delete writes
    // that flow through the Drift stream). Spec 08 §Local reminders.
    ref.listen(remindersStreamProvider, (previous, next) {
      final reminders = next.valueOrNull;
      if (reminders == null) return;
      ref.read(reminderSchedulerProvider).scheduleAll(reminders);
    });
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings?.themeMode.toThemeMode() ?? ThemeMode.system,
      locale: settings?.locale.toLocale(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}

extension on ThemeModeSetting {
  ThemeMode toThemeMode() {
    return switch (this) {
      ThemeModeSetting.system => ThemeMode.system,
      ThemeModeSetting.light => ThemeMode.light,
      ThemeModeSetting.dark => ThemeMode.dark,
    };
  }
}

extension on LocaleSetting {
  Locale? toLocale() {
    return switch (this) {
      LocaleSetting.system => null,
      LocaleSetting.en => const Locale('en'),
      LocaleSetting.de => const Locale('de'),
      LocaleSetting.zh => const Locale('zh'),
    };
  }
}
