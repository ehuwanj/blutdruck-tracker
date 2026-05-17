# CLAUDE.md

This file gives Claude Code the project context, constraints, architecture rules, and development workflow for the Blood Pressure Tracker app.

## Project summary

Build a Flutter-based mobile app for tracking blood pressure.

The app is Android-first, but the technology choice must keep future iOS support realistic. The app should work primarily offline and should not require a backend for the MVP.

The app tracks:
- Systolic blood pressure
- Diastolic blood pressure
- Pulse
- Weight, optional
- Measurement date and time
- Notes, optional
- Context metadata, optional, such as arm, body position, stress, medication note, and measurement condition

The app should provide:
- Manual data entry
- Local storage
- Overview dashboard
- History list
- Statistics
- Charts
- Classification/status view
- Local reminders
- CSV/PDF export
- Local-first privacy model

Future extensions:
- Online LLM-based insight generation
- Health Connect integration on Android
- HealthKit integration on iOS
- Optional cloud sync or account system, only if explicitly requested later

Do not implement online LLM, Health Connect, HealthKit, or remote backend integration in the MVP unless explicitly instructed.

---

## Technology decisions

Use this stack for the MVP:

```text
Framework: Flutter
Language: Dart
State management: Riverpod
Database: Drift + SQLite
Navigation: go_router
Charts: fl_chart or a similarly mature Flutter chart package
Local notifications: flutter_local_notifications
CSV export: csv package
PDF export: pdf + printing packages
Localization: Flutter intl / gen_l10n
Secure storage: flutter_secure_storage, only for secrets or future user-managed API keys
Testing: flutter_test, mocktail, integration_test where useful
Architecture: feature-based Clean Architecture
```

Preferred package choices:

```yaml
dependencies:
  flutter_riverpod:
  go_router:
  drift:
  drift_flutter:
  sqlite3_flutter_libs:
  path_provider:
  path:
  intl:
  fl_chart:
  csv:
  pdf:
  printing:
  flutter_local_notifications:
  flutter_secure_storage:
  uuid:
  freezed_annotation:
  json_annotation:

dev_dependencies:
  build_runner:
  drift_dev:
  freezed:
  json_serializable:
  mocktail:
  very_good_analysis:
```

Use stable, well-maintained packages. Do not add unnecessary dependencies.

---

## Architecture rules

Use feature-based Clean Architecture.

Recommended structure:

```text
lib/
  main.dart

  app/
    app.dart
    router.dart
    theme/
      app_theme.dart
      app_colors.dart
      app_typography.dart
    localization/

  core/
    database/
      app_database.dart
      tables/
      migrations/
    errors/
      app_exception.dart
      failure.dart
    utils/
      date_time_utils.dart
      number_format_utils.dart
    widgets/
      app_card.dart
      app_empty_state.dart
      app_error_view.dart
      app_loading_view.dart
    constants/
      app_constants.dart

  features/
    readings/
      domain/
        entities/
          blood_pressure_reading.dart
          measurement_context.dart
        repositories/
          reading_repository.dart
        usecases/
          add_reading.dart
          update_reading.dart
          delete_reading.dart
          get_readings.dart
          get_latest_reading.dart
        services/
          reading_validator.dart
      data/
        datasources/
          reading_local_datasource.dart
        repositories/
          reading_repository_impl.dart
        mappers/
          reading_mapper.dart
      presentation/
        screens/
          reading_entry_screen.dart
          reading_history_screen.dart
        widgets/
          reading_form.dart
          reading_list_item.dart
        providers/
          reading_providers.dart

    overview/
      presentation/
        screens/
          overview_screen.dart
        widgets/
          latest_reading_card.dart
          blood_pressure_chart_card.dart
          weight_chart_card.dart
          overview_tabs.dart
        providers/
          overview_providers.dart

    statistics/
      domain/
        entities/
          statistics_result.dart
          metric_summary.dart
          trend_direction.dart
        services/
          statistics_calculator.dart
          blood_pressure_classifier.dart
          trend_analyzer.dart
      presentation/
        screens/
          statistics_screen.dart
        widgets/
          report_period_card.dart
          key_metrics_card.dart
          classification_card.dart
          trend_indicator.dart
        providers/
          statistics_providers.dart

    insights/
      domain/
        entities/
          insight.dart
          insight_severity.dart
        services/
          insight_engine.dart
          rule_based_insight_engine.dart
      data/
        llm/
          llm_insight_provider.dart
          disabled_llm_insight_provider.dart
      presentation/
        screens/
          insights_screen.dart
        widgets/
          insight_card.dart

    export/
      domain/
        services/
          csv_export_service.dart
          pdf_report_service.dart
      presentation/
        screens/
          export_screen.dart

    reminders/
      domain/
        entities/
          reminder.dart
        services/
          reminder_scheduler.dart
      data/
        local_notification_reminder_scheduler.dart
      presentation/
        screens/
          reminder_settings_screen.dart

    settings/
      presentation/
        screens/
          settings_screen.dart
        providers/
          settings_providers.dart

    integrations/
      health/
        domain/
          health_data_gateway.dart
        data/
          disabled_health_data_gateway.dart
          README.md
      llm/
        domain/
          llm_gateway.dart
        data/
          disabled_llm_gateway.dart
          README.md
```

