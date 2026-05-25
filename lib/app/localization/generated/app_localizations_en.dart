// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Blood Pressure Tracker';

  @override
  String get overviewTitle => 'Overview';

  @override
  String get historyTitle => 'History';

  @override
  String get statisticsTitle => 'Statistics';

  @override
  String get statusTitle => 'Status';

  @override
  String get exportTitle => 'Export';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get privacyTitle => 'Privacy info';

  @override
  String get addReadingTitle => 'Add reading';

  @override
  String get editReadingTitle => 'Edit reading';

  @override
  String get saveButton => 'Save';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageChinese => '中文';

  @override
  String get categoryHypotension => 'Low blood pressure';

  @override
  String get categoryOptimal => 'Optimal';

  @override
  String get categoryNormal => 'Normal';

  @override
  String get categoryHighNormal => 'High normal';

  @override
  String get categoryHypertensionGrade1 => 'Hypertension grade 1';

  @override
  String get categoryHypertensionGrade2 => 'Hypertension grade 2';

  @override
  String get categoryHypertensionGrade3 => 'Hypertension grade 3';

  @override
  String get categoryIsolatedSystolic => 'Isolated systolic hypertension';

  @override
  String get bmiUnderweight => 'Underweight';

  @override
  String get bmiNormal => 'Normal weight';

  @override
  String get bmiOverweight => 'Overweight';

  @override
  String get bmiObese => 'Obesity';

  @override
  String get disclaimerTitle => 'Important notice';

  @override
  String get disclaimerBody =>
      'This app is for personal tracking and informational purposes only. It is not a medical device and does not provide diagnosis, treatment, or medical advice. Please consult a qualified healthcare professional for medical decisions.';

  @override
  String get disclaimerAccept => 'I understand';

  @override
  String get measuredAtLabel => 'Date and time';

  @override
  String get systolicLabel => 'Systolic';

  @override
  String get diastolicLabel => 'Diastolic';

  @override
  String get pulseLabel => 'Pulse';

  @override
  String get weightLabel => 'Weight';

  @override
  String get armLabel => 'Arm';

  @override
  String get armLeftLabel => 'Left';

  @override
  String get armRightLabel => 'Right';

  @override
  String get unspecifiedLabel => 'Unspecified';

  @override
  String get stressLevelLabel => 'Stress level';

  @override
  String get medicationNoteLabel => 'Medication note';

  @override
  String get noteLabel => 'Notes';

  @override
  String get validationRange =>
      'This value is outside the expected input range. Please check it.';

  @override
  String get validationSystolicDiastolic =>
      'Systolic should usually be higher than diastolic.';

  @override
  String get validationNoteTooLong => 'The note is too long.';

  @override
  String get validationMedicationTooLong => 'The medication note is too long.';

  @override
  String get validationFutureDate =>
      'The measurement time is too far in the future.';

  @override
  String get readingSavedMessage => 'Reading saved';

  @override
  String get formLoadErrorTitle => 'Could not load reading';

  @override
  String get formLoadErrorBody => 'Please try again.';

  @override
  String get deleteReadingTitle => 'Delete reading';

  @override
  String get deleteReadingBody => 'Delete this reading?';

  @override
  String get overviewTabHistory => 'History';

  @override
  String get overviewTabStatistics => 'Statistics';

  @override
  String get overviewTabStatus => 'Status';

  @override
  String get latestReadingTitle => 'Latest reading';

  @override
  String get latestReadingEmptyTitle => 'No readings yet';

  @override
  String get latestReadingEmptyBody =>
      'Add your first reading to start seeing your trend.';

  @override
  String get latestReadingEmptyAction => 'Add first reading';

  @override
  String latestReadingSemanticLabel(
    int systolic,
    int diastolic,
    int pulse,
    String category,
    String relativeTime,
  ) {
    return 'Latest reading: $systolic to $diastolic, pulse $pulse, category $category, $relativeTime';
  }

  @override
  String get relativeTimeNow => 'Just now';

  @override
  String relativeTimeMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String relativeTimeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String relativeTimeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get bloodPressureChartTitle => 'Blood pressure trend';

  @override
  String get chartEmptyTitle => 'No readings in this period';

  @override
  String get chartEmptyBody => 'Choose another period or add a new reading.';

  @override
  String get period7Days => '7 d';

  @override
  String get period14Days => '14 d';

  @override
  String get period30Days => '30 d';

  @override
  String get period90Days => '90 d';

  @override
  String get periodCustom => 'Custom';

  @override
  String get timeSlotChartTitle => 'Time slot';

  @override
  String get timeSlotChartEmptyTitle => 'Time slot trend';

  @override
  String get timeSlotChartHint =>
      'Collect more readings at a similar time of day to see this view.';

  @override
  String get timeSlotSourceAuto => 'auto-detected';

  @override
  String get timeSlotSourcePinned => 'pinned';

  @override
  String timeSlotHeader(String range, int hours, String source) {
    return '$range · $hours h · $source';
  }

  @override
  String get timeSlotSettingsTooltip => 'Time-slot settings';

  @override
  String get timeSlotAutoToggle => 'Choose slot automatically';

  @override
  String get timeSlotSettingsLink => 'Change width in Settings';

  @override
  String get weightChartTitle => 'Weight trend';

  @override
  String get overviewLoadErrorTitle => 'Could not load overview';

  @override
  String get overviewLoadErrorBody => 'Please try again.';

  @override
  String get historyEmptyTitle => 'No readings yet';

  @override
  String get historyEmptyBody => 'Tap the + button to add your first reading.';

  @override
  String get historyEmptyAction => 'Add first reading';

  @override
  String historyEntriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries',
      one: '1 entry',
    );
    return '$_temp0';
  }

  @override
  String get historyFilterAllTime => 'All time';

  @override
  String historyFilterRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get historyFilterClear => 'Clear filter';

  @override
  String get historyLoadErrorTitle => 'Could not load readings';

  @override
  String get historyLoadErrorBody => 'Please try again.';

  @override
  String historyPulseLabel(int count) {
    return 'Pulse $count';
  }
}
