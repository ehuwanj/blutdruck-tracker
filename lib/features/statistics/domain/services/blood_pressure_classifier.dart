import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';

class BloodPressureClassifier {
  const BloodPressureClassifier();

  BloodPressureCategory classify({
    required int systolic,
    required int diastolic,
  }) {
    if (systolic < 50 || systolic > 260 || diastolic < 30 || diastolic > 200) {
      throw ArgumentError.value(
        {'systolic': systolic, 'diastolic': diastolic},
        'reading',
        'Blood pressure values are outside validator hard ranges.',
      );
    }
    if (systolic < 90 || diastolic < 60) {
      return BloodPressureCategory.hypotension;
    }
    if (systolic >= 180 || diastolic >= 110) {
      return BloodPressureCategory.hypertensionGrade3;
    }
    if (systolic >= 140 && diastolic < 90) {
      return BloodPressureCategory.isolatedSystolic;
    }
    if (systolic >= 160 || diastolic >= 100) {
      return BloodPressureCategory.hypertensionGrade2;
    }
    if (systolic >= 140 || diastolic >= 90) {
      return BloodPressureCategory.hypertensionGrade1;
    }
    if (systolic >= 130 || diastolic >= 85) {
      return BloodPressureCategory.highNormal;
    }
    if (systolic >= 120 || diastolic >= 80) {
      return BloodPressureCategory.normal;
    }
    return BloodPressureCategory.optimal;
  }
}
