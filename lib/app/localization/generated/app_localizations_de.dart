// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Blutdruck Tracker';

  @override
  String get overviewTitle => 'Blutdruck';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get statisticsTitle => 'Statistiken';

  @override
  String get statusTitle => 'Status';

  @override
  String get exportTitle => 'Exportieren';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get remindersTitle => 'Erinnerungen';

  @override
  String get privacyTitle => 'Datenschutz';

  @override
  String get addReadingTitle => 'Hinzufügen';

  @override
  String get editReadingTitle => 'Bearbeiten';

  @override
  String get saveButton => 'Speichern';

  @override
  String get cancelButton => 'Abbrechen';

  @override
  String get backButtonTooltip => 'Zurück';

  @override
  String get deleteButton => 'Löschen';

  @override
  String get confirmButton => 'Bestätigen';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageChinese => '中文';

  @override
  String get categoryHypotension => 'Niedriger Blutdruck';

  @override
  String get categoryOptimal => 'Optimal';

  @override
  String get categoryNormal => 'Normal';

  @override
  String get categoryHighNormal => 'Hochnormal';

  @override
  String get categoryHypertensionGrade1 => 'Bluthochdruck Grad 1';

  @override
  String get categoryHypertensionGrade2 => 'Bluthochdruck Grad 2';

  @override
  String get categoryHypertensionGrade3 => 'Bluthochdruck Grad 3';

  @override
  String get categoryIsolatedSystolic => 'Isolierte systolische Hypertonie';

  @override
  String get bmiUnderweight => 'Untergewicht';

  @override
  String get bmiNormal => 'Normalgewicht';

  @override
  String get bmiOverweight => 'Übergewicht';

  @override
  String get bmiObese => 'Adipositas';

  @override
  String get disclaimerTitle => 'Wichtiger Hinweis';

  @override
  String get disclaimerBody =>
      'Diese App dient nur der persönlichen Dokumentation und Information. Sie ist kein Medizinprodukt und bietet keine Diagnose, Behandlung oder medizinische Beratung. Bitte wenden Sie sich bei medizinischen Fragen an qualifiziertes medizinisches Fachpersonal.';

  @override
  String get disclaimerAccept => 'Verstanden';

  @override
  String get measuredAtLabel => 'Datum und Uhrzeit';

  @override
  String get systolicLabel => 'Systolisch';

  @override
  String get diastolicLabel => 'Diastolisch';

  @override
  String get pulseLabel => 'Puls';

  @override
  String get weightLabel => 'Gewicht';

  @override
  String get unspecifiedLabel => 'Nicht angegeben';

  @override
  String get noteLabel => 'Notiz';

  @override
  String get validationRange =>
      'Dieser Wert liegt außerhalb des Eingabebereichs. Bitte überprüfen.';

  @override
  String get validationSystolicDiastolic =>
      'Systolisch sollte normalerweise höher als diastolisch sein.';

  @override
  String get validationNoteTooLong => 'Die Notiz ist zu lang.';

  @override
  String get validationFutureDate =>
      'Der Messzeitpunkt liegt zu weit in der Zukunft.';

  @override
  String get readingSavedMessage => 'Eintrag gespeichert';

  @override
  String get formLoadErrorTitle => 'Messung konnte nicht geladen werden';

  @override
  String get formLoadErrorBody => 'Bitte erneut versuchen.';

  @override
  String get deleteReadingTitle => 'Messung löschen';

  @override
  String get deleteReadingBody => 'Diese Messung löschen?';

  @override
  String get overviewTabHistory => 'Verlauf';

  @override
  String get overviewTabStatistics => 'Statistiken';

  @override
  String get overviewTabStatus => 'Status';

  @override
  String get latestReadingTitle => 'Aktuell';

  @override
  String get latestReadingSystolicShort => 'Sys.';

  @override
  String get latestReadingDiastolicShort => 'Dia.';

  @override
  String get latestReadingPulseShort => 'Puls';

  @override
  String latestReadingTapHint(int count) {
    return 'Tippen für die letzten $count Einträge';
  }

  @override
  String lastRecentEntriesTitle(int count) {
    return 'Letzte $count Einträge';
  }

  @override
  String get lastRecentEntriesEmpty => 'Noch keine Einträge.';

  @override
  String get latestReadingEmptyTitle => 'Noch keine Messungen';

  @override
  String get latestReadingEmptyBody =>
      'Erfassen Sie die erste Messung, um Ihren Verlauf zu sehen.';

  @override
  String get latestReadingEmptyAction => 'Erste Messung erfassen';

  @override
  String latestReadingSemanticLabel(
    int systolic,
    int diastolic,
    int pulse,
    String category,
    String relativeTime,
  ) {
    return 'Letzte Messung: $systolic zu $diastolic, Puls $pulse, Kategorie $category, $relativeTime';
  }

  @override
  String get relativeTimeNow => 'Gerade eben';

  @override
  String relativeTimeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Minuten',
      one: 'vor 1 Minute',
    );
    return '$_temp0';
  }

  @override
  String relativeTimeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Stunden',
      one: 'vor 1 Stunde',
    );
    return '$_temp0';
  }

  @override
  String relativeTimeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get bloodPressureChartTitle => 'Blutdruckverlauf';

  @override
  String get chartEmptyTitle => 'Keine Messungen in diesem Zeitraum';

  @override
  String get chartEmptyBody =>
      'Wählen Sie einen anderen Zeitraum oder erfassen Sie eine neue Messung.';

  @override
  String get period7Days => '7 T';

  @override
  String get period14Days => '14 T';

  @override
  String get period30Days => '30 T';

  @override
  String get period90Days => '90 T';

  @override
  String get periodCustom => 'Benutzerdefiniert';

  @override
  String get timeSlotChartTitle => 'Zeitfenster';

  @override
  String get timeSlotChartEmptyTitle => 'Zeitfensterverlauf';

  @override
  String get timeSlotChartHint =>
      'Sammeln Sie mehr Messungen zur gleichen Tageszeit, um diese Auswertung zu sehen.';

  @override
  String get timeSlotSourceAuto => 'automatisch erkannt';

  @override
  String get timeSlotSourcePinned => 'festgelegt';

  @override
  String timeSlotHeader(String range, int hours, String source) {
    return '$range · $hours h · $source';
  }

  @override
  String get timeSlotSettingsTooltip => 'Zeitfenster einstellen';

  @override
  String get timeSlotAutoToggle => 'Slot automatisch wählen';

  @override
  String get timeSlotSettingsLink => 'Breite in Einstellungen ändern';

  @override
  String get weightChartTitle => 'Gewichtsverlauf';

  @override
  String get overviewLoadErrorTitle => 'Überblick konnte nicht geladen werden';

  @override
  String get overviewLoadErrorBody => 'Bitte erneut versuchen.';

  @override
  String get historyEmptyTitle => 'Noch keine Einträge';

  @override
  String get historyEmptyBody =>
      'Tippen Sie auf das +, um die erste Messung zu erfassen.';

  @override
  String get historyEmptyAction => 'Erste Messung erfassen';

  @override
  String historyEntriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String get historyFilterAllTime => 'Gesamter Zeitraum';

  @override
  String historyFilterRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get historyFilterClear => 'Filter zurücksetzen';

  @override
  String get historyLoadErrorTitle => 'Einträge konnten nicht geladen werden';

  @override
  String get historyLoadErrorBody => 'Bitte erneut versuchen.';

  @override
  String historyPulseLabel(int count) {
    return 'Puls $count';
  }

  @override
  String statisticsPeriodSummary(String from, String to) {
    return '$from – $to';
  }

  @override
  String get statisticsKeyMetricsTitle => 'Kennzahlen';

  @override
  String get statisticsMetricLabel => 'Kennzahl';

  @override
  String get statisticsMetricAverage => 'Mittel';

  @override
  String get statisticsMetricMin => 'Min';

  @override
  String get statisticsMetricMax => 'Max';

  @override
  String get statisticsMetricTrend => 'Trend';

  @override
  String get statisticsMetricEmptyValue => '—';

  @override
  String get pulsePressureLabel => 'Pulsdruck';

  @override
  String get meanArterialPressureLabel => 'MAD';

  @override
  String get trendUp => 'steigend';

  @override
  String get trendDown => 'fallend';

  @override
  String get trendStable => 'stabil';

  @override
  String get trendUnknown => 'kein Trend';

  @override
  String get statisticsClassificationTitle => 'Kategorieverteilung';

  @override
  String get statisticsClassificationOpenStatus => 'Status öffnen';

  @override
  String get statisticsBmiTitle => 'BMI';

  @override
  String get statisticsBmiCurrent => 'Aktuell';

  @override
  String get statisticsBmiAverage => 'Mittel';

  @override
  String get statisticsBmiHelper =>
      'Berechnet aus Ihrer Profilgröße und dem letzten Gewicht im Zeitraum.';

  @override
  String get statisticsBmiProfileTitle => 'Größe ergänzen';

  @override
  String get statisticsBmiProfileLink =>
      'Größe im Profil eintragen, um BMI zu berechnen.';

  @override
  String get statisticsInsightsTitle => 'Hinweise';

  @override
  String get statisticsLoadErrorTitle =>
      'Statistiken konnten nicht geladen werden';

  @override
  String get statisticsLoadErrorBody => 'Bitte erneut versuchen.';

  @override
  String get statusDistributionTitle => 'Kategorieverteilung';

  @override
  String get statusDistributionEmpty => 'Keine Messungen in diesem Zeitraum.';

  @override
  String get statusExplanationTitle => 'Was bedeuten die Kategorien?';

  @override
  String get statusExplanationIntro =>
      'Die Schwellen orientieren sich an üblichen Praxiswerten. Sie sind beschreibende Hinweise, keine Diagnose.';

  @override
  String get statusCategoryThresholdHypotension =>
      'Systolisch < 90 oder diastolisch < 60';

  @override
  String get statusCategoryThresholdOptimal =>
      'Systolisch < 120 und diastolisch < 80';

  @override
  String get statusCategoryThresholdNormal =>
      'Systolisch 120–129 und/oder diastolisch 80–84';

  @override
  String get statusCategoryThresholdHighNormal =>
      'Systolisch 130–139 und/oder diastolisch 85–89';

  @override
  String get statusCategoryThresholdHypertensionGrade1 =>
      'Systolisch 140–159 und/oder diastolisch 90–99';

  @override
  String get statusCategoryThresholdHypertensionGrade2 =>
      'Systolisch 160–179 und/oder diastolisch 100–109';

  @override
  String get statusCategoryThresholdHypertensionGrade3 =>
      'Systolisch ≥ 180 oder diastolisch ≥ 110';

  @override
  String get statusCategoryThresholdIsolatedSystolic =>
      'Systolisch ≥ 140 und diastolisch < 90';

  @override
  String categoryCount(int count) {
    return '$count';
  }

  @override
  String get insightNoDataTitle => 'Noch keine Hinweise';

  @override
  String get insightNoDataBody =>
      'Erfassen Sie einige Messungen, um Hinweise zu sehen.';

  @override
  String get insightFewEntriesTitle => 'Wenige Einträge in diesem Zeitraum';

  @override
  String get insightFewEntriesBody =>
      'Erfassen Sie mehr Messungen für eine deutlichere Auswertung.';

  @override
  String get insightMeasureMoreOftenTitle => 'Häufiger messen';

  @override
  String get insightMeasureMoreOftenBody =>
      'Mehrere Messungen pro Woche helfen, einen Verlauf zu sehen.';

  @override
  String get insightBpRisingTitle => 'Trend steigt';

  @override
  String get insightBpRisingBody =>
      'Die jüngsten Werte sind höher als zu Beginn des Zeitraums.';

  @override
  String get insightBpFallingTitle => 'Trend fällt';

  @override
  String get insightBpFallingBody =>
      'Die jüngsten Werte sind niedriger als zu Beginn des Zeitraums.';

  @override
  String get insightFrequentlyElevatedTitle => 'Häufig über dem Normalbereich';

  @override
  String insightFrequentlyElevatedBody(Object count, Object total) {
    return '$count von $total Messungen lagen in erhöhten Kategorien.';
  }

  @override
  String get insightFrequentlyLowTitle => 'Häufig unter dem Normalbereich';

  @override
  String insightFrequentlyLowBody(Object count, Object total) {
    return '$count von $total Messungen waren niedrig.';
  }

  @override
  String get insightWellDocumentedTitle => 'Gut dokumentiert';

  @override
  String get insightWellDocumentedBody => 'Sie erfassen regelmäßig. Weiter so.';

  @override
  String get csvColumnDate => 'Datum';

  @override
  String get csvColumnTime => 'Uhrzeit';

  @override
  String get csvColumnSystolic => 'Systolisch';

  @override
  String get csvColumnDiastolic => 'Diastolisch';

  @override
  String get csvColumnPulse => 'Puls';

  @override
  String get csvColumnPulsePressure => 'Pulsdruck';

  @override
  String get csvColumnMap => 'MAD';

  @override
  String get csvColumnWeightKg => 'Gewicht_kg';

  @override
  String get csvColumnNote => 'Notiz';

  @override
  String get csvColumnCategory => 'Kategorie';

  @override
  String get csvColumnSource => 'Quelle';

  @override
  String get exportFormatCsv => 'CSV';

  @override
  String get exportFormatPdf => 'PDF';

  @override
  String get exportFormatLabel => 'Format';

  @override
  String get exportPeriodLabel => 'Zeitraum';

  @override
  String get exportIncludeContextFields => 'Kontextfelder einschließen';

  @override
  String get exportIncludeChartImage => 'Diagramm einbetten';

  @override
  String get exportGenerateAction => 'Erstellen und teilen';

  @override
  String get exportGeneratingMessage => 'Wird erstellt…';

  @override
  String get exportSavedMessage => 'Export gespeichert.';

  @override
  String get exportHistoryTitle => 'Letzte Exporte';

  @override
  String get exportHistoryEmpty => 'Noch keine Exporte.';

  @override
  String get exportDeleteRecordTitle => 'Export löschen?';

  @override
  String get exportDeleteRecordBody => 'Eintrag aus der Liste entfernen.';

  @override
  String get pdfReportHeader => 'Blutdruck-Bericht';

  @override
  String pdfGeneratedAt(String timestamp) {
    return 'Erstellt $timestamp';
  }

  @override
  String get pdfSummaryTitle => 'Zusammenfassung';

  @override
  String get pdfReadingsTitle => 'Messungen';

  @override
  String get pdfDisclaimerFooter =>
      'Diese Auswertung ersetzt keine ärztliche Beurteilung.';

  @override
  String get pdfChartUnavailable =>
      'Diagrammbild in dieser Version nicht enthalten.';

  @override
  String get reminderNotificationTitle => 'Blutdruckmessung';

  @override
  String get reminderNotificationBody => 'Zeit für eine Messung.';

  @override
  String get remindersMasterToggle => 'Erinnerungen aktivieren';

  @override
  String get remindersEmptyTitle => 'Noch keine Erinnerungen';

  @override
  String get remindersEmptyBody =>
      'Erinnerung hinzufügen, um eine sanfte Erinnerung zu erhalten.';

  @override
  String get remindersAddAction => 'Erinnerung hinzufügen';

  @override
  String get reminderEditTitle => 'Erinnerung bearbeiten';

  @override
  String get reminderAddTitle => 'Neue Erinnerung';

  @override
  String get reminderTimeLabel => 'Uhrzeit';

  @override
  String get reminderWeekdaysLabel => 'Wochentage';

  @override
  String get reminderEveryDay => 'Täglich';

  @override
  String get reminderLabelLabel => 'Bezeichnung (optional)';

  @override
  String get reminderPermissionDenied =>
      'Benachrichtigungsberechtigung wurde nicht erteilt.';

  @override
  String get weekdayMon => 'Mo';

  @override
  String get weekdayTue => 'Di';

  @override
  String get weekdayWed => 'Mi';

  @override
  String get weekdayThu => 'Do';

  @override
  String get weekdayFri => 'Fr';

  @override
  String get weekdaySat => 'Sa';

  @override
  String get weekdaySun => 'So';

  @override
  String get settingsGroupProfile => 'Profil';

  @override
  String get settingsGroupAppearance => 'Erscheinungsbild';

  @override
  String get settingsGroupUnits => 'Einheiten';

  @override
  String get settingsGroupTimeSlot => 'Zeitfenster';

  @override
  String get settingsGroupReminders => 'Erinnerungen';

  @override
  String get settingsGroupData => 'Daten';

  @override
  String get settingsGroupPrivacy => 'Datenschutz';

  @override
  String get settingsGroupIntegrations => 'Integrationen';

  @override
  String get settingsGroupAbout => 'Über die App';

  @override
  String get settingsHeightLabel => 'Größe';

  @override
  String get settingsHeightHint => 'Wird für die BMI-Berechnung verwendet.';

  @override
  String get settingsHeightSuffix => 'cm';

  @override
  String get settingsHeightOutOfRange =>
      'Bitte einen Wert zwischen 80 und 250 eingeben.';

  @override
  String get settingsHeightInvalid => 'Bitte eine Zahl eingeben.';

  @override
  String get settingsHeightSaveAction => 'Speichern';

  @override
  String get settingsHeightClearAction => 'Löschen';

  @override
  String get settingsWeightLabel => 'Gewicht';

  @override
  String get settingsWeightHint => 'Wird für den BMI verwendet.';

  @override
  String get settingsWeightSuffix => 'kg';

  @override
  String get settingsWeightOutOfRange =>
      'Geben Sie einen Wert zwischen 20 und 400 ein.';

  @override
  String get settingsWeightInvalid => 'Bitte eine Zahl eingeben.';

  @override
  String get settingsRecentEntriesLabel => 'Letzte Einträge beim Antippen';

  @override
  String get settingsRecentEntriesHint =>
      'Wie viele Einträge im Status-Tab beim Antippen der letzten Messung angezeigt werden.';

  @override
  String get settingsThemeLabel => 'Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsLanguageLabel => 'Sprache';

  @override
  String get settingsWeightUnitLabel => 'Gewichtseinheit';

  @override
  String get settingsWeightUnitKg => 'kg';

  @override
  String get settingsWeightUnitLb => 'lb';

  @override
  String get settingsSlotWidthLabel => 'Fensterbreite';

  @override
  String get settingsSlotWidth1h => '1 h';

  @override
  String get settingsSlotWidth2h => '2 h';

  @override
  String get settingsSlotWidth3h => '3 h';

  @override
  String get settingsSlotAutoToggle => 'Slot automatisch wählen';

  @override
  String get settingsSlotStartLabel => 'Fester Slot-Start';

  @override
  String get settingsSlotStartUnset => 'Nicht festgelegt';

  @override
  String get settingsRemindersOpen => 'Erinnerungseinstellungen öffnen';

  @override
  String get settingsExportOpen => 'Export öffnen';

  @override
  String get settingsDeleteAllAction => 'Alle Daten löschen';

  @override
  String get settingsDeleteAllConfirmTitle => 'Alle Daten löschen?';

  @override
  String get settingsDeleteAllConfirmBody =>
      'Alle Messungen, Erinnerungen und Exporte werden entfernt. Dies kann nicht rückgängig gemacht werden.';

  @override
  String get settingsDeleteAllConfirmAction => 'Weiter';

  @override
  String get settingsDeleteAllSecondTitle => 'Letzte Bestätigung';

  @override
  String get settingsDeleteAllSecondBody =>
      'Geben Sie LÖSCHEN ein, um zu bestätigen.';

  @override
  String get settingsDeleteAllChallenge => 'LÖSCHEN';

  @override
  String get settingsDeleteAllCompleted => 'Alle Daten gelöscht.';

  @override
  String get settingsPrivacyOpen => 'Datenschutzhinweise öffnen';

  @override
  String get settingsIntegrationsHealthConnect => 'Health Connect / HealthKit';

  @override
  String get settingsIntegrationsFitbit => 'Fitbit / Google Health';

  @override
  String get settingsIntegrationsLlm => 'KI-Zusammenfassung (LLM)';

  @override
  String get settingsIntegrationsComingSoon => 'Bald verfügbar';

  @override
  String get settingsAboutVersion => 'Version';

  @override
  String get settingsAboutLicenses => 'Open-Source-Lizenzen';

  @override
  String get settingsAboutAppVersion => '0.1.0+1';

  @override
  String get privacyResetDisclaimerAction => 'Hinweis erneut anzeigen';
}
