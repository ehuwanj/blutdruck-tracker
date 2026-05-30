import 'package:blutdruck_tracker/core/constants/blood_pressure_thresholds.dart';
import 'package:blutdruck_tracker/features/insights/domain/entities/insight_severity.dart';
import 'package:blutdruck_tracker/features/insights/domain/services/rule_based_insight_engine.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/readings/domain/services/reading_validator.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/bmi_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/metric_summary.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/statistics_result.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_pick.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/trend_direction.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/blood_pressure_classifier.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/bmi_calculator.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/statistics_calculator.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/time_slot_aggregator.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/time_slot_detector.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/trend_analyzer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReadingValidator', () {
    const validator = ReadingValidator();
    final now = DateTime.utc(2026, 5, 25, 8);

    test('accepts valid input', () {
      final result = validator.validate(reading: reading(), now: now);

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
      expect(result.warnings, isEmpty);
    });

    test('accepts hard range boundaries', () {
      final cases = [
        reading(systolic: 50),
        reading(systolic: 260),
        reading(diastolic: 30, systolic: 90),
        reading(diastolic: 200, systolic: 220),
        reading(pulse: 25),
        reading(pulse: 220),
        reading(weightKg: 20),
        reading(weightKg: 400),
      ];

      for (final candidate in cases) {
        expect(
          validator.validate(reading: candidate, now: now).errors,
          isEmpty,
        );
      }
    });

    test('rejects values outside hard ranges', () {
      final cases = {
        ValidationIssue.systolicOutOfRange: [
          reading(systolic: 49),
          reading(systolic: 261),
        ],
        ValidationIssue.diastolicOutOfRange: [
          reading(diastolic: 29),
          reading(diastolic: 201, systolic: 220),
        ],
        ValidationIssue.pulseOutOfRange: [
          reading(pulse: 24),
          reading(pulse: 221),
        ],
        ValidationIssue.weightOutOfRange: [
          reading(weightKg: 19),
          reading(weightKg: 401),
        ],
      };

      for (final entry in cases.entries) {
        for (final candidate in entry.value) {
          expect(
            validator.validate(reading: candidate, now: now).errors,
            contains(entry.key),
          );
        }
      }
    });

    test('reports soft warnings at unusual bands', () {
      final cases = {
        ValidationIssue.systolicUnusual: [
          reading(systolic: 79),
          reading(systolic: 201),
        ],
        ValidationIssue.diastolicUnusual: [
          reading(diastolic: 39, systolic: 90),
          reading(diastolic: 131, systolic: 150),
        ],
        ValidationIssue.pulseUnusual: [reading(pulse: 39), reading(pulse: 151)],
      };

      for (final entry in cases.entries) {
        for (final candidate in entry.value) {
          expect(
            validator.validate(reading: candidate, now: now).warnings,
            contains(entry.key),
          );
        }
      }
    });

    test('warns for cross-field, old date, and weight step', () {
      final result = validator.validate(
        reading: reading(
          systolic: 90,
          diastolic: 86,
          measuredAt: DateTime.utc(2020),
          weightKg: 86,
        ),
        previousReading: reading(weightKg: 80),
        now: now,
      );

      expect(result.errors, isEmpty);
      expect(result.warnings, contains(ValidationIssue.systolicDiastolicClose));
      expect(
        result.warnings,
        contains(ValidationIssue.measuredAtOlderThanFiveYears),
      );
      expect(result.warnings, contains(ValidationIssue.weightStepUnusual));
    });

    test('rejects measured-at too far in future and note length limits', () {
      final result = validator.validate(
        reading: reading(
          measuredAt: now.add(const Duration(hours: 2)),
          note: 'n' * 501,
        ),
        now: now,
      );

      expect(result.errors, contains(ValidationIssue.measuredAtTooFarInFuture));
      expect(result.errors, contains(ValidationIssue.noteTooLong));
    });
  });

  group('BloodPressureClassifier', () {
    const classifier = BloodPressureClassifier();

    test('classifies representative category values', () {
      expect(
        classifier.classify(systolic: 85, diastolic: 65),
        BloodPressureCategory.hypotension,
      );
      expect(
        classifier.classify(systolic: 118, diastolic: 76),
        BloodPressureCategory.optimal,
      );
      expect(
        classifier.classify(systolic: 124, diastolic: 82),
        BloodPressureCategory.normal,
      );
      expect(
        classifier.classify(systolic: 134, diastolic: 86),
        BloodPressureCategory.highNormal,
      );
      expect(
        classifier.classify(systolic: 145, diastolic: 92),
        BloodPressureCategory.hypertensionGrade1,
      );
      expect(
        classifier.classify(systolic: 164, diastolic: 102),
        BloodPressureCategory.hypertensionGrade2,
      );
      expect(
        classifier.classify(systolic: 184, diastolic: 112),
        BloodPressureCategory.hypertensionGrade3,
      );
      expect(
        classifier.classify(systolic: 145, diastolic: 85),
        BloodPressureCategory.isolatedSystolic,
      );
    });

    test('uses the binding evaluation order', () {
      expect(
        classifier.classify(systolic: 145, diastolic: 85),
        BloodPressureCategory.isolatedSystolic,
      );
      expect(
        classifier.classify(systolic: 145, diastolic: 92),
        BloodPressureCategory.hypertensionGrade1,
      );
      expect(
        classifier.classify(systolic: 185, diastolic: 80),
        BloodPressureCategory.hypertensionGrade3,
      );
      expect(
        classifier.classify(systolic: 85, diastolic: 55),
        BloodPressureCategory.hypotension,
      );
      expect(
        () => classifier.classify(systolic: 49, diastolic: 70),
        throwsArgumentError,
      );
    });
  });

  group('BmiCalculator', () {
    const calculator = BmiCalculator();

    test('returns null for missing or invalid inputs', () {
      expect(calculator.compute(weightKg: null, heightCm: 180), isNull);
      expect(calculator.compute(weightKg: 75, heightCm: null), isNull);
      expect(calculator.compute(weightKg: 75, heightCm: 79), isNull);
      expect(calculator.compute(weightKg: 75, heightCm: 251), isNull);
      expect(calculator.compute(weightKg: 19, heightCm: 180), isNull);
      expect(calculator.compute(weightKg: 401, heightCm: 180), isNull);
    });

    test('categorizes boundary cases', () {
      expect(calculator.categorize(18.5), BmiCategory.normal);
      expect(calculator.categorize(24.999), BmiCategory.normal);
      expect(calculator.categorize(25), BmiCategory.overweight);
      expect(calculator.categorize(30), BmiCategory.obese);
    });

    test('rounds display value to one decimal', () {
      expect(calculator.roundForDisplay(26.45), 26.5);
    });
  });

  group('TrendAnalyzer', () {
    const analyzer = TrendAnalyzer();

    test('returns unknown with fewer than four values', () {
      expect(
        analyzer.analyze(values: [1, 2, 3], upThreshold: 3, downThreshold: 3),
        TrendDirection.unknown,
      );
    });

    test('returns up, down, and stable at thresholds', () {
      expect(
        analyzer.analyze(
          values: [100, 100, 103, 103],
          upThreshold: 3,
          downThreshold: 3,
        ),
        TrendDirection.up,
      );
      expect(
        analyzer.analyze(
          values: [100, 100, 97, 97],
          upThreshold: 3,
          downThreshold: 3,
        ),
        TrendDirection.down,
      );
      expect(
        analyzer.analyze(
          values: [100, 100, 102, 102],
          upThreshold: 3,
          downThreshold: 3,
        ),
        TrendDirection.stable,
      );
    });

    test('uses metric-specific thresholds', () {
      expect(
        analyzer.analyze(
          values: [80, 80, 82, 82],
          upThreshold: 2,
          downThreshold: 2,
        ),
        TrendDirection.up,
      );
      expect(
        analyzer.analyze(
          values: [80.0, 80.0, 79.7, 79.7],
          upThreshold: 0.3,
          downThreshold: 0.3,
        ),
        TrendDirection.down,
      );
    });
  });

  group('StatisticsCalculator', () {
    const calculator = StatisticsCalculator();
    final from = DateTime.utc(2026, 5);
    final to = DateTime.utc(2026, 5, 31);

    test('empty input returns null metrics and count zero', () {
      final result = calculator.calculate(
        readings: const [],
        from: from,
        to: to,
        settings: AppSettings.defaults(),
      );

      expect(result.entryCount, 0);
      expect(result.systolic.min, isNull);
      expect(result.diastolic.average, isNull);
      expect(result.pulse.trend, TrendDirection.unknown);
      expect(result.categoryDistribution, isEmpty);
    });

    test('single reading computes metrics', () {
      final result = calculator.calculate(
        readings: [reading(systolic: 140, diastolic: 90, pulse: 70)],
        from: from,
        to: to,
        settings: AppSettings.defaults(),
      );

      expect(result.entryCount, 1);
      expect(result.systolic.min, 140);
      expect(result.systolic.max, 140);
      expect(result.systolic.average, 140);
      expect(result.pulse.average, 70);
      expect(result.pulsePressure.average, 50);
      expect(result.meanArterialPressure.average, 107);
    });

    test('multiple readings compute min max averages and mixed presence', () {
      final result = calculator.calculate(
        readings: [
          reading(pulse: 60),
          reading(systolic: 130, diastolic: 85),
          reading(systolic: 140, diastolic: 90, pulse: 90),
        ],
        from: from,
        to: to,
        settings: AppSettings.defaults(),
      );

      expect(result.systolic.min, 120);
      expect(result.systolic.max, 140);
      expect(result.systolic.average, 130);
      expect(result.diastolic.average, 85);
      expect(result.pulse.average, 75);
      expect(result.categoryDistribution[BloodPressureCategory.normal], 1);
    });

    test('BMI integration follows height and latest weighted reading', () {
      final result = calculator.calculate(
        readings: [
          reading(measuredAt: DateTime.utc(2026, 5), weightKg: 80),
          reading(measuredAt: DateTime.utc(2026, 5, 2), weightKg: 75),
        ],
        from: from,
        to: to,
        settings: AppSettings.defaults().copyWith(heightCm: 180),
      );
      final noWeight = calculator.calculate(
        readings: [reading()],
        from: from,
        to: to,
        settings: AppSettings.defaults().copyWith(heightCm: 180),
      );
      final noHeight = calculator.calculate(
        readings: [reading(weightKg: 80)],
        from: from,
        to: to,
        settings: AppSettings.defaults(),
      );

      expect(result.bmi, isNotNull);
      expect(result.bmi!.currentBmi, closeTo(23.148, 0.001));
      expect(result.bmi!.averageBmi, closeTo(23.92, 0.01));
      expect(result.bmi!.category, BmiCategory.normal);
      expect(noWeight.bmi, isNull);
      expect(noHeight.bmi, isNull);
    });
  });

  group('TimeSlotDetector', () {
    const detector = TimeSlotDetector();

    test('returns null when fewer than five readings match any slot', () {
      final pick = detector.detect(
        readings: List.generate(4, (index) => readingAtLocal(8, index)),
        widthMinutes: 60,
      );

      expect(pick, isNull);
    });

    test('picks highest count and tie-breaks by earliest start', () {
      final readings = [
        ...List.generate(5, (index) => readingAtLocal(8, index)),
        ...List.generate(5, (index) => readingAtLocal(10, index)),
        readingAtLocal(10, 45),
      ];
      final tied = detector.detect(
        readings: [
          ...List.generate(3, (_) => readingAtLocal(7, 0)),
          ...List.generate(2, (_) => readingAtLocal(7, 59)),
          ...List.generate(3, (_) => readingAtLocal(9, 0)),
          ...List.generate(2, (_) => readingAtLocal(9, 59)),
        ],
        widthMinutes: 60,
      );

      final pick = detector.detect(readings: readings, widthMinutes: 60);

      expect(pick!.slot.startMinutes, 600);
      expect(pick.matchingReadings, 6);
      expect(tied!.slot.startMinutes, 420);
    });

    test('pinned start short-circuits and clamps before midnight', () {
      final pick = detector.detect(
        readings: const [],
        widthMinutes: 120,
        pinnedStartMinutes: 1380,
      );

      expect(pick!.isAutoDetected, isFalse);
      expect(pick.slot.startMinutes, 1320);
      expect(pick.slot.endMinutesExclusive, 1440);
      expect(pick.matchingReadings, 0);
    });

    test('supports slot widths 60, 120, and 180', () {
      final readings = List.generate(
        5,
        (index) => readingAtLocal(8, index * 10),
      );

      for (final width in [60, 120, 180]) {
        expect(
          detector.detect(readings: readings, widthMinutes: width),
          isNotNull,
        );
      }
    });
  });

  group('TimeSlotAggregator', () {
    const aggregator = TimeSlotAggregator();
    const pick = TimeSlotPick(
      slot: TimeSlot(startMinutes: 480, widthMinutes: 60),
      isAutoDetected: true,
      matchingReadings: 5,
    );

    test('creates one point for one in-slot reading per day', () {
      final series = aggregator.aggregate(
        readings: [
          readingAtLocal(8, 15, systolic: 132, diastolic: 84, pulse: 72),
        ],
        pick: pick,
      );

      expect(series.points, hasLength(1));
      expect(series.points.single.systolicAverage, 132);
      expect(series.points.single.diastolicAverage, 84);
      expect(series.points.single.pulseAverage, 72);
    });

    test('averages multiple same-day readings and omits out-of-slot days', () {
      final series = aggregator.aggregate(
        readings: [
          readingAtLocal(8, 0, systolic: 130),
          readingAtLocal(8, 30, systolic: 135, diastolic: 85, pulse: 75),
          readingAtLocal(10, 0, systolic: 180, diastolic: 100, pulse: 100),
        ],
        pick: pick,
      );

      expect(series.points, hasLength(1));
      expect(series.points.single.systolicAverage, 133);
      expect(series.points.single.diastolicAverage, 83);
      expect(series.points.single.pulseAverage, 75);
      expect(series.points.single.readingCount, 2);
    });

    test('sets pulse average null and sorts by local day', () {
      final series = aggregator.aggregate(
        readings: [
          readingAtLocal(8, 0, measuredAt: DateTime(2026, 5, 2, 8)),
          readingAtLocal(8, 0, measuredAt: DateTime(2026, 5, 1, 8)),
        ],
        pick: pick,
      );

      expect(series.points, hasLength(2));
      expect(series.points.first.localDay, DateTime(2026, 5));
      expect(series.points.first.pulseAverage, isNull);
    });
  });

  group('RuleBasedInsightEngine', () {
    const engine = RuleBasedInsightEngine();

    test('rule 1 fires alone for no data', () {
      final insights = engine.generate(
        stats: stats(),
        readings: const [],
        periodLength: const Duration(days: 7),
        messages: messagesEn,
      );

      expect(insights, hasLength(1));
      expect(insights.single.id, 'noData');
    });

    test('rule 4 and rule 6 can both fire independently', () {
      final insights = engine.generate(
        stats: stats(
          entryCount: 6,
          systolic: const MetricSummary(trend: TrendDirection.up),
        ),
        readings: List.generate(
          6,
          (_) => reading(systolic: 145, diastolic: 95),
        ),
        periodLength: const Duration(days: 7),
        messages: messagesEn,
      );

      expect(
        insights.map((i) => i.id),
        containsAllInOrder(['bpRising', 'frequentlyElevated']),
      );
      expect(insights.first.severity, InsightSeverity.warning);
    });

    test('is deterministic', () {
      final inputStats = stats(entryCount: 6);
      final readings = List.generate(6, (_) => reading());

      final first = engine.generate(
        stats: inputStats,
        readings: readings,
        periodLength: const Duration(days: 7),
        messages: messagesEn,
      );
      final second = engine.generate(
        stats: inputStats,
        readings: readings,
        periodLength: const Duration(days: 7),
        messages: messagesEn,
      );

      expect(second.map((i) => i.id), first.map((i) => i.id));
    });

    test('resolves plural count templates for EN DE ZH fixtures', () {
      for (final messages in [messagesEn, messagesDe, messagesZh]) {
        final insights = engine.generate(
          stats: stats(entryCount: 2),
          readings: [
            reading(systolic: 145, diastolic: 95),
            reading(systolic: 150, diastolic: 98),
          ],
          periodLength: const Duration(days: 7),
          messages: messages,
        );

        final elevated = insights.singleWhere(
          (i) => i.id == 'frequentlyElevated',
        );
        expect(elevated.body, contains('2'));
        expect(elevated.body, contains('readings'));
      }
    });
  });

  test('BloodPressureThresholds snapshot is stable', () {
    final snapshot = kBloodPressureThresholds.map(
      (key, value) => MapEntry(key.name, value.toSnapshot()),
    );

    expect(snapshot, {
      'hypotension': {
        'systolicFrom': null,
        'systolicTo': null,
        'systolicBelow': 90,
        'diastolicFrom': null,
        'diastolicTo': null,
        'diastolicBelow': 60,
      },
      'optimal': {
        'systolicFrom': null,
        'systolicTo': null,
        'systolicBelow': 120,
        'diastolicFrom': null,
        'diastolicTo': null,
        'diastolicBelow': 80,
      },
      'normal': {
        'systolicFrom': 120,
        'systolicTo': 129,
        'systolicBelow': null,
        'diastolicFrom': 80,
        'diastolicTo': 84,
        'diastolicBelow': null,
      },
      'highNormal': {
        'systolicFrom': 130,
        'systolicTo': 139,
        'systolicBelow': null,
        'diastolicFrom': 85,
        'diastolicTo': 89,
        'diastolicBelow': null,
      },
      'hypertensionGrade1': {
        'systolicFrom': 140,
        'systolicTo': 159,
        'systolicBelow': null,
        'diastolicFrom': 90,
        'diastolicTo': 99,
        'diastolicBelow': null,
      },
      'hypertensionGrade2': {
        'systolicFrom': 160,
        'systolicTo': 179,
        'systolicBelow': null,
        'diastolicFrom': 100,
        'diastolicTo': 109,
        'diastolicBelow': null,
      },
      'hypertensionGrade3': {
        'systolicFrom': 180,
        'systolicTo': null,
        'systolicBelow': null,
        'diastolicFrom': 110,
        'diastolicTo': null,
        'diastolicBelow': null,
      },
      'isolatedSystolic': {
        'systolicFrom': 140,
        'systolicTo': null,
        'systolicBelow': null,
        'diastolicFrom': null,
        'diastolicTo': null,
        'diastolicBelow': 90,
      },
    });
  });
}

