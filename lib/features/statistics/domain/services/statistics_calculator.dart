import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/bmi_summary.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/metric_summary.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/statistics_result.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/blood_pressure_classifier.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/bmi_calculator.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/trend_analyzer.dart';

class StatisticsCalculator {
  const StatisticsCalculator({
    this.classifier = const BloodPressureClassifier(),
    this.bmiCalculator = const BmiCalculator(),
    this.trendAnalyzer = const TrendAnalyzer(),
  });

  final BloodPressureClassifier classifier;
  final BmiCalculator bmiCalculator;
  final TrendAnalyzer trendAnalyzer;

  StatisticsResult calculate({
    required List<BloodPressureReading> readings,
    required DateTime from,
    required DateTime to,
    required AppSettings settings,
  }) {
    final sorted = [...readings]
      ..sort((a, b) => a.measuredAt.compareTo(b.measuredAt));

    return StatisticsResult(
      from: from,
      to: to,
      entryCount: sorted.length,
      systolic: _metric(sorted.map((r) => r.systolic).toList(), up: 3, down: 3),
      diastolic: _metric(
        sorted.map((r) => r.diastolic).toList(),
        up: 2,
        down: 2,
      ),
      pulse: _metric(
        sorted.where((r) => r.pulse != null).map((r) => r.pulse!).toList(),
        up: 3,
        down: 3,
      ),
      pulsePressure: _metric(
        sorted.map((r) => r.pulsePressure).toList(),
        up: 2,
        down: 2,
      ),
      meanArterialPressure: _metric(
        sorted.map((r) => r.meanArterialPressure).toList(),
        up: 2,
        down: 2,
      ),
      categoryDistribution: _distribution(sorted),
      bmi: _bmi(settings),
    );
  }

  MetricSummary _metric(
    List<num> values, {
    required num up,
    required num down,
  }) {
    if (values.isEmpty) {
      return const MetricSummary();
    }
    final min = values.fold<num>(values.first, (a, b) => a < b ? a : b);
    final max = values.fold<num>(values.first, (a, b) => a > b ? a : b);
    final average =
        values.fold<double>(0, (sum, value) => sum + value) / values.length;
    return MetricSummary(
      min: min,
      max: max,
      average: average.round(),
      trend: trendAnalyzer.analyze(
        values: values,
        upThreshold: up,
        downThreshold: down,
      ),
    );
  }

  Map<BloodPressureCategory, int> _distribution(
    List<BloodPressureReading> readings,
  ) {
    final distribution = <BloodPressureCategory, int>{};
    for (final reading in readings) {
      final category = classifier.classify(
        systolic: reading.systolic,
        diastolic: reading.diastolic,
      );
      distribution[category] = (distribution[category] ?? 0) + 1;
    }
    return distribution;
  }

  /// BMI is now computed purely from the profile settings (single height
  /// + single weight). No per-reading weight series exists anymore, so
  /// there's no "average BMI over period" — just a single current value.
  BmiSummary? _bmi(AppSettings settings) {
    final bmi = bmiCalculator.compute(
      weightKg: settings.weightKg,
      heightCm: settings.heightCm,
    );
    if (bmi == null) return null;
    return BmiSummary(bmi: bmi, category: bmiCalculator.categorize(bmi));
  }
}
