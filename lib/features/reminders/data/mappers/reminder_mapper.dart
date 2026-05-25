import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';

/// Set of ISO weekdays (1=Mon..7=Sun) ↔ 7-bit mask used by Drift.
/// Bit 0 = Monday, bit 6 = Sunday. An empty set encodes as `0` and means
/// "every day" at the domain layer; the mapper preserves the empty set.
int weekdaysToMask(Set<int> weekdays) {
  var mask = 0;
  for (final weekday in weekdays) {
    if (weekday < 1 || weekday > 7) continue;
    mask |= 1 << (weekday - 1);
  }
  return mask;
}

Set<int> weekdaysFromMask(int mask) {
  final result = <int>{};
  for (var i = 0; i < 7; i++) {
    if ((mask & (1 << i)) != 0) {
      result.add(i + 1);
    }
  }
  return result;
}

ReminderRow reminderToRow(Reminder reminder, {required DateTime now}) {
  return ReminderRow(
    id: reminder.id,
    hour: reminder.hour,
    minute: reminder.minute,
    weekdaysMask: weekdaysToMask(reminder.weekdays),
    enabled: reminder.enabled,
    label: reminder.label,
    createdAt: now.toUtc().millisecondsSinceEpoch,
    updatedAt: now.toUtc().millisecondsSinceEpoch,
  );
}

Reminder reminderFromRow(ReminderRow row) {
  return Reminder(
    id: row.id,
    hour: row.hour,
    minute: row.minute,
    weekdays: weekdaysFromMask(row.weekdaysMask),
    enabled: row.enabled,
    label: row.label,
  );
}
