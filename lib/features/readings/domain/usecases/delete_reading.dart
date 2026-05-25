import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';

class DeleteReading {
  const DeleteReading(this.repository);

  final ReadingRepository repository;

  Future<void> call(String id) => repository.deleteById(id);
}
