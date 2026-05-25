import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_theme.dart';
import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/overview/presentation/screens/overview_screen.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/blood_pressure_chart_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/latest_reading_card.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/time_slot_chart_card.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 5, 25, 10);

  testWidgets('latest reading card renders fixture reading', (tester) async {
    await tester.pumpWidget(
      _testApp(
        readings: [
          _reading(
            now: now,
            measuredAt: now,
            systolic: 132,
            diastolic: 84,
            pulse: 72,
          ),
        ],
        child: const LatestReadingCard(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('132 / 84'), findsOneWidget);
    expect(find.text('Pulse 72 bpm'), findsOneWidget);
  });

  testWidgets('period chip change updates periodProvider', (tester) async {
    final container = _container(
      now: now,
      readings: [
        _reading(now: now, measuredAt: now.subtract(const Duration(days: 3))),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      _scopedTestApp(
        container: container,
        child: const BloodPressureChartCard(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('7 d'));
    await tester.pumpAndSettle();

    final period = container.read(periodProvider);
    expect(period.start, DateTime(2026, 5, 19));
    expect(period.end, DateTime(2026, 5, 25, 23, 59, 59, 999));
  });

  testWidgets(
    'time-slot card shows chart when detector finds enough readings',
    (tester) async {
      await tester.pumpWidget(
        _testApp(
          readings: _timeSlotReadings(now),
          child: const TimeSlotChartCard(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LineChart), findsOneWidget);
      expect(find.textContaining('auto-detected'), findsOneWidget);
    },
  );

  testWidgets('time-slot card shows hint when detector has too few readings', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        readings: _timeSlotReadings(now).take(4).toList(),
        child: const TimeSlotChartCard(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        'Collect more readings at a similar time of day to see this view.',
      ),
      findsOneWidget,
    );
    expect(find.byType(LineChart), findsNothing);
  });

  testWidgets('time-slot card does not change when period chip changes', (
    tester,
  ) async {
    // OverviewScreen stacks four cards inside a ListView; the time-slot card
    // lives below the fold at the default 800x600 test viewport. Make the
    // viewport tall enough that the lazy sliver builds every card.
    final originalSize = tester.view.physicalSize;
    final originalRatio = tester.view.devicePixelRatio;
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.physicalSize = originalSize;
      tester.view.devicePixelRatio = originalRatio;
    });

    await tester.pumpWidget(
      _testApp(readings: _timeSlotReadings(now), child: const OverviewScreen()),
    );
    await tester.pumpAndSettle();

    final headerBefore = tester.widget<Text>(
      find.textContaining('auto-detected'),
    );

    await tester.tap(find.text('7 d'));
    await tester.pumpAndSettle();

    final headerAfter = tester.widget<Text>(
      find.textContaining('auto-detected'),
    );
    expect(headerAfter.data, headerBefore.data);
  });
}

Widget _testApp({
  required List<BloodPressureReading> readings,
  required Widget child,
}) {
  final container = _container(
    now: DateTime.utc(2026, 5, 25, 10),
    readings: readings,
  );
  return _scopedTestApp(container: container, child: child);
}

Widget _scopedTestApp({
  required ProviderContainer container,
  required Widget child,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

ProviderContainer _container({
  required DateTime now,
  required List<BloodPressureReading> readings,
}) {
  return ProviderContainer(
    overrides: [
      clockProvider.overrideWithValue(_FixedClock(now)),
      readingRepositoryProvider.overrideWithValue(
        _FakeReadingRepository(readings),
      ),
      settingsRepositoryProvider.overrideWithValue(
        _FakeSettingsRepository(AppSettings.defaults()),
      ),
    ],
  );
}

List<BloodPressureReading> _timeSlotReadings(DateTime now) {
  return List.generate(5, (index) {
    final measuredAt = DateTime.utc(2026, 5, 20 + index, 8, 15);
    return _reading(
      now: now,
      id: 'slot-$index',
      measuredAt: measuredAt,
      systolic: 128 + index,
      diastolic: 78 + index,
    );
  });
}

BloodPressureReading _reading({
  required DateTime now,
  DateTime? measuredAt,
  String id = 'reading-1',
  int systolic = 128,
  int diastolic = 82,
  int? pulse,
}) {
  return BloodPressureReading(
    id: id,
    measuredAt: measuredAt ?? now,
    systolic: systolic,
    diastolic: diastolic,
    pulse: pulse,
    source: ReadingSource.manual,
    createdAt: now,
    updatedAt: now,
  );
}

class _FixedClock implements Clock {
  const _FixedClock(this.value);

  final DateTime value;

  @override
  DateTime now() => value;
}

class _FakeReadingRepository implements ReadingRepository {
  _FakeReadingRepository(List<BloodPressureReading> readings)
    : _readings = readings.toList()
        ..sort((a, b) => b.measuredAt.compareTo(a.measuredAt));

  final List<BloodPressureReading> _readings;

  @override
  Future<void> upsert(BloodPressureReading reading) async {}

  @override
  Future<void> deleteById(String id) async {}

  @override
  Future<BloodPressureReading?> findById(String id) async {
    return _readings.where((reading) => reading.id == id).firstOrNull;
  }

  @override
  Stream<List<BloodPressureReading>> watchAll() => Stream.value(_readings);

  @override
  Stream<List<BloodPressureReading>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) {
    return Stream.value(
      _readings.where((reading) {
        return !reading.measuredAt.isBefore(fromUtc) &&
            !reading.measuredAt.isAfter(toUtc);
      }).toList(),
    );
  }

  @override
  Future<BloodPressureReading?> findLatest() async {
    return _readings.isEmpty ? null : _readings.first;
  }
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
