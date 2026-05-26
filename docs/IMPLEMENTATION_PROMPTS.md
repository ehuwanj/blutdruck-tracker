# Implementation Prompts

Copy-paste prompts to drive Claude Code through the MVP, one reviewable step
at a time. Each step is one PR's worth of work.

## How to use

- In a fresh Claude Code session, type **`implement <N>`** where `<N>` is
  the step number. Claude will read the corresponding section in this file
  (this file is referenced from [`.claude/CLAUDE.md`](../.claude/CLAUDE.md))
  and follow it.
- Or paste the full prompt block from the step verbatim — this works in any
  session, even without the CLAUDE.md pointer.
- Between steps: run `flutter format . && flutter analyze && flutter test`
  yourself before you approve. Commit the step. Then move to the next one.
- If Claude drifts out of scope, reply with "out of scope for this step;
  revert those edits."

## Global rules for every step

- Read the spec files listed under "Specs to read" **before** writing code.
- Do **not** touch areas outside the step's deliverables.
- Add or update tests as listed under "Tests".
- Run `flutter analyze` and `flutter test` at the end of the step. Report
  the actual output, not a paraphrase. If anything fails, fix it inside the
  step — do not declare done.
- Commit style follows [`.claude/CLAUDE.md`](../.claude/CLAUDE.md) (`feat:`,
  `test:`, `fix:`, …). One commit per step is the default; split only if
  there's a clean seam (e.g., generated files vs. handwritten code).
- Never run `dart run build_runner` unless the step adds/changes a Drift
  table, freezed class, or JSON model.

---

## Step 0 — Foundation PR

**Goal:** repo is buildable, lints pass, and every cross-cutting
scaffold the feature steps depend on is in place. **No features yet.**

**Specs to read**
- [01-architecture.md](specs/01-architecture.md)
- [06-design-system.md](specs/06-design-system.md) — `AppColors` ThemeExtension
- [08-export-and-reminders.md](specs/08-export-and-reminders.md) — Android FileProvider, notification icon
- [09-localization.md](specs/09-localization.md) — l10n pipeline
- [12-privacy-and-medical.md](specs/12-privacy-and-medical.md) — disclaimer

**Deliverables**
- `flutter create` the project at the repo root (Android-first, but iOS
  config left in place).
- Dependencies from spec 01 added to `pubspec.yaml`. No extras.
- `analysis_options.yaml` includes `package:very_good_analysis/analysis_options.yaml`.
- `l10n.yaml` and `lib/app/localization/arb/{app_en.arb, app_de.arb, app_zh.arb}`
  with one placeholder key (`appTitle`) so the generator runs cleanly.
- `lib/app/theme/app_colors.dart` — `AppColors extends ThemeExtension<AppColors>`
  with light + dark variants per spec 06; registered on `ThemeData(extensions: [...])`.
- `lib/app/theme/app_typography.dart`, `lib/app/theme/app_theme.dart`.
- `lib/core/constants/app_constants.dart` defining `kDisclaimerVersion = 1`
  and the spacing tokens from spec 06.
- `android/app/src/main/AndroidManifest.xml` — `FileProvider` entry with
  authority `${applicationId}.fileprovider`.
- `android/app/src/main/res/xml/file_paths.xml` per spec 08.
- `android/app/src/main/res/drawable/ic_notification.xml` — a white-silhouette
  vector drawable (placeholder OK).
- `lib/main.dart` runs an empty `MaterialApp` wrapped in `ProviderScope`,
  shows the disclaimer text on first launch as a modal, and writes a
  no-op `disclaimerAcceptedVersion` to an in-memory stub (real persistence
  arrives in step 3 — leave a `TODO(step-3)` and keep the stub small).

**Tests**
- `flutter analyze` is clean.
- `flutter test` passes (the default counter test from `flutter create` is
  fine for this step, or replace it with one trivial smoke test that
  pumps `MaterialApp`).

**Out of scope**
- Domain models, services, DB, any feature screen, any chart.

**Prompt**
```
Implement step 0 (Foundation PR) from docs/IMPLEMENTATION_PROMPTS.md.
Follow the deliverables and acceptance criteria in that file exactly.
Do not implement any feature beyond what step 0 lists. Stop when
flutter analyze and flutter test are clean, and report what was created.
```

