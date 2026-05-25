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
  String get overviewTitle => '概览';

  @override
  String get historyTitle => '历史';

  @override
  String get statisticsTitle => '统计';

  @override
  String get statusTitle => '状态';

  @override
  String get exportTitle => '导出';

  @override
  String get settingsTitle => '设置';

  @override
  String get remindersTitle => '提醒';

  @override
  String get privacyTitle => '隐私说明';

  @override
  String get addReadingTitle => '添加记录';

  @override
  String get editReadingTitle => '编辑记录';

  @override
  String get saveButton => '保存';

  @override
  String get cancelButton => '取消';

  @override
  String get deleteButton => '删除';

  @override
  String get confirmButton => '确认';

  @override
  String get languageSystem => '系统';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageChinese => '中文';

  @override
  String get categoryHypotension => '低血压';

  @override
  String get categoryOptimal => '理想';

  @override
  String get categoryNormal => '正常';

  @override
  String get categoryHighNormal => '正常偏高';

  @override
  String get categoryHypertensionGrade1 => '高血压 1 级';

  @override
  String get categoryHypertensionGrade2 => '高血压 2 级';

  @override
  String get categoryHypertensionGrade3 => '高血压 3 级';

  @override
  String get categoryIsolatedSystolic => '单纯收缩期高血压';

  @override
  String get bmiUnderweight => '偏瘦';

  @override
  String get bmiNormal => '正常';

  @override
  String get bmiOverweight => '超重';

  @override
  String get bmiObese => '肥胖';

  @override
  String get disclaimerTitle => '重要提示';

  @override
  String get disclaimerBody =>
      '此应用仅用于个人记录和信息参考。它不是医疗器械，不提供诊断、治疗或医疗建议。医疗决定请咨询合格的医疗专业人员。';

  @override
  String get disclaimerAccept => '明白了';

  @override
  String get measuredAtLabel => '日期和时间';

  @override
  String get systolicLabel => '收缩压';

  @override
  String get diastolicLabel => '舒张压';

  @override
  String get pulseLabel => '脉搏';

  @override
  String get weightLabel => '体重';

  @override
  String get armLabel => '测量手臂';

  @override
  String get armLeftLabel => '左';

  @override
  String get armRightLabel => '右';

  @override
  String get unspecifiedLabel => '未指定';

  @override
  String get stressLevelLabel => '压力等级';

  @override
  String get medicationNoteLabel => '用药备注';

  @override
  String get noteLabel => '备注';

  @override
  String get validationRange => '该值超出输入范围，请检查。';

  @override
  String get validationSystolicDiastolic => '收缩压通常应高于舒张压。';

  @override
  String get validationNoteTooLong => '备注过长。';

  @override
  String get validationMedicationTooLong => '用药备注过长。';

  @override
  String get validationFutureDate => '测量时间过于靠后。';

  @override
  String get readingSavedMessage => '已保存';

  @override
  String get formLoadErrorTitle => '无法加载记录';

  @override
  String get formLoadErrorBody => '请重试。';

  @override
  String get deleteReadingTitle => '删除记录';

  @override
  String get deleteReadingBody => '删除这条记录？';

  @override
  String get overviewTabHistory => '历史';

  @override
  String get overviewTabStatistics => '统计';

  @override
  String get overviewTabStatus => '状态';

  @override
  String get latestReadingTitle => '最新记录';

  @override
  String get latestReadingEmptyTitle => '暂无记录';

  @override
  String get latestReadingEmptyBody => '添加第一条记录后即可查看趋势。';

  @override
  String get latestReadingEmptyAction => '添加第一条记录';

  @override
  String latestReadingSemanticLabel(
    int systolic,
    int diastolic,
    int pulse,
    String category,
    String relativeTime,
  ) {
    return '最新记录：$systolic 比 $diastolic，脉搏 $pulse，分类 $category，$relativeTime';
  }

  @override
  String get relativeTimeNow => '刚刚';

  @override
  String relativeTimeMinutes(int count) {
    return '$count 分钟前';
  }

  @override
  String relativeTimeHours(int count) {
    return '$count 小时前';
  }

  @override
  String relativeTimeDays(int count) {
    return '$count 天前';
  }

  @override
  String get bloodPressureChartTitle => '血压趋势';

  @override
  String get chartEmptyTitle => '此时间段没有记录';

  @override
  String get chartEmptyBody => '请选择其他时间段或添加新记录。';

  @override
  String get period7Days => '7 天';

  @override
  String get period14Days => '14 天';

  @override
  String get period30Days => '30 天';

  @override
  String get period90Days => '90 天';

  @override
  String get periodCustom => '自定义';

  @override
  String get timeSlotChartTitle => '时间窗口';

  @override
  String get timeSlotChartEmptyTitle => '时间窗口趋势';

  @override
  String get timeSlotChartHint => '在相近的每天时间记录更多测量后，即可查看此视图。';

  @override
  String get timeSlotSourceAuto => '自动识别';

  @override
  String get timeSlotSourcePinned => '已固定';

  @override
  String timeSlotHeader(String range, int hours, String source) {
    return '$range · $hours 小时 · $source';
  }

  @override
  String get timeSlotSettingsTooltip => '时间窗口设置';

  @override
  String get timeSlotAutoToggle => '自动选择时间窗口';

  @override
  String get timeSlotSettingsLink => '在设置中更改宽度';

  @override
  String get weightChartTitle => '体重趋势';

  @override
  String get overviewLoadErrorTitle => '无法加载概览';

  @override
  String get overviewLoadErrorBody => '请重试。';
}
