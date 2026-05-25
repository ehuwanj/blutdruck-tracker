import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';

abstract class ReminderLocalDataSource {
  Stream<List<ReminderRow>> watchAll();
  Future<List<ReminderRow>> readAll();
  Future<void> upsert(ReminderRow row);
  Future<void> deleteById(String id);
}

class DriftReminderLocalDataSource implements ReminderLocalDataSource {
  const DriftReminderLocalDataSource(this.database);

  final AppDatabase database;

  @override
  Stream<List<ReminderRow>> watchAll() {
    return (database.select(database.reminders)..orderBy([
          (table) => OrderingTerm.asc(table.hour),
          (table) => OrderingTerm.asc(table.minute),
        ]))
        .watch();
  }

  @override
  Future<List<ReminderRow>> readAll() {
    return (database.select(database.reminders)..orderBy([
          (table) => OrderingTerm.asc(table.hour),
          (table) => OrderingTerm.asc(table.minute),
        ]))
        .get();
  }

  @override
  Future<void> upsert(ReminderRow row) {
    return database.into(database.reminders).insertOnConflictUpdate(row);
  }

  @override
  Future<void> deleteById(String id) {
    return (database.delete(
      database.reminders,
    )..where((table) => table.id.equals(id))).go();
  }
}
