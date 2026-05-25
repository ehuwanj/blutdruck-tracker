import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_pick.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_point.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_series.dart';

class TimeSlotAggregator {
  const TimeSlotAggregator();

  TimeSlotSeries aggregate({
    required List<BloodPressureReading> readings,
    required TimeSlotPick pick,
  }) {
    final grouped = <DateTime, List<BloodPressureReading>>{};
    for (final reading in readings) {
      final local = reading.measuredAt.toLocal();
      if (!_contains(pick.slot, local)) {
        continue;
      }
      final day = DateTime(local.year, local.month, local.day);
      grouped.putIfAbsent(day, () => []).add(reading);
    }
    final points = grouped.entries.map((entry) {
      final readings = entry.value;
      final pulses = readings
          .where((r) => r.pulse != null)
          .map((r) => r.pulse!)
          .toList();
      return TimeSlotPoint(
        localDay: entry.key,
        systolicAverage: _average(readings.map((r) => r.systolic)).round(),
        diastolicAverage: _average(readings.map((r) => r.diastolic)).round(),
        pulseAverage: pulses.isEmpty ? null : _average(pulses).round(),
        readingCount: readings.length,
      );
    }).toList()..sort((a, b) => a.localDay.compareTo(b.localDay));

    return TimeSlotSeries(pick: pick, points: points);
  }

  bool _contains(TimeSlot slot, DateTime localTime) {
    final minutes = localTime.hour * 60 + localTime.minute;
    return minutes >= slot.startMinutes && minutes < slot.endMinutesExclusive;
  }

  double _average(Iterable<num> values) {
    final list = values.toList();
    return list.fold<double>(0, (sum, value) => sum + value) / list.length;
  }
}
