import 'package:blutdruck_tracker/features/insights/domain/entities/insight.dart';
import 'package:blutdruck_tracker/features/statistics/domain/entities/statistics_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insight_prompt_data.freezed.dart';

/// Input bundle for the future LLM gateway. Carries aggregates only —
/// never raw rows — so an enabled LLM build still meets the privacy
/// rules in docs/specs/12-privacy-and-medical.md.
///
/// `localeName` is a plain string (e.g. `en`, `de`, `zh`) so this entity
/// stays free of `dart:ui` / Flutter imports; the gateway impl converts
/// to a real `Locale` when constructing the request.
@freezed
class InsightPromptData with _$InsightPromptData {
  const factory InsightPromptData({
    required DateTime from,
    required DateTime to,
    required StatisticsResult stats,
    required String localeName,
    @Default(<Insight>[]) List<Insight> ruleBasedInsights,
  }) = _InsightPromptData;
}
