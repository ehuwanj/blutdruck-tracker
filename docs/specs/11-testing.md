# 11 — Testing

## Goals

- Every calculation that affects user-visible numbers has a unit test.
- Every screen has at least one widget test that proves the happy path
  and one for the empty state.
- The database has migration tests that prevent silent data loss.
- The test suite is fast enough to run on every save (`flutter test`
  under ~15 s for the unit tier).

## Tiers

| Tier | Tool | Scope |
|---|---|---|
| Unit | `flutter_test`, `mocktail` | Pure Dart: services, calculators, mappers, validators |
| Widget | `flutter_test` | Single widgets / screens with mocked providers |
| Golden (optional) | `flutter_test` golden API | Key cards (latest reading, statistics row) |
| Integration | `integration_test` | One end-to-end flow per release: add a reading, see it in the overview, export CSV |

## Required unit tests

- `ReadingValidator`
  - Valid input.
  - Each hard error boundary (50, 260, 30, 200, 25, 220, 20, 400).
  - Each soft warning boundary.
  - Cross-field: systolic ≤ diastolic.
  - Future date > 1 hour ahead.
  - Length limits on note / medication.

- `StatisticsCalculator`
  - Empty input → all metrics `null`, count `0`, trends `unknown`.
  - Single reading.
  - Multiple readings: avg/min/max correctness (with fixtures).
  - Mixed presence: some readings without pulse, some without weight.
  - Pulse pressure and MAP correctness on hand-computed cases.

- `TrendAnalyzer`
  - `unknown` when fewer than 4 readings.
  - `up`, `down`, `stable` at and around thresholds.
  - Same thresholds for each metric.

- `BloodPressureClassifier`
  - One test per category, on representative values.
  - Combine-rule test: systolic in `hypertensionGrade1` and diastolic in
    `optimal` → `hypertensionGrade1`.
  - `isolatedSystolic` exact rule.
  - Out-of-range values → `unknown`.

- `BmiCalculator`
  - Null inputs (either missing) → `null`.
  - Out-of-range height (79, 251) or weight (19, 401) → `null`.
  - Hand-computed cases at category boundaries:
    `bmi == 18.5` → `normal`,
    `bmi == 24.999…` → `normal`,
    `bmi == 25` → `overweight`,
    `bmi == 30` → `obese`.
  - Display rounding: BMI 26.45 with one decimal renders as `26.5`.
  - `StatisticsCalculator` BMI integration:
    - Height set, no weight in period → `BmiSummary` is `null`.
    - Height unset, weights present → `BmiSummary` is `null`.
    - Both present → `currentBmi` from the latest weight reading; `averageBmi`
      is the mean of per-reading BMIs (not BMI of mean weight).

- `TimeSlotDetector`
  - Returns `null` when fewer than 5 readings match any slot.
  - Picks the candidate with the highest count; tie-breaks by earliest start.
  - `pinnedStartMinutes` short-circuits scanning and returns the pinned slot
    with the correct match count (including 0).
  - Slot widths 60, 120, 180 all produce valid picks on fixture data.
  - Slot never crosses midnight: pinning `1380` (23:00) with width 120
    is clamped/rejected per the rule in [04-business-logic.md](04-business-logic.md).
  - Time-of-day filter uses local time of `measuredAt`, not UTC.

- `TimeSlotAggregator`
  - One reading per day inside the slot → point equals that reading's rounded values.
  - Multiple readings on the same day inside the slot → averaged and rounded.
  - Days with no in-slot reading produce no point (no zeros, no nulls).
  - Pulse averaged only over readings with non-null pulse; if none, `pulseAverage` is `null`.
  - Series is sorted ascending by `localDay`.

- `ReadingMapper` (data layer)
  - Row → entity round-trip.
  - Unknown `arm` string → `null` (no `unknown` enum value, see
    [02-domain-model.md](02-domain-model.md)).
  - Unknown `source` string → `manual` and emits a single warn-level log
    with no PHI.

