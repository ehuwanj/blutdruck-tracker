import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/readings/data/datasources/reading_local_datasource.dart';
import 'package:blutdruck_tracker/features/readings/data/repositories/reading_repository_impl.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/add_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/delete_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/get_latest_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/get_reading_by_id.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/get_readings.dart';
import 'package:blutdruck_tracker/features/readings/domain/usecases/update_reading.dart';
import 'package:blutdruck_tracker/features/settings/data/datasources/app_settings_local_datasource.dart';
import 'package:blutdruck_tracker/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/statistics_result.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_pick.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_series.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/statistics_calculator.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/time_slot_aggregator.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/time_slot_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.open();
  ref.onDispose(database.close);
  return database;
});

final readingLocalDataSourceProvider = Provider<ReadingLocalDataSource>((ref) {
  return DriftReadingLocalDataSource(ref.watch(databaseProvider));
});

final appSettingsLocalDataSourceProvider = Provider<AppSettingsLocalDataSource>(
  (ref) {
    return DriftAppSettingsLocalDataSource(ref.watch(databaseProvider));
  },
);

final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  return ReadingRepositoryImpl(ref.watch(readingLocalDataSourceProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(appSettingsLocalDataSourceProvider));
});

final addReadingProvider = Provider<AddReading>((ref) {
  return AddReading(ref.watch(readingRepositoryProvider));
});

final updateReadingProvider = Provider<UpdateReading>((ref) {
  return UpdateReading(ref.watch(readingRepositoryProvider));
});

final deleteReadingProvider = Provider<DeleteReading>((ref) {
  return DeleteReading(ref.watch(readingRepositoryProvider));
});

final getReadingsProvider = Provider<GetReadings>((ref) {
  return GetReadings(ref.watch(readingRepositoryProvider));
});

final getReadingByIdProvider = Provider<GetReadingById>((ref) {
  return GetReadingById(ref.watch(readingRepositoryProvider));
});

final getLatestReadingProvider = Provider<GetLatestReading>((ref) {
  return GetLatestReading(ref.watch(readingRepositoryProvider));
});

final readingsStreamProvider =
    StreamProvider.autoDispose<List<BloodPressureReading>>((ref) {
      return ref.watch(readingRepositoryProvider).watchAll();
    });

final latestReadingProvider = Provider<AsyncValue<BloodPressureReading?>>((
  ref,
) {
  return ref
      .watch(readingsStreamProvider)
      .whenData((readings) => readings.isEmpty ? null : readings.first);
});

final periodProvider = NotifierProvider<PeriodNotifier, DateTimeRange>(
  PeriodNotifier.new,
);

class PeriodNotifier extends Notifier<DateTimeRange> {
  @override
  DateTimeRange build() {
    final now = ref.watch(clockProvider).now().toLocal();
    return DateTimeRange(
      start: DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 29)),
      end: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
    );
  }

  // ignore: use_setters_to_change_properties, reads naturally at call sites.
  void setRange(DateTimeRange range) => state = range;
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() => ref.watch(settingsRepositoryProvider).read();

  Future<void> save(AppSettings settings) async {
    state = AsyncValue.data(settings);
    await ref.read(settingsRepositoryProvider).write(settings);
  }
}

final statisticsProvider = Provider<AsyncValue<StatisticsResult>>((ref) {
  final period = ref.watch(periodProvider);
  final readings = ref.watch(readingsStreamProvider);
  final settings =
      ref.watch(settingsProvider).valueOrNull ?? AppSettings.defaults();
  return readings.whenData((all) {
    return const StatisticsCalculator().calculate(
      readings: all.where((reading) {
        return !reading.measuredAt.isBefore(period.start.toUtc()) &&
            !reading.measuredAt.isAfter(period.end.toUtc());
      }).toList(),
      from: period.start.toUtc(),
      to: period.end.toUtc(),
      settings: settings,
    );
  });
});

final timeSlotDetectorInputProvider =
    Provider<AsyncValue<List<BloodPressureReading>>>((ref) {
      final now = ref.watch(clockProvider).now();
      final cutoff = now.subtract(const Duration(days: 30));
      return ref
          .watch(readingsStreamProvider)
          .whenData(
            (all) => all
                .where((reading) => !reading.measuredAt.isBefore(cutoff))
                .toList(),
          );
    });

final timeSlotPickProvider = Provider<AsyncValue<TimeSlotPick?>>((ref) {
  final input = ref.watch(timeSlotDetectorInputProvider);
  final settings =
      ref.watch(settingsProvider).valueOrNull ?? AppSettings.defaults();
  return input.whenData((readings) {
    return const TimeSlotDetector().detect(
      readings: readings,
      widthMinutes: settings.timeSlotWidthMinutes,
      pinnedStartMinutes: settings.pinnedTimeSlotStartMinutes,
    );
  });
});

final timeSlotSeriesProvider = Provider<AsyncValue<TimeSlotSeries?>>((ref) {
  final input = ref.watch(timeSlotDetectorInputProvider);
  final pick = ref.watch(timeSlotPickProvider);
  return pick.whenData((selected) {
    if (selected == null) {
      return null;
    }
    return const TimeSlotAggregator().aggregate(
      readings: input.valueOrNull ?? const [],
      pick: selected,
    );
  });
});
