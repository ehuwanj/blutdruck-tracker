import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';
import 'package:blutdruck_tracker/features/reminders/domain/services/reminder_occurrence_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calculator = ReminderOccurrenceCalculator();
  // 2026-05-25 is a Monday (ISO weekday 1).
  final from = DateTime(2026, 5, 25);
  final until = from.add(const Duration(days: 14));

  test('disabled reminders produce zero occurrences', () {
    final result = calculator.computeOccurrences(
      reminders: [
        _reminder(id: 'r1', hour: 7, weekdays: const {}, enabled: false),
      ],
      from: from,
      until: until,
    );
    expect(result, isEmpty);
  });

  test('empty weekdays means every day across the 14-day window', () {
    final result = calculator.computeOccurrences(
      reminders: [_reminder(id: 'r1', hour: 7, weekdays: const {})],
      from: from,
      until: until,
    );
    expect(result, hasLength(14));
    for (var i = 0; i < 14; i++) {
      expect(result[i].localOccurrence, DateTime(2026, 5, 25 + i, 7));
    }
  });

  test('Mon/Wed/Fri reminder fires 6 times in two weeks', () {
    final result = calculator.computeOccurrences(
      reminders: [
        _reminder(
          id: 'r1',
          hour: 7,
          weekdays: const {
            DateTime.monday,
            DateTime.wednesday,
            DateTime.friday,
          },
        ),
      ],
      from: from,
      until: until,
    );
    expect(result, hasLength(6));
    expect(result.map((o) => o.localOccurrence.weekday).toSet(), {
      DateTime.monday,
      DateTime.wednesday,
      DateTime.friday,
    });
  });

  test('two reminders on the same day are sorted by time', () {
    final result = calculator.computeOccurrences(
      reminders: [
        _reminder(id: 'evening', hour: 20, weekdays: const {}),
        _reminder(id: 'morning', hour: 7, weekdays: const {}),
      ],
      from: from,
      until: from.add(const Duration(days: 1)),
    );
    expect(result, hasLength(2));
    expect(result.first.reminder.id, 'morning');
    expect(result.last.reminder.id, 'evening');
  });

  test('occurrences strictly inside the from..until half-open window', () {
    // from = today 12:00; a 7:00 reminder today is *before* from and must
    // be skipped. The next firing is tomorrow.
    final start = DateTime(2026, 5, 25, 12);
    final end = start.add(const Duration(days: 2));
    final result = calculator.computeOccurrences(
      reminders: [_reminder(id: 'r1', hour: 7, weekdays: const {})],
      from: start,
      until: end,
    );
    expect(result, hasLength(2));
    expect(result.first.localOccurrence, DateTime(2026, 5, 26, 7));
    expect(result.last.localOccurrence, DateTime(2026, 5, 27, 7));
  });
}

Reminder _reminder({
  required String id,
  required int hour,
  required Set<int> weekdays,
  bool enabled = true,
}) {
  return Reminder(
    id: id,
    hour: hour,
    minute: 0,
    weekdays: weekdays,
    enabled: enabled,
  );
}