Rules:
- UI must not directly access Drift database classes.
- Use repositories/use cases between presentation and data layers.
- Keep business logic out of widgets.
- Statistics and classification logic must be unit-tested.
- Database schema and migrations must be reviewed carefully.
- Prefer immutable models.
- Use `freezed` for value types where it improves clarity.
- Use `DateTime` carefully. Store timestamps in UTC, render in local time.
- Keep all medical thresholds configurable in one place.

---

## MVP scope

Implement these features first:

### 1. Manual reading entry

Fields:
- Date/time, default now
- Systolic, required
- Diastolic, required
- Pulse, optional but recommended
- Weight, optional
- Notes, optional
- Measurement arm, optional
- Body position, optional
- Medication note, optional
- Tags/context, optional

Validation:
- Systolic must be a reasonable integer range.
- Diastolic must be a reasonable integer range.
- Pulse must be a reasonable integer range if provided.
- Weight must be a reasonable positive decimal if provided.
- Systolic should normally be greater than diastolic.
- Show validation warnings, not scary medical advice.

Do not diagnose the user.

### 2. Overview screen

Reference style:
- Top navigation with tabs:
  - Verlauf
  - Statistiken
  - Status
- Latest reading summary card:
  - Systolic
  - Diastolic
  - Pulse
  - Status label
  - Last captured time
- Blood pressure chart card:
  - Systolic line
  - Diastolic line
  - Optional pulse display
  - Average values
  - Time range
- Weight chart card, if weight data exists
- Floating action button for adding a new reading

### 3. Statistics screen

Show:
- Report period
- Number of entries
- Max / average / min for:
  - Systolic
  - Diastolic
  - Pulse
  - Pulse pressure
  - Mean arterial pressure
- Trend direction:
  - up
  - down
  - stable
  - unknown, if insufficient data
- Classification summary

Important calculations:
```text
pulse_pressure = systolic - diastolic
mean_arterial_pressure = diastolic + (pulse_pressure / 3)
```

Use clear formatting:
- No excessive decimals for blood pressure.
- Weight can use one decimal.
- Averages should be rounded consistently.

### 4. History screen

Show:
- List of readings grouped by date
- Search/filter by date range
- Edit reading
- Delete reading with confirmation
- Empty state

### 5. Status/classification screen

Show:
- Distribution of readings by classification
- Explanation of what the app’s categories mean
- Clear disclaimer:
  - The app is not a medical device.
  - The app does not provide diagnosis or treatment.
  - Users should consult medical professionals for medical decisions.

Use neutral language.

### 6. Export

Implement:
- CSV export
- PDF report export

