import 'package:blutdruck_tracker/features/insights/domain/entities/insight.dart';
import 'package:blutdruck_tracker/features/insights/domain/entities/insight_severity.dart';
import 'package:blutdruck_tracker/features/reminders/domain/entities/reminder.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/locale_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/theme_mode_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/weight_unit.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/bmi_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/bmi_summary.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/metric_summary.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/statistics_result.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_pick.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_point.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/time_slot_series.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/trend_direction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final from = DateTime.utc(2026, 5);
  final to = DateTime.utc(2026, 5, 31, 23, 59);
  final localDay = DateTime(2026, 5, 25);
  const slot = TimeSlot(startMinutes: 420, widthMinutes: 60);
  const pick = TimeSlotPick(
    slot: slot,
    isAutoDetected: true,
    matchingReadings: 8,
  );
  final point = TimeSlotPoint(
    localDay: localDay,
    systolicAverage: 132,
    diastolicAverage: 84,
    pulseAverage: 72,
    readingCount: 2,
  );

  test(
    'MetricSummary constructs with all fields and copyWith changes trend',
    () {
      const summary = MetricSummary(
        min: 80,
        max: 140,
        average: 112,
        trend: TrendDirection.stable,
      );

      expect(summary.min, 80);
      expect(summary.max, 140);
      expect(summary.average, 112);
      expect(summary.trend, TrendDirection.stable);
      expect(
        summary.copyWith(trend: TrendDirection.up).trend,
        TrendDirection.up,
      );
    },
  );

  test(
    'StatisticsResult constructs with all fields and copyWith changes count',
    () {
      const metric = MetricSummary(
        min: 80,
        max: 140,
        average: 112,
        trend: TrendDirection.stable,
      );
      const bmi = BmiSummary(bmi: 24.2, category: BmiCategory.normal);
      final result = StatisticsResult(
        from: from,
        to: to,
        entryCount: 4,
        systolic: metric,
        diastolic: metric,
        pulse: metric,
        pulsePressure: metric,
        meanArterialPressure: metric,
        categoryDistribution: const {
          BloodPressureCategory.normal: 2,
          BloodPressureCategory.highNormal: 2,
        },
        bmi: bmi,
      );

      expect(result.from, from);
      expect(result.to, to);
      expect(result.entryCount, 4);
      expect(result.categoryDistribution[BloodPressureCategory.normal], 2);
      expect(result.bmi, bmi);
      expect(result.copyWith(entryCount: 5).entryCount, 5);
    },
  );

  test(
    'BmiSummary constructs with all fields and copyWith changes category',
    () {
      const summary = BmiSummary(bmi: 26.2, category: BmiCategory.overweight);

      expect(summary.bmi, 26.2);
      expect(summary.category, BmiCategory.overweight);
      expect(
        summary.copyWith(category: BmiCategory.normal).category,
        BmiCategory.normal,
      );
    },
  );

  test('TimeSlot constructs with all fields and copyWith changes width', () {
    expect(slot.startMinutes, 420);
    expect(slot.widthMinutes, 60);
    expect(slot.endMinutesExclusive, 480);
    expect(slot.copyWith(widthMinutes: 120).widthMinutes, 120);
  });

  test(
    'TimeSlotPick constructs with all fields and copyWith changes count',
    () {
      expect(pick.slot, slot);
      expect(pick.isAutoDetected, isTrue);
      expect(pick.matchingReadings, 8);
      expect(pick.copyWith(matchingReadings: 9).matchingReadings, 9);
    },
  );

  test(
    'TimeSlotPoint constructs with all fields and copyWith changes systolic',
    () {
      expect(point.localDay, localDay);
      expect(point.systolicAverage, 132);
      expect(point.diastolicAverage, 84);
      expect(point.pulseAverage, 72);
      expect(point.readingCount, 2);
      expect(point.copyWith(systolicAverage: 134).systolicAverage, 134);
    },
  );

  test(
    'TimeSlotSeries constructs with all fields and copyWith changes points',
    () {
      final series = TimeSlotSeries(pick: pick, points: [point]);
      final nextPoint = point.copyWith(localDay: DateTime(2026, 5, 26));

      expect(series.pick, pick);
      expect(series.points, [point]);
      expect(series.copyWith(points: [point, nextPoint]).points, [
        point,
        nextPoint,
      ]);
    },
  );

  test('Insight constructs with all fields and copyWith changes severity', () {
    final generatedAt = DateTime.utc(2026, 5, 25, 8);
    final insight = Insight(
      id: 'i1',
      severity: InsightSeverity.info,
      title: 'title',
      body: 'body',
      generatedAt: generatedAt,
    );

    expect(insight.id, 'i1');
    expect(insight.severity, InsightSeverity.info);
    expect(insight.title, 'title');
    expect(insight.body, 'body');
    expect(insight.generatedAt, generatedAt);
    expect(
      insight.copyWith(severity: InsightSeverity.neutral).severity,
      InsightSeverity.neutral,
    );
  });

  test('Reminder constructs with all fields and copyWith changes enabled', () {
    const reminder = Reminder(
      id: 'reminder-1',
      hour: 7,
      minute: 30,
      weekdays: {1, 3, 5},
      enabled: true,
      label: 'morning',
    );

    expect(reminder.id, 'reminder-1');
    expect(reminder.hour, 7);
    expect(reminder.minute, 30);
    expect(reminder.weekdays, {1, 3, 5});
    expect(reminder.enabled, isTrue);
    expect(reminder.label, 'morning');
    expect(reminder.copyWith(enabled: false).enabled, isFalse);
  });

  test(
    'AppSettings constructs with all fields and copyWith changes locale',
    () {
      const settings = AppSettings(
        locale: LocaleSetting.de,
        themeMode: ThemeModeSetting.dark,
        weightUnit: WeightUnit.lb,
        remindersEnabled: true,
        timeSlotWidthMinutes: 120,
        recentEntriesCount: 10,
        heightCm: 178,
        weightKg: 80,
        pinnedTimeSlotStartMinutes: 420,
        disclaimerAcceptedVersion: 1,
        lastExportDirectoryHint: '/exports',
      );

      expect(settings.locale, LocaleSetting.de);
      expect(settings.themeMode, ThemeModeSetting.dark);
      expect(settings.weightUnit, WeightUnit.lb);
      expect(settings.remindersEnabled, isTrue);
      expect(settings.timeSlotWidthMinutes, 120);
      expect(settings.heightCm, 178);
      expect(settings.pinnedTimeSlotStartMinutes, 420);
      expect(settings.disclaimerAcceptedVersion, 1);
      expect(settings.lastExportDirectoryHint, '/exports');
      expect(
        settings.copyWith(locale: LocaleSetting.en).locale,
        LocaleSetting.en,
      );
    },
  );
}
