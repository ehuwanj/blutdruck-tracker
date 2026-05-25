import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/reminders/data/datasources/reminder_local_datasource.dart';
import 'package:blutdruck_tracker/features/reminders/data/mappers/reminder_mapper.dart';
import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';
import 'package:blutdruck_tracker/features/reminders/domain/repositories/reminder_repository.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  const ReminderRepositoryImpl({required this.dataSource, required this.clock});

  final ReminderLocalDataSource dataSource;
  final Clock clock;

  @override
  Stream<List<Reminder>> watchAll() {
    return dataSource.watchAll().map(
      (rows) => rows.map(reminderFromRow).toList(growable: false),
    );
  }

  @override
  Future<List<Reminder>> readAll() async {
    final rows = await dataSource.readAll();
    return rows.map(reminderFromRow).toList(growable: false);
  }

  @override
  Future<void> upsert(Reminder reminder) {
    return dataSource.upsert(reminderToRow(reminder, now: clock.now()));
  }

  @override
  Future<void> deleteById(String id) => dataSource.deleteById(id);
}
