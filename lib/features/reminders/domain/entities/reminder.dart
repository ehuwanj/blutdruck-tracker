import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder.freezed.dart';

/// A scheduled reminder to take a reading. Hour/minute are plain `int`s so
/// the domain layer stays free of `flutter/material.dart`; widgets convert
/// to/from `TimeOfDay` at the UI boundary.
@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,

    /// 0..23 (validated at the use case / mapper layer).
    required int hour,

    /// 0..59 (validated at the use case / mapper layer).
    required int minute,

    /// ISO weekdays 1..7; empty set = every day.
    required Set<int> weekdays,
    required bool enabled,
    String? label,
  }) = _Reminder;
}
