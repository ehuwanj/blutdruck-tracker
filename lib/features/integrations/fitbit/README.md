# Fitbit / Google Health Integration (Disabled)

The MVP ships only the `DisabledFitbitGateway`:
- `isAvailable()` returns `false`.
- `connect()`, `disconnect()`, and `readFitnessSummary()` throw
  `UnsupportedError`.

This gateway is read-only fitness/sleep context for enriching the
blood-pressure view (sleep duration alongside morning systolic, etc.).
It is **not** a blood-pressure source.

To enable in a future iteration, follow
[docs/specs/10-future-integrations.md §Fitbit gateway](../../../../docs/specs/10-future-integrations.md):

1. Use OAuth 2.0 with PKCE. **Do not** embed the Fitbit client secret in
   the mobile binary — either use the no-secret PKCE flow or route the
   token exchange through a small proxy backend that holds the secret.
2. Store `access_token`, `refresh_token`, and expiry in
   `flutter_secure_storage` only. Never in the SQLite DB, never in logs.
3. Show a consent screen before starting OAuth that explains: scopes
   requested, that no Fitbit data is written, that disconnect deletes
   cached data, that this is a read-only enrichment feature.
4. Request minimum scopes: typically `sleep`, `heartrate`, `activity`.
5. Replace the Riverpod binding for `fitbitGatewayProvider` in
   `lib/app/providers.dart` with the concrete implementation.
6. Surface neutral, descriptive observations only — no causal claims,
   no diagnoses, no behaviour prescriptions.
7. Disconnect must revoke the token with Fitbit and delete cached data.

No real Fitbit URLs, client IDs, or PKCE code paths exist in this
codebase today. Adding them is part of enabling the gateway.
