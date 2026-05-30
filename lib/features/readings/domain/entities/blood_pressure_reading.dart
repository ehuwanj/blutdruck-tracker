import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blood_pressure_reading.freezed.dart';

/// One blood-pressure measurement. Domain-pure: no Flutter imports, no
/// JSON. Mapping to/from rows lives in `data/mappers/`.
@freezed
class BloodPressureReading with _$BloodPressureReading {
  const factory BloodPressureReading({
    required String id,

    /// Always stored UTC; rendered in device-local time by the UI.
    required DateTime measuredAt,
    required int systolic,
    required int diastolic,
    required ReadingSource source,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? pulse,
    String? note,
  }) = _BloodPressureReading;

  const BloodPressureReading._();

  int get pulsePressure => systolic - diastolic;

  double get meanArterialPressure => diastolic + (pulsePressure / 3.0);
}
