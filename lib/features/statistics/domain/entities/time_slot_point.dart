import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot_point.freezed.dart';

/// One point on the time-slot chart: the daily average within the slot.
/// Days with no in-slot reading produce no point (the chart renders gaps,
/// not zeros).
@freezed
class TimeSlotPoint with _$TimeSlotPoint {
  const factory TimeSlotPoint({
    /// 00:00 local of the represented day.
    required DateTime localDay,
    required int systolicAverage,
    required int diastolicAverage,
    required int readingCount,

    /// `null` when no in-slot reading on this day had a pulse value.
    int? pulseAverage,
  }) = _TimeSlotPoint;
}