PDF should include:
- Report period
- Summary metrics
- List of readings
- Simple trend summary
- Disclaimer

### 7. Settings

Settings:
- Units
- Language
- Theme
- Reminder settings
- Export options
- Privacy information
- Data deletion
- Future integrations disabled by default

---

## Future extension: Online LLM

The MVP must not call an online LLM.

Create only a clean interface and disabled implementation:

```dart
abstract class LlmGateway {
  Future<String> generateInsightSummary({
    required InsightPromptData data,
  });
}

class DisabledLlmGateway implements LlmGateway {
  @override
  Future<String> generateInsightSummary({
    required InsightPromptData data,
  }) async {
    throw UnsupportedError('Online LLM is disabled in this build.');
  }
}
```

Future LLM design rules:
- Do not put OpenAI, Anthropic, or other provider API keys directly inside the mobile app.
- A production app should use a small backend/proxy for LLM calls.
- If a user-provided API key mode is implemented for a private/technical build, store it only in secure storage.
- LLM must be opt-in.
- Show explicit consent before sending health-related data to an external API.
- Send summarized data, not full raw history, unless the user explicitly chooses otherwise.
- Never ask the LLM to diagnose, prescribe medication, or make treatment decisions.
- The LLM can:
  - summarize reports
  - explain trends in simple language
  - generate doctor-visit questions
  - create a user-readable monthly summary
- The LLM must not:
  - diagnose hypertension
  - recommend medication changes
  - say a situation is safe or unsafe
  - replace medical advice

Recommended future architecture:

```text
Mobile app
  -> LLM proxy backend
    -> LLM provider API
```

Candidate backend options for future:
- Cloudflare Workers
- Firebase Cloud Functions
- Supabase Edge Functions
- AWS Lambda

Keep the future LLM code isolated under:

```text
lib/features/integrations/llm/
lib/features/insights/
```

---

## Future extension: Health Connect and HealthKit

Health Connect is not required for MVP.

Create only an interface and disabled implementation:

```dart
abstract class HealthDataGateway {
  Future<bool> isAvailable();

  Future<void> requestPermissions();

  Future<void> writeBloodPressureReading(BloodPressureReading reading);

  Future<List<BloodPressureReading>> readBloodPressureReadings({
    required DateTime from,
    required DateTime to,
  });
}

class DisabledHealthDataGateway implements HealthDataGateway {
  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<void> requestPermissions() async {
    throw UnsupportedError('Health integration is disabled in this build.');
  }

  @override
  Future<void> writeBloodPressureReading(BloodPressureReading reading) async {
    throw UnsupportedError('Health integration is disabled in this build.');
  }

  @override
  Future<List<BloodPressureReading>> readBloodPressureReadings({
    required DateTime from,
    required DateTime to,
  }) async {
    throw UnsupportedError('Health integration is disabled in this build.');
  }
}
```

Future integration rules:
- Health Connect on Android and HealthKit on iOS are optional integrations.
- Do not make app functionality depend on them.
- Manual entry must always work.
- Ask for minimum required permissions only.
- Explain clearly what data is read/written.
- Add integration tests or manual QA checklists for permissions.
- Handle “no data available” gracefully.
- Do not assume blood pressure data exists in Health Connect or HealthKit.

Keep the future health code isolated under:

```text
lib/features/integrations/health/
```

---

## Medical and privacy rules

This app handles sensitive health-related data.

Rules:
- Do not implement diagnosis.
- Do not implement treatment recommendations.
- Do not recommend medication changes.
- Do not use alarming language.
- Do not claim the app measures blood pressure by itself.
- Do not imply medical-device certification.
- Always include disclaimers in reports and status/explanation pages.
- Store data locally by default.
- Do not send health data to remote services in the MVP.
- Avoid analytics SDKs in the MVP.
- Do not add advertising SDKs in the MVP.
- Do not log health readings in plain debug logs.
- Do not print sensitive data to console.
- Any future cloud/LLM feature must require explicit opt-in consent.

