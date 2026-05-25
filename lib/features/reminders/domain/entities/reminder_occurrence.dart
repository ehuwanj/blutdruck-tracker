import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';

/// One concrete firing of a [Reminder] at a wall-clock instant. The
/// occurrence time is **local**; the scheduler converts to a timezone-aware
/// instant before passing it to the platform plugin.
///
/// Equality is identity. Callers compare individual fields (`reminder.id`
/// and `localOccurrence`) — that's enough for the scheduler contract and
/// keeps this domain entity free of `flutter/foundation.dart`'s
/// `@immutable`.
class ReminderOccurrence {
  const ReminderOccurrence({
    required this.reminder,
    required this.localOccurrence,
  });

  final Reminder reminder;
  final DateTime localOccurrence;

  int get weekday => localOccurrence.weekday;
}
