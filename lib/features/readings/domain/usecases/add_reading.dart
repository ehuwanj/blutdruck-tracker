import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';

class AddReading {
  const AddReading(this.repository);

  final ReadingRepository repository;

  Future<void> call(BloodPressureReading reading) => repository.upsert(reading);
}
