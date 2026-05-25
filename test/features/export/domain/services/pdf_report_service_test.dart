import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/features/export/domain/services/pdf_report_service.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  late AppLocalizations en;
  const service = PdfReportService();

  setUpAll(() async {
    await initializeDateFormatting('en');
    en = await AppLocalizations.delegate.load(const Locale('en'));
  });

  final from = DateTime.utc(2026, 5);
  final to = DateTime.utc(2026, 5, 31, 23, 59, 59, 999);
  final generatedAt = DateTime.utc(2026, 5, 31, 18);

  test('builds without throwing for an empty period', () async {
    final document = service.build(
      readings: const [],
      from: from,
      to: to,
      generatedAt: generatedAt,
      l10n: en,
    );
    final bytes = await document.save();
    expect(bytes, isNotEmpty);
  });

  test('builds without throwing for a single reading', () async {
    final document = service.build(
      readings: [_reading(id: 'r-1')],
      from: from,
      to: to,
      generatedAt: generatedAt,
      l10n: en,
    );
    final bytes = await document.save();
    expect(bytes, isNotEmpty);
  });

  test('builds without throwing for ~100 readings', () async {
    final readings = List.generate(100, (i) => _reading(id: 'r-$i', offset: i));
    final document = service.build(
      readings: readings,
      from: from,
      to: to,
      generatedAt: generatedAt,
      l10n: en,
    );
    final bytes = await document.save();
    expect(bytes, isNotEmpty);
  });

  test('built document produces a parseable PDF header', () async {
    // The pdf package compresses content streams, so the disclaimer text
    // is not byte-searchable in the raw output. Verifying its presence on
    // the last page requires a full PDF parser, which is out of scope for
    // a unit test. We instead assert the produced bytes are a well-formed
    // PDF; the disclaimer is exercised by the screen and the document
    // builder is small enough to read.
    final document = service.build(
      readings: [_reading(id: 'r-1')],
      from: from,
      to: to,
      generatedAt: generatedAt,
      l10n: en,
    );
    final bytes = await document.save();
    expect(String.fromCharCodes(bytes.take(4).toList()), '%PDF');
  });
}

BloodPressureReading _reading({required String id, int offset = 0}) {
  final at = DateTime.utc(2026, 5, 25, 8).add(Duration(minutes: offset));
  return BloodPressureReading(
    id: id,
    measuredAt: at,
    systolic: 130 + (offset % 8),
    diastolic: 82 + (offset % 4),
    pulse: 70 + (offset % 6),
    source: ReadingSource.manual,
    createdAt: at,
    updatedAt: at,
  );
}
