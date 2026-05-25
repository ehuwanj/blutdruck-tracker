import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';

abstract class ReadingLocalDataSource {
  Future<void> upsert(BloodPressureReadingRow row);
  Future<void> deleteById(String id);
  Future<BloodPressureReadingRow?> findById(String id);
  Stream<List<BloodPressureReadingRow>> watchAll();
  Stream<List<BloodPressureReadingRow>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  );
  Future<BloodPressureReadingRow?> findLatest();
}

class DriftReadingLocalDataSource implements ReadingLocalDataSource {
  const DriftReadingLocalDataSource(this.database);

  final AppDatabase database;

  @override
  Future<void> upsert(BloodPressureReadingRow row) {
    return database
        .into(database.bloodPressureReadings)
        .insertOnConflictUpdate(row);
  }

  @override
  Future<void> deleteById(String id) {
    return (database.delete(
      database.bloodPressureReadings,
    )..where((table) => table.id.equals(id))).go();
  }

  @override
  Future<BloodPressureReadingRow?> findById(String id) {
    return (database.select(
      database.bloodPressureReadings,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  @override
  Stream<List<BloodPressureReadingRow>> watchAll() {
    return (database.select(database.bloodPressureReadings)..orderBy([
          (table) => OrderingTerm.desc(table.measuredAt),
          (table) => OrderingTerm.desc(table.createdAt),
        ]))
        .watch();
  }

  @override
  Stream<List<BloodPressureReadingRow>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) {
    return (database.select(database.bloodPressureReadings)
          ..where(
            (table) =>
                table.measuredAt.isBiggerOrEqualValue(_millis(fromUtc)) &
                table.measuredAt.isSmallerOrEqualValue(_millis(toUtc)),
          )
          ..orderBy([
            (table) => OrderingTerm.desc(table.measuredAt),
            (table) => OrderingTerm.desc(table.createdAt),
          ]))
        .watch();
  }

  @override
  Future<BloodPressureReadingRow?> findLatest() {
    return (database.select(database.bloodPressureReadings)
          ..orderBy([
            (table) => OrderingTerm.desc(table.measuredAt),
            (table) => OrderingTerm.desc(table.createdAt),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  int _millis(DateTime dateTime) => dateTime.toUtc().millisecondsSinceEpoch;
}
