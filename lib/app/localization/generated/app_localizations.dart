import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure Tracker'**
  String get appTitle;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get overviewTitle;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @statisticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statisticsTitle;

  /// No description provided for @statusTitle.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusTitle;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy info'**
  String get privacyTitle;

  /// No description provided for @addReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addReadingTitle;

  /// No description provided for @editReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editReadingTitle;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @backButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButtonTooltip;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @categoryHypotension.
  ///
  /// In en, this message translates to:
  /// **'Low blood pressure'**
  String get categoryHypotension;

  /// No description provided for @categoryOptimal.
  ///
  /// In en, this message translates to:
  /// **'Optimal'**
  String get categoryOptimal;

  /// No description provided for @categoryNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get categoryNormal;

  /// No description provided for @categoryHighNormal.
  ///
  /// In en, this message translates to:
  /// **'High normal'**
  String get categoryHighNormal;

  /// No description provided for @categoryHypertensionGrade1.
  ///
  /// In en, this message translates to:
  /// **'Hypertension grade 1'**
  String get categoryHypertensionGrade1;

  /// No description provided for @categoryHypertensionGrade2.
  ///
  /// In en, this message translates to:
  /// **'Hypertension grade 2'**
  String get categoryHypertensionGrade2;

  /// No description provided for @categoryHypertensionGrade3.
  ///
  /// In en, this message translates to:
  /// **'Hypertension grade 3'**
  String get categoryHypertensionGrade3;

  /// No description provided for @categoryIsolatedSystolic.
  ///
  /// In en, this message translates to:
  /// **'Isolated systolic hypertension'**
  String get categoryIsolatedSystolic;

  /// No description provided for @bmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweight;

  /// No description provided for @bmiNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal weight'**
  String get bmiNormal;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In en, this message translates to:
  /// **'Obesity'**
  String get bmiObese;

  /// No description provided for @disclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Important notice'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'This app is for personal tracking and informational purposes only. It is not a medical device and does not provide diagnosis, treatment, or medical advice. Please consult a qualified healthcare professional for medical decisions.'**
  String get disclaimerBody;

  /// No description provided for @disclaimerAccept.
  ///
  /// In en, this message translates to:
  /// **'I understand'**
  String get disclaimerAccept;

  /// No description provided for @measuredAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Date and time'**
  String get measuredAtLabel;

  /// No description provided for @systolicLabel.
  ///
  /// In en, this message translates to:
  /// **'Systolic'**
  String get systolicLabel;

  /// No description provided for @diastolicLabel.
  ///
  /// In en, this message translates to:
  /// **'Diastolic'**
  String get diastolicLabel;

  /// No description provided for @pulseLabel.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get pulseLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @unspecifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get unspecifiedLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @validationRange.
  ///
  /// In en, this message translates to:
  /// **'This value is outside the expected input range. Please check it.'**
  String get validationRange;

  /// No description provided for @validationSystolicDiastolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic should usually be higher than diastolic.'**
  String get validationSystolicDiastolic;

  /// No description provided for @validationNoteTooLong.
  ///
  /// In en, this message translates to:
  /// **'The note is too long.'**
  String get validationNoteTooLong;

  /// No description provided for @validationFutureDate.
  ///
  /// In en, this message translates to:
  /// **'The measurement time is too far in the future.'**
  String get validationFutureDate;

  /// No description provided for @readingSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Reading saved'**
  String get readingSavedMessage;

  /// No description provided for @formLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load reading'**
  String get formLoadErrorTitle;

  /// No description provided for @formLoadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get formLoadErrorBody;

  /// No description provided for @deleteReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete reading'**
  String get deleteReadingTitle;

  /// No description provided for @deleteReadingBody.
  ///
  /// In en, this message translates to:
  /// **'Delete this reading?'**
  String get deleteReadingBody;

  /// No description provided for @overviewTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get overviewTabHistory;

  /// No description provided for @overviewTabStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get overviewTabStatistics;

  /// No description provided for @overviewTabStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get overviewTabStatus;

  /// No description provided for @latestReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latestReadingTitle;

  /// No description provided for @latestReadingSystolicShort.
  ///
  /// In en, this message translates to:
  /// **'Sys.'**
  String get latestReadingSystolicShort;

  /// No description provided for @latestReadingDiastolicShort.
  ///
  /// In en, this message translates to:
  /// **'Dia.'**
  String get latestReadingDiastolicShort;

  /// No description provided for @latestReadingPulseShort.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get latestReadingPulseShort;

  /// No description provided for @latestReadingTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to see the last 7 entries'**
  String get latestReadingTapHint;

  /// No description provided for @lastSevenEntriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Last 7 entries'**
  String get lastSevenEntriesTitle;

  /// No description provided for @lastSevenEntriesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.'**
  String get lastSevenEntriesEmpty;

  /// No description provided for @latestReadingEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No readings yet'**
  String get latestReadingEmptyTitle;

  /// No description provided for @latestReadingEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your first reading to start seeing your trend.'**
  String get latestReadingEmptyBody;

  /// No description provided for @latestReadingEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Add first reading'**
  String get latestReadingEmptyAction;

  /// No description provided for @latestReadingSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Latest reading: {systolic} to {diastolic}, pulse {pulse}, category {category}, {relativeTime}'**
  String latestReadingSemanticLabel(
    int systolic,
    int diastolic,
    int pulse,
    String category,
    String relativeTime,
  );

  /// No description provided for @relativeTimeNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get relativeTimeNow;

  /// No description provided for @relativeTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {1 minute ago} other {{count} minutes ago}}'**
  String relativeTimeMinutes(int count);

  /// No description provided for @relativeTimeHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {1 hour ago} other {{count} hours ago}}'**
  String relativeTimeHours(int count);

  /// No description provided for @relativeTimeDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {1 day ago} other {{count} days ago}}'**
  String relativeTimeDays(int count);

  /// No description provided for @bloodPressureChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure trend'**
  String get bloodPressureChartTitle;

  /// No description provided for @chartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No readings in this period'**
  String get chartEmptyTitle;

  /// No description provided for @chartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Choose another period or add a new reading.'**
  String get chartEmptyBody;

  /// No description provided for @period7Days.
  ///
  /// In en, this message translates to:
  /// **'7 d'**
  String get period7Days;

  /// No description provided for @period14Days.
  ///
  /// In en, this message translates to:
  /// **'14 d'**
  String get period14Days;

  /// No description provided for @period30Days.
  ///
  /// In en, this message translates to:
  /// **'30 d'**
  String get period30Days;

  /// No description provided for @period90Days.
  ///
  /// In en, this message translates to:
  /// **'90 d'**
  String get period90Days;

  /// No description provided for @periodCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get periodCustom;

  /// No description provided for @timeSlotChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Time slot'**
  String get timeSlotChartTitle;

  /// No description provided for @timeSlotChartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Time slot trend'**
  String get timeSlotChartEmptyTitle;

  /// No description provided for @timeSlotChartHint.
  ///
  /// In en, this message translates to:
  /// **'Collect more readings at a similar time of day to see this view.'**
  String get timeSlotChartHint;

  /// No description provided for @timeSlotSourceAuto.
  ///
  /// In en, this message translates to:
  /// **'auto-detected'**
  String get timeSlotSourceAuto;

  /// No description provided for @timeSlotSourcePinned.
  ///
  /// In en, this message translates to:
  /// **'pinned'**
  String get timeSlotSourcePinned;

  /// No description provided for @timeSlotHeader.
  ///
  /// In en, this message translates to:
  /// **'{range} · {hours} h · {source}'**
  String timeSlotHeader(String range, int hours, String source);

  /// No description provided for @timeSlotSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Time-slot settings'**
  String get timeSlotSettingsTooltip;

  /// No description provided for @timeSlotAutoToggle.
  ///
  /// In en, this message translates to:
  /// **'Choose slot automatically'**
  String get timeSlotAutoToggle;

  /// No description provided for @timeSlotSettingsLink.
  ///
  /// In en, this message translates to:
  /// **'Change width in Settings'**
  String get timeSlotSettingsLink;

  /// No description provided for @weightChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight trend'**
  String get weightChartTitle;

  /// No description provided for @overviewLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load overview'**
  String get overviewLoadErrorTitle;

  /// No description provided for @overviewLoadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get overviewLoadErrorBody;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No readings yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to add your first reading.'**
  String get historyEmptyBody;

  /// No description provided for @historyEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Add first reading'**
  String get historyEmptyAction;

  /// No description provided for @historyEntriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {1 entry} other {{count} entries}}'**
  String historyEntriesCount(int count);

  /// No description provided for @historyFilterAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get historyFilterAllTime;

  /// No description provided for @historyFilterRange.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String historyFilterRange(String from, String to);

  /// No description provided for @historyFilterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get historyFilterClear;

  /// No description provided for @historyLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load readings'**
  String get historyLoadErrorTitle;

  /// No description provided for @historyLoadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get historyLoadErrorBody;

  /// No description provided for @historyPulseLabel.
  ///
  /// In en, this message translates to:
  /// **'Pulse {count}'**
  String historyPulseLabel(int count);

  /// No description provided for @statisticsPeriodSummary.
  ///
  /// In en, this message translates to:
  /// **'{from} – {to}'**
  String statisticsPeriodSummary(String from, String to);

  /// No description provided for @statisticsKeyMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Key metrics'**
  String get statisticsKeyMetricsTitle;

  /// No description provided for @statisticsMetricLabel.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get statisticsMetricLabel;

  /// No description provided for @statisticsMetricAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get statisticsMetricAverage;

  /// No description provided for @statisticsMetricMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get statisticsMetricMin;

  /// No description provided for @statisticsMetricMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get statisticsMetricMax;

  /// No description provided for @statisticsMetricTrend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get statisticsMetricTrend;

  /// No description provided for @statisticsMetricEmptyValue.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get statisticsMetricEmptyValue;

  /// No description provided for @pulsePressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Pulse pressure'**
  String get pulsePressureLabel;

  /// No description provided for @meanArterialPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'MAP'**
  String get meanArterialPressureLabel;

  /// No description provided for @trendUp.
  ///
  /// In en, this message translates to:
  /// **'rising'**
  String get trendUp;

  /// No description provided for @trendDown.
  ///
  /// In en, this message translates to:
  /// **'falling'**
  String get trendDown;

  /// No description provided for @trendStable.
  ///
  /// In en, this message translates to:
  /// **'stable'**
  String get trendStable;

  /// No description provided for @trendUnknown.
  ///
  /// In en, this message translates to:
  /// **'no trend'**
  String get trendUnknown;

  /// No description provided for @statisticsClassificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Category distribution'**
  String get statisticsClassificationTitle;

  /// No description provided for @statisticsClassificationOpenStatus.
  ///
  /// In en, this message translates to:
  /// **'Open status view'**
  String get statisticsClassificationOpenStatus;

  /// No description provided for @statisticsBmiTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get statisticsBmiTitle;

  /// No description provided for @statisticsBmiCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get statisticsBmiCurrent;

  /// No description provided for @statisticsBmiAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get statisticsBmiAverage;

  /// No description provided for @statisticsBmiHelper.
  ///
  /// In en, this message translates to:
  /// **'Calculated from your profile height and the latest in-period weight.'**
  String get statisticsBmiHelper;

  /// No description provided for @statisticsBmiProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your height'**
  String get statisticsBmiProfileTitle;

  /// No description provided for @statisticsBmiProfileLink.
  ///
  /// In en, this message translates to:
  /// **'Set height in profile to calculate BMI.'**
  String get statisticsBmiProfileLink;

  /// No description provided for @statisticsInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get statisticsInsightsTitle;

  /// No description provided for @statisticsLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load statistics'**
  String get statisticsLoadErrorTitle;

  /// No description provided for @statisticsLoadErrorBody.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get statisticsLoadErrorBody;

  /// No description provided for @statusDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Category distribution'**
  String get statusDistributionTitle;

  /// No description provided for @statusDistributionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No readings in this period.'**
  String get statusDistributionEmpty;

  /// No description provided for @statusExplanationTitle.
  ///
  /// In en, this message translates to:
  /// **'What do the categories mean?'**
  String get statusExplanationTitle;

  /// No description provided for @statusExplanationIntro.
  ///
  /// In en, this message translates to:
  /// **'Thresholds follow common office-measurement ranges. They are descriptive guides, not diagnoses.'**
  String get statusExplanationIntro;

  /// No description provided for @statusCategoryThresholdHypotension.
  ///
  /// In en, this message translates to:
  /// **'Systolic < 90 or diastolic < 60'**
  String get statusCategoryThresholdHypotension;

  /// No description provided for @statusCategoryThresholdOptimal.
  ///
  /// In en, this message translates to:
  /// **'Systolic < 120 and diastolic < 80'**
  String get statusCategoryThresholdOptimal;

  /// No description provided for @statusCategoryThresholdNormal.
  ///
  /// In en, this message translates to:
  /// **'Systolic 120–129 and/or diastolic 80–84'**
  String get statusCategoryThresholdNormal;

  /// No description provided for @statusCategoryThresholdHighNormal.
  ///
  /// In en, this message translates to:
  /// **'Systolic 130–139 and/or diastolic 85–89'**
  String get statusCategoryThresholdHighNormal;

  /// No description provided for @statusCategoryThresholdHypertensionGrade1.
  ///
  /// In en, this message translates to:
  /// **'Systolic 140–159 and/or diastolic 90–99'**
  String get statusCategoryThresholdHypertensionGrade1;

  /// No description provided for @statusCategoryThresholdHypertensionGrade2.
  ///
  /// In en, this message translates to:
  /// **'Systolic 160–179 and/or diastolic 100–109'**
  String get statusCategoryThresholdHypertensionGrade2;

  /// No description provided for @statusCategoryThresholdHypertensionGrade3.
  ///
  /// In en, this message translates to:
  /// **'Systolic ≥ 180 or diastolic ≥ 110'**
  String get statusCategoryThresholdHypertensionGrade3;

  /// No description provided for @statusCategoryThresholdIsolatedSystolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic ≥ 140 and diastolic < 90'**
  String get statusCategoryThresholdIsolatedSystolic;

  /// No description provided for @categoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String categoryCount(int count);

  /// No description provided for @insightNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No insights yet'**
  String get insightNoDataTitle;

  /// No description provided for @insightNoDataBody.
  ///
  /// In en, this message translates to:
  /// **'Record a few readings to see insights here.'**
  String get insightNoDataBody;

  /// No description provided for @insightFewEntriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Few entries this period'**
  String get insightFewEntriesTitle;

  /// No description provided for @insightFewEntriesBody.
  ///
  /// In en, this message translates to:
  /// **'Add more readings for a clearer picture.'**
  String get insightFewEntriesBody;

  /// No description provided for @insightMeasureMoreOftenTitle.
  ///
  /// In en, this message translates to:
  /// **'Measure more often'**
  String get insightMeasureMoreOftenTitle;

  /// No description provided for @insightMeasureMoreOftenBody.
  ///
  /// In en, this message translates to:
  /// **'Aim for several readings each week.'**
  String get insightMeasureMoreOftenBody;

  /// No description provided for @insightBpRisingTitle.
  ///
  /// In en, this message translates to:
  /// **'Trend is rising'**
  String get insightBpRisingTitle;

  /// No description provided for @insightBpRisingBody.
  ///
  /// In en, this message translates to:
  /// **'Recent readings have been higher than earlier in the period.'**
  String get insightBpRisingBody;

  /// No description provided for @insightBpFallingTitle.
  ///
  /// In en, this message translates to:
  /// **'Trend is falling'**
  String get insightBpFallingTitle;

  /// No description provided for @insightBpFallingBody.
  ///
  /// In en, this message translates to:
  /// **'Recent readings have been lower than earlier in the period.'**
  String get insightBpFallingBody;

  /// No description provided for @insightFrequentlyElevatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Often above the normal range'**
  String get insightFrequentlyElevatedTitle;

  /// No description provided for @insightFrequentlyElevatedBody.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} readings landed in elevated categories.'**
  String insightFrequentlyElevatedBody(Object count, Object total);

  /// No description provided for @insightFrequentlyLowTitle.
  ///
  /// In en, this message translates to:
  /// **'Often below the normal range'**
  String get insightFrequentlyLowTitle;

  /// No description provided for @insightFrequentlyLowBody.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} readings were low.'**
  String insightFrequentlyLowBody(Object count, Object total);

  /// No description provided for @insightWellDocumentedTitle.
  ///
  /// In en, this message translates to:
  /// **'Well documented'**
  String get insightWellDocumentedTitle;

  /// No description provided for @insightWellDocumentedBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re recording regularly. Keep it up.'**
  String get insightWellDocumentedBody;

  /// No description provided for @csvColumnDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get csvColumnDate;

  /// No description provided for @csvColumnTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get csvColumnTime;

  /// No description provided for @csvColumnSystolic.
  ///
  /// In en, this message translates to:
  /// **'Systolic'**
  String get csvColumnSystolic;

  /// No description provided for @csvColumnDiastolic.
  ///
  /// In en, this message translates to:
  /// **'Diastolic'**
  String get csvColumnDiastolic;

  /// No description provided for @csvColumnPulse.
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get csvColumnPulse;

  /// No description provided for @csvColumnPulsePressure.
  ///
  /// In en, this message translates to:
  /// **'PulsePressure'**
  String get csvColumnPulsePressure;

  /// No description provided for @csvColumnMap.
  ///
  /// In en, this message translates to:
  /// **'MAP'**
  String get csvColumnMap;

  /// No description provided for @csvColumnWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight_kg'**
  String get csvColumnWeightKg;

  /// No description provided for @csvColumnNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get csvColumnNote;

  /// No description provided for @csvColumnCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get csvColumnCategory;

  /// No description provided for @csvColumnSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get csvColumnSource;

  /// No description provided for @exportFormatCsv.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get exportFormatCsv;

  /// No description provided for @exportFormatPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get exportFormatPdf;

  /// No description provided for @exportFormatLabel.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get exportFormatLabel;

  /// No description provided for @exportPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get exportPeriodLabel;

  /// No description provided for @exportIncludeContextFields.
  ///
  /// In en, this message translates to:
  /// **'Include context fields'**
  String get exportIncludeContextFields;

  /// No description provided for @exportIncludeChartImage.
  ///
  /// In en, this message translates to:
  /// **'Include chart image'**
  String get exportIncludeChartImage;

  /// No description provided for @exportGenerateAction.
  ///
  /// In en, this message translates to:
  /// **'Generate and share'**
  String get exportGenerateAction;

  /// No description provided for @exportGeneratingMessage.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get exportGeneratingMessage;

  /// No description provided for @exportSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Export saved.'**
  String get exportSavedMessage;

  /// No description provided for @exportHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent exports'**
  String get exportHistoryTitle;

  /// No description provided for @exportHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exports yet.'**
  String get exportHistoryEmpty;

  /// No description provided for @exportDeleteRecordTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete export?'**
  String get exportDeleteRecordTitle;

  /// No description provided for @exportDeleteRecordBody.
  ///
  /// In en, this message translates to:
  /// **'Delete this export file from the recents list.'**
  String get exportDeleteRecordBody;

  /// No description provided for @pdfReportHeader.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure report'**
  String get pdfReportHeader;

  /// No description provided for @pdfGeneratedAt.
  ///
  /// In en, this message translates to:
  /// **'Generated {timestamp}'**
  String pdfGeneratedAt(String timestamp);

  /// No description provided for @pdfSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get pdfSummaryTitle;

  /// No description provided for @pdfReadingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get pdfReadingsTitle;

  /// No description provided for @pdfDisclaimerFooter.
  ///
  /// In en, this message translates to:
  /// **'This report does not replace medical advice.'**
  String get pdfDisclaimerFooter;

  /// No description provided for @pdfChartUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Chart image not included in this build.'**
  String get pdfChartUnavailable;

  /// No description provided for @reminderNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure reading'**
  String get reminderNotificationTitle;

  /// No description provided for @reminderNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Time to record a measurement.'**
  String get reminderNotificationBody;

  /// No description provided for @remindersMasterToggle.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get remindersMasterToggle;

  /// No description provided for @remindersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No reminders yet'**
  String get remindersEmptyTitle;

  /// No description provided for @remindersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a reminder to get a gentle nudge each day.'**
  String get remindersEmptyBody;

  /// No description provided for @remindersAddAction.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get remindersAddAction;

  /// No description provided for @reminderEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get reminderEditTitle;

  /// No description provided for @reminderAddTitle.
  ///
  /// In en, this message translates to:
  /// **'New reminder'**
  String get reminderAddTitle;

  /// No description provided for @reminderTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get reminderTimeLabel;

  /// No description provided for @reminderWeekdaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get reminderWeekdaysLabel;

  /// No description provided for @reminderEveryDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get reminderEveryDay;

  /// No description provided for @reminderLabelLabel.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get reminderLabelLabel;

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was not granted.'**
  String get reminderPermissionDenied;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @settingsGroupProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsGroupProfile;

  /// No description provided for @settingsGroupAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsGroupAppearance;

  /// No description provided for @settingsGroupUnits.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsGroupUnits;

  /// No description provided for @settingsGroupTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Time slot'**
  String get settingsGroupTimeSlot;

  /// No description provided for @settingsGroupReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsGroupReminders;

  /// No description provided for @settingsGroupData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsGroupData;

  /// No description provided for @settingsGroupPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsGroupPrivacy;

  /// No description provided for @settingsGroupIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get settingsGroupIntegrations;

  /// No description provided for @settingsGroupAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsGroupAbout;

  /// No description provided for @settingsHeightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get settingsHeightLabel;

  /// No description provided for @settingsHeightHint.
  ///
  /// In en, this message translates to:
  /// **'Used for the BMI calculation.'**
  String get settingsHeightHint;

  /// No description provided for @settingsHeightSuffix.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get settingsHeightSuffix;

  /// No description provided for @settingsHeightOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 80 and 250.'**
  String get settingsHeightOutOfRange;

  /// No description provided for @settingsHeightInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a number.'**
  String get settingsHeightInvalid;

  /// No description provided for @settingsHeightSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsHeightSaveAction;

  /// No description provided for @settingsHeightClearAction.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get settingsHeightClearAction;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeLabel;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsWeightUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight unit'**
  String get settingsWeightUnitLabel;

  /// No description provided for @settingsWeightUnitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get settingsWeightUnitKg;

  /// No description provided for @settingsWeightUnitLb.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get settingsWeightUnitLb;

  /// No description provided for @settingsSlotWidthLabel.
  ///
  /// In en, this message translates to:
  /// **'Slot width'**
  String get settingsSlotWidthLabel;

  /// No description provided for @settingsSlotWidth1h.
  ///
  /// In en, this message translates to:
  /// **'1 h'**
  String get settingsSlotWidth1h;

  /// No description provided for @settingsSlotWidth2h.
  ///
  /// In en, this message translates to:
  /// **'2 h'**
  String get settingsSlotWidth2h;

  /// No description provided for @settingsSlotWidth3h.
  ///
  /// In en, this message translates to:
  /// **'3 h'**
  String get settingsSlotWidth3h;

  /// No description provided for @settingsSlotAutoToggle.
  ///
  /// In en, this message translates to:
  /// **'Choose slot automatically'**
  String get settingsSlotAutoToggle;

  /// No description provided for @settingsSlotStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Pinned slot start'**
  String get settingsSlotStartLabel;

  /// No description provided for @settingsSlotStartUnset.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsSlotStartUnset;

  /// No description provided for @settingsRemindersOpen.
  ///
  /// In en, this message translates to:
  /// **'Open reminder settings'**
  String get settingsRemindersOpen;

  /// No description provided for @settingsExportOpen.
  ///
  /// In en, this message translates to:
  /// **'Open export'**
  String get settingsExportOpen;

  /// No description provided for @settingsDeleteAllAction.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get settingsDeleteAllAction;

  /// No description provided for @settingsDeleteAllConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get settingsDeleteAllConfirmTitle;

  /// No description provided for @settingsDeleteAllConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'All readings, reminders, and exports will be removed. This cannot be undone.'**
  String get settingsDeleteAllConfirmBody;

  /// No description provided for @settingsDeleteAllConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get settingsDeleteAllConfirmAction;

  /// No description provided for @settingsDeleteAllSecondTitle.
  ///
  /// In en, this message translates to:
  /// **'Last chance'**
  String get settingsDeleteAllSecondTitle;

  /// No description provided for @settingsDeleteAllSecondBody.
  ///
  /// In en, this message translates to:
  /// **'Type DELETE to confirm.'**
  String get settingsDeleteAllSecondBody;

  /// No description provided for @settingsDeleteAllChallenge.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get settingsDeleteAllChallenge;

  /// No description provided for @settingsDeleteAllCompleted.
  ///
  /// In en, this message translates to:
  /// **'All data deleted.'**
  String get settingsDeleteAllCompleted;

  /// No description provided for @settingsPrivacyOpen.
  ///
  /// In en, this message translates to:
  /// **'Open privacy info'**
  String get settingsPrivacyOpen;

  /// No description provided for @settingsIntegrationsHealthConnect.
  ///
  /// In en, this message translates to:
  /// **'Health Connect / HealthKit'**
  String get settingsIntegrationsHealthConnect;

  /// No description provided for @settingsIntegrationsFitbit.
  ///
  /// In en, this message translates to:
  /// **'Fitbit / Google Health'**
  String get settingsIntegrationsFitbit;

  /// No description provided for @settingsIntegrationsLlm.
  ///
  /// In en, this message translates to:
  /// **'AI insights (LLM)'**
  String get settingsIntegrationsLlm;

  /// No description provided for @settingsIntegrationsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get settingsIntegrationsComingSoon;

  /// No description provided for @settingsAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsAboutVersion;

  /// No description provided for @settingsAboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get settingsAboutLicenses;

  /// No description provided for @settingsAboutAppVersion.
  ///
  /// In en, this message translates to:
  /// **'0.1.0+1'**
  String get settingsAboutAppVersion;

  /// No description provided for @privacyResetDisclaimerAction.
  ///
  /// In en, this message translates to:
  /// **'Show disclaimer again'**
  String get privacyResetDisclaimerAction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
