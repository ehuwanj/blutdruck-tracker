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
  String get disclaimerTitle => 'Wichtiger Hinweis';

  @override
  String get disclaimerBody =>
      'Diese App dient nur der persönlichen Dokumentation und Information. Sie ist kein Medizinprodukt und bietet keine Diagnose, Behandlung oder medizinische Beratung. Bitte wenden Sie sich bei medizinischen Fragen an qualifiziertes medizinisches Fachpersonal.';

  @override
  String get disclaimerAccept => 'Verstanden';
}
