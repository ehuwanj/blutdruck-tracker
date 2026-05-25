import 'package:blutdruck_tracker/app/disclaimer/disclaimer_dialog.dart';
import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/overview/presentation/screens/overview_screen.dart';
import 'package:blutdruck_tracker/features/readings/presentation/screens/reading_entry_screen.dart';
import 'package:blutdruck_tracker/features/readings/presentation/screens/reading_history_screen.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/locale_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const OverviewScreen()),
        GoRoute(
          path: '/history',
          builder: (context, state) => const ReadingHistoryScreen(),
        ),
        GoRoute(
          path: '/statistics',
          builder: (context, state) => PlaceholderScreen(
            title: AppLocalizations.of(context).statisticsTitle,
          ),
        ),
        GoRoute(
          path: '/status',
          builder: (context, state) => PlaceholderScreen(
            title: AppLocalizations.of(context).statusTitle,
          ),
        ),
        GoRoute(
          path: '/export',
          builder: (context, state) => PlaceholderScreen(
            title: AppLocalizations.of(context).exportTitle,
          ),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPlaceholderScreen(),
          routes: [
            GoRoute(
              path: 'reminders',
              builder: (context, state) => PlaceholderScreen(
                title: AppLocalizations.of(context).remindersTitle,
              ),
            ),
            GoRoute(
              path: 'privacy',
              builder: (context, state) => PlaceholderScreen(
                title: AppLocalizations.of(context).privacyTitle,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/readings/new',
          builder: (context, state) => const ReadingEntryScreen(),
        ),
        GoRoute(
          path: '/readings/:id/edit',
          builder: (context, state) =>
              ReadingEntryScreen(readingId: state.pathParameters['id']),
        ),
      ],
    ),
  ],
);

class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DisclaimerGate(child: child),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/readings/new'),
        tooltip: AppLocalizations.of(context).addReadingTitle,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(title, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class SettingsPlaceholderScreen extends ConsumerWidget {
  const SettingsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            SegmentedButton<LocaleSetting>(
              segments: [
                ButtonSegment(
                  value: LocaleSetting.system,
                  label: Text(l10n.languageSystem),
                ),
                ButtonSegment(
                  value: LocaleSetting.en,
                  label: Text(l10n.languageEnglish),
                ),
                ButtonSegment(
                  value: LocaleSetting.de,
                  label: Text(l10n.languageGerman),
                ),
                ButtonSegment(
                  value: LocaleSetting.zh,
                  label: Text(l10n.languageChinese),
                ),
              ],
              selected: {settings?.locale ?? LocaleSetting.system},
              onSelectionChanged: settings == null
                  ? null
                  : (selection) {
                      ref
                          .read(settingsProvider.notifier)
                          .save(settings.copyWith(locale: selection.single));
                    },
            ),
          ],
        ),
      ),
    );
  }
}
