// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '血压记录';

  @override
  String get disclaimerTitle => '重要提示';

  @override
  String get disclaimerBody =>
      '本应用仅用于个人记录和信息参考。它不是医疗设备，不提供诊断、治疗或医疗建议。如有医学问题，请咨询合格的医疗专业人员。';

  @override
  String get disclaimerAccept => '我明白了';
}
