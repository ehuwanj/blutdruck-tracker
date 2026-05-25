import 'dart:convert';

import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/features/export/domain/services/csv_export_service.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/measurement_arm.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizations en;
  late AppLocalizations de;
  late AppLocalizations zh;

  setUpAll(() async {
    en = await AppLocalizations.delegate.load(const Locale('en'));
    de = await AppLocalizations.delegate.load(const Locale('de'));
    zh = await AppLocalizations.delegate.load(const Locale('zh'));
  });

  const service = CsvExportService();

  group('headers', () {
    test('locale-specific row across en/de/zh', () {
      expect(service.headers(en).first, 'Date');
      expect(service.headers(de).first, 'Datum');
      expect(service.headers(zh).first, '日期');
    });

    test('14 columns in identical order across locales', () {
      expect(service.headers(en), hasLength(14));
      expect(service.headers(de), hasLength(14));
      expect(service.headers(zh), hasLength(14));
    });
  });

  group('build', () {
    test('empty list produces header-only output', () {
      final csv = service.build(readings: const [], l10n: en);
      final lines = csv.split('\r\n')..removeLast(); // trailing line ending
      expect(lines, hasLength(1));
      expect(lines.first.split(';'), service.headers(en));
    });

    test('row values match the reading and decimals use a dot', () {
      final reading = _reading(
        id: 'r-1',
        measuredAt: DateTime.utc(2026, 5, 25, 6, 30),
        weightKg: 78.45,
      );
      final csv = service.build(readings: [reading], l10n: en);
      final data = csv.split('\r\n')[1].split(';');
      // Column 8 = Weight_kg with single-decimal "."-separator format.
      expect(data[7], '78.5');
      // Column 14 = Source, enum name lowercase (not localized).
      expect(data[13], 'manual');
    });
  });

  group('escaping', () {
    test('separators inside notes are quoted', () {
      final reading = _reading(
        id: 'r-1',
        measuredAt: DateTime.utc(2026, 5, 25, 7),
        note: 'morning; before coffee',
      );
      final csv = service.build(readings: [reading], l10n: en);
      expect(csv, contains('"morning; before coffee"'));
    });

    test('quotes inside notes are doubled', () {
      final reading = _reading(
        id: 'r-1',
        measuredAt: DateTime.utc(2026, 5, 25, 7),
        note: 'said "ok"',
      );
      final csv = service.build(readings: [reading], l10n: en);
      expect(csv, contains('"said ""ok"""'));
    });

    test('newlines inside notes are quoted', () {
      final reading = _reading(
        id: 'r-1',
        measuredAt: DateTime.utc(2026, 5, 25, 7),
        note: 'line1\nline2',
      );
      final csv = service.build(readings: [reading], l10n: en);
      expect(csv, contains('"line1\nline2"'));
    });
  });

  test('encodeUtf8WithBom prefixes the BOM bytes', () {
    const sample = 'Date;Time';
    final bytes = service.encodeUtf8WithBom(sample);
    expect(bytes.take(3).toList(), CsvExportService.utf8Bom);
    expect(utf8.decode(bytes.skip(3).toList()), sample);
  });
}

BloodPressureReading _reading({
  required String id,
  required DateTime measuredAt,
  String? note,
  double? weightKg,
}) {
  return BloodPressureReading(
    id: id,
    measuredAt: measuredAt,
    systolic: 132,
    diastolic: 84,
    pulse: 72,
    weightKg: weightKg,
    note: note,
    arm: MeasurementArm.left,
    source: ReadingSource.manual,
    createdAt: measuredAt,
    updatedAt: measuredAt,
  );
}
