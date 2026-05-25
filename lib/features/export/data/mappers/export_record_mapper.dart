import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:blutdruck_tracker/features/export/domain/entities/export_format.dart';
import 'package:blutdruck_tracker/features/export/domain/entities/export_record.dart';
import 'package:drift/drift.dart';

ExportHistoryRow exportRecordToRow(ExportRecord record) {
  return ExportHistoryRow(
    id: record.id,
    format: record.format.name,
    periodFrom: record.periodFrom.toUtc().millisecondsSinceEpoch,
    periodTo: record.periodTo.toUtc().millisecondsSinceEpoch,
    filePath: record.filePath,
    createdAt: record.createdAt.toUtc().millisecondsSinceEpoch,
  );
}

ExportRecord exportRecordFromRow(ExportHistoryRow row) {
  return ExportRecord(
    id: row.id,
    format: _format(row.format),
    periodFrom: DateTime.fromMillisecondsSinceEpoch(
      row.periodFrom,
      isUtc: true,
    ),
    periodTo: DateTime.fromMillisecondsSinceEpoch(row.periodTo, isUtc: true),
    filePath: row.filePath,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAt, isUtc: true),
  );
}

ExportFormat _format(String raw) {
  return ExportFormat.values.firstWhere(
    (value) => value.name == raw,
    orElse: () => ExportFormat.csv,
  );
}

// Drift's `into(...).insertOnConflictUpdate(row)` accepts the data class
// directly, so we don't need a Companion helper. This export is kept to
// signal intent to call sites.
Insertable<ExportHistoryRow> exportRecordCompanion(ExportRecord record) {
  return exportRecordToRow(record);
}
