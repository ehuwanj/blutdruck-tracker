import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';

/// Schedules and cancels OS-level local notifications for the user's
/// reminders. Implementations live in the data layer; this interface keeps
/// the orchestrating code (app-start hook, form submit handlers) free of
/// platform plugin imports.
abstract class ReminderScheduler {
  /// Cancels every previously scheduled notification and re-schedules from
  /// the supplied list. Disabled reminders are skipped. Called on app
  /// start, after add/edit/delete, and when the locale changes.
  ///
  /// [title] and [body] are the user-visible notification copy in the
  /// active locale. They are passed per call (rather than fixed at
  /// scheduler construction) so a locale change re-schedules with the
  /// new copy on the very next emission.
  Future<void> scheduleAll(
    List<Reminder> reminders, {
    required String title,
    required String body,
  });

  /// Cancels every previously scheduled notification.
  Future<void> cancelAll();

  /// Requests OS notification permission. Returns `true` if granted.
  /// Spec 08: only called the first time the user enables reminders,
  /// never on launch.
  Future<bool> requestPermission();

  /// Returns whether the OS has currently granted notification permission.
  Future<bool> hasPermission();
}
