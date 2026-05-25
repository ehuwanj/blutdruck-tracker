import 'package:blutdruck_tracker/features/statistics/domain/entities/trend_direction.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'metric_summary.freezed.dart';

/// Min/max/avg of one metric over a period, plus its trend direction.
/// `null` values mean "no data" — the UI renders an em dash, not "0".
@freezed
class MetricSummary with _$MetricSummary {
  const factory MetricSummary({
    num? min,
    num? max,
    num? average,
    @Default(TrendDirection.unknown) TrendDirection trend,
  }) = _MetricSummary;
}
