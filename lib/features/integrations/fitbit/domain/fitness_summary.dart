import 'package:blutdruck_tracker/features/integrations/fitbit/domain/daily_fitness.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fitness_summary.freezed.dart';

/// A range of per-day fitness aggregates returned by the Fitbit gateway.
/// `days` is sorted ascending by `date`.
@freezed
class FitnessSummary with _$FitnessSummary {
  const factory FitnessSummary({required List<DailyFitness> days}) =
      _FitnessSummary;
}
