# 10 — Future Integrations (Disabled in MVP)

The MVP must **not** make any remote API call and must **not** depend on
Health Connect (Android), HealthKit (iOS), or the Fitbit Web API. All three
extensions are anticipated, so the MVP ships clean interfaces and
**disabled** implementations so the codebase is ready when these features
are added.

These live under:

```
lib/features/integrations/health/    # on-device: Health Connect / HealthKit
lib/features/integrations/fitbit/    # cloud OAuth: Fitbit Web API ("Google Health")
lib/features/integrations/llm/       # cloud LLM via proxy backend
```

Each subfolder contains a `README.md` explaining its current status and
the work needed to enable it.

## LLM gateway

### Interface

```dart
// lib/features/integrations/llm/domain/llm_gateway.dart
abstract class LlmGateway {
  /// Returns a short, user-readable summary of the supplied insight prompt.
  /// Throws [UnsupportedError] when the gateway is disabled.
  Future<String> generateInsightSummary({
    required InsightPromptData data,
  });
}
```

```dart
// lib/features/insights/domain/entities/insight_prompt_data.dart
@freezed
class InsightPromptData with _$InsightPromptData {
  const factory InsightPromptData({
    required DateTime from,           // UTC
    required DateTime to,             // UTC
    required StatisticsResult stats,  // already aggregated; never raw rows
    @Default(<Insight>[]) List<Insight> ruleBasedInsights,
    required Locale locale,
  }) = _InsightPromptData;
}
```

### Disabled implementation

```dart
// lib/features/integrations/llm/data/disabled_llm_gateway.dart
class DisabledLlmGateway implements LlmGateway {
  @override
  Future<String> generateInsightSummary({
    required InsightPromptData data,
  }) async {
    throw UnsupportedError('Online LLM is disabled in this build.');
  }
}
```

Bound in Riverpod:

```dart
final llmGatewayProvider = Provider<LlmGateway>((ref) => DisabledLlmGateway());
```

### Rules for any future LLM work

- **No provider API keys in the mobile app.** A small proxy backend owns
  the key. The app calls the proxy.
- If a "developer build" with a user-provided API key is ever added,
  store the key only in `flutter_secure_storage`.
- The LLM feature must be **opt-in** with an explicit consent screen
  that explains what is sent.
- Never send raw rows by default. Send aggregates from
  `StatisticsResult` plus the rule-based insights.
- Never instruct the LLM to diagnose, prescribe, recommend treatment, or
  declare values "safe" or "unsafe".
- LLM responses are stored only in `insight_cache` after the user views
  them, and cleared on data deletion.

### Recommended future shape

```
Mobile app ──▶ LLM proxy backend ──▶ LLM provider API
```

Candidate hosts: Cloudflare Workers, Firebase Cloud Functions, Supabase
Edge Functions, AWS Lambda. Decision deferred until the feature is
actually scheduled.

## Health gateway (Health Connect / HealthKit)

### Interface

```dart
// lib/features/integrations/health/domain/health_data_gateway.dart
abstract class HealthDataGateway {
  Future<bool> isAvailable();
  Future<void> requestPermissions();
  Future<void> writeBloodPressureReading(BloodPressureReading reading);
  Future<List<BloodPressureReading>> readBloodPressureReadings({
    required DateTime fromUtc,
    required DateTime toUtc,
  });
}
```

### Disabled implementation

```dart
// lib/features/integrations/health/data/disabled_health_data_gateway.dart
class DisabledHealthDataGateway implements HealthDataGateway {
  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<void> requestPermissions() async =>
      throw UnsupportedError('Health integration is disabled in this build.');

  @override
  Future<void> writeBloodPressureReading(BloodPressureReading reading) async =>
      throw UnsupportedError('Health integration is disabled in this build.');

  @override
  Future<List<BloodPressureReading>> readBloodPressureReadings({
    required DateTime fromUtc,
    required DateTime toUtc,
  }) async =>
      throw UnsupportedError('Health integration is disabled in this build.');
}
```

Bound in Riverpod:

```dart
final healthGatewayProvider =
    Provider<HealthDataGateway>((ref) => DisabledHealthDataGateway());
```

### Rules for any future Health work

- Manual entry must **always** continue to work, regardless of
  Health Connect/HealthKit state.
- Ask only for the permissions actually needed (blood pressure read and,
  optionally, write).
- Show a small explanation card before requesting permissions and
  document precisely what is read/written.
- Handle "permission denied" and "no data available" gracefully; never
  crash, never nag.
- Treat the integration as a **source of additional readings**, not as a
  replacement for the local DB. Imported readings are stored locally
  with `ReadingSource.healthConnect` / `healthKit`.
- Add platform-specific manual QA checklists when enabling.

## Fitbit / Google Health gateway

"Fitbit / Google Health" refers to the **Fitbit Web API** at
`api.fitbit.com`. The Fitbit app is now part of Google's health portfolio;
the data source for this integration is the user's Fitbit account, into
which a Fitbit watch or tracker syncs sleep, activity, and heart-rate data.

