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
  String get overviewTitle => 'Blood Pressure';

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
  String get addReadingTitle => 'Add';

  @override
  String get editReadingTitle => 'Edit';

  @override
  String get saveButton => 'Save';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get backButtonTooltip => 'Back';

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
  String get unspecifiedLabel => 'Unspecified';

  @override
  String get noteLabel => 'Note';

  @override
  String get validationRange =>
      'This value is outside the expected input range. Please check it.';

  @override
  String get validationSystolicDiastolic =>
      'Systolic should usually be higher than diastolic.';

  @override
  String get validationNoteTooLong => 'The note is too long.';

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
  String get latestReadingTitle => 'Latest';

  @override
  String get latestReadingSystolicShort => 'Sys.';

  @override
  String get latestReadingDiastolicShort => 'Dia.';

  @override
  String get latestReadingPulseShort => 'Pulse';

  @override
  String latestReadingTapHint(int count) {
    return 'Tap to see the last $count entries';
  }

  @override
  String lastRecentEntriesTitle(int count) {
    return 'Last $count entries';
  }

  @override
  String get lastRecentEntriesEmpty => 'No entries yet.';

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

  @override
  String statisticsPeriodSummary(String from, String to) {
    return '$from – $to';
  }

  @override
  String get statisticsKeyMetricsTitle => 'Key metrics';

  @override
  String get statisticsMetricLabel => 'Metric';

  @override
  String get statisticsMetricAverage => 'Avg';

  @override
  String get statisticsMetricMin => 'Min';

  @override
  String get statisticsMetricMax => 'Max';

  @override
  String get statisticsMetricTrend => 'Trend';

  @override
  String get statisticsMetricEmptyValue => '—';

  @override
  String get pulsePressureLabel => 'Pulse pressure';

  @override
  String get meanArterialPressureLabel => 'MAP';

  @override
  String get trendUp => 'rising';

  @override
  String get trendDown => 'falling';

  @override
  String get trendStable => 'stable';

  @override
  String get trendUnknown => 'no trend';

  @override
  String get statisticsClassificationTitle => 'Category distribution';

  @override
  String get statisticsClassificationOpenStatus => 'Open status view';

  @override
  String get statisticsBmiTitle => 'BMI';

  @override
  String get statisticsBmiCurrent => 'Current';

  @override
  String get statisticsBmiAverage => 'Average';

  @override
  String get statisticsBmiHelper =>
      'Calculated from your profile height and the latest in-period weight.';

  @override
  String get statisticsBmiProfileTitle => 'Add your height';

  @override
  String get statisticsBmiProfileLink =>
      'Set height in profile to calculate BMI.';

  @override
  String get statisticsInsightsTitle => 'Insights';

  @override
  String get statisticsLoadErrorTitle => 'Could not load statistics';

  @override
  String get statisticsLoadErrorBody => 'Please try again.';

  @override
  String get statusDistributionTitle => 'Category distribution';

  @override
  String get statusDistributionEmpty => 'No readings in this period.';

  @override
  String get statusExplanationTitle => 'What do the categories mean?';

  @override
  String get statusExplanationIntro =>
      'Thresholds follow common office-measurement ranges. They are descriptive guides, not diagnoses.';

  @override
  String get statusCategoryThresholdHypotension =>
      'Systolic < 90 or diastolic < 60';

  @override
  String get statusCategoryThresholdOptimal =>
      'Systolic < 120 and diastolic < 80';

  @override
  String get statusCategoryThresholdNormal =>
      'Systolic 120–129 and/or diastolic 80–84';

  @override
  String get statusCategoryThresholdHighNormal =>
      'Systolic 130–139 and/or diastolic 85–89';

  @override
  String get statusCategoryThresholdHypertensionGrade1 =>
      'Systolic 140–159 and/or diastolic 90–99';

  @override
  String get statusCategoryThresholdHypertensionGrade2 =>
      'Systolic 160–179 and/or diastolic 100–109';

  @override
  String get statusCategoryThresholdHypertensionGrade3 =>
      'Systolic ≥ 180 or diastolic ≥ 110';

  @override
  String get statusCategoryThresholdIsolatedSystolic =>
      'Systolic ≥ 140 and diastolic < 90';

  @override
  String categoryCount(int count) {
    return '$count';
  }

  @override
  String get insightNoDataTitle => 'No insights yet';

  @override
  String get insightNoDataBody => 'Record a few readings to see insights here.';

  @override
  String get insightFewEntriesTitle => 'Few entries this period';

  @override
  String get insightFewEntriesBody =>
      'Add more readings for a clearer picture.';

  @override
  String get insightMeasureMoreOftenTitle => 'Measure more often';

  @override
  String get insightMeasureMoreOftenBody =>
      'Aim for several readings each week.';

  @override
  String get insightBpRisingTitle => 'Trend is rising';

  @override
  String get insightBpRisingBody =>
      'Recent readings have been higher than earlier in the period.';

  @override
  String get insightBpFallingTitle => 'Trend is falling';

  @override
  String get insightBpFallingBody =>
      'Recent readings have been lower than earlier in the period.';

  @override
  String get insightFrequentlyElevatedTitle => 'Often above the normal range';

  @override
  String insightFrequentlyElevatedBody(Object count, Object total) {
    return '$count of $total readings landed in elevated categories.';
  }

  @override
  String get insightFrequentlyLowTitle => 'Often below the normal range';

  @override
  String insightFrequentlyLowBody(Object count, Object total) {
    return '$count of $total readings were low.';
  }

  @override
  String get insightWellDocumentedTitle => 'Well documented';

  @override
  String get insightWellDocumentedBody =>
      'You\'re recording regularly. Keep it up.';

  @override
  String get csvColumnDate => 'Date';

  @override
  String get csvColumnTime => 'Time';

  @override
  String get csvColumnSystolic => 'Systolic';

  @override
  String get csvColumnDiastolic => 'Diastolic';

  @override
  String get csvColumnPulse => 'Pulse';

  @override
  String get csvColumnPulsePressure => 'PulsePressure';

  @override
  String get csvColumnMap => 'MAP';

  @override
  String get csvColumnWeightKg => 'Weight_kg';

  @override
  String get csvColumnNote => 'Note';

  @override
  String get csvColumnCategory => 'Category';

  @override
  String get csvColumnSource => 'Source';

  @override
  String get exportFormatCsv => 'CSV';

  @override
  String get exportFormatPdf => 'PDF';

  @override
  String get exportFormatLabel => 'Format';

  @override
  String get exportPeriodLabel => 'Period';

  @override
  String get exportIncludeContextFields => 'Include context fields';

  @override
  String get exportIncludeChartImage => 'Include chart image';

  @override
  String get exportGenerateAction => 'Generate and share';

  @override
  String get exportGeneratingMessage => 'Generating…';

  @override
  String get exportSavedMessage => 'Export saved.';

  @override
  String get exportHistoryTitle => 'Recent exports';

  @override
  String get exportHistoryEmpty => 'No exports yet.';

  @override
  String get exportDeleteRecordTitle => 'Delete export?';

  @override
  String get exportDeleteRecordBody =>
      'Delete this export file from the recents list.';

  @override
  String get pdfReportHeader => 'Blood pressure report';

  @override
  String pdfGeneratedAt(String timestamp) {
    return 'Generated $timestamp';
  }

  @override
  String get pdfSummaryTitle => 'Summary';

  @override
  String get pdfReadingsTitle => 'Readings';

  @override
  String get pdfDisclaimerFooter =>
      'This report does not replace medical advice.';

  @override
  String get pdfChartUnavailable => 'Chart image not included in this build.';

  @override
  String get reminderNotificationTitle => 'Blood pressure reading';

  @override
  String get reminderNotificationBody => 'Time to record a measurement.';

  @override
  String get remindersMasterToggle => 'Enable reminders';

  @override
  String get remindersEmptyTitle => 'No reminders yet';

  @override
  String get remindersEmptyBody =>
      'Add a reminder to get a gentle nudge each day.';

  @override
  String get remindersAddAction => 'Add reminder';

  @override
  String get reminderEditTitle => 'Edit reminder';

  @override
  String get reminderAddTitle => 'New reminder';

  @override
  String get reminderTimeLabel => 'Time';

  @override
  String get reminderWeekdaysLabel => 'Weekdays';

  @override
  String get reminderEveryDay => 'Every day';

  @override
  String get reminderLabelLabel => 'Label (optional)';

  @override
  String get reminderPermissionDenied =>
      'Notification permission was not granted.';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get settingsGroupProfile => 'Profile';

  @override
  String get settingsGroupAppearance => 'Appearance';

  @override
  String get settingsGroupUnits => 'Units';

  @override
  String get settingsGroupTimeSlot => 'Time slot';

  @override
  String get settingsGroupReminders => 'Reminders';

  @override
  String get settingsGroupData => 'Data';

  @override
  String get settingsGroupPrivacy => 'Privacy';

  @override
  String get settingsGroupIntegrations => 'Integrations';

  @override
  String get settingsGroupAbout => 'About';

  @override
  String get settingsHeightLabel => 'Height';

  @override
  String get settingsHeightHint => 'Used for the BMI calculation.';

  @override
  String get settingsHeightSuffix => 'cm';

  @override
  String get settingsHeightOutOfRange => 'Enter a value between 80 and 250.';

  @override
  String get settingsHeightInvalid => 'Please enter a number.';

  @override
  String get settingsHeightSaveAction => 'Save';

  @override
  String get settingsHeightClearAction => 'Clear';

  @override
  String get settingsWeightLabel => 'Weight';

  @override
  String get settingsWeightHint => 'Used for the BMI calculation.';

  @override
  String get settingsWeightSuffix => 'kg';

  @override
  String get settingsWeightOutOfRange => 'Enter a value between 20 and 400.';

  @override
  String get settingsWeightInvalid => 'Please enter a number.';

  @override
  String get settingsRecentEntriesLabel => 'Recent entries on tap';

  @override
  String get settingsRecentEntriesHint =>
      'How many entries the Status tab shows when you tap the latest reading.';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsWeightUnitLabel => 'Weight unit';

  @override
  String get settingsWeightUnitKg => 'kg';

  @override
  String get settingsWeightUnitLb => 'lb';

  @override
  String get settingsSlotWidthLabel => 'Slot width';

  @override
  String get settingsSlotWidth1h => '1 h';

  @override
  String get settingsSlotWidth2h => '2 h';

  @override
  String get settingsSlotWidth3h => '3 h';

  @override
  String get settingsSlotAutoToggle => 'Choose slot automatically';

  @override
  String get settingsSlotStartLabel => 'Pinned slot start';

  @override
  String get settingsSlotStartUnset => 'Not set';

  @override
  String get settingsRemindersOpen => 'Open reminder settings';

  @override
  String get settingsExportOpen => 'Open export';

  @override
  String get settingsDeleteAllAction => 'Delete all data';

  @override
  String get settingsDeleteAllConfirmTitle => 'Delete all data?';

  @override
  String get settingsDeleteAllConfirmBody =>
      'All readings, reminders, and exports will be removed. This cannot be undone.';

  @override
  String get settingsDeleteAllConfirmAction => 'Continue';

  @override
  String get settingsDeleteAllSecondTitle => 'Last chance';

  @override
  String get settingsDeleteAllSecondBody => 'Type DELETE to confirm.';

  @override
  String get settingsDeleteAllChallenge => 'DELETE';

  @override
  String get settingsDeleteAllCompleted => 'All data deleted.';

  @override
  String get settingsPrivacyOpen => 'Open privacy info';

  @override
  String get settingsIntegrationsHealthConnect => 'Health Connect / HealthKit';

  @override
  String get settingsIntegrationsFitbit => 'Fitbit / Google Health';

  @override
  String get settingsIntegrationsLlm => 'AI insights (LLM)';

  @override
  String get settingsIntegrationsComingSoon => 'Coming soon';

  @override
  String get settingsAboutVersion => 'Version';

  @override
  String get settingsAboutLicenses => 'Open source licenses';

  @override
  String get settingsAboutAppVersion => '0.1.0+1';

  @override
  String get privacyResetDisclaimerAction => 'Show disclaimer again';
}
