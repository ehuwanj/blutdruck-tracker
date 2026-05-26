import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/widgets/app_empty_state.dart';
import 'package:blutdruck_tracker/core/widgets/app_error_view.dart';
import 'package:blutdruck_tracker/core/widgets/app_loading_view.dart';
import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';
import 'package:blutdruck_tracker/features/reminders/presentation/widgets/reminder_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ReminderSettingsScreen extends ConsumerWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final remindersAsync = ref.watch(remindersStreamProvider);
    final settings = ref.watch(settingsProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.remindersTitle)),
      body: Column(
        children: [
          _MasterToggle(enabled: settings?.remindersEnabled ?? false),
          const Divider(height: 1),
          Expanded(
            child: remindersAsync.when(
              loading: () => const AppLoadingView(),
              error: (error, stackTrace) => AppErrorView(
                headline: l10n.statisticsLoadErrorTitle,
                body: l10n.statisticsLoadErrorBody,
              ),
              data: (reminders) {
                if (reminders.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.alarm,
                    headline: l10n.remindersEmptyTitle,
                    body: l10n.remindersEmptyBody,
                    action: FilledButton.icon(
                      icon: const Icon(Icons.add_alarm),
                      label: Text(l10n.remindersAddAction),
                      onPressed: () => _openSheet(context, ref, null),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: reminders.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return _ReminderRow(reminder: reminder);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.remindersAddAction,
        onPressed: () => _openSheet(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MasterToggle extends ConsumerWidget {
  const _MasterToggle({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SwitchListTile(
      title: Text(l10n.remindersMasterToggle),
      value: enabled,
      onChanged: (value) async {
        final settings = ref.read(settingsProvider).valueOrNull;
        if (settings == null) return;
        if (value) {
          final scheduler = ref.read(reminderSchedulerProvider);
          final granted = await scheduler.requestPermission();
          if (!granted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.reminderPermissionDenied)),
            );
            return;
          }
        }
        await ref
            .read(settingsProvider.notifier)
            .save(settings.copyWith(remindersEnabled: value));
        if (!value) {
          await ref.read(reminderSchedulerProvider).cancelAll();
        } else {
          final reminders = ref.read(remindersStreamProvider).valueOrNull;
          if (reminders != null) {
            await ref
                .read(reminderSchedulerProvider)
                .scheduleAll(
                  reminders,
                  title: l10n.reminderNotificationTitle,
                  body: l10n.reminderNotificationBody,
                );
          }
        }
      },
    );
  }
}

class _ReminderRow extends ConsumerWidget {
  const _ReminderRow({required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final timeText = '${_p2(reminder.hour)}:${_p2(reminder.minute)}';
    final weekdaysText = reminder.weekdays.isEmpty
        ? l10n.reminderEveryDay
        : _shortWeekdaysLabel(l10n, reminder.weekdays);
    return ListTile(
      leading: const Icon(Icons.alarm_outlined),
      title: Text(timeText),
      subtitle: Text(
        [if (reminder.label != null) reminder.label!, weekdaysText].join(' · '),
      ),
      trailing: Switch(
        value: reminder.enabled,
        onChanged: (value) async {
          await ref
              .read(reminderRepositoryProvider)
              .upsert(reminder.copyWith(enabled: value));
        },
      ),
      onTap: () => _openSheet(context, ref, reminder),
      onLongPress: () async {
        await ref.read(reminderRepositoryProvider).deleteById(reminder.id);
      },
    );
  }
}

Future<void> _openSheet(
  BuildContext context,
  WidgetRef ref,
  Reminder? existing,
) async {
  final result = await showModalBottomSheet<Reminder>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => ReminderFormSheet(initial: existing),
  );
  if (result == null) return;
  final repository = ref.read(reminderRepositoryProvider);
  final id = existing?.id ?? const Uuid().v4();
  await repository.upsert(result.copyWith(id: id));
  // Toggle the master switch on automatically when the first reminder is
  // added — matches the spec's "first enable" permission flow.
  final settings = ref.read(settingsProvider).valueOrNull;
  if (existing == null && settings != null && !settings.remindersEnabled) {
    await ref
        .read(settingsProvider.notifier)
        .save(settings.copyWith(remindersEnabled: true));
  }
}

String _p2(int value) => value < 10 ? '0$value' : '$value';

String _shortWeekdaysLabel(AppLocalizations l10n, Set<int> weekdays) {
  final ordered = weekdays.toList()..sort();
  return ordered.map((day) => _shortWeekday(l10n, day)).join(' ');
}

String _shortWeekday(AppLocalizations l10n, int weekday) {
  return switch (weekday) {
    DateTime.monday => l10n.weekdayMon,
    DateTime.tuesday => l10n.weekdayTue,
    DateTime.wednesday => l10n.weekdayWed,
    DateTime.thursday => l10n.weekdayThu,
    DateTime.friday => l10n.weekdayFri,
    DateTime.saturday => l10n.weekdaySat,
    DateTime.sunday => l10n.weekdaySun,
    _ => '',
  };
}
