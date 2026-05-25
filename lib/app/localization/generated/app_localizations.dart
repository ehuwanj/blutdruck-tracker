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
  /// **'Overview'**
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
  /// **'Add reading'**
  String get addReadingTitle;

  /// No description provided for @editReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit reading'**
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

  /// No description provided for @armLabel.
  ///
  /// In en, this message translates to:
  /// **'Arm'**
  String get armLabel;

  /// No description provided for @armLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get armLeftLabel;

  /// No description provided for @armRightLabel.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get armRightLabel;

  /// No description provided for @unspecifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get unspecifiedLabel;

  /// No description provided for @stressLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Stress level'**
  String get stressLevelLabel;

  /// No description provided for @medicationNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Medication note'**
  String get medicationNoteLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
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

  /// No description provided for @validationMedicationTooLong.
  ///
  /// In en, this message translates to:
  /// **'The medication note is too long.'**
  String get validationMedicationTooLong;

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
  /// **'Latest reading'**
  String get latestReadingTitle;

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
