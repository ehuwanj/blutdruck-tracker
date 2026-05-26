# Health Connect / HealthKit Integration (Disabled)

The MVP ships only the `DisabledHealthDataGateway`:
- `isAvailable()` returns `false`.
- Every mutating method throws `UnsupportedError`.

Manual entry continues to work regardless of this gateway's state.

To enable in a future iteration, follow
[docs/specs/10-future-integrations.md §Health gateway](../../../../docs/specs/10-future-integrations.md):

1. Add the chosen plugin (`health` package or equivalent) to
   `pubspec.yaml`. Document the new dependency in the PR description.
2. Show a consent card before requesting permissions; ask only for what
   the feature reads/writes (blood pressure for the MVP+).
3. Replace the Riverpod binding for `healthGatewayProvider` in
   `lib/app/providers.dart` with the concrete implementation.
4. Store imported readings locally with `ReadingSource.healthConnect`;
   never depend on the gateway for the live data path.
5. Add platform-specific manual QA checklists when enabling.
6. Handle "permission denied" and "no data available" gracefully; never
   crash, never nag the user.

No real plugin imports or platform permissions live in this codebase
today. Adding them is part of enabling the gateway, not part of the MVP.
