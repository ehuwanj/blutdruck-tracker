import 'package:blutdruck_tracker/features/insights/domain/entities/insight_prompt_data.dart';

/// Future LLM gateway. The MVP ships only the `DisabledLlmGateway`
/// implementation, which throws `UnsupportedError` from every method.
/// See docs/specs/10-future-integrations.md for the binding rules an
/// enabled implementation must follow (proxy backend, no provider keys
/// in the mobile app, opt-in consent, no diagnoses).
///
/// Kept as an abstract interface (not a typedef) so tests can swap in a
/// mock without standing up a proxy backend.
// ignore: one_member_abstracts
abstract class LlmGateway {
  /// Returns a short, user-readable summary of the supplied prompt data.
  /// Implementations must accept aggregates only — never raw readings.
  Future<String> generateInsightSummary({required InsightPromptData data});
}
