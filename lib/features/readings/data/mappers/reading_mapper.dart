import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';

typedef WarningLog = void Function(String message);

class ReadingMapper {
  const ReadingMapper({this.warn});

  final WarningLog? warn;

  BloodPressureReadingRow toRow(BloodPressureReading entity) {
    return BloodPressureReadingRow(
      id: entity.id,
      measuredAt: _toMillis(entity.measuredAt),
      systolic: entity.systolic,
      diastolic: entity.diastolic,
      pulse: entity.pulse,
      note: entity.note?.trim(),
      source: entity.source.name,
      createdAt: _toMillis(entity.createdAt),
      updatedAt: _toMillis(entity.updatedAt),
    );
  }

  BloodPressureReading toEntity(BloodPressureReadingRow row) {
    return BloodPressureReading(
      id: row.id,
      measuredAt: _fromMillis(row.measuredAt),
      systolic: row.systolic,
      diastolic: row.diastolic,
      pulse: row.pulse,
      note: row.note,
      source: _source(row.source),
      createdAt: _fromMillis(row.createdAt),
      updatedAt: _fromMillis(row.updatedAt),
    );
  }

  int _toMillis(DateTime value) => value.toUtc().millisecondsSinceEpoch;

  DateTime _fromMillis(int value) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }

  ReadingSource _source(String value) {
    for (final source in ReadingSource.values) {
      if (source.name == value) {
        return source;
      }
    }
    warn?.call('Unknown reading source "$value"; using manual.');
    return ReadingSource.manual;
  }
}
