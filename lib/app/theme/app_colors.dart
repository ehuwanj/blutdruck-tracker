import 'package:flutter/material.dart';

/// Semantic color tokens used across the app. Bound to [ThemeData] via
/// `ThemeData(extensions: [AppColors.light])` / `AppColors.dark`. Widgets
/// read it with `Theme.of(context).extension<AppColors>()`.
///
/// Surface, background, and text colors come from [ColorScheme]; only the
/// semantic categories live here, so dark-mode swapping flows from
/// [ThemeData] naturally.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.info,
    required this.caution,
    required this.warn,
    required this.alert,
    required this.textMuted,
  });

  static const Color seed = Color(0xFF3F6F84);

  static const AppColors light = AppColors(
    success: Color(0xFF2E7D5B),
    info: Color(0xFF3F6F84),
    caution: Color(0xFFC19A2B),
    warn: Color(0xFFB86E2B),
    alert: Color(0xFFA04341),
    textMuted: Color(0xFF5E5F62),
  );

  static const AppColors dark = AppColors(
    success: Color(0xFF7FCBA8),
    info: Color(0xFF9BC6D6),
    caution: Color(0xFFE7C766),
    warn: Color(0xFFE89C66),
    alert: Color(0xFFE08583),
    textMuted: Color(0xFFA2A4A8),
  );

  final Color success;
  final Color info;
  final Color caution;
  final Color warn;
  final Color alert;
  final Color textMuted;

  @override
  AppColors copyWith({
    Color? success,
    Color? info,
    Color? caution,
    Color? warn,
    Color? alert,
    Color? textMuted,
  }) {
    return AppColors(
      success: success ?? this.success,
      info: info ?? this.info,
      caution: caution ?? this.caution,
      warn: warn ?? this.warn,
      alert: alert ?? this.alert,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      info: Color.lerp(info, other.info, t)!,
      caution: Color.lerp(caution, other.caution, t)!,
      warn: Color.lerp(warn, other.warn, t)!,
      alert: Color.lerp(alert, other.alert, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
    );
  }
}
