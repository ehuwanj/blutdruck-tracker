import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';

class GetReadings {
  const GetReadings(this.repository);

  final ReadingRepository repository;

  Stream<List<BloodPressureReading>> call() => repository.watchAll();

  Stream<List<BloodPressureReading>> byRange(DateTime fromUtc, DateTime toUtc) {
    return repository.watchByRange(fromUtc, toUtc);
  }
}