---

## Step 1 — Domain models

**Goal:** every immutable type used across the app exists, builds, and has
trivial structural tests. **No logic.**

**Specs to read**
- [02-domain-model.md](specs/02-domain-model.md) — primary source
- [04-business-logic.md](specs/04-business-logic.md) — only the type shapes referenced

**Deliverables**
- `lib/features/readings/domain/entities/blood_pressure_reading.dart` —
  `BloodPressureReading` (freezed) with the exact fields from spec 02.
- `lib/features/readings/domain/entities/measurement_arm.dart` —
  `enum MeasurementArm { left, right }`. **No `unknown` value.**
- `lib/features/readings/domain/entities/reading_source.dart` —
  `enum ReadingSource { manual, import, healthConnect }`.
- `lib/features/statistics/domain/entities/`:
  - `metric_summary.dart`, `statistics_result.dart`, `trend_direction.dart`
  - `bmi_summary.dart`, `bmi_category.dart`
  - `blood_pressure_category.dart` (no `unknown` value)
- `lib/features/statistics/domain/entities/time_slot.dart`,
  `time_slot_pick.dart`, `time_slot_point.dart`, `time_slot_series.dart`.
- `lib/features/insights/domain/entities/insight.dart` and
  `insight_severity.dart`.
- `lib/features/reminders/domain/entities/reminder.dart` — `hour` and
  `minute` as `int` (no `TimeOfDay` import).
- `lib/features/settings/domain/entities/app_settings.dart` with all
  fields from spec 02, plus `LocaleSetting`, `ThemeModeSetting`,
  `WeightUnit`.
- Run `dart run build_runner build --delete-conflicting-outputs`.
  Commit the generated `*.freezed.dart` / `*.g.dart` files.

**Tests**
- For each freezed class: one test that constructs an instance with all
  fields and verifies `copyWith` on one representative field.
- For `BloodPressureReading.pulsePressure` and `meanArterialPressure`
  getters: one test each using `(140, 90)` → PP 50, MAP ≈ 106.67.

**Out of scope**
- Validation logic, statistics math, classifier, DB, UI.

**Prompt**
```
Implement step 1 (Domain models) from docs/IMPLEMENTATION_PROMPTS.md.
Read docs/specs/02-domain-model.md first. Create the files listed,
run build_runner, and commit the generated files. Keep these files
free of Flutter imports — domain is pure Dart.
```

---

## Step 2 — Pure-Dart services + their tests

**Goal:** every calculation lives in `domain/services/`, is unit-tested,
and has zero Flutter imports. This step is where most correctness work
happens.

**Specs to read**
- [04-business-logic.md](specs/04-business-logic.md) — primary
- [11-testing.md](specs/11-testing.md) — required unit tests section

**Deliverables**
- `lib/core/constants/blood_pressure_thresholds.dart` — the threshold map
  used by the classifier (binding test in spec 11).
- `lib/features/readings/domain/services/reading_validator.dart` —
  `ReadingValidator` with hard errors + soft warnings per spec 04.
- `lib/features/statistics/domain/services/bmi_calculator.dart` —
  `BmiCalculator.compute` and `categorize`.
- `lib/features/statistics/domain/services/blood_pressure_classifier.dart` —
  with the **8-step evaluation order** from spec 04 §Classification.
  Throws `ArgumentError` when systolic/diastolic are outside the
  validator's hard ranges.
- `lib/features/statistics/domain/services/trend_analyzer.dart`.
- `lib/features/statistics/domain/services/statistics_calculator.dart` —
  composes the above; takes `(readings, period, settings)` and returns
  `StatisticsResult` including `BmiSummary`.
- `lib/features/statistics/domain/services/time_slot_detector.dart` and
  `time_slot_aggregator.dart`.
- `lib/features/insights/domain/services/rule_based_insight_engine.dart` —
  the 8 numbered rules from spec 04 §Insight engine, severity per the
  table, i18n keys passed as a `Map<String, String>` for now (we wire
  `AppLocalizations` in step 5).

**Tests**
- All cases listed in spec 11 under "Required unit tests":
  validator boundaries, statistics math, BMI rounding and edge cases,
  classifier evaluation-order cases (145/85, 145/92, 185/80, 85/55,
  throw on 49/?), trend thresholds, time-slot detector + aggregator
  cases, insight-engine determinism + rule-coexistence.
