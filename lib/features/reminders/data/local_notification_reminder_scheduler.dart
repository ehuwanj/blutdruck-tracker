import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';
import 'package:blutdruck_tracker/features/reminders/domain/services/reminder_occurrence_calculator.dart';
import 'package:blutdruck_tracker/features/reminders/domain/services/reminder_scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Wraps `flutter_local_notifications` for the [ReminderScheduler] contract.
///
/// Notification IDs are derived from the reminder id + a per-occurrence
/// index so re-scheduling does not duplicate. Permission requests are
/// triggered explicitly by the caller, not on app start (spec 08).
class LocalNotificationReminderScheduler implements ReminderScheduler {
  LocalNotificationReminderScheduler({
    required this.plugin,
    required this.clock,
    this.calculator = const ReminderOccurrenceCalculator(),
    this.scheduleWindow = const Duration(days: 14),
  });

  static const String channelId = 'reminders_default';
  static const String channelName = 'Reminders';
  static const String smallIcon = 'ic_notification';

  final FlutterLocalNotificationsPlugin plugin;
  final Clock clock;
  final ReminderOccurrenceCalculator calculator;
  final Duration scheduleWindow;

  @override
  Future<void> scheduleAll(
    List<Reminder> reminders, {
    required String title,
    required String body,
  }) async {
    await plugin.cancelAll();
    final now = clock.now().toLocal();
    final occurrences = calculator.computeOccurrences(
      reminders: reminders,
      from: now,
      until: now.add(scheduleWindow),
    );
    final details = _notificationDetails();
    for (var index = 0; index < occurrences.length; index++) {
      final occurrence = occurrences[index];
      final id = _idFor(occurrence.reminder.id, index);
      final tzTime = tz.TZDateTime.from(occurrence.localOccurrence, tz.local);
      await plugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  @override
  Future<void> cancelAll() => plugin.cancelAll();

  @override
  Future<bool> requestPermission() async {
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }
    final ios = plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final granted = await ios.requestPermissions(alert: true, badge: true);
      return granted ?? false;
    }
    return false;
  }

  @override
  Future<bool> hasPermission() async {
    final android = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return (await android.areNotificationsEnabled()) ?? false;
    }
    final ios = plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      final settings = await ios.checkPermissions();
      return settings?.isEnabled ?? false;
    }
    return false;
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'Blood pressure reading reminders',
        icon: smallIcon,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  /// Stable 31-bit notification id derived from the reminder id hash + an
  /// occurrence index. Re-scheduling the same reminder list produces
  /// matching ids so duplicates are avoided naturally after `cancelAll`.
  int _idFor(String reminderId, int index) {
    final base = reminderId.hashCode & 0x7FFFFFF;
    return (base ^ index) & 0x7FFFFFFF;
  }
}
