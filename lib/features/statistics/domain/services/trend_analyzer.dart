import 'package:blutdruck_tracker/features/statistics/domain/entities/trend_direction.dart';

class TrendAnalyzer {
  const TrendAnalyzer();

  TrendDirection analyze({
    required List<num> values,
    required num upThreshold,
    required num downThreshold,
  }) {
    if (values.length < 4) {
      return TrendDirection.unknown;
    }
    final midpoint = values.length ~/ 2;
    final first = values.take(midpoint).toList();
    final second = values.skip(midpoint).toList();
    final delta = _average(second) - _average(first);
    const epsilon = 0.000001;
    if (delta >= upThreshold - epsilon) {
      return TrendDirection.up;
    }
    if (delta <= -downThreshold + epsilon) {
      return TrendDirection.down;
    }
    return TrendDirection.stable;
  }

  double _average(List<num> values) {
    return values.fold<double>(0, (sum, value) => sum + value) / values.length;
  }
}
