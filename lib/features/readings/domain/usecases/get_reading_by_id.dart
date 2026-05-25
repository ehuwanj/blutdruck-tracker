import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';

class GetReadingById {
  const GetReadingById(this.repository);

  final ReadingRepository repository;

  Future<BloodPressureReading?> call(String id) => repository.findById(id);
}
