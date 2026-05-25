import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/trend_direction.dart';

String trendLabel(AppLocalizations l10n, TrendDirection trend) {
  return switch (trend) {
    TrendDirection.up => l10n.trendUp,
    TrendDirection.down => l10n.trendDown,
    TrendDirection.stable => l10n.trendStable,
    TrendDirection.unknown => l10n.trendUnknown,
  };
}

String formatMetricInt(AppLocalizations l10n, num? value) {
  return value == null ? l10n.statisticsMetricEmptyValue : '${value.round()}';
}

String formatBmi(double? value, AppLocalizations l10n) {
  return value == null
      ? l10n.statisticsMetricEmptyValue
      : value.toStringAsFixed(1);
}
