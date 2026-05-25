import 'package:blutdruck_tracker/features/export/domain/entities/export_record.dart';

/// Persists records of past exports so the user can re-share or clean up.
/// Implementations live in the data layer.
abstract class ExportHistoryRepository {
  Stream<List<ExportRecord>> watchRecent({int limit = 5});
  Future<void> upsert(ExportRecord record);
  Future<void> deleteById(String id);
}
