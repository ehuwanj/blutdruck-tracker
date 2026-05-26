import 'package:blutdruck_tracker/app/app.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/features/reminders/data/local_notification_reminder_scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz_data.initializeTimeZones();
  // `tz.local` defaults to UTC. A future improvement would resolve the
  // device's IANA timezone via flutter_timezone; for the MVP we keep
  // the default and schedule notifications in the system clock's wall
  // time. See docs/specs/08-export-and-reminders.md §Local reminders.

  final plugin = FlutterLocalNotificationsPlugin();
  await _initializePlugin(plugin);

  runApp(
    ProviderScope(
      overrides: [
        reminderSchedulerProvider.overrideWith((ref) {
          return LocalNotificationReminderScheduler(
            plugin: plugin,
            clock: ref.watch(clockProvider),
          );
        }),
      ],
      child: const BlutdruckTrackerApp(),
    ),
  );
}

Future<void> _initializePlugin(FlutterLocalNotificationsPlugin plugin) async {
  const android = AndroidInitializationSettings(
    LocalNotificationReminderScheduler.smallIcon,
  );
  const ios = DarwinInitializationSettings();
  const settings = InitializationSettings(android: android, iOS: ios);
  await plugin.initialize(settings);

  final androidPlugin = plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  if (androidPlugin != null) {
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        LocalNotificationReminderScheduler.channelId,
        LocalNotificationReminderScheduler.channelName,
        description: 'Blood pressure reading reminders',
      ),
    );
  }

  // `tz.local` set above is UTC; if the future flutter_timezone integration
  // resolves a different zone, set it here before re-scheduling.
  if (tz.local.name == 'Factory') {
    tz.setLocalLocation(tz.UTC);
  }
}
