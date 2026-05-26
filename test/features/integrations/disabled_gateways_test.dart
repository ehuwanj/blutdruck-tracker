import 'package:blutdruck_tracker/features/insights/domain/entities/insight_prompt_data.dart';
import 'package:blutdruck_tracker/features/integrations/fitbit/data/disabled_fitbit_gateway.dart';
import 'package:blutdruck_tracker/features/integrations/health/data/disabled_health_data_gateway.dart';
import 'package:blutdruck_tracker/features/integrations/llm/data/disabled_llm_gateway.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/metric_summary.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/statistics_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DisabledLlmGateway', () {
    const gateway = DisabledLlmGateway();
    final prompt = InsightPromptData(
      from: DateTime.utc(2026, 5),
      to: DateTime.utc(2026, 5, 31, 23, 59, 59, 999),
      localeName: 'en',
      stats: StatisticsResult(
        from: DateTime.utc(2026, 5),
        to: DateTime.utc(2026, 5, 31, 23, 59, 59, 999),
        entryCount: 0,
        systolic: const MetricSummary(),
        diastolic: const MetricSummary(),
        pulse: const MetricSummary(),
        pulsePressure: const MetricSummary(),
        meanArterialPressure: const MetricSummary(),
        categoryDistribution: const <BloodPressureCategory, int>{},
      ),
    );

    test('generateInsightSummary throws UnsupportedError', () async {
      await expectLater(
        () => gateway.generateInsightSummary(data: prompt),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });

  group('DisabledHealthDataGateway', () {
    const gateway = DisabledHealthDataGateway();

    test('isAvailable returns false', () async {
      expect(await gateway.isAvailable(), isFalse);
    });

    test('requestPermissions throws UnsupportedError', () async {
      await expectLater(
        gateway.requestPermissions,
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('writeBloodPressureReading throws UnsupportedError', () async {
      final reading = BloodPressureReading(
        id: 'r-1',
        measuredAt: DateTime.utc(2026, 5, 25, 7),
        systolic: 132,
        diastolic: 84,
        source: ReadingSource.manual,
        createdAt: DateTime.utc(2026, 5, 25, 7),
        updatedAt: DateTime.utc(2026, 5, 25, 7),
      );
      await expectLater(
        () => gateway.writeBloodPressureReading(reading),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('readBloodPressureReadings throws UnsupportedError', () async {
      await expectLater(
        () => gateway.readBloodPressureReadings(
          fromUtc: DateTime.utc(2026, 5),
          toUtc: DateTime.utc(2026, 5, 31, 23, 59, 59, 999),
        ),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });

  group('DisabledFitbitGateway', () {
    const gateway = DisabledFitbitGateway();

    test('isAvailable returns false', () async {
      expect(await gateway.isAvailable(), isFalse);
    });

    test('connect throws UnsupportedError', () async {
      await expectLater(gateway.connect, throwsA(isA<UnsupportedError>()));
    });

    test('disconnect throws UnsupportedError', () async {
      await expectLater(gateway.disconnect, throwsA(isA<UnsupportedError>()));
    });

    test('readFitnessSummary throws UnsupportedError', () async {
      await expectLater(
        () => gateway.readFitnessSummary(
          fromUtc: DateTime.utc(2026, 5),
          toUtc: DateTime.utc(2026, 5, 31, 23, 59, 59, 999),
        ),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
