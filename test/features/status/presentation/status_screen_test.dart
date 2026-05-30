import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_theme.dart';
import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:blutdruck_tracker/features/status/presentation/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 5, 25, 12);

  testWidgets(
    'renders latest reading and the persistent disclaimer for fixture data',
    (tester) async {
      // Comfortable surface so all stacked cards in the ListView render.
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final readings = [_reading(id: 'r-latest', sys: 132, dia: 84, at: now)];

      await tester.pumpScreen(readings: readings, now: now);

      // Latest-reading card shows the systolic/diastolic — Text.rich now,
      // so check by substring rather than exact-match Text widget.
      expect(find.textContaining('132'), findsWidgets);
      expect(find.textContaining('84'), findsWidgets);

      // Persistent disclaimer block is present.
      expect(
        find.textContaining(
          'This app is for personal tracking and informational purposes only.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('shows empty-state text when there are no readings', (
    tester,
  ) async {
    await tester.pumpScreen(readings: const [], now: now);
    expect(find.text('No readings yet'), findsOneWidget);
  });
}

BloodPressureReading _reading({
  required String id,
  required int sys,
  required int dia,
  required DateTime at,
}) {
  return BloodPressureReading(
    id: id,
    measuredAt: at,
    systolic: sys,
    diastolic: dia,
    source: ReadingSource.manual,
    createdAt: at,
    updatedAt: at,
  );
}

extension on WidgetTester {
  Future<void> pumpScreen({
    required List<BloodPressureReading> readings,
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
            _FakeSettingsRepository(AppSettings.defaults()),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const StatusScreen(),
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
  _FakeReadingRepository(this._readings);

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
