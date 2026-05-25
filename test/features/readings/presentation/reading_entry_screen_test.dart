import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:blutdruck_tracker/features/readings/presentation/screens/reading_entry_screen.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('submit is disabled when systolic or diastolic is missing', (
    tester,
  ) async {
    await tester.pumpScreen(repository: _FakeReadingRepository());

    final save = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(save.onPressed, isNull);
  });

  testWidgets('warning is shown when systolic is close to diastolic', (
    tester,
  ) async {
    await tester.pumpScreen(repository: _FakeReadingRepository());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Systolic'),
      '90',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Diastolic'),
      '86',
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Systolic should usually be higher than diastolic.'),
      findsOneWidget,
    );
  });

  testWidgets('submit adds a reading with the expected values', (tester) async {
    final repository = _FakeReadingRepository();
    await tester.pumpScreen(repository: repository);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Systolic'),
      '132',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Diastolic'),
      '84',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(repository.upserted, hasLength(1));
    expect(repository.upserted.single.systolic, 132);
    expect(repository.upserted.single.diastolic, 84);
  });

  testWidgets('edit mode pre-fills and saves via update path', (tester) async {
    final existing = reading(id: 'r1', systolic: 128, diastolic: 82);
    final repository = _FakeReadingRepository(seed: [existing]);
    await tester.pumpScreen(repository: repository, readingId: 'r1');

    expect(find.widgetWithText(TextFormField, '128'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, '82'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Systolic'),
      '130',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(repository.upserted.single.id, 'r1');
    expect(repository.upserted.single.systolic, 130);
  });
}

extension on WidgetTester {
  Future<void> pumpScreen({
    required _FakeReadingRepository repository,
    String? readingId,
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(
            _FakeClock(DateTime.utc(2026, 5, 25, 8)),
          ),
          readingRepositoryProvider.overrideWithValue(repository),
          settingsRepositoryProvider.overrideWithValue(
            _FakeSettingsRepository(AppSettings.defaults()),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ReadingEntryScreen(readingId: readingId),
        ),
      ),
    );
    await pumpAndSettle();
  }
}

BloodPressureReading reading({
  required String id,
  int systolic = 120,
  int diastolic = 80,
}) {
  final now = DateTime.utc(2026, 5, 25, 8);
  return BloodPressureReading(
    id: id,
    measuredAt: now,
    systolic: systolic,
    diastolic: diastolic,
    source: ReadingSource.manual,
    createdAt: now,
    updatedAt: now,
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

  final AppSettings value;

  @override
  Future<AppSettings> read() async => value;

  @override
  Future<void> write(AppSettings settings) async {}
}

class _FakeReadingRepository implements ReadingRepository {
  _FakeReadingRepository({List<BloodPressureReading> seed = const []})
    : readings = [...seed];

  final List<BloodPressureReading> readings;
  final upserted = <BloodPressureReading>[];

  @override
  Future<void> upsert(BloodPressureReading reading) async {
    upserted.add(reading);
    readings
      ..removeWhere((candidate) => candidate.id == reading.id)
      ..add(reading);
  }

  @override
  Future<void> deleteById(String id) async {
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
  Future<BloodPressureReading?> findLatest() async {
    return readings.isEmpty ? null : readings.last;
  }

  @override
  Stream<List<BloodPressureReading>> watchAll() => Stream.value(readings);

  @override
  Stream<List<BloodPressureReading>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) {
    return Stream.value(readings);
  }
}
