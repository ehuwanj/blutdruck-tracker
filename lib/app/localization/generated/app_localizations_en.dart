// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Blutdruck Tracker';

  @override
  String get disclaimerTitle => 'Important notice';

  @override
  String get disclaimerBody =>
      'This app is for personal tracking and informational purposes only. It is not a medical device and does not provide diagnosis, treatment, or medical advice. Please consult a qualified healthcare professional for medical decisions.';

  @override
  String get disclaimerAccept => 'I understand';
}
