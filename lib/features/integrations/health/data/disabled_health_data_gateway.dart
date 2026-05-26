import 'package:blutdruck_tracker/features/integrations/health/domain/health_data_gateway.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';

/// MVP-default [HealthDataGateway]: `isAvailable` returns `false`; every
/// mutating method throws `UnsupportedError`. Manual entry continues to
/// work regardless of this gateway's state. See
/// docs/specs/10-future-integrations.md.
class DisabledHealthDataGateway implements HealthDataGateway {
  const DisabledHealthDataGateway();

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<void> requestPermissions() async {
    throw UnsupportedError('Health integration is disabled in this build.');
  }

  @override
  Future<void> writeBloodPressureReading(BloodPressureReading reading) async {
    throw UnsupportedError('Health integration is disabled in this build.');
  }

  @override
  Future<List<BloodPressureReading>> readBloodPressureReadings({
    required DateTime fromUtc,
    required DateTime toUtc,
  }) async {
    throw UnsupportedError('Health integration is disabled in this build.');
  }
}
