import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/database/app_database.dart' as db;
import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/readings/data/datasources/reading_local_datasource.dart';
import 'package:blutdruck_tracker/features/readings/data/mappers/reading_mapper.dart';
import 'package:blutdruck_tracker/features/readings/data/repositories/reading_repository_impl.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/add_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/delete_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/get_latest_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/get_reading_by_id.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/get_readings.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/update_reading.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReadingRepositoryImpl', () {
    test('maps domain entities through the datasource unchanged', () async {
      final dataSource = _FakeReadingLocalDataSource();
      final repository = ReadingRepositoryImpl(dataSource);
      final entity = reading('r1');

      await repository.upsert(entity);
      final byId = await repository.findById('r1');
      final latest = await repository.findLatest();
      final all = await repository.watchAll().first;

      expect(byId, entity);
      expect(latest, entity);
      expect(all, [entity]);
    });
  });

  group('reading use cases', () {
    test('happy paths delegate to repository', () async {
      final repository = _FakeReadingRepository([reading('r1')]);
      final r2 = reading('r2');

      await AddReading(repository).call(r2);
      await UpdateReading(repository).call(r2.copyWith(systolic: 130));
      final all = await GetReadings(repository).call().first;
      final byId = await GetReadingById(repository).call('r2');
      final latest = await GetLatestReading(repository).call();
      await DeleteReading(repository).call('r1');

      expect(all.map((r) => r.id), contains('r2'));
      expect(byId!.systolic, 130);
      expect(latest, isNotNull);
      expect(repository.deletedIds, ['r1']);
    });
  });

  test('statisticsProvider composes settings and readings', () async {
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(_FakeClock(DateTime.utc(2026, 5, 30))),
        readingRepositoryProvider.overrideWithValue(
          _FakeReadingRepository([
            reading('r1', measuredAt: DateTime.utc(2026, 5, 29), weightKg: 80),
          ]),
        ),
        settingsRepositoryProvider.overrideWithValue(
          _FakeSettingsRepository(
            AppSettings.defaults().copyWith(
              heightCm: 180,
              disclaimerAcceptedVersion: kDisclaimerVersion,
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(readingsStreamProvider.future);
    await container.read(settingsProvider.future);

    final stats = container.read(statisticsProvider).requireValue;
    expect(stats.entryCount, 1);
    expect(stats.bmi, isNotNull);
  });

  test('timeSlotDetectorInputProvider filters to last 30 days', () async {
    final now = DateTime.utc(2026, 5, 30);
    final recent = reading(
      'recent',
      measuredAt: now.subtract(const Duration(days: 2)),
    );
    final old = reading(
      'old',
      measuredAt: now.subtract(const Duration(days: 31)),
    );
    final container = ProviderContainer(
      overrides: [
        clockProvider.overrideWithValue(_FakeClock(now)),
        readingRepositoryProvider.overrideWithValue(
          _FakeReadingRepository([recent, old]),
        ),
        settingsRepositoryProvider.overrideWithValue(
          _FakeSettingsRepository(AppSettings.defaults()),
        ),
      ],
    );
    addTearDown(container.dispose);

    await container.read(readingsStreamProvider.future);

    final input = container.read(timeSlotDetectorInputProvider).requireValue;
    expect(input.map((r) => r.id), ['recent']);
  });
}

BloodPressureReading reading(
  String id, {
  DateTime? measuredAt,
  int systolic = 120,
  int diastolic = 80,
  double? weightKg,
}) {
  final timestamp = measuredAt ?? DateTime.utc(2026, 5, 25, 8);
  return BloodPressureReading(
    id: id,
    measuredAt: timestamp,
    systolic: systolic,
    diastolic: diastolic,
    weightKg: weightKg,
    source: ReadingSource.manual,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

class _FakeClock implements Clock {
  const _FakeClock(this.value);

  final DateTime value;

  @override
  DateTime now() => value;
}

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository(this.value);

  AppSettings value;

  @override
  Future<AppSettings> read() async => value;

  @override
  Future<void> write(AppSettings settings) async {
    value = settings;
  }
}

class _FakeReadingRepository implements ReadingRepository {
  _FakeReadingRepository(List<BloodPressureReading> seed)
    : readings = [...seed];

  final List<BloodPressureReading> readings;
  final deletedIds = <String>[];

  @override
  Future<void> upsert(BloodPressureReading reading) async {
    readings
      ..removeWhere((candidate) => candidate.id == reading.id)
      ..insert(0, reading);
  }

  @override
  Future<void> deleteById(String id) async {
    deletedIds.add(id);
    readings.removeWhere((reading) => reading.id == id);
  }

  @override
  Future<BloodPressureReading?> findById(String id) async {
    for (final reading in readings) {
      if (reading.id == id) {
        return reading;
      }
    }
    return null;
  }

  @override
  Stream<List<BloodPressureReading>> watchAll() => Stream.value(readings);

  @override
  Stream<List<BloodPressureReading>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) {
    return Stream.value(
      readings.where((reading) {
        return !reading.measuredAt.isBefore(fromUtc) &&
            !reading.measuredAt.isAfter(toUtc);
      }).toList(),
    );
  }

  @override
  Future<BloodPressureReading?> findLatest() async {
    return readings.isEmpty ? null : readings.first;
  }
}

class _FakeReadingLocalDataSource implements ReadingLocalDataSource {
  final _mapper = const ReadingMapper();
  final _rows = <String, db.BloodPressureReadingRow>{};

  @override
  Future<void> upsert(db.BloodPressureReadingRow row) async {
    _rows[row.id] = row;
  }

  @override
  Future<void> deleteById(String id) async {
    _rows.remove(id);
  }

  @override
  Future<db.BloodPressureReadingRow?> findById(String id) async => _rows[id];

  @override
  Stream<List<db.BloodPressureReadingRow>> watchAll() {
    return Stream.value(_rows.values.toList());
  }

  @override
  Stream<List<db.BloodPressureReadingRow>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) {
    return Stream.value(
      _rows.values.where((row) {
        final reading = _mapper.toEntity(row);
        return !reading.measuredAt.isBefore(fromUtc) &&
            !reading.measuredAt.isAfter(toUtc);
      }).toList(),
    );
  }

  @override
  Future<db.BloodPressureReadingRow?> findLatest() async {
    return _rows.values.isEmpty ? null : _rows.values.first;
  }
}
