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
  String get overviewTitle => 'Überblick';

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
  String get addReadingTitle => 'Messung erfassen';

  @override
  String get editReadingTitle => 'Messung bearbeiten';

  @override
  String get saveButton => 'Speichern';

  @override
  String get cancelButton => 'Abbrechen';

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
  String get armLabel => 'Arm';

  @override
  String get armLeftLabel => 'Links';

  @override
  String get armRightLabel => 'Rechts';

  @override
  String get unspecifiedLabel => 'Nicht angegeben';

  @override
  String get stressLevelLabel => 'Stress';

  @override
  String get medicationNoteLabel => 'Medikament';

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
  String get validationMedicationTooLong =>
      'Der Medikamentenhinweis ist zu lang.';

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
  String get latestReadingTitle => 'Letzte Messung';

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
}