BloodPressureReading reading({
  DateTime? measuredAt,
  int systolic = 120,
  int diastolic = 80,
  int? pulse,
  double? weightKg,
  String? note,
}) {
  final timestamp = measuredAt ?? DateTime.utc(2026, 5, 25, 8);
  return BloodPressureReading(
    id: 'r-${timestamp.microsecondsSinceEpoch}-$systolic-$diastolic',
    measuredAt: timestamp,
    systolic: systolic,
    diastolic: diastolic,
    pulse: pulse,
    weightKg: weightKg,
    note: note,
    source: ReadingSource.manual,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

BloodPressureReading readingAtLocal(
  int hour,
  int minute, {
  DateTime? measuredAt,
  int systolic = 120,
  int diastolic = 80,
  int? pulse,
}) {
  final local = measuredAt ?? DateTime(2026, 5, 25, hour, minute);
  return reading(
    measuredAt: local.toUtc(),
    systolic: systolic,
    diastolic: diastolic,
    pulse: pulse,
  );
}

StatisticsResult stats({
  int entryCount = 0,
  MetricSummary systolic = const MetricSummary(),
  MetricSummary diastolic = const MetricSummary(),
}) {
  const empty = MetricSummary();
  return StatisticsResult(
    from: DateTime.utc(2026, 5),
    to: DateTime.utc(2026, 5, 31),
    entryCount: entryCount,
    systolic: systolic,
    diastolic: diastolic,
    pulse: empty,
    pulsePressure: empty,
    meanArterialPressure: empty,
    categoryDistribution: const {},
  );
}

const messagesEn = {
  'insight.noData.title': 'No data',
  'insight.noData.body': 'No data yet.',
  'insight.fewEntries.title': 'Few readings',
  'insight.fewEntries.body': 'Few readings.',
  'insight.measureMoreOften.title': 'More readings',
  'insight.measureMoreOften.body': 'More readings help.',
  'insight.bpRising.title': 'Rising',
  'insight.bpRising.body': 'Values are rising.',
  'insight.bpFalling.title': 'Falling',
  'insight.bpFalling.body': 'Values are falling.',
  'insight.frequentlyElevated.title': 'Elevated often',
  'insight.frequentlyElevated.body':
      '{count, plural, one {1 reading} other {# readings}} '
      'of {total} readings.',
  'insight.frequentlyLow.title': 'Low often',
  'insight.frequentlyLow.body':
      '{count, plural, one {1 reading} other {# readings}} '
      'of {total} readings.',
  'insight.wellDocumented.title': 'Well documented',
  'insight.wellDocumented.body': 'Well documented.',
};

final messagesDe = {
  ...messagesEn,
  'insight.frequentlyElevated.body':
      '{count, plural, one {1 readings} other {# readings}} '
      'von {total} readings.',
};

final messagesZh = {
  ...messagesEn,
  'insight.frequentlyElevated.body':
      '{count, plural, one {1 readings} other {# readings}} '
      '/ {total} readings.',
};