- Run `flutter test` and paste actual output in the step summary.

**Out of scope**
- DB, repositories, providers, any UI.

**Prompt**
```
Implement step 2 (Pure-Dart services + tests) from
docs/IMPLEMENTATION_PROMPTS.md. Read docs/specs/04-business-logic.md and
docs/specs/11-testing.md first. Implement every service with the
classifier's exact 8-step evaluation order, then write the unit tests
listed in spec 11. No Flutter imports in any service file.
```

---

## Step 3 — Drift database + mappers

**Goal:** persistence layer exists, schema v1 is committed, mappers are
unit-tested. UI does **not** import Drift.

**Specs to read**
- [03-database.md](specs/03-database.md) — primary
- [02-domain-model.md](specs/02-domain-model.md) — settings serialization
- [11-testing.md](specs/11-testing.md) — mapper + migration tests

**Deliverables**
- `lib/core/database/app_database.dart` with tables:
  `blood_pressure_readings`, `reminders`, `app_settings`, `export_history`.
- Table column types and nullability **exactly** per spec 03 (no
  `body_position` column).
- Indexes: `idx_readings_measured_at`, `idx_readings_source`.
- `PRAGMA foreign_keys = ON` on open.
- `lib/features/readings/data/datasources/reading_local_datasource.dart` +
  Drift implementation; matches the contract in spec 03.
- `lib/features/settings/data/datasources/app_settings_local_datasource.dart`
  — key/value access plus a typed `read()`/`write(AppSettings)` helper
  with the serialization rules from spec 03.
- `lib/features/readings/data/mappers/reading_mapper.dart` and
  `lib/features/settings/data/mappers/app_settings_mapper.dart`.
- Run `dart run build_runner build --delete-conflicting-outputs`. Commit
  the generated `*.drift.dart`.

**Tests**
- Schema v1: open a fresh in-memory DB and assert columns + indexes.
- Reading mapper round-trip: entity → row → entity.
- Mapper defensive cases (per spec 11): unknown `arm` → null, unknown
  `source` → `manual` (one warn-level log emitted, asserted with a
  `Logger` fake or equivalent).
- AppSettings mapper: enum `name` round-trip, decimal `.` separator,
  absent row → default, unknown enum string on read → documented default.

**Out of scope**
- Repositories, use cases, providers, UI. (Datasources can be exercised
  directly in their tests.)

**Prompt**
```
Implement step 3 (Drift database + mappers) from
docs/IMPLEMENTATION_PROMPTS.md. Read docs/specs/03-database.md first.
Create the schema, datasources, and mappers; write the mapper and
schema-v1 tests from spec 11. UI must not import app_database.dart.
```

---

## Step 4 — Repositories + use cases + Riverpod wiring

**Goal:** the feature layers can talk to data via clean interfaces,
state-management providers are in place, and the next step can start UI
work without inventing wiring.

**Specs to read**
- [07-state-management.md](specs/07-state-management.md) — primary
- [02-domain-model.md](specs/02-domain-model.md) — repository contracts implied

**Deliverables**
- `lib/features/readings/domain/repositories/reading_repository.dart` —
  interface returning domain entities only (no Drift types).
- `lib/features/readings/data/repositories/reading_repository_impl.dart`.
- `lib/features/settings/domain/repositories/settings_repository.dart`
  and impl.
- Use cases in `lib/features/readings/domain/usecases/`:
  `add_reading.dart`, `update_reading.dart`, `delete_reading.dart`,
  `get_readings.dart`, `get_reading_by_id.dart`, `get_latest_reading.dart`.
- `lib/core/utils/clock.dart` — `abstract class Clock { DateTime now(); }`
  and a `SystemClock` default. Inject via Riverpod.
- All providers from spec 07: `databaseProvider`, datasource providers,
  repository providers, use case providers, `readingsStreamProvider`,
  `latestReadingProvider`, `periodProvider` (`NotifierProvider`),
  `statisticsProvider`, `settingsProvider` (`AsyncNotifierProvider`),
  the three time-slot providers
  (`timeSlotDetectorInputProvider`, `timeSlotPickProvider`,
  `timeSlotSeriesProvider`).
