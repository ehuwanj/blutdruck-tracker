import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';

/// Persists user-defined reminders. The scheduler reads from this
/// repository to compute notification slots; the UI reads from
/// `watchAll()` to render the list.
abstract class ReminderRepository {
  Stream<List<Reminder>> watchAll();
  Future<List<Reminder>> readAll();
  Future<void> upsert(Reminder reminder);
  Future<void> deleteById(String id);
}
