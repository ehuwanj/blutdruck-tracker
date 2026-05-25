import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';

abstract class ExportHistoryLocalDataSource {
  Stream<List<ExportHistoryRow>> watchRecent({int limit = 5});
  Future<void> upsert(ExportHistoryRow row);
  Future<void> deleteById(String id);
}

class DriftExportHistoryLocalDataSource
    implements ExportHistoryLocalDataSource {
  const DriftExportHistoryLocalDataSource(this.database);

  final AppDatabase database;

  @override
  Stream<List<ExportHistoryRow>> watchRecent({int limit = 5}) {
    return (database.select(database.exportHistory)
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
          ..limit(limit))
        .watch();
  }

  @override
  Future<void> upsert(ExportHistoryRow row) {
    return database.into(database.exportHistory).insertOnConflictUpdate(row);
  }

  @override
  Future<void> deleteById(String id) {
    return (database.delete(
      database.exportHistory,
    )..where((table) => table.id.equals(id))).go();
  }
}
