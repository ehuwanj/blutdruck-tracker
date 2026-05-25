import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/bmi_summary.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/metric_summary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics_result.freezed.dart';

/// Aggregated statistics over a closed date range. Produced by
/// `StatisticsCalculator` in step 2.
@freezed
class StatisticsResult with _$StatisticsResult {
  const factory StatisticsResult({
    /// UTC, inclusive.
    required DateTime from,

    /// UTC, inclusive.
    required DateTime to,
    required int entryCount,
    required MetricSummary systolic,
    required MetricSummary diastolic,
    required MetricSummary pulse,
    required MetricSummary pulsePressure,
    required MetricSummary meanArterialPressure,
    required Map<BloodPressureCategory, int> categoryDistribution,

    /// `null` when height is unset or no in-period reading has weight.
    BmiSummary? bmi,
  }) = _StatisticsResult;
}
