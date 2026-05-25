import 'dart:async';

import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_theme.dart';
import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:blutdruck_tracker/features/readings/presentation/screens/reading_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 5, 25, 10);

  testWidgets('groups readings by local day, newest first', (tester) async {
    final readings = [
      _reading(
        id: 'r-may-25-morning',
        measuredAt: DateTime(2026, 5, 25, 7, 30),
      ),
      _reading(
        id: 'r-may-25-evening',
        measuredAt: DateTime(2026, 5, 25, 20, 15),
      ),
      _reading(id: 'r-may-24', measuredAt: DateTime(2026, 5, 24, 8)),
    ];

    await tester.pumpScreen(seed: readings, now: now);

    // Two day headers (the count chip text is locale-formatted).
    expect(find.textContaining('May 25, 2026'), findsOneWidget);
    expect(find.textContaining('May 24, 2026'), findsOneWidget);

    // The May 25 section contains both same-day readings; May 24 has one.
    expect(find.text('2 entries'), findsOneWidget);
    expect(find.text('1 entry'), findsOneWidget);

    // Each row renders sys/dia as "<sys> / <dia>". Three rows, three texts.
    expect(find.textContaining('/'), findsAtLeastNWidgets(3));
  });

  testWidgets('swipe to delete cancel keeps the row', (tester) async {
    final repository = _FakeReadingRepository(
      seed: [_reading(id: 'r-1', measuredAt: now)],
    );

    await tester.pumpScreen(repository: repository, now: now);

    await tester.drag(
      find.byKey(const ValueKey('dismiss-r-1')),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byKey(const ValueKey('dismiss-r-1')), findsOneWidget);
    expect(repository.deletedIds, isEmpty);
  });

  testWidgets('swipe to delete confirm removes the row', (tester) async {
    final repository = _FakeReadingRepository(
      seed: [_reading(id: 'r-1', measuredAt: now)],
    );

    await tester.pumpScreen(repository: repository, now: now);

    await tester.drag(
      find.byKey(const ValueKey('dismiss-r-1')),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(repository.deletedIds, ['r-1']);
  });
}

BloodPressureReading _reading({
  required String id,
  required DateTime measuredAt,
  int systolic = 128,
  int diastolic = 82,
  int? pulse,
}) {
  return BloodPressureReading(
    id: id,
    measuredAt: measuredAt,
    systolic: systolic,
    diastolic: diastolic,
    pulse: pulse,
    source: ReadingSource.manual,
    createdAt: measuredAt,
    updatedAt: measuredAt,
  );
}

extension on WidgetTester {
  Future<void> pumpScreen({
    required DateTime now,
    _FakeReadingRepository? repository,
    List<BloodPressureReading>? seed,
  }) async {
    // OverviewScreen is unaffected here; the history screen renders a
    // single Scaffold with a small filter bar plus a ListView that fits
    // any reasonable test viewport.
    final repo = repository ?? _FakeReadingRepository(seed: seed ?? const []);
    await pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(now)),
          readingRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ReadingHistoryScreen(),
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

class _FakeReadingRepository implements ReadingRepository {
  _FakeReadingRepository({List<BloodPressureReading> seed = const []})
    : _readings = seed.toList();

  final List<BloodPressureReading> _readings;
  final deletedIds = <String>[];
  final _controller = StreamController<List<BloodPressureReading>>.broadcast();

  @override
  Future<void> upsert(BloodPressureReading reading) async {}

  @override
  Future<void> deleteById(String id) async {
    deletedIds.add(id);
    _readings.removeWhere((reading) => reading.id == id);
    _controller.add(List.unmodifiable(_readings));
  }

  @override
  Future<BloodPressureReading?> findById(String id) async => null;

  @override
  Future<BloodPressureReading?> findLatest() async =>
      _readings.isEmpty ? null : _readings.first;

  @override
  Stream<List<BloodPressureReading>> watchAll() async* {
    yield List.unmodifiable(_readings);
    yield* _controller.stream;
  }

  @override
  Stream<List<BloodPressureReading>> watchByRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) {
    return Stream.value(List.unmodifiable(_readings));
  }
}