- `ReadingFormNotifier` as a `FamilyAsyncNotifier<ReadingFormState, String?>`
  with its `AsyncNotifierProvider.family(...)` registration.

**Tests**
- Repository implementation: `mocktail`-backed datasource, verify
  domain entities flow through unchanged.
- Use cases: one happy-path test each.
- `statisticsProvider`: `ProviderContainer(overrides: [...])` test that
  it composes settings + readings into a `StatisticsResult`.
- `timeSlotDetectorInputProvider`: filters to last 30 days using an
  injected fake `Clock`.

**Out of scope**
- Any UI.

**Prompt**
```
Implement step 4 (Repositories + use cases + Riverpod wiring) from
docs/IMPLEMENTATION_PROMPTS.md. Read docs/specs/07-state-management.md
first. Use the FamilyAsyncNotifier pattern for the reading form per
spec 07. Wire a Clock abstraction so tests can inject time.
```

---

## Step 5 — App shell, theme, routing, l10n, shared widgets

**Goal:** the app boots into a navigable shell with theme + l10n + the
shared `core/widgets/`. No feature screens implemented yet, but every
route exists and shows a placeholder.

**Specs to read**
- [01-architecture.md](specs/01-architecture.md) — folder structure
- [05-screens.md](specs/05-screens.md) — route map
- [06-design-system.md](specs/06-design-system.md) — shared widgets
- [09-localization.md](specs/09-localization.md) — wiring AppLocalizations
- [12-privacy-and-medical.md](specs/12-privacy-and-medical.md) — disclaimer

**Deliverables**
- `lib/app/app.dart` and updated `lib/main.dart` so `MaterialApp.router`
  uses the theme + localizations + go_router config.
- `lib/app/router.dart` — every route from spec 05 §Navigation registered;
  each non-implemented route renders a placeholder `Scaffold` with the
  route name.
- `lib/core/widgets/`: `app_card.dart`, `app_loading_view.dart`,
  `app_empty_state.dart`, `app_error_view.dart`,
  `blood_pressure_value_display.dart`, `category_dot.dart`, `trend_icon.dart`.
- Replace the in-memory disclaimer stub from step 0 with the real
  settings-backed dialog: shows when `disclaimerAcceptedVersion == null`
  or `< kDisclaimerVersion`; writes on accept.
- `lib/app/localization/arb/` populated with the keys needed so far:
  `appTitle`, route titles (`overviewTitle`, `historyTitle`,
  `statisticsTitle`, `statusTitle`, `exportTitle`, `settingsTitle`,
  `remindersTitle`, `privacyTitle`), category labels, BMI category
  labels, the disclaimer key, common buttons (save/cancel/delete/confirm).
  Each key present in EN, DE, ZH.

**Tests**
- Widget test: app boots, renders the overview placeholder, FAB navigates
  to `/readings/new` placeholder.
- Widget test: when `disclaimerAcceptedVersion` is null, the modal blocks
  interaction; tapping the accept button writes the version and dismisses.
- Widget test: language picker (stub) switches between EN/DE/ZH and the
  app title updates.

**Out of scope**
- Forms, charts, statistics tables, export, reminders, settings beyond
  the language picker stub used by the test.

**Prompt**
```
Implement step 5 (App shell, theme, routing, l10n, shared widgets) from
docs/IMPLEMENTATION_PROMPTS.md. Read specs 01, 05, 06, 09, 12. Wire every
route from spec 05 with placeholders for screens not yet built. Move the
disclaimer dialog from the step-0 stub to the real settings provider.
Use AppColors via Theme.of(context).extension<AppColors>().
```

---

## Step 6 — Reading entry form

**Goal:** users can add and edit readings; validation runs on the form;
data persists.

**Specs to read**
- [05-screens.md](specs/05-screens.md) §Reading entry
- [04-business-logic.md](specs/04-business-logic.md) §ReadingValidator
- [07-state-management.md](specs/07-state-management.md) §Form state
- [11-testing.md](specs/11-testing.md) — entry-form widget tests

**Deliverables**
- `lib/features/readings/presentation/screens/reading_entry_screen.dart`
  — fields in the exact order from spec 05 §Reading entry (no body
  position).
- `lib/features/readings/presentation/widgets/reading_form.dart`,
  `reading_form_field.dart` (numeric input, segmented control for arm,
  segmented control for stress 1..5).
