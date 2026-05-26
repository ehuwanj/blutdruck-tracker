import 'package:blutdruck_tracker/app/disclaimer/disclaimer_dialog.dart';
import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/features/export/presentation/screens/export_screen.dart';
import 'package:blutdruck_tracker/features/overview/presentation/screens/overview_screen.dart';
import 'package:blutdruck_tracker/features/readings/presentation/screens/reading_entry_screen.dart';
import 'package:blutdruck_tracker/features/readings/presentation/screens/reading_history_screen.dart';
import 'package:blutdruck_tracker/features/reminders/presentation/screens/reminder_settings_screen.dart';
import 'package:blutdruck_tracker/features/settings/presentation/screens/privacy_info_screen.dart';
import 'package:blutdruck_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:blutdruck_tracker/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:blutdruck_tracker/features/status/presentation/screens/status_screen.dart';
import 'package:flutter/material.dart';
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
          builder: (context, state) => const StatisticsScreen(),
        ),
        GoRoute(
          path: '/status',
          builder: (context, state) => const StatusScreen(),
        ),
        GoRoute(
          path: '/export',
          builder: (context, state) => const ExportScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
          routes: [
            GoRoute(
              path: 'reminders',
              builder: (context, state) => const ReminderSettingsScreen(),
            ),
            GoRoute(
              path: 'privacy',
              builder: (context, state) => const PrivacyInfoScreen(),
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
