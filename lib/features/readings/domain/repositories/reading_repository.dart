import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';

abstract class ReadingRepository {
  Future<void> upsert(BloodPressureReading reading);
  Future<void> deleteById(String id);
  Future<BloodPressureReading?> findById(String id);
  Stream<List<BloodPressureReading>> watchAll();
  Stream<List<BloodPressureReading>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  );
  Future<BloodPressureReading?> findLatest();
}
