import 'dart:io';

import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/app/providers.dart';
import 'package:blutdruck_tracker/features/export/domain/entities/export_format.dart';
import 'package:blutdruck_tracker/features/export/domain/entities/export_record.dart';
import 'package:blutdruck_tracker/features/export/domain/services/csv_export_service.dart';
import 'package:blutdruck_tracker/features/export/domain/services/pdf_report_service.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

final exportFormProvider =
    NotifierProvider.autoDispose<ExportFormNotifier, ExportFormState>(
      ExportFormNotifier.new,
    );

class ExportFormState {
  const ExportFormState({
    required this.format,
    required this.period,
    required this.includeContextFields,
    required this.includeChartImage,
    required this.isGenerating,
  });

  final ExportFormat format;
  final DateTimeRange period;
  final bool includeContextFields;
  final bool includeChartImage;
  final bool isGenerating;

  ExportFormState copyWith({
    ExportFormat? format,
    DateTimeRange? period,
    bool? includeContextFields,
    bool? includeChartImage,
    bool? isGenerating,
  }) {
    return ExportFormState(
      format: format ?? this.format,
      period: period ?? this.period,
      includeContextFields: includeContextFields ?? this.includeContextFields,
      includeChartImage: includeChartImage ?? this.includeChartImage,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }
}

class ExportFormNotifier extends AutoDisposeNotifier<ExportFormState> {
  static const _uuid = Uuid();
  static const _csv = CsvExportService();
  static const _pdf = PdfReportService();

  @override
  ExportFormState build() {
    return ExportFormState(
      format: ExportFormat.csv,
      period: ref.read(periodProvider),
      includeContextFields: true,
      includeChartImage: true,
      isGenerating: false,
    );
  }

  // ignore: use_setters_to_change_properties, action verbs at call sites.
  void setFormat(ExportFormat format) {
    state = state.copyWith(format: format);
  }

  // ignore: use_setters_to_change_properties, action verbs at call sites.
  void setPeriod(DateTimeRange period) {
    state = state.copyWith(period: period);
  }

  // ignore: use_setters_to_change_properties, action verbs at call sites.
  void setIncludeContextFields({required bool value}) {
    state = state.copyWith(includeContextFields: value);
  }

  // ignore: use_setters_to_change_properties, action verbs at call sites.
  void setIncludeChartImage({required bool value}) {
    state = state.copyWith(includeChartImage: value);
  }

  /// Builds the file, writes it under `<documents>/exports/`, records the
  /// `ExportRecord`, and triggers the system share sheet. Throws on any
  /// failure; callers surface the message in the UI.
  Future<ExportRecord> generateAndShare(AppLocalizations l10n) async {
    state = state.copyWith(isGenerating: true);
    try {
      final period = state.period;
      final readings =
          ref
              .read(readingsStreamProvider)
              .valueOrNull
              ?.where((reading) {
                return !reading.measuredAt.isBefore(period.start.toUtc()) &&
                    !reading.measuredAt.isAfter(period.end.toUtc());
              })
              .toList(growable: false) ??
          const [];
      final settings =
          ref.read(settingsProvider).valueOrNull ?? AppSettings.defaults();
      final now = ref.read(clockProvider).now();

      final fileName = _fileName(state.format, period.start, period.end);
      final dir = await _ensureExportsDirectory();
      final file = File(p.join(dir.path, fileName));

      List<int> bytes;
      switch (state.format) {
        case ExportFormat.csv:
          final content = _csv.build(readings: readings, l10n: l10n);
          bytes = _csv.encodeUtf8WithBom(content);
        case ExportFormat.pdf:
          final document = _pdf.build(
            readings: readings,
            from: period.start,
            to: period.end,
            generatedAt: now,
            l10n: l10n,
            settings: settings,
          );
          bytes = await document.save();
      }
      await file.writeAsBytes(bytes, flush: true);

      final record = ExportRecord(
        id: _uuid.v4(),
        format: state.format,
        periodFrom: period.start.toUtc(),
        periodTo: period.end.toUtc(),
        filePath: file.path,
        createdAt: now,
      );
      await ref.read(exportHistoryRepositoryProvider).upsert(record);

      await Share.shareXFiles([XFile(file.path)]);

      return record;
    } finally {
      state = state.copyWith(isGenerating: false);
    }
  }

  Future<Directory> _ensureExportsDirectory() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'exports'));
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  String _fileName(ExportFormat format, DateTime from, DateTime to) {
    final fromIso = _isoDate(from.toLocal());
    final toIso = _isoDate(to.toLocal());
    final ext = format == ExportFormat.csv ? 'csv' : 'pdf';
    return 'blutdruck_${fromIso}_$toIso.$ext';
  }

  String _isoDate(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }
}
