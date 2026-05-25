import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:intl/intl.dart';

String categoryLabel(AppLocalizations l10n, BloodPressureCategory category) {
  return switch (category) {
    BloodPressureCategory.hypotension => l10n.categoryHypotension,
    BloodPressureCategory.optimal => l10n.categoryOptimal,
    BloodPressureCategory.normal => l10n.categoryNormal,
    BloodPressureCategory.highNormal => l10n.categoryHighNormal,
    BloodPressureCategory.hypertensionGrade1 => l10n.categoryHypertensionGrade1,
    BloodPressureCategory.hypertensionGrade2 => l10n.categoryHypertensionGrade2,
    BloodPressureCategory.hypertensionGrade3 => l10n.categoryHypertensionGrade3,
    BloodPressureCategory.isolatedSystolic => l10n.categoryIsolatedSystolic,
  };
}

String formatShortDate(AppLocalizations l10n, DateTime value) {
  return DateFormat.Md(l10n.localeName).format(value);
}

String formatTime(AppLocalizations l10n, DateTime value) {
  return DateFormat.Hm(l10n.localeName).format(value);
}

String formatDateTime(AppLocalizations l10n, DateTime value) {
  return DateFormat.yMMMd(l10n.localeName).add_Hm().format(value);
}

String formatRelativeTime(AppLocalizations l10n, DateTime from, DateTime to) {
  final difference = to.difference(from);
  if (difference.inMinutes < 1) {
    return l10n.relativeTimeNow;
  }
  if (difference.inHours < 1) {
    return l10n.relativeTimeMinutes(difference.inMinutes);
  }
  if (difference.inDays < 1) {
    return l10n.relativeTimeHours(difference.inHours);
  }
  return l10n.relativeTimeDays(difference.inDays);
}

String formatSlotRange(
  AppLocalizations l10n,
  int startMinutes,
  int widthMinutes,
) {
  final start = DateTime(2000, 1, 1, startMinutes ~/ 60, startMinutes % 60);
  final endMinutes = startMinutes + widthMinutes;
  final end = DateTime(2000, 1, 1, endMinutes ~/ 60, endMinutes % 60);
  return '${formatTime(l10n, start)} - ${formatTime(l10n, end)}';
}