Preferred disclaimer text:

```text
This app is for personal tracking and informational purposes only. It is not a medical device and does not provide diagnosis, treatment, or medical advice. Please consult a qualified healthcare professional for medical decisions.
```

German version:

```text
Diese App dient nur der persönlichen Dokumentation und Information. Sie ist kein Medizinprodukt und bietet keine Diagnose, Behandlung oder medizinische Beratung. Bitte wenden Sie sich bei medizinischen Fragen an qualifiziertes medizinisches Fachpersonal.
```

---

## Domain model guidelines

Core entity:

```dart
class BloodPressureReading {
  final String id;
  final DateTime measuredAt;
  final int systolic;
  final int diastolic;
  final int? pulse;
  final double? weightKg;
  final String? note;
  final MeasurementArm? arm;
  final BodyPosition? bodyPosition;
  final String? medicationNote;
  final int? stressLevel;
  final ReadingSource source;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

Enums:

```dart
enum MeasurementArm {
  left,
  right,
  unknown,
}

enum BodyPosition {
  sitting,
  lying,
  standing,
  unknown,
}

enum ReadingSource {
  manual,
  import,
  healthConnect,
  healthKit,
}

enum TrendDirection {
  up,
  down,
  stable,
  unknown,
}

enum InsightSeverity {
  info,
  warning,
  neutral,
}
```

Statistics entity:

```dart
class MetricSummary {
  final num? min;
  final num? max;
  final num? average;
  final TrendDirection trend;
}

class StatisticsResult {
  final DateTime from;
  final DateTime to;
  final int entryCount;
  final MetricSummary systolic;
  final MetricSummary diastolic;
  final MetricSummary pulse;
  final MetricSummary pulsePressure;
  final MetricSummary meanArterialPressure;
}
```

---

## Database guidelines

Use Drift.

Tables:
- blood_pressure_readings
- reminders
- app_settings
- export_history, optional
- insight_cache, optional for future

Suggested blood pressure table fields:
- id TEXT PRIMARY KEY
- measured_at INTEGER NOT NULL
- systolic INTEGER NOT NULL
- diastolic INTEGER NOT NULL
- pulse INTEGER NULL
- weight_kg REAL NULL
- note TEXT NULL
- arm TEXT NULL
- body_position TEXT NULL
- medication_note TEXT NULL
- stress_level INTEGER NULL
- source TEXT NOT NULL
- created_at INTEGER NOT NULL
- updated_at INTEGER NOT NULL

Indexes:
- measured_at
- source

Rules:
- Store dates as UTC milliseconds or seconds consistently.
- All database access goes through datasource/repository classes.
- Do not expose Drift row classes to UI.
- Add migration tests when schema changes.

---

## UI/design guidelines

The UI should feel clean, calm, and trustworthy.

Design principles:
- Health app, not gaming app.
- Clear cards.
- Large readable values.
- Calm colors.
- Strong contrast.
- Avoid alarming red except for clearly defined warnings.
- Support dark mode.
- Support German and English.
- Use accessible font sizes.
- Avoid clutter.
- Charts should be readable, not overloaded.

Reference UI from provided screenshots:
- Top title: Überblick
- Tabs: Verlauf / Statistiken / Status
- Rounded cards
- Latest reading card with large numbers
- Statistics card with rows and columns
- Floating action button
- Simple line charts
- Status labels

Do not copy brand-specific visual identity exactly. Use it only as functional inspiration.

---

## State management rules

Use Riverpod.

Rules:
- Use providers for repositories, use cases, and screen state.
- Prefer `AsyncValue` for async UI.
- Keep providers small.
- Do not place complex business logic inside providers.
- Business logic belongs to services/use cases.
- Widgets should be mostly declarative.

Example provider layering:

```dart
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final readingLocalDataSourceProvider = Provider<ReadingLocalDataSource>((ref) {
  return ReadingLocalDataSource(ref.watch(databaseProvider));
});

