import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_theme.dart';
import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:blutdruck_tracker/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 5, 25, 12);

  // Statistics screen stacks ~5 cards in a ListView. Use a tall test
  // viewport so the lazy sliver builds every card.
  void useTallViewport(WidgetTester tester) {
    final originalSize = tester.view.physicalSize;
    final originalRatio = tester.view.devicePixelRatio;
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.physicalSize = originalSize;
      tester.view.devicePixelRatio = originalRatio;
    });
  }

  testWidgets('renders all five metric rows with fixture data', (tester) async {
    useTallViewport(tester);
    await tester.pumpScreen(
      readings: _periodReadings(now: now, count: 6),
      settings: AppSettings.defaults(),
      now: now,
    );

    // Metric rows by label.
    expect(find.text('Systolic'), findsOneWidget);
    expect(find.text('Diastolic'), findsOneWidget);
    expect(find.text('Pulse'), findsOneWidget);
    expect(find.text('Pulse pressure'), findsOneWidget);
    expect(find.text('MAP'), findsOneWidget);

    // At least one Semantics node carries a trend label (stable / rising /
    // falling / no trend) — TrendIcon wraps an Icon with Semantics(label:).
    final hasTrendSemantics = find.byWidgetPredicate((widget) {
      return widget is Semantics &&
          {
            'rising',
            'falling',
            'stable',
            'no trend',
          }.contains(widget.properties.label);
    });
    expect(hasTrendSemantics, findsAtLeastNWidgets(1));
  });

  testWidgets('BMI card visible when height is set and weight is present', (
    tester,
  ) async {
    useTallViewport(tester);
    final readings = _periodReadings(now: now, count: 6, withWeight: true);
    await tester.pumpScreen(
      readings: readings,
      settings: AppSettings.defaults().copyWith(heightCm: 178),
      now: now,
    );

    expect(find.text('BMI'), findsOneWidget);
    // The helper text is the BMI card's tell-tale text.
    expect(
      find.textContaining('Calculated from your profile height'),
      findsOneWidget,
    );
  });

  testWidgets('BMI card is replaced by the profile-link when height is null', (
    tester,
  ) async {
    useTallViewport(tester);
    final readings = _periodReadings(now: now, count: 6, withWeight: true);
    await tester.pumpScreen(
      readings: readings,
      settings: AppSettings.defaults(),
      now: now,
    );

    expect(
      find.text('Set height in profile to calculate BMI.'),
      findsOneWidget,
    );
    // The full BMI card body text must not be present.
    expect(
      find.textContaining('Calculated from your profile height'),
      findsNothing,
    );
  });

  testWidgets('BMI card is hidden when height is set but no weight in period', (
    tester,
  ) async {
    useTallViewport(tester);
    final readings = _periodReadings(now: now, count: 6);
    await tester.pumpScreen(
      readings: readings,
      settings: AppSettings.defaults().copyWith(heightCm: 178),
      now: now,
    );

    expect(find.text('BMI'), findsNothing);
    expect(find.text('Set height in profile to calculate BMI.'), findsNothing);
  });
}

List<BloodPressureReading> _periodReadings({
  required DateTime now,
  required int count,
  bool withWeight = false,
}) {
  return [
    for (var i = 0; i < count; i++)
      BloodPressureReading(
        id: 'r-$i',
        // Spread across the current 30-day period so all readings fall in.
        measuredAt: now.subtract(Duration(days: i)),
        systolic: 130 + i,
        diastolic: 82 + (i % 4),
        pulse: 70 + i,
        weightKg: withWeight ? 78.0 + i * 0.2 : null,
        source: ReadingSource.manual,
        createdAt: now,
        updatedAt: now,
      ),
  ];
}

extension on WidgetTester {
  Future<void> pumpScreen({
    required List<BloodPressureReading> readings,
    required AppSettings settings,
    required DateTime now,
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(now)),
          readingRepositoryProvider.overrideWithValue(
            _FakeReadingRepository(readings),
          ),
          settingsRepositoryProvider.overrideWithValue(
            _FakeSettingsRepository(settings),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const StatisticsScreen(),
        ),
      ),
    );
    await pumpAndSettle();
  }
}

class _FixedClock implements Clock {
  const _FixedClock(this.value);
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
  _FakeReadingRepository(List<BloodPressureReading> readings)
    : _readings = readings.toList()
        ..sort((a, b) => b.measuredAt.compareTo(a.measuredAt));

  final List<BloodPressureReading> _readings;

  @override
  Future<void> upsert(BloodPressureReading reading) async {}

  @override
  Future<void> deleteById(String id) async {}

  @override
  Future<BloodPressureReading?> findById(String id) async => null;

  @override
  Future<BloodPressureReading?> findLatest() async =>
      _readings.isEmpty ? null : _readings.first;

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
}
