import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';
import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder_occurrence.dart';

/// Pure-Dart computation of when each [Reminder] fires inside a half-open
/// window `[from, until)`. The scheduler turns the result into
/// `flutter_local_notifications` calls — this calculator stays free of
/// platform plugins and timezones so it can be unit-tested deterministically.
class ReminderOccurrenceCalculator {
  const ReminderOccurrenceCalculator();

  /// Returns occurrences sorted ascending by
  /// [ReminderOccurrence.localOccurrence]. Disabled reminders are skipped.
  /// A reminder with an empty `weekdays` set means "every day".
  List<ReminderOccurrence> computeOccurrences({
    required List<Reminder> reminders,
    required DateTime from,
    required DateTime until,
  }) {
    assert(!from.isAfter(until), 'from must be <= until');
    final results = <ReminderOccurrence>[];

    for (final reminder in reminders) {
      if (!reminder.enabled) continue;
      var day = DateTime(from.year, from.month, from.day);
      while (day.isBefore(until)) {
        if (_firesOn(reminder, day)) {
          final occurrence = DateTime(
            day.year,
            day.month,
            day.day,
            reminder.hour,
            reminder.minute,
          );
          if (!occurrence.isBefore(from) && occurrence.isBefore(until)) {
            results.add(
              ReminderOccurrence(
                reminder: reminder,
                localOccurrence: occurrence,
              ),
            );
          }
        }
        day = day.add(const Duration(days: 1));
      }
    }

    results.sort((a, b) => a.localOccurrence.compareTo(b.localOccurrence));
    return results;
  }

  bool _firesOn(Reminder reminder, DateTime day) {
    if (reminder.weekdays.isEmpty) return true;
    return reminder.weekdays.contains(day.weekday);
  }
}