- Validation surfaced inline: errors block submit, warnings allow submit.
- Edit mode pre-fills from `getReadingById`; AppBar shows delete in edit
  mode with confirmation dialog.
- Snackbar "Eintrag gespeichert" / "Reading saved" / "已保存" on success.
- Add all newly-needed ARB keys across EN/DE/ZH.

**Tests**
- Submit disabled when systolic or diastolic missing.
- Warning shown when systolic ≤ diastolic + 5.
- Submit invokes `AddReading` with the expected entity (mock the use case).
- Edit mode pre-fills and saves via `UpdateReading`.

**Out of scope**
- History screen, overview cards beyond the FAB target.

**Prompt**
```
Implement step 6 (Reading entry form) from docs/IMPLEMENTATION_PROMPTS.md.
Use the FamilyAsyncNotifier reading-form pattern from spec 07. Surface
ReadingValidator results inline. Tests per spec 11 entry-form section.
```

---

## Step 7 — Overview screen with charts (Verlauf tab)

**Goal:** the headline screen of the app: latest reading + BP chart +
time-slot chart + weight chart (conditional).

**Specs to read**
- [05-screens.md](specs/05-screens.md) §Overview
- [04-business-logic.md](specs/04-business-logic.md) §Time-slot
- [06-design-system.md](specs/06-design-system.md) §Charts
- [11-testing.md](specs/11-testing.md) — overview + time-slot widget tests

**Deliverables**
- `lib/features/overview/presentation/screens/overview_screen.dart` with
  the three-tab scaffold (Verlauf / Statistiken / Status). Tabs route to
  the respective screens; Verlauf is the default.
- `latest_reading_card.dart`, `blood_pressure_chart_card.dart`,
  `time_slot_chart_card.dart`, `weight_chart_card.dart`.
- Period selector chips (7/14/30/90/custom) writing to `periodProvider`.
  Custom uses Material `showDateRangePicker`.
- Time-slot card uses `timeSlotPickProvider` + `timeSlotSeriesProvider`
  from step 4. Header shows slot range, width, and source
  (auto-detected vs. pinned). Trailing icon opens a sheet with the
  auto/pin toggle.
- Empty states via `AppEmptyState`.

**Tests**
- Latest reading card renders fixture reading.
- Period chip change updates `periodProvider`.
- Time-slot card shows the chart when detector returns a slot with ≥5
  readings; otherwise shows the "Sammeln Sie mehr Messungen…" hint.
- Time-slot card does NOT change when the period chip changes (it uses
  the 30-day detector input, not `periodProvider`).

**Out of scope**
- Statistics / Status tab content beyond a placeholder that the tab
  scaffold routes to.

**Prompt**
```
Implement step 7 (Overview with charts) from docs/IMPLEMENTATION_PROMPTS.md.
Read specs 05, 04 §Time-slot, and 06 §Charts. Hook into the providers
from step 4. The time-slot card must not react to periodProvider changes.
```

---

## Step 8 — History screen

**Specs to read**
- [05-screens.md](specs/05-screens.md) §History
- [11-testing.md](specs/11-testing.md) — history widget tests

**Deliverables**
- `lib/features/readings/presentation/screens/reading_history_screen.dart`.
- Sectioned list grouped by local day (use a helper from
  `core/utils/date_time_utils.dart`).
- Each row: time, sys/dia, pulse, category dot.
- Tap → `/readings/:id/edit`. Swipe-to-delete with confirmation dialog
  → calls `DeleteReading`.
- Date range filter (defaults to all-time; honors `periodProvider` if
  the screen is reached from the Verlauf tab? — keep it independent for
  the MVP, with its own local filter state).
- Empty state.

**Tests**
- Grouping by local day works across a DST boundary fixture.
- Swipe-to-delete shows confirmation; cancel keeps the row; confirm
  removes it.

**Out of scope**
- Category filter chips beyond a TODO.

**Prompt**
```
Implement step 8 (History screen) from docs/IMPLEMENTATION_PROMPTS.md.
Read spec 05 §History. Group by local day, not by UTC day. Use the
shared widgets from step 5.
```

---

## Step 9 — Statistics + Status screens

