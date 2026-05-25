import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:blutdruck_tracker/core/widgets/category_dot.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:flutter/material.dart';

class BloodPressureValueDisplay extends StatelessWidget {
  const BloodPressureValueDisplay({
    required this.systolic,
    required this.diastolic,
    this.pulse,
    this.pulseLabel,
    this.category,
    this.categoryLabel,
    super.key,
  });

  final int systolic;
  final int diastolic;
  final int? pulse;
  final String? pulseLabel;
  final BloodPressureCategory? category;
  final String? categoryLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (category != null && categoryLabel != null) ...[
          CategoryDot(category: category!, label: categoryLabel!),
          const SizedBox(width: AppSpacing.sm),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$systolic / $diastolic', style: textTheme.displayMedium),
            if (pulse != null && pulseLabel != null)
              Text('$pulseLabel $pulse bpm', style: textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}
