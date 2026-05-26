import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_fitness.freezed.dart';

/// One local day's worth of fitness aggregates pulled from the Fitbit
/// Web API. Used to enrich the blood-pressure view with sleep / activity
/// context; never used as a blood-pressure source. See
/// docs/specs/10-future-integrations.md §Fitbit gateway.
@freezed
class DailyFitness with _$DailyFitness {
  const factory DailyFitness({
    /// 00:00 of the local day this row represents.
    required DateTime date,
    Duration? sleepDuration,
    int? sleepScore,
    int? restingHeartRate,
    int? steps,
    int? activeMinutes,
  }) = _DailyFitness;
}
