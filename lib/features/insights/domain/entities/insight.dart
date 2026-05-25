import 'package:blutdruck_tracker/features/insights/domain/entities/insight_severity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insight.freezed.dart';

/// One short, neutral observation surfaced in the Statistics insights card.
/// Phrasing is held in ARB and supplied by the engine at generation time;
/// this type carries already-localized [title] and [body].
@freezed
class Insight with _$Insight {
  const factory Insight({
    required String id,
    required InsightSeverity severity,
    required String title,
    required String body,
    DateTime? generatedAt,
  }) = _Insight;
}
