import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';

class UpdateReading {
  const UpdateReading(this.repository);

  final ReadingRepository repository;

  Future<void> call(BloodPressureReading reading) => repository.upsert(reading);
}
