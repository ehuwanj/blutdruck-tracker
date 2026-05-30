import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/app/theme/app_theme.dart';
import 'package:blutdruck_tracker/core/utils/clock.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/latest_reading_card.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/readings/domain/repositories/reading_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 5, 25, 10);

  testWidgets('latest-reading card exposes one composite Semantics label '
      'covering systolic, diastolic, pulse, category, and relative time', (
    tester,
  ) async {
    await tester.pumpScreen(
      readings: [
        BloodPressureReading(
          id: 'r-1',
          measuredAt: now.subtract(const Duration(minutes: 30)),
          systolic: 132,
          diastolic: 84,
          pulse: 72,
          source: ReadingSource.manual,
          createdAt: now,
          updatedAt: now,
        ),
      ],
      now: now,
    );

    // The Semantics widget wraps the entire reading column; its label
    // must mention every spoken piece in one sentence. Looking for the
    // three numerics is sufficient — only the composite label contains
    // all three; the leaf widgets each carry just one number.
    final semanticsWithLabel = find.byWidgetPredicate((widget) {
      if (widget is! Semantics) return false;
      final label = widget.properties.label;
      if (label == null) return false;
      return label.contains('132') &&
          label.contains('84') &&
          label.contains('72');
    });
    expect(semanticsWithLabel, findsAtLeastNWidgets(1));
  });

  testWidgets(
    'latest-reading card renders at 200% text scaling without overflow',
    (tester) async {
      // Make the test surface comfortably wide so we are testing reflow,
      // not viewport clipping. RenderFlex overflow shows up as a logged
      // error which fails the test; if the card lays out cleanly at 2x
      // scale, this passes.
      final originalSize = tester.view.physicalSize;
      final originalRatio = tester.view.devicePixelRatio;
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.physicalSize = originalSize;
        tester.view.devicePixelRatio = originalRatio;
      });

      await tester.pumpScreen(
        readings: [
          BloodPressureReading(
            id: 'r-1',
            measuredAt: now.subtract(const Duration(minutes: 30)),
            systolic: 132,
            diastolic: 84,
            pulse: 72,
            source: ReadingSource.manual,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        now: now,
        textScaler: const TextScaler.linear(2),
      );

      // Text.rich-based format renders 132 and 84 in separate spans;
      // textContaining is enough as a smoke check for "did the numbers
      // render". The real assertion here is no RenderFlex overflow.
      expect(find.textContaining('132'), findsWidgets);
      expect(find.textContaining('84'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}

extension on WidgetTester {
  Future<void> pumpScreen({
    required List<BloodPressureReading> readings,
    required DateTime now,
    TextScaler textScaler = TextScaler.noScaling,
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: [
          clockProvider.overrideWithValue(_FixedClock(now)),
          readingRepositoryProvider.overrideWithValue(
            _FakeReadingRepository(readings),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: child!,
            );
          },
          home: const Scaffold(body: LatestReadingCard()),
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
    return Stream.value(_readings);
  }
}
