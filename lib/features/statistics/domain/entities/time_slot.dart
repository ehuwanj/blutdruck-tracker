import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot.freezed.dart';

/// A time-of-day window used by the time-slot chart. Constraints (default
/// width, allowed widths, no-midnight-crossing) live in the detector;
/// this type only carries the bounds.
@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    /// 0..1439, minutes since local midnight.
    required int startMinutes,

    /// Must be `> 0`. Default exposed via settings is 60.
    required int widthMinutes,
  }) = _TimeSlot;

  const TimeSlot._();

  int get endMinutesExclusive => startMinutes + widthMinutes;
}
