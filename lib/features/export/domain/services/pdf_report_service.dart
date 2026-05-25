import 'package:blutdruck_tracker/app/localization/generated/app_localizations.dart';
import 'package:blutdruck_tracker/features/overview/presentation/widgets/overview_formatters.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/blood_pressure_category.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/metric_summary.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/statistics_result.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/blood_pressure_classifier.dart';
import 'package:blutdruck_tracker/features/statistics/domain/services/statistics_calculator.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Builds an A4 portrait PDF report over a closed period. The implementation
/// keeps the chart image optional: if a chart `pw.MemoryImage` is supplied
/// we embed it on page 1; otherwise a small "chart unavailable" text block
/// is used. This keeps PDF generation always succeed-or-throw-loud, never
/// partial.
class PdfReportService {
  const PdfReportService({
    this.classifier = const BloodPressureClassifier(),
    this.statisticsCalculator = const StatisticsCalculator(),
  });

  final BloodPressureClassifier classifier;
  final StatisticsCalculator statisticsCalculator;

  pw.Document build({
    required List<BloodPressureReading> readings,
    required DateTime from,
    required DateTime to,
    required DateTime generatedAt,
    required AppLocalizations l10n,
    AppSettings? settings,
    pw.MemoryImage? chartImage,
  }) {
    final stats = statisticsCalculator.calculate(
      readings: readings,
      from: from,
      to: to,
      settings: settings ?? AppSettings.defaults(),
    );
    final document = pw.Document(title: l10n.pdfReportHeader);
    final sorted = readings.toList()
      ..sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(32, 32, 32, 48),
        header: (context) => _buildHeader(l10n, from, to, generatedAt),
        footer: (context) => _buildFooter(l10n, context),
        build: (context) {
          return [
            _buildSummary(l10n, stats),
            pw.SizedBox(height: 16),
            _buildDistribution(l10n, stats.categoryDistribution),
            pw.SizedBox(height: 16),
            if (chartImage != null)
              pw.Image(chartImage)
            else
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400),
                ),
                child: pw.Text(
                  l10n.pdfChartUnavailable,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            pw.SizedBox(height: 16),
            ..._buildReadingsTable(l10n, sorted),
            pw.SizedBox(height: 24),
            _buildFullDisclaimer(l10n),
          ];
        },
      ),
    );
    return document;
  }

  pw.Widget _buildHeader(
    AppLocalizations l10n,
    DateTime from,
    DateTime to,
    DateTime generatedAt,
  ) {
    final range = l10n.statisticsPeriodSummary(
      formatShortDate(l10n, from.toLocal()),
      formatShortDate(l10n, to.toLocal()),
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.pdfReportHeader,
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(range, style: const pw.TextStyle(fontSize: 11)),
        pw.Text(
          l10n.pdfGeneratedAt(formatDateTime(l10n, generatedAt.toLocal())),
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildFooter(AppLocalizations l10n, pw.Context context) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
          pw.Text(
            l10n.pdfDisclaimerFooter,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSummary(AppLocalizations l10n, StatisticsResult stats) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.pdfSummaryTitle,
          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          l10n.historyEntriesCount(stats.entryCount),
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: const {
            0: pw.FlexColumnWidth(3),
            1: pw.FlexColumnWidth(2),
            2: pw.FlexColumnWidth(2),
            3: pw.FlexColumnWidth(2),
          },
          children: [
            _metricsHeaderRow(l10n),
            _metricsRow(l10n.systolicLabel, stats.systolic),
            _metricsRow(l10n.diastolicLabel, stats.diastolic),
            _metricsRow(l10n.pulseLabel, stats.pulse),
            _metricsRow(l10n.pulsePressureLabel, stats.pulsePressure),
            _metricsRow(
              l10n.meanArterialPressureLabel,
              stats.meanArterialPressure,
            ),
          ],
        ),
      ],
    );
  }

  pw.TableRow _metricsHeaderRow(AppLocalizations l10n) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: [
        _cellHeader(l10n.statisticsMetricLabel),
        _cellHeader(l10n.statisticsMetricAverage),
        _cellHeader(l10n.statisticsMetricMin),
        _cellHeader(l10n.statisticsMetricMax),
      ],
    );
  }

  pw.TableRow _metricsRow(String label, MetricSummary summary) {
    return pw.TableRow(
      children: [
        _cell(label),
        _cell(_metricValue(summary.average)),
        _cell(_metricValue(summary.min)),
        _cell(_metricValue(summary.max)),
      ],
    );
  }

  pw.Widget _buildDistribution(
    AppLocalizations l10n,
    Map<BloodPressureCategory, int> distribution,
  ) {
    final total = distribution.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) {
      return pw.Text(
        l10n.statusDistributionEmpty,
        style: const pw.TextStyle(fontSize: 10),
      );
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.statusDistributionTitle,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        for (final category in BloodPressureCategory.values)
          if ((distribution[category] ?? 0) > 0)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 1),
              child: pw.Text(
                '${_categoryLabel(category, l10n)}: '
                '${distribution[category]} / $total',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
      ],
    );
  }

  /// Returns the readings section as a list of separate widgets so the
  /// surrounding `pw.MultiPage` can paginate across them. A single
  /// `pw.Table` with N rows is a non-splittable widget and overflows once
  /// the table exceeds one page.
  List<pw.Widget> _buildReadingsTable(
    AppLocalizations l10n,
    List<BloodPressureReading> readings,
  ) {
    if (readings.isEmpty) {
      return [
        pw.Text(
          l10n.statusDistributionEmpty,
          style: const pw.TextStyle(fontSize: 10),
        ),
      ];
    }
    return [
      pw.Text(
        l10n.pdfReadingsTitle,
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 4),
      _readingsHeaderRow(l10n),
      for (final reading in readings) _readingRow(reading, l10n),
    ];
  }

  pw.Widget _readingsHeaderRow(AppLocalizations l10n) {
    return pw.Container(
      color: PdfColors.grey200,
      child: pw.Row(
        children: [
          pw.Expanded(flex: 2, child: _cellHeader(l10n.csvColumnDate)),
          pw.Expanded(child: _cellHeader(l10n.csvColumnTime)),
          pw.Expanded(
            flex: 2,
            child: _cellHeader(
              '${l10n.csvColumnSystolic} / ${l10n.csvColumnDiastolic}',
            ),
          ),
          pw.Expanded(child: _cellHeader(l10n.csvColumnPulse)),
          pw.Expanded(flex: 3, child: _cellHeader(l10n.csvColumnCategory)),
          pw.Expanded(flex: 4, child: _cellHeader(l10n.csvColumnNote)),
        ],
      ),
    );
  }

  pw.Widget _readingRow(BloodPressureReading reading, AppLocalizations l10n) {
    final local = reading.measuredAt.toLocal();
    final category = classifier.classify(
      systolic: reading.systolic,
      diastolic: reading.diastolic,
    );
    final note = reading.note ?? '';
    final truncated = note.length <= 40 ? note : '${note.substring(0, 39)}…';
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: _cell('${local.year}-${_p2(local.month)}-${_p2(local.day)}'),
          ),
          pw.Expanded(child: _cell('${_p2(local.hour)}:${_p2(local.minute)}')),
          pw.Expanded(
            flex: 2,
            child: _cell('${reading.systolic} / ${reading.diastolic}'),
          ),
          pw.Expanded(
            child: _cell(reading.pulse == null ? '—' : '${reading.pulse}'),
          ),
          pw.Expanded(flex: 3, child: _cell(_categoryLabel(category, l10n))),
          pw.Expanded(flex: 4, child: _cell(truncated)),
        ],
      ),
    );
  }

  pw.Widget _buildFullDisclaimer(AppLocalizations l10n) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Text(
        l10n.disclaimerBody,
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
      ),
    );
  }

  pw.Widget _cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }

  pw.Widget _cellHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  String _metricValue(num? value) => value == null ? '—' : '${value.round()}';

  String _p2(int value) => value < 10 ? '0$value' : '$value';

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
}