**Specs to read**
- [05-screens.md](specs/05-screens.md) §Statistics, §Status
- [04-business-logic.md](specs/04-business-logic.md) §StatisticsCalculator, §Classification
- [11-testing.md](specs/11-testing.md) — statistics + status widget tests

**Deliverables**
- `lib/features/statistics/presentation/screens/statistics_screen.dart`
  with: period selector, period summary, key metrics table, classification
  card, BMI card (conditional), insights card.
- `lib/features/status/presentation/screens/status_screen.dart` with
  the distribution chart (donut or stacked bar), legend, expandable
  category explanation panel, and the persistent disclaimer at the bottom.
- BMI card shows "Größe im Profil eintragen" link when height is null.

**Tests**
- All five metric rows render with fixture data; trend icons have
  semantic labels.
- BMI card visibility: shown when height + ≥1 weight present; replaced
  with the profile-link when height is null; hidden when no weight in
  period.
- Status: distribution renders for fixture data; disclaimer is present.

**Out of scope**
- Export, reminders, settings.

**Prompt**
```
Implement step 9 (Statistics + Status) from docs/IMPLEMENTATION_PROMPTS.md.
Read spec 05 §Statistics and §Status, plus spec 04. Use the
StatisticsResult.bmi field from step 2 for the BMI card visibility logic.
```

---

## Step 10 — Export (CSV + PDF)

**Specs to read**
- [08-export-and-reminders.md](specs/08-export-and-reminders.md) §Export sections
- [11-testing.md](specs/11-testing.md) — `CsvExportService`, `PdfReportService`

**Deliverables**
- `lib/features/export/domain/services/csv_export_service.dart` with the
  14 columns from spec 08, headers per the active locale (EN/DE/ZH),
  UTF-8 BOM, `;` separator, `\r\n` line endings, field escaping.
- `lib/features/export/domain/services/pdf_report_service.dart` —
  A4 portrait, page 1 summary + chart image (fl_chart →
  RepaintBoundary → PNG), page 2+ table of readings, footer disclaimer.
- `lib/features/export/presentation/screens/export_screen.dart` — period
  picker, format radio, options, generate button → share sheet via
  `share_plus`. Last 5 exports listed from `export_history`.

**Tests**
- CSV header row matches locale fixture for EN, DE, ZH. Column order
  identical across locales.
- Escaping for separator, quote, newline.
- Empty list → header-only file with BOM.
- PDF: builds a `pw.Document` without throwing for empty, single, and
  ~100-reading fixtures. Disclaimer text on last page.

**Out of scope**
- Reminders, settings polish.

**Prompt**
```
Implement step 10 (Export) from docs/IMPLEMENTATION_PROMPTS.md. Read
spec 08 §Export sections. CSV headers per the locale table. PDF embeds
an fl_chart PNG via RepaintBoundary; on chart-generation failure, embed
a text block — never crash the PDF.
```

---

## Step 11 — Reminders

**Specs to read**
- [08-export-and-reminders.md](specs/08-export-and-reminders.md) §Local reminders
- [02-domain-model.md](specs/02-domain-model.md) §Reminder

**Deliverables**
- `lib/features/reminders/domain/services/reminder_scheduler.dart`
  interface (`scheduleAll`, `cancelAll`, `requestPermission`,
  `hasPermission`).
- `lib/features/reminders/data/local_notification_reminder_scheduler.dart`
  using `flutter_local_notifications` + `timezone`. Channel id
  `reminders_default`. Small icon `ic_notification`.
- App-start hook that re-schedules from the `reminders` table on launch.
- Re-schedule on add/edit/delete.
- `lib/features/reminders/presentation/screens/reminder_settings_screen.dart`
  per spec 05 §Reminder settings.
- Permission request flow on first enable (Android 13+ / iOS).

**Tests**
- Pure-Dart test: given N reminders × M weekdays, the scheduler computes
  the next 14 days of notification slots correctly. Mock the plugin via
  `mocktail`.
- Disabled reminders are not scheduled.

**Out of scope**
- Settings screen polish beyond the reminders entry.

**Prompt**
```
Implement step 11 (Reminders) from docs/IMPLEMENTATION_PROMPTS.md. Read
spec 08 §Local reminders. The domain ReminderScheduler stays pure; only
the Local impl touches flutter_local_notifications. Use channel id
"reminders_default".
```