This is **distinct** from on-device Health Connect / HealthKit and lives in
its own gateway. It is a **read-only** cloud integration used to enrich the
view of blood pressure data with lifestyle context (e.g., displaying
overnight sleep duration next to morning systolic). It does **not** read or
write blood pressure values.

### Interface

```dart
// lib/features/integrations/fitbit/domain/fitbit_gateway.dart
abstract class FitbitGateway {
  Future<bool> isAvailable();

  /// Starts the OAuth 2.0 PKCE flow. Resolves when the user has either
  /// consented or aborted. Throws on misconfiguration.
  Future<void> connect();

  /// Revokes the access token with Fitbit and clears any cached data.
  Future<void> disconnect();

  /// Returns a per-day aggregate. Network and parsing errors surface as
  /// typed failures; never partial data without indication.
  Future<FitnessSummary> readFitnessSummary({
    required DateTime fromUtc,
    required DateTime toUtc,
  });
}
```

```dart
// lib/features/integrations/fitbit/domain/fitness_summary.dart
@freezed
class DailyFitness with _$DailyFitness {
  const factory DailyFitness({
    required DateTime date,         // local 00:00 of that day
    Duration? sleepDuration,
    int? sleepScore,                // 0..100 if Fitbit returns it
    int? restingHeartRate,          // bpm
    int? steps,
    int? activeMinutes,
  }) = _DailyFitness;
}

@freezed
class FitnessSummary with _$FitnessSummary {
  const factory FitnessSummary({
    required List<DailyFitness> days,
  }) = _FitnessSummary;
}
```

### Disabled implementation

```dart
// lib/features/integrations/fitbit/data/disabled_fitbit_gateway.dart
class DisabledFitbitGateway implements FitbitGateway {
  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<void> connect() async =>
      throw UnsupportedError('Fitbit integration is disabled in this build.');

  @override
  Future<void> disconnect() async =>
      throw UnsupportedError('Fitbit integration is disabled in this build.');

  @override
  Future<FitnessSummary> readFitnessSummary({
    required DateTime fromUtc,
    required DateTime toUtc,
  }) async =>
      throw UnsupportedError('Fitbit integration is disabled in this build.');
}
```

Bound in Riverpod:

```dart
final fitbitGatewayProvider =
    Provider<FitbitGateway>((ref) => DisabledFitbitGateway());
```

### Rules for any future Fitbit work

- **OAuth 2.0 with PKCE.** Do not embed the Fitbit client secret in the
  mobile binary. Either use the no-secret PKCE flow, or route token
  exchange through a small proxy backend that owns the secret.
- **Token storage:** `access_token`, `refresh_token`, and the token
  expiry go in `flutter_secure_storage` only. **Never** in the SQLite
  database. **Never** in logs.
- **Opt-in.** A consent screen before OAuth must explain exactly which
  scopes are requested, that no Fitbit data is written, that disconnect
  deletes cached data, and that this is a read-only enrichment feature.
- **Minimum scopes.** Typical starting set: `sleep`, `heartrate`,
  `activity`. Add scopes only when a feature actually uses them.
- **No raw export.** Aggregates may be shown in-app; the CSV/PDF export
  pipeline in the MVP must **not** start including Fitbit raw data when
  the gateway is enabled — that requires a separate consent decision.
- **Caching:** the most recent `FitnessSummary` may be cached on device
  (e.g., a small `fitness_cache` table introduced in the migration where
  the gateway is enabled). On disconnect, the cache is dropped.
- **Suggestions stay generic and non-medical.** The integration may
  surface neutral, descriptive observations such as "morning systolic
  tended to be higher on days following < 6 h sleep." It must not
  prescribe behavior, must not diagnose, must not claim causality, and
  must remain inside the rules of
  [12-privacy-and-medical.md](12-privacy-and-medical.md).
- **No blood pressure flow through Fitbit.** Treat this gateway as a
  read-only context source. BP data stays local to the device.
- **Failure handling.** Network errors, expired tokens, revoked
  consent, and rate-limit responses all degrade gracefully to "no
  fitness data available right now"; the rest of the app keeps working.
- **Disconnect is destructive.** Disconnect revokes the token with Fitbit
  and deletes the local fitness cache.

### Recommended future shape

```
Mobile app ──▶ Fitbit Web API (PKCE)
                                or
Mobile app ──▶ Token proxy backend ──▶ Fitbit Web API
```

Decision (PKCE-only vs. proxy) deferred until the feature is scheduled.

## Why interfaces now

Defining the interfaces in the MVP makes three things free later:

1. The app already injects via Riverpod; swapping `Disabled*` for a real
   implementation is one line.
2. UI code that depends on these gateways can be written, tested, and
   reviewed early without flipping them on.
3. Privacy review can audit the interface boundary before any real
   integration ships.

The three gateways (`HealthDataGateway`, `FitbitGateway`, `LlmGateway`) are
deliberately independent: enabling one does not require the others, and a
privacy regression in one cannot leak through another.
