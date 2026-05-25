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

  @override
  String get historyEmptyTitle => '暂无记录';

  @override
  String get historyEmptyBody => '点击 + 添加第一条记录。';

  @override
  String get historyEmptyAction => '添加第一条记录';

  @override
  String historyEntriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条记录',
    );
    return '$_temp0';
  }

  @override
  String get historyFilterAllTime => '全部时间';

  @override
  String historyFilterRange(String from, String to) {
    return '$from – $to';
  }

  @override
  String get historyFilterClear => '清除筛选';

  @override
  String get historyLoadErrorTitle => '无法加载记录';

  @override
  String get historyLoadErrorBody => '请重试。';

  @override
  String historyPulseLabel(int count) {
    return '脉搏 $count';
  }

  @override
  String statisticsPeriodSummary(String from, String to) {
    return '$from – $to';
  }

  @override
  String get statisticsKeyMetricsTitle => '关键指标';

  @override
  String get statisticsMetricLabel => '指标';

  @override
  String get statisticsMetricAverage => '平均';

  @override
  String get statisticsMetricMin => '最小';

  @override
  String get statisticsMetricMax => '最大';

  @override
  String get statisticsMetricTrend => '趋势';

  @override
  String get statisticsMetricEmptyValue => '—';

  @override
  String get pulsePressureLabel => '脉压';

  @override
  String get meanArterialPressureLabel => '平均动脉压';

  @override
  String get trendUp => '上升';

  @override
  String get trendDown => '下降';

  @override
  String get trendStable => '稳定';

  @override
  String get trendUnknown => '无趋势';

  @override
  String get statisticsClassificationTitle => '分类分布';

  @override
  String get statisticsClassificationOpenStatus => '打开状态视图';

  @override
  String get statisticsBmiTitle => 'BMI';

  @override
  String get statisticsBmiCurrent => '当前';

  @override
  String get statisticsBmiAverage => '平均';

  @override
  String get statisticsBmiHelper => '根据您的身高和该时段内最新的体重计算。';

  @override
  String get statisticsBmiProfileTitle => '添加身高';

  @override
  String get statisticsBmiProfileLink => '在个人资料中填写身高以计算 BMI。';

  @override
  String get statisticsInsightsTitle => '提示';

  @override
  String get statisticsLoadErrorTitle => '无法加载统计';

  @override
  String get statisticsLoadErrorBody => '请重试。';

  @override
  String get statusDistributionTitle => '分类分布';

  @override
  String get statusDistributionEmpty => '此时间段没有记录。';

  @override
  String get statusExplanationTitle => '各分类的含义';

  @override
  String get statusExplanationIntro => '阈值基于常见的门诊测量参考。它们是描述性的指引，不是诊断。';

  @override
  String get statusCategoryThresholdHypotension => '收缩压 < 90 或舒张压 < 60';

  @override
  String get statusCategoryThresholdOptimal => '收缩压 < 120 且舒张压 < 80';

  @override
  String get statusCategoryThresholdNormal => '收缩压 120–129 且/或舒张压 80–84';

  @override
  String get statusCategoryThresholdHighNormal => '收缩压 130–139 且/或舒张压 85–89';

  @override
  String get statusCategoryThresholdHypertensionGrade1 =>
      '收缩压 140–159 且/或舒张压 90–99';

  @override
  String get statusCategoryThresholdHypertensionGrade2 =>
      '收缩压 160–179 且/或舒张压 100–109';

  @override
  String get statusCategoryThresholdHypertensionGrade3 =>
      '收缩压 ≥ 180 或舒张压 ≥ 110';

  @override
  String get statusCategoryThresholdIsolatedSystolic => '收缩压 ≥ 140 且舒张压 < 90';

  @override
  String categoryCount(int count) {
    return '$count';
  }

  @override
  String get insightNoDataTitle => '暂无提示';

  @override
  String get insightNoDataBody => '记录几次测量后即可查看提示。';

  @override
  String get insightFewEntriesTitle => '本时段记录较少';

  @override
  String get insightFewEntriesBody => '增加记录可获得更清晰的视图。';

  @override
  String get insightMeasureMoreOftenTitle => '建议更频繁地测量';

  @override
  String get insightMeasureMoreOftenBody => '每周多次测量有助于看清趋势。';

  @override
  String get insightBpRisingTitle => '趋势上升';

  @override
  String get insightBpRisingBody => '近期测量值高于时段初期。';

  @override
  String get insightBpFallingTitle => '趋势下降';

  @override
  String get insightBpFallingBody => '近期测量值低于时段初期。';

  @override
  String get insightFrequentlyElevatedTitle => '经常高于正常范围';

  @override
  String insightFrequentlyElevatedBody(Object count, Object total) {
    return '共 $total 次记录中，$count 次落在偏高分类。';
  }

  @override
  String get insightFrequentlyLowTitle => '经常低于正常范围';

  @override
  String insightFrequentlyLowBody(Object count, Object total) {
    return '共 $total 次记录中，$count 次偏低。';
  }

  @override
  String get insightWellDocumentedTitle => '记录良好';

  @override
  String get insightWellDocumentedBody => '您在规律地记录。请保持。';

  @override
  String get csvColumnDate => '日期';

  @override
  String get csvColumnTime => '时间';

  @override
  String get csvColumnSystolic => '收缩压';

  @override
  String get csvColumnDiastolic => '舒张压';

  @override
  String get csvColumnPulse => '脉搏';

  @override
  String get csvColumnPulsePressure => '脉压';

  @override
  String get csvColumnMap => 'MAP';

  @override
  String get csvColumnWeightKg => '体重_kg';

  @override
  String get csvColumnArm => '手臂';

  @override
  String get csvColumnStress => '压力';

  @override
  String get csvColumnMedication => '用药';

  @override
  String get csvColumnNote => '备注';

  @override
  String get csvColumnCategory => '分类';

  @override
  String get csvColumnSource => '来源';

  @override
  String get exportFormatCsv => 'CSV';

  @override
  String get exportFormatPdf => 'PDF';

  @override
  String get exportFormatLabel => '格式';

  @override
  String get exportPeriodLabel => '时间段';

  @override
  String get exportIncludeContextFields => '包含上下文字段';

  @override
  String get exportIncludeChartImage => '包含图表';

  @override
  String get exportGenerateAction => '生成并分享';

  @override
  String get exportGeneratingMessage => '正在生成…';

  @override
  String get exportSavedMessage => '导出已保存。';

  @override
  String get exportHistoryTitle => '最近的导出';

  @override
  String get exportHistoryEmpty => '暂无导出。';

  @override
  String get exportDeleteRecordTitle => '删除导出？';

  @override
  String get exportDeleteRecordBody => '从最近列表中移除此导出。';

  @override
  String get pdfReportHeader => '血压报告';

  @override
  String pdfGeneratedAt(String timestamp) {
    return '生成于 $timestamp';
  }

  @override
  String get pdfSummaryTitle => '摘要';

  @override
  String get pdfReadingsTitle => '记录';

  @override
  String get pdfDisclaimerFooter => '此报告不能替代医学建议。';

  @override
  String get pdfChartUnavailable => '此版本未包含图表图像。';

  @override
  String get reminderNotificationTitle => '血压测量';

  @override
  String get reminderNotificationBody => '该记录一次测量了。';

  @override
  String get remindersMasterToggle => '启用提醒';

  @override
  String get remindersEmptyTitle => '暂无提醒';

  @override
  String get remindersEmptyBody => '添加提醒后即可获得每天的轻柔提示。';

  @override
  String get remindersAddAction => '添加提醒';

  @override
  String get reminderEditTitle => '编辑提醒';

  @override
  String get reminderAddTitle => '新建提醒';

  @override
  String get reminderTimeLabel => '时间';

  @override
  String get reminderWeekdaysLabel => '星期';

  @override
  String get reminderEveryDay => '每天';

  @override
  String get reminderLabelLabel => '标签（可选）';

  @override
  String get reminderPermissionDenied => '未授予通知权限。';

  @override
  String get weekdayMon => '一';

  @override
  String get weekdayTue => '二';

  @override
  String get weekdayWed => '三';

  @override
  String get weekdayThu => '四';

  @override
  String get weekdayFri => '五';

  @override
  String get weekdaySat => '六';

  @override
  String get weekdaySun => '日';
}