---

## Step 12 — Settings screen + polish

**Specs to read**
- [05-screens.md](specs/05-screens.md) §Settings
- [12-privacy-and-medical.md](specs/12-privacy-and-medical.md) §Data lifecycle

**Deliverables**
- `lib/features/settings/presentation/screens/settings_screen.dart` with
  every group from spec 05 §Settings: Profil (height), Erscheinungsbild
  (theme + language), Einheiten (weight unit), Zeitfenster (width +
  auto/pinned start), Erinnerungen, Daten, Datenschutz, Integrationen
  (inert rows with "Bald verfügbar" tag), Über die App.
- "Alle Daten löschen" two-step confirmation flow; on confirm runs the
  single-transaction delete from spec 12 §Data lifecycle, then
  `wal_checkpoint(TRUNCATE)` + `VACUUM`. Re-seeds default settings.
  Cancels and re-schedules local notifications afterward.
- `lib/features/settings/presentation/screens/privacy_info_screen.dart`
  with the full disclaimer and a "Erneut anzeigen" button that resets
  `disclaimerAcceptedVersion` to null.

**Tests**
- Height input accepts 80–250, rejects out-of-range with inline error.
- Slot-width dropdown updates settings and the overview reflects it.
- Pinned-start picker disabled when auto-detect is on.
- Delete-all dialog requires both confirmations before any DB write.

**Out of scope**
- The actual disabled gateways (next step).

**Prompt**
```
Implement step 12 (Settings + polish) from docs/IMPLEMENTATION_PROMPTS.md.
Read spec 05 §Settings and spec 12 §Data lifecycle. The delete-all flow
runs a single Drift transaction followed by VACUUM, then re-schedules
reminders. Do not delete the SQLite file directly.
```

---

## Step 13 — Disabled gateway interfaces (LLM, Health, Fitbit)

**Specs to read**
- [10-future-integrations.md](specs/10-future-integrations.md)

**Deliverables**
- `lib/features/integrations/llm/domain/llm_gateway.dart` and
  `lib/features/integrations/llm/data/disabled_llm_gateway.dart`.
- `lib/features/integrations/health/domain/health_data_gateway.dart` and
  `lib/features/integrations/health/data/disabled_health_data_gateway.dart`.
- `lib/features/integrations/fitbit/domain/fitbit_gateway.dart`,
  `fitness_summary.dart`, `daily_fitness.dart`, and
  `lib/features/integrations/fitbit/data/disabled_fitbit_gateway.dart`.
- Riverpod bindings (`llmGatewayProvider`, `healthGatewayProvider`,
  `fitbitGatewayProvider`).
- `README.md` in each integrations subfolder explaining its current
  status and the steps to enable.
- Inert Settings rows in step 12 already point at these (no changes
  needed if step 12 is done).

**Tests**
- Every `Disabled*` method throws `UnsupportedError`.

**Out of scope**
- Any real network code or OAuth.

**Prompt**
```
Implement step 13 (Disabled gateway interfaces) from
docs/IMPLEMENTATION_PROMPTS.md. Read spec 10. Only the disabled
implementations and Riverpod bindings — no real API code.
```

---

## Step 14 — Localization completeness + accessibility pass

**Specs to read**
- [09-localization.md](specs/09-localization.md)
- [06-design-system.md](specs/06-design-system.md) §Accessibility

**Deliverables**
- Every visible string in the app reads from `AppLocalizations`. Grep
  for hardcoded German/English strings in widgets and move them to ARB.
- All ARB keys exist in `app_en.arb`, `app_de.arb`, `app_zh.arb`. Run
  `flutter gen-l10n` and ensure no warnings.
- Plural/select forms use ICU `plural`/`select`, not concatenation.
- Semantic labels: every icon-only button has a `Semantics` label.
  Category dots have tooltips and labels.
- Latest-reading card reads as a single sentence under TalkBack/VoiceOver.
- Text-scaling pass: latest-reading card renders at 200% without
  clipping.

**Tests**
- Locale-switch widget test: render the overview in EN/DE/ZH and assert
  no missing-key warnings.
- Semantics widget test on the latest-reading card.

**Out of scope**
- New features.

