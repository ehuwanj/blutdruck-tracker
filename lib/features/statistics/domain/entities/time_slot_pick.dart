import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'time_slot_pick.freezed.dart';

/// The chosen [TimeSlot] for the chart, plus provenance and how many
/// readings fall inside it. Built by `TimeSlotDetector` (step 2).
@freezed
class TimeSlotPick with _$TimeSlotPick {
  const factory TimeSlotPick({
    required TimeSlot slot,

    /// `true` = picked from data; `false` = user-pinned in settings.
    required bool isAutoDetected,
    required int matchingReadings,
  }) = _TimeSlotPick;
}
