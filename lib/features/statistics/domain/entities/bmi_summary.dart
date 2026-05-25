import 'package:blutdruck_tracker/features/statistics/domain/entities/bmi_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bmi_summary.freezed.dart';

/// BMI rollup over a period. Computed only when height (settings) and at
/// least one in-period weight reading are both present; otherwise the
/// parent `StatisticsResult.bmi` is `null`.
@freezed
class BmiSummary with _$BmiSummary {
  const factory BmiSummary({
    /// BMI of the latest in-period reading that has a weight.
    double? currentBmi,

    /// Mean of per-reading BMI values across in-period readings with weight.
    double? averageBmi,

    /// Category of [currentBmi]; `null` when [currentBmi] is `null`.
    BmiCategory? category,
  }) = _BmiSummary;
}
