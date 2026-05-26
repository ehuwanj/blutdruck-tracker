# LLM Integration (Disabled)

The MVP ships only the `DisabledLlmGateway`. Every method throws
`UnsupportedError` so no remote call is possible in this build.

To enable in a future iteration, follow
[docs/specs/10-future-integrations.md §LLM gateway](../../../../docs/specs/10-future-integrations.md):

1. Stand up a small proxy backend that holds the provider API key.
2. Add an opt-in consent screen that documents exactly what is sent
   (only `StatisticsResult` aggregates + rule-based `Insight` items —
   never raw rows).
3. Replace the `DisabledLlmGateway` Riverpod binding in
   `lib/app/providers.dart` with the concrete proxy-client implementation.
4. Persist responses in the (reserved) `insight_cache` table; clear on
   data deletion.
5. Honour the no-diagnosis / no-treatment-advice rules in
   `docs/specs/12-privacy-and-medical.md`.

No real provider URLs, client IDs, or endpoints are present in this
codebase. Adding them is part of enabling the gateway, not part of the
MVP.
