import 'package:blutdruck_tracker/features/statistics/domain/entities/trend_direction.dart';
import 'package:flutter/material.dart';

class TrendIcon extends StatelessWidget {
  const TrendIcon({required this.trend, required this.label, super.key});

  final TrendDirection trend;
  final String label;

  @override
  Widget build(BuildContext context) {
    final icon = switch (trend) {
      TrendDirection.up => Icons.arrow_upward,
      TrendDirection.down => Icons.arrow_downward,
      TrendDirection.stable => Icons.arrow_forward,
      TrendDirection.unknown => Icons.help_outline,
    };
    return Tooltip(
      message: label,
      child: Semantics(label: label, child: Icon(icon)),
    );
  }
}
