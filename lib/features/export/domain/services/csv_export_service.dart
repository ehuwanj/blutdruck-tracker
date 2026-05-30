import 'dart:convert';

import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/blood_pressure_classifier.dart';
import 'package:intl/intl.dart';

/// Produces a CSV serialization of a reading list. Pure Dart so the data
/// path stays testable; the export feature writes the bytes elsewhere.
///
/// Conventions per docs/specs/08-export-and-reminders.md:
/// - UTF-8 with BOM (callers prefix the BOM via [encodeUtf8WithBom]).
/// - `;` field separator, `\r\n` line endings.
/// - Decimal separator is always `.` regardless of locale.
/// - 11 columns in a fixed order; header text follows the locale.
class CsvExportService {
  const CsvExportService({this.classifier = const BloodPressureClassifier()});

  static const String separator = ';';
  static const String lineEnding = '\r\n';
  static const List<int> utf8Bom = [0xEF, 0xBB, 0xBF];

  final BloodPressureClassifier classifier;

  /// Builds the CSV content as a single UTF-8 string (no BOM).
  String build({
    required List<BloodPressureReading> readings,
    required AppLocalizations l10n,
  }) {
    final headerRow = _row(headers(l10n));
    if (readings.isEmpty) {
      return '$headerRow$lineEnding';
    }
    final sorted = readings.toList()
      ..sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
    final dataRows = sorted.map((r) => _row(_valuesFor(r, l10n)));
    return '$headerRow$lineEnding${dataRows.join(lineEnding)}$lineEnding';
  }

  /// Returns CSV bytes prefixed with the UTF-8 BOM.
  List<int> encodeUtf8WithBom(String content) {
    return [...utf8Bom, ...utf8.encode(content)];
  }

  /// The column headers in the active locale, in canonical order.
  List<String> headers(AppLocalizations l10n) {
    return [
      l10n.csvColumnDate,
      l10n.csvColumnTime,
      l10n.csvColumnSystolic,
      l10n.csvColumnDiastolic,
      l10n.csvColumnPulse,
      l10n.csvColumnPulsePressure,
      l10n.csvColumnMap,
      l10n.csvColumnWeightKg,
      l10n.csvColumnNote,
      l10n.csvColumnCategory,
      l10n.csvColumnSource,
    ];
  }

  List<String> _valuesFor(BloodPressureReading reading, AppLocalizations l10n) {
    final local = reading.measuredAt.toLocal();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');
    final category = classifier.classify(
      systolic: reading.systolic,
      diastolic: reading.diastolic,
    );
    return [
      dateFormat.format(local),
      timeFormat.format(local),
      '${reading.systolic}',
      '${reading.diastolic}',
      _intOrEmpty(reading.pulse),
      '${reading.pulsePressure}',
      '${reading.meanArterialPressure.round()}',
      _weightOrEmpty(reading.weightKg),
      reading.note ?? '',
      _categoryLabel(category, l10n),
      // Source is the enum `name` — stable for round-trips, not localized.
      reading.source.name,
    ];
  }

  String _intOrEmpty(int? value) => value == null ? '' : '$value';

  String _weightOrEmpty(double? kg) => kg == null ? '' : kg.toStringAsFixed(1);

  String _categoryLabel(BloodPressureCategory category, AppLocalizations l10n) {
    return switch (category) {
      BloodPressureCategory.hypotension => l10n.categoryHypotension,
      BloodPressureCategory.optimal => l10n.categoryOptimal,
      BloodPressureCategory.normal => l10n.categoryNormal,
      BloodPressureCategory.highNormal => l10n.categoryHighNormal,
      BloodPressureCategory.hypertensionGrade1 =>
        l10n.categoryHypertensionGrade1,
      BloodPressureCategory.hypertensionGrade2 =>
        l10n.categoryHypertensionGrade2,
      BloodPressureCategory.hypertensionGrade3 =>
        l10n.categoryHypertensionGrade3,
      BloodPressureCategory.isolatedSystolic => l10n.categoryIsolatedSystolic,
    };
  }

  String _row(List<String> cells) {
    return cells.map(_escape).join(separator);
  }

  String _escape(String value) {
    final needsQuoting =
        value.contains(separator) ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r');
    if (!needsQuoting) {
      return value;
    }
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }
}
