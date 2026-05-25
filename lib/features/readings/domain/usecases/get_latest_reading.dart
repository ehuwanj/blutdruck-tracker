import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';

class GetLatestReading {
  const GetLatestReading(this.repository);

  final ReadingRepository repository;

  Future<BloodPressureReading?> call() => repository.findLatest();
}
