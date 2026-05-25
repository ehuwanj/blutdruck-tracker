import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_pick.dart';

class TimeSlotDetector {
  const TimeSlotDetector();

  TimeSlotPick? detect({
    required List<BloodPressureReading> readings,
    required int widthMinutes,
    int? pinnedStartMinutes,
  }) {
    final normalizedWidth = _validWidth(widthMinutes);
    if (pinnedStartMinutes != null) {
      final start = pinnedStartMinutes.clamp(0, 1440 - normalizedWidth);
      final slot = TimeSlot(startMinutes: start, widthMinutes: normalizedWidth);
      return TimeSlotPick(
        slot: slot,
        isAutoDetected: false,
        matchingReadings: _count(readings, slot),
      );
    }

    var bestStart = 0;
    var bestCount = -1;
    for (var start = 0; start <= 1440 - normalizedWidth; start += 15) {
      final slot = TimeSlot(startMinutes: start, widthMinutes: normalizedWidth);
      final count = _count(readings, slot);
      if (count > bestCount) {
        bestStart = start;
        bestCount = count;
      }
    }
    if (bestCount < 5) {
      return null;
    }
    return TimeSlotPick(
      slot: TimeSlot(startMinutes: bestStart, widthMinutes: normalizedWidth),
      isAutoDetected: true,
      matchingReadings: bestCount,
    );
  }

  int _validWidth(int widthMinutes) {
    if (widthMinutes <= 0 || widthMinutes > 1440) {
      throw ArgumentError.value(widthMinutes, 'widthMinutes');
    }
    return widthMinutes;
  }

  int _count(List<BloodPressureReading> readings, TimeSlot slot) {
    return readings
        .where((reading) => _contains(slot, reading.measuredAt.toLocal()))
        .length;
  }

  bool _contains(TimeSlot slot, DateTime localTime) {
    final minutes = localTime.hour * 60 + localTime.minute;
    return minutes >= slot.startMinutes && minutes < slot.endMinutesExclusive;
  }
}