- `BloodPressureClassifier` — evaluation-order tests
  - 145/85 → `isolatedSystolic` (step 3 short-circuits step 5).
  - 145/92 → `hypertensionGrade1` (step 3 misses on dia ≥ 90).
  - 185/80 → `hypertensionGrade3` (step 2 wins over step 3).
  - 85/55 → `hypotension` (step 1 wins everywhere).
  - Calling with `systolic = 49` (outside validator range) throws
    `ArgumentError`.

- `RuleBasedInsightEngine`
  - Rule 1 (no data) fires alone — never alongside other rules.
  - Rule 4 (BP rising) and Rule 6 (frequently elevated) can both fire
    in the same call when independent.
  - Determinism: identical inputs → identical output order across runs.
  - Plural counts use ICU `plural` and resolve correctly in EN/DE/ZH.

- `AppSettingsMapper`
  - Enum round-trip uses `name` only.
  - Decimal round-trip uses `.` separator regardless of locale fixture.
  - Absent row → field is null / documented default.
  - Unknown enum string on read → documented default (e.g.,
    `themeMode` → `system`).

- `CsvExportService`
  - Header row matches the active locale (EN/DE/ZH fixtures).
  - Column count and order are identical across locales.
  - Field escaping for separator, quote, newline.
  - Empty list → header-only file with BOM.
  - `source` column is the enum `name`, never localized (round-trip).

- `PdfReportService`
  - Builds a `pw.Document` without throwing for: empty period, single
    reading, ~100 readings.
  - Disclaimer text is present on the last page.

- `BloodPressureThresholds` constants
  - Stability test: snapshot of the threshold map. If thresholds change,
    the test must fail intentionally.

## Required widget tests

- Overview screen
  - Empty state when no readings.
  - Latest reading card with a fixture reading.
  - Tapping FAB navigates to `/readings/new` (router-aware test).

- Reading entry form
  - Submit disabled when systolic/diastolic missing.
  - Warning shown when systolic ≤ diastolic.
  - Submit calls `AddReading` with the expected entity.

- Statistics screen
  - Renders all five metric rows with fixture data.
  - Trend icons are present and have semantic labels.
  - BMI card visible when height is set AND a weight exists in the period.
  - BMI card replaced by the "Größe im Profil eintragen" link when height is null.
  - BMI card hidden when no weight exists in the period.

- Overview — time-slot chart card
  - Renders the chart when the detector returns a slot with ≥ 5 readings.
  - Shows the hint ("Sammeln Sie mehr Messungen…") otherwise.
  - Header displays the slot range and source (auto-detected vs. pinned).
  - Settings change to slot width re-runs detection and updates the chart.

- Settings screen
  - Height input accepts 80–250 and rejects out-of-range with an inline error.
  - Empty height input clears the stored value.
  - Slot-width dropdown writes the stored value; UI reflects it without restart.
  - Pinned-start picker is disabled when auto-detect toggle is on.

- History screen
  - Groups readings by local day.
  - Swipe-to-delete shows confirmation; cancel keeps the row.

- Status screen
  - Distribution renders for fixture data.
  - Disclaimer is present.

## Database tests

- For each migration `n → n+1`:
  - Build a v(n) database in-memory.
  - Seed representative rows.
  - Run the migration.
  - Assert v(n+1) shape, indexes, and row content.

- A single-shot test that opens a fresh DB and creates the v1 schema
  cleanly.

## Integration tests (one per release, minimum)

- Cold start → empty state.
- Add a reading via the form.
- See it in the overview.
- Export to CSV (write only; the share sheet itself is not asserted).

## Fakes & overrides

- `mocktail` for repositories/datasources.
- `ProviderScope(overrides: [...])` for widget tests.
- Time: use a `Clock` abstraction (e.g., the `clock` package or a small
  in-house `Clock` interface). Tests inject a fixed clock so trend and
  "vor 2 Stunden" labels are deterministic.

## CI gates

- `flutter format --set-exit-if-changed .`
- `flutter analyze`
- `flutter test`
- `flutter test integration_test` on a single Android emulator (CI may
  skip if no emulator is available locally).

A change that fails any of these gates does not ship.

## Coverage

No hard percentage. The required-tests list above is the gate. New
calculations need new unit tests; new screens need at least one widget
test.
