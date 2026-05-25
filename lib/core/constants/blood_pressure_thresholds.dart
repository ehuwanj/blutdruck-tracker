import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';

/// Central threshold table used by the classifier and protected by tests.
const Map<BloodPressureCategory, BloodPressureThreshold>
kBloodPressureThresholds = {
  BloodPressureCategory.hypotension: BloodPressureThreshold(
    systolicBelow: 90,
    diastolicBelow: 60,
  ),
  BloodPressureCategory.optimal: BloodPressureThreshold(
    systolicBelow: 120,
    diastolicBelow: 80,
  ),
  BloodPressureCategory.normal: BloodPressureThreshold(
    systolicFrom: 120,
    systolicTo: 129,
    diastolicFrom: 80,
    diastolicTo: 84,
  ),
  BloodPressureCategory.highNormal: BloodPressureThreshold(
    systolicFrom: 130,
    systolicTo: 139,
    diastolicFrom: 85,
    diastolicTo: 89,
  ),
  BloodPressureCategory.hypertensionGrade1: BloodPressureThreshold(
    systolicFrom: 140,
    systolicTo: 159,
    diastolicFrom: 90,
    diastolicTo: 99,
  ),
  BloodPressureCategory.hypertensionGrade2: BloodPressureThreshold(
    systolicFrom: 160,
    systolicTo: 179,
    diastolicFrom: 100,
    diastolicTo: 109,
  ),
  BloodPressureCategory.hypertensionGrade3: BloodPressureThreshold(
    systolicFrom: 180,
    diastolicFrom: 110,
  ),
  BloodPressureCategory.isolatedSystolic: BloodPressureThreshold(
    systolicFrom: 140,
    diastolicBelow: 90,
  ),
};

class BloodPressureThreshold {
  const BloodPressureThreshold({
    this.systolicFrom,
    this.systolicTo,
    this.systolicBelow,
    this.diastolicFrom,
    this.diastolicTo,
    this.diastolicBelow,
  });

  final int? systolicFrom;
  final int? systolicTo;
  final int? systolicBelow;
  final int? diastolicFrom;
  final int? diastolicTo;
  final int? diastolicBelow;

  Map<String, int?> toSnapshot() => {
    'systolicFrom': systolicFrom,
    'systolicTo': systolicTo,
    'systolicBelow': systolicBelow,
    'diastolicFrom': diastolicFrom,
    'diastolicTo': diastolicTo,
    'diastolicBelow': diastolicBelow,
  };
}
