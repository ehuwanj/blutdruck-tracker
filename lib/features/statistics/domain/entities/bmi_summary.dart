import 'package:blutdruck_tracker/features/statistics/domain/entities/bmi_category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bmi_summary.freezed.dart';

/// BMI snapshot computed from `AppSettings.heightCm` and
/// `AppSettings.weightKg`. Weight is now a single setting (not
/// per-reading), so BMI has no time series — just the current value and
/// its WHO category. `null` when either height or weight is unset.
@freezed
class BmiSummary with _$BmiSummary {
  const factory BmiSummary({double? bmi, BmiCategory? category}) = _BmiSummary;
}
