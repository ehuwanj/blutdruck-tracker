import 'package:blutdruck_tracker/features/export/data/datasources/export_history_local_datasource.dart';
import 'package:blutdruck_tracker/features/export/data/mappers/export_record_mapper.dart';
import 'package:blutdruck_tracker/features/export/domain/entities/export_record.dart';
import 'package:blutdruck_tracker/features/export/domain/repositories/export_history_repository.dart';

class ExportHistoryRepositoryImpl implements ExportHistoryRepository {
  const ExportHistoryRepositoryImpl(this.dataSource);

  final ExportHistoryLocalDataSource dataSource;

  @override
  Stream<List<ExportRecord>> watchRecent({int limit = 5}) {
    return dataSource
        .watchRecent(limit: limit)
        .map((rows) => rows.map(exportRecordFromRow).toList(growable: false));
  }

  @override
  Future<void> upsert(ExportRecord record) {
    return dataSource.upsert(exportRecordToRow(record));
  }

  @override
  Future<void> deleteById(String id) => dataSource.deleteById(id);
}
