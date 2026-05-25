import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_pick.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_point.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot_series.freezed.dart';

/// Time-slot chart data: the [TimeSlotPick] used to filter, plus one
/// [TimeSlotPoint] per local day with at least one in-slot reading, sorted
/// ascending by `localDay`.
@freezed
class TimeSlotSeries with _$TimeSlotSeries {
  const factory TimeSlotSeries({
    required TimeSlotPick pick,
    required List<TimeSlotPoint> points,
  }) = _TimeSlotSeries;
}
