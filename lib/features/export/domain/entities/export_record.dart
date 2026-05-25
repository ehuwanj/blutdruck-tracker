import 'package:blutdruck_tracker/features/export/domain/entities/export_format.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_record.freezed.dart';

/// One row of `export_history` — the user generated a CSV or PDF over the
/// supplied period and the resulting file lives at [filePath].
@freezed
class ExportRecord with _$ExportRecord {
  const factory ExportRecord({
    required String id,
    required ExportFormat format,
    required DateTime periodFrom,
    required DateTime periodTo,
    required String filePath,
    required DateTime createdAt,
  }) = _ExportRecord;
}
