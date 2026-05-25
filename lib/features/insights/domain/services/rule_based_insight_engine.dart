import 'package:blutdruck_tracker/features/insights/domain/entities/insight.dart';
import 'package:blutdruck_tracker/features/insights/domain/entities/insight_severity.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/statistics_result.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/trend_direction.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/blood_pressure_classifier.dart';

class RuleBasedInsightEngine {
  const RuleBasedInsightEngine({
    this.classifier = const BloodPressureClassifier(),
  });

  final BloodPressureClassifier classifier;

  List<Insight> generate({
    required StatisticsResult stats,
    required List<BloodPressureReading> readings,
    required Duration periodLength,
    required Map<String, String> messages,
  }) {
    if (stats.entryCount == 0) {
      return [_insight('noData', InsightSeverity.info, messages)];
    }

    final insights = <Insight>[];
    final periodDays = periodLength.inHours / 24;
    var trendOrShareRuleFired = false;

    if (periodLength >= const Duration(days: 7) && stats.entryCount < 5) {
      insights.add(_insight('fewEntries', InsightSeverity.info, messages));
    }
    if (stats.entryCount >= 5 && stats.entryCount < 4 * periodDays / 7) {
      insights.add(
        _insight('measureMoreOften', InsightSeverity.info, messages),
      );
    }
    if (stats.systolic.trend == TrendDirection.up ||
        stats.diastolic.trend == TrendDirection.up) {
      trendOrShareRuleFired = true;
      insights.add(_insight('bpRising', InsightSeverity.warning, messages));
    }
    if (stats.systolic.trend == TrendDirection.down &&
        stats.diastolic.trend == TrendDirection.down) {
      trendOrShareRuleFired = true;
      insights.add(_insight('bpFalling', InsightSeverity.info, messages));
    }

    final elevatedCount = _countElevated(readings);
    if (readings.isNotEmpty && elevatedCount / readings.length >= 0.5) {
      trendOrShareRuleFired = true;
      insights.add(
        _insight(
          'frequentlyElevated',
          InsightSeverity.info,
          messages,
          count: elevatedCount,
          total: readings.length,
        ),
      );
    }

    final lowCount = _countLow(readings);
    if (readings.isNotEmpty && lowCount / readings.length >= 0.3) {
      trendOrShareRuleFired = true;
      insights.add(
        _insight(
          'frequentlyLow',
          InsightSeverity.info,
          messages,
          count: lowCount,
          total: readings.length,
        ),
      );
    }

    if (stats.entryCount >= 4 * periodDays / 7 && !trendOrShareRuleFired) {
      insights.add(
        _insight('wellDocumented', InsightSeverity.neutral, messages),
      );
    }

    return insights.take(3).toList();
  }

  int _countElevated(List<BloodPressureReading> readings) {
    const elevated = {
      BloodPressureCategory.hypertensionGrade1,
      BloodPressureCategory.hypertensionGrade2,
      BloodPressureCategory.hypertensionGrade3,
      BloodPressureCategory.isolatedSystolic,
    };
    return readings.where((reading) {
      return elevated.contains(
        classifier.classify(
          systolic: reading.systolic,
          diastolic: reading.diastolic,
        ),
      );
    }).length;
  }

  int _countLow(List<BloodPressureReading> readings) {
    return readings.where((reading) {
      return classifier.classify(
            systolic: reading.systolic,
            diastolic: reading.diastolic,
          ) ==
          BloodPressureCategory.hypotension;
    }).length;
  }

  Insight _insight(
    String key,
    InsightSeverity severity,
    Map<String, String> messages, {
    int? count,
    int? total,
  }) {
    final title = _resolve(
      messages['insight.$key.title'] ?? key,
      count: count,
      total: total,
    );
    final body = _resolve(
      messages['insight.$key.body'] ?? key,
      count: count,
      total: total,
    );
    return Insight(id: key, severity: severity, title: title, body: body);
  }

  String _resolve(String template, {int? count, int? total}) {
    var resolved = template;
    if (count != null) {
      resolved = _resolvePlural(resolved, 'count', count);
      resolved = resolved.replaceAll('{count}', '$count');
    }
    if (total != null) {
      resolved = _resolvePlural(resolved, 'total', total);
      resolved = resolved.replaceAll('{total}', '$total');
    }
    return resolved;
  }

  String _resolvePlural(String template, String variable, int value) {
    final pattern = RegExp(
      r'\{' +
          variable +
          r',\s*plural,\s*one\s*\{([^{}]*)\}\s*other\s*\{([^{}]*)\}\s*\}',
    );
    return template.replaceAllMapped(pattern, (match) {
      final selected = value == 1 ? match.group(1)! : match.group(2)!;
      return selected.replaceAll('#', '$value');
    });
  }
}
