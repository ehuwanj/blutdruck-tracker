import 'package:blutdruck_tracker/features/insights/domain/entities/insight_prompt_data.dart';
import 'package:blutdruck_tracker/features/integrations/llm/domain/llm_gateway.dart';

/// MVP-default [LlmGateway]: every method throws `UnsupportedError` so
/// it's impossible to accidentally call out to a network in this build.
/// See docs/specs/10-future-integrations.md.
class DisabledLlmGateway implements LlmGateway {
  const DisabledLlmGateway();

  @override
  Future<String> generateInsightSummary({
    required InsightPromptData data,
  }) async {
    throw UnsupportedError('Online LLM is disabled in this build.');
  }
}