**Prompt**
```
Implement step 14 (Localization completeness + accessibility) from
docs/IMPLEMENTATION_PROMPTS.md. Read spec 09. Grep for hardcoded strings
in lib/, move them into ARB across en/de/zh, then run the locale-switch
and semantics widget tests. Report any keys that are present in one
locale but missing in another — those must be fixed in this step.
```

---

## Step 15 — Integration test + final analyzer pass

**Specs to read**
- [11-testing.md](specs/11-testing.md) §Integration tests, §CI gates

**Deliverables**
- `integration_test/app_test.dart` covering:
  cold start → empty state → add a reading via the form → see it in
  the overview → export CSV. Assert the file is written; the system
  share sheet itself is not asserted.
- `flutter format --set-exit-if-changed .` is clean.
- `flutter analyze` is clean. No `// ignore: …` without a justification
  comment on the same line.
- `flutter test` and `flutter test integration_test` both pass.
- A short README check: every spec file's "Status" line in
  [README.md](specs/README.md) updated from Draft.

**Out of scope**
- Anything new.

**Prompt**
```
Implement step 15 (Integration test + final analyzer pass) from
docs/IMPLEMENTATION_PROMPTS.md. Read spec 11 §Integration tests and §CI
gates. Add the one end-to-end integration test, then make sure format,
analyze, unit tests, and integration test all pass. Update the spec
status table in docs/specs/README.md.
```

---

## Verification findings — 2026-05-26

Follow-up review after Claude's implementation found that the MVP is not fully
finished yet. The main quality gates are mostly healthy, but the following
items still need fixes before the steps can be considered complete:

- `lib/app/router.dart`: `AppShell.reschedule()` schedules reminders whenever
  the reminder stream emits or the locale changes, but it does not check
  `settings.remindersEnabled`. This can recreate scheduled notifications after
  the user has disabled reminders.
- `lib/features/reminders/presentation/screens/reminder_settings_screen.dart`:
  adding the first reminder auto-enables reminders without requesting
  notification permission. The permission request exists in the master toggle
  path, but `_openSheet()` bypasses it.
- `integration_test/app_test.dart`: the file comment says the test can run
  without a device, but `flutter test integration_test` currently fails before
  executing tests on this machine with "No supported devices connected". Step
  15's integration-test gate is therefore not satisfied unless a supported
  Android/iOS target is connected or the test strategy is adjusted.

Verified during the review:

- `dart analyze .` passed with no issues.
- `dart format --set-exit-if-changed .` reported `152 files (0 changed)`.
- `flutter gen-l10n` completed successfully.
- `flutter test` passed.
- Targeted reminder occurrence and disabled-gateway tests passed.

### Resolutions

All three findings were validated against the relevant specs and addressed:

- `lib/app/router.dart`: `reschedule()` now reads `settingsProvider` and
  short-circuits when `remindersEnabled` is false. The OS schedule is no longer
  re-created on a stream/locale tick after the user disabled reminders. The
  master-toggle path still owns the "off → on" transition (permission +
  schedule) and the "on → off" transition (`cancelAll`).
- `lib/features/reminders/presentation/screens/reminder_settings_screen.dart`:
  `_openSheet()` now requests OS notification permission before flipping
  `remindersEnabled` on the implicit first-enable (adding the first reminder
  while the master switch is off). When permission is denied it shows the
  same `reminderPermissionDenied` snackbar as the master toggle and skips
  persisting the reminder. Behaviour matches spec 08 §Local reminders:
  "Request notification permission … the first time the user enables
  reminders."
- `integration_test/app_test.dart`: the inaccurate "runs without a device"
  comment was rewritten to reflect the actual execution model. Spec 11
  §CI gates explicitly permits skipping the integration gate locally when
  no emulator is attached, so no behavioural change is needed — the comment
  now documents both how to run the test on CI/an emulator and how to
  exercise the same scenarios on the host VM (`flutter test
  integration_test/app_test.dart`).

---

## After step 15

The MVP is feature-complete per the acceptance criteria in
[`.claude/CLAUDE.md`](../.claude/CLAUDE.md) and [00-project-overview.md](specs/00-project-overview.md).
Beyond the MVP, future work is the disabled gateways: LLM, Health Connect,
Fitbit / Google Health. Each is its own multi-step branch and should be
prompted the same way — one PR at a time, with a written spec or addendum
first.
