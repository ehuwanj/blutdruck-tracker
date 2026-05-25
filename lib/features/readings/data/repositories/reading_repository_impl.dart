import 'package:blutdruck_tracker/features/readings/data/datasources/reading_local_datasource.dart';
import 'package:blutdruck_tracker/features/readings/data/mappers/reading_mapper.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';

class ReadingRepositoryImpl implements ReadingRepository {
  const ReadingRepositoryImpl(
    this.dataSource, {
    this.mapper = const ReadingMapper(),
  });

  final ReadingLocalDataSource dataSource;
  final ReadingMapper mapper;

  @override
  Future<void> upsert(BloodPressureReading reading) {
    return dataSource.upsert(mapper.toRow(reading));
  }

  @override
  Future<void> deleteById(String id) => dataSource.deleteById(id);

  @override
  Future<BloodPressureReading?> findById(String id) async {
    final row = await dataSource.findById(id);
    return row == null ? null : mapper.toEntity(row);
  }

  @override
  Stream<List<BloodPressureReading>> watchAll() {
    return dataSource.watchAll().map(
      (rows) => rows.map(mapper.toEntity).toList(),
    );
  }

  @override
  Stream<List<BloodPressureReading>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) {
    return dataSource
        .watchByRange(fromUtc, toUtc)
        .map((rows) => rows.map(mapper.toEntity).toList());
  }

  @override
  Future<BloodPressureReading?> findLatest() async {
    final row = await dataSource.findLatest();
    return row == null ? null : mapper.toEntity(row);
  }
}
