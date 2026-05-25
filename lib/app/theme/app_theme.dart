import 'package:blutdruck_tracker/app/theme/app_colors.dart';
import 'package:blutdruck_tracker/app/theme/app_typography.dart';
import 'package:blutdruck_tracker/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

/// Builds the light and dark [ThemeData] for the app.
abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.seed);
    return _baseTheme(
      colorScheme,
    ).copyWith(extensions: const [AppColors.light]);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.dark,
    );
    return _baseTheme(colorScheme).copyWith(extensions: const [AppColors.dark]);
  }

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      cardTheme: const CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadii.card)),
        ),
      ),
    );
  }
}