final readingRepositoryProvider = Provider<ReadingRepository>((ref) {
  return ReadingRepositoryImpl(ref.watch(readingLocalDataSourceProvider));
});

final getReadingsProvider = Provider<GetReadings>((ref) {
  return GetReadings(ref.watch(readingRepositoryProvider));
});
```

---

## Testing requirements

Write tests for every calculation.

Required unit tests:
- Reading validation
- Pulse pressure calculation
- Mean arterial pressure calculation
- Average/min/max calculation
- Trend calculation
- Classification logic
- Date range filtering
- CSV export formatting
- PDF data preparation, not necessarily visual PDF rendering

Widget tests:
- Overview screen empty state
- Overview screen with latest reading
- Reading entry form validation
- Statistics screen with sample data
- History list grouped by date

Golden tests are optional but useful for important cards.

Before finishing a task, run:

```bash
flutter format .
flutter analyze
flutter test
```

Do not leave analyzer errors.

---

## Development workflow for Claude Code

Work in small, reviewable steps.

Do not generate the whole app in one pass.

Recommended task sequence:

1. Create Flutter project structure.
2. Add dependencies.
3. Add linting.
4. Implement domain models.
5. Implement statistics calculator with tests.
6. Implement Drift database.
7. Implement reading repository.
8. Implement add/edit/delete reading.
9. Implement overview UI with fake data.
10. Connect overview UI to repository.
11. Implement charts.
12. Implement statistics screen.
13. Implement history screen.
14. Implement export services.
15. Implement reminders.
16. Implement settings.
17. Add localization.
18. Add disabled future integration interfaces for LLM and Health.
19. Polish UI.
20. Add integration tests.

Each task should include:
- implementation
- tests where relevant
- no unrelated refactoring
- no unnecessary dependencies
- no secrets
- no remote API calls unless explicitly requested

---

## Git and code quality rules

Commit style:
```text
feat: add blood pressure reading model
feat: implement statistics calculator
test: add statistics calculator tests
fix: correct average rounding
refactor: isolate chart data mapping
docs: add future health integration notes
```

Rules:
- Keep commits focused.
- Do not mix UI redesign with database changes.
- Do not commit generated secrets.
- Do not commit local build artifacts.
- Update this CLAUDE.md when architectural decisions change.
- Prefer readable code over clever code.
- Add comments only where they clarify non-obvious logic.
- Keep files reasonably small.

---

## Security rules

Never:
- Hardcode API keys.
- Log blood pressure values in production logs.
- Send health data to remote services in MVP.
- Add analytics SDKs without explicit instruction.
- Add ad SDKs without explicit instruction.
- Store secrets in plain text.
- Make medical claims.

Use:
- Local SQLite database for readings.
- Secure storage only for future secrets or sensitive settings.
- Explicit user consent for any future external data sharing.

---

## Localization

Initial languages:
- English
- German

Do not hardcode UI strings directly in widgets once localization is introduced.

German terminology:
- Overview: Überblick
- History: Verlauf
- Statistics: Statistiken
- Status: Status
- Systolic: Systolisch
- Diastolic: Diastolisch
- Pulse: Puls
- Blood pressure: Blutdruck
- Weight: Gewicht
- Report period: Berichtszeitraum
- Entries: Einträge
- Average: Mittel
- Minimum: Min
- Maximum: Max
- Pulse pressure: Pulsdruck
- Mean arterial pressure: Mittlerer arterieller Druck

---

## Acceptance criteria for MVP

The MVP is acceptable when:

- User can add, edit, and delete readings.
- User can view latest reading.
- User can view history.
- User can view charts.
- User can view statistics for a selected period.
- User can export CSV.
- User can generate a basic PDF report.
- Data is stored locally.
- App works without login.
- App works without backend.
- App has no online LLM call.
- Health Connect is not required.
- Health integration and LLM integration are represented only as disabled future extension interfaces.
- Tests pass.
- Analyzer passes.
- App has English and German UI text, or at minimum is structured for localization.
- Medical disclaimer is present.
