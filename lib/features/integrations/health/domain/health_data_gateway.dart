import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';

/// Health Connect (Android) / HealthKit (iOS) gateway. Disabled in the
/// MVP — every method on the concrete `DisabledHealthDataGateway` throws
/// `UnsupportedError`. See docs/specs/10-future-integrations.md.
abstract class HealthDataGateway {
  Future<bool> isAvailable();
  Future<void> requestPermissions();
  Future<void> writeBloodPressureReading(BloodPressureReading reading);
  Future<List<BloodPressureReading>> readBloodPressureReadings({
    required DateTime fromUtc,
    required DateTime toUtc,
  });
}
