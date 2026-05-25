import 'dart:math' as math;

import 'package:blutdruck_tracker/features/statistics/domain/entities/bmi_category.dart';

class BmiCalculator {
  const BmiCalculator();

  double? compute({required double? weightKg, required double? heightCm}) {
    if (weightKg == null || heightCm == null) {
      return null;
    }
    if (heightCm < 80 || heightCm > 250 || weightKg < 20 || weightKg > 400) {
      return null;
    }
    return weightKg / math.pow(heightCm / 100, 2);
  }

  BmiCategory? categorize(double? bmi) {
    if (bmi == null) {
      return null;
    }
    if (bmi < 18.5) {
      return BmiCategory.underweight;
    }
    if (bmi < 25) {
      return BmiCategory.normal;
    }
    if (bmi < 30) {
      return BmiCategory.overweight;
    }
    return BmiCategory.obese;
  }

  double roundForDisplay(double bmi) => (bmi * 10).round() / 10;
}
