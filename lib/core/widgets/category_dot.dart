import 'package:blutdruck_tracker/app/theme/app_colors.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:flutter/material.dart';

class CategoryDot extends StatelessWidget {
  const CategoryDot({required this.category, required this.label, super.key});

  final BloodPressureCategory category;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final color = switch (category) {
      BloodPressureCategory.optimal ||
      BloodPressureCategory.normal => colors.success,
      BloodPressureCategory.highNormal => colors.caution,
      BloodPressureCategory.hypertensionGrade1 => colors.warn,
      BloodPressureCategory.hypertensionGrade2 ||
      BloodPressureCategory.hypertensionGrade3 ||
      BloodPressureCategory.hypotension => colors.alert,
      BloodPressureCategory.isolatedSystolic => colors.warn,
    };
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: const SizedBox.square(dimension: 10),
        ),
      ),
    );
  }
}
