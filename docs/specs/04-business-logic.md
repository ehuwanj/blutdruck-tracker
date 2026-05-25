# 04 — Business Logic

All calculations, classification rules, and validation live in
`features/<feature>/domain/services/`. They are **pure Dart**, have no
Flutter or platform imports, and are unit-tested.

## Validation — `ReadingValidator`

Inputs: a candidate `BloodPressureReading` from the entry form.

Outputs: `ValidationResult` with two lists:

- `errors` — block submission.
- `warnings` — show, but allow submission.

Rules:

| Rule | Errors when | Warns when |
|------|-------------|------------|
| Systolic range | < 50 or > 260 | < 80 or > 200 |
| Diastolic range | < 30 or > 200 | < 40 or > 130 |
| Pulse range | provided and < 25 or > 220 | provided and < 40 or > 150 |
| Weight range | provided and < 20 or > 400 | step > 5 kg vs previous entry |
| Systolic vs diastolic | systolic ≤ diastolic + 5 (strong warning, not error) | — |
| Measured-at | in the future by > 1 hour | older than 5 years |
| Note length | > 500 chars | — |
| Medication note length | > 200 chars | — |

The validator returns warnings using **neutral language**. Examples:

- "Dieser Wert liegt außerhalb des üblichen Bereichs. Bitte überprüfen."
- "Systolisch sollte normalerweise höher als diastolisch sein."

Never use words like *danger*, *critical*, *abnormal*, *gefährlich*, *kritisch*.

## Math — `StatisticsCalculator`

Inputs: a list of `BloodPressureReading` filtered to a date range, plus
the current `AppSettings` (for height → BMI).

Outputs: a `StatisticsResult` (see [02-domain-model.md](02-domain-model.md)).

Definitions:

```
pulse_pressure          = systolic - diastolic
mean_arterial_pressure  = diastolic + (pulse_pressure / 3)
bmi                     = weight_kg / (height_cm / 100)^2
```

- Averages are computed as the arithmetic mean over the period and **rounded
  to the nearest integer for mmHg metrics**, one decimal for weight.
- BMI is rounded to one decimal for display; internal computation keeps full
  precision.
- If `entryCount == 0`, every `MetricSummary` has `null` for min/max/avg and
  `trend = unknown`. The UI renders this as an em dash, not "0".
- `pulse`, `weight` may be present in some readings but not others — compute
  metrics over the readings where the value is present, and surface a small
  hint in the UI ("Puls in 12/30 Einträgen").

## BMI — `BmiCalculator`

Pure function, no Flutter imports.

```dart
class BmiCalculator {
  /// Returns BMI as kg / m², or null if either input is missing/invalid.
  double? compute({required double? weightKg, required double? heightCm});

  BmiCategory? categorize(double? bmi);
}
```

Rules:

- Both inputs required; if either is `null`, return `null`.
- `heightCm` must be in `[80, 250]` and `weightKg` in `[20, 400]`. Out of
  range → `null` (validation is done elsewhere; the calculator stays defensive).
- Category thresholds:

  | Category | Range |
  |---|---|
  | `underweight` | bmi < 18.5 |
  | `normal` | 18.5 ≤ bmi < 25 |
  | `overweight` | 25 ≤ bmi < 30 |
  | `obese` | bmi ≥ 30 |

The category text in the UI is a neutral label only. **The app does not
produce blood-pressure control advice based on BMI.** This is a deliberate
medical-safety choice; see [12-privacy-and-medical.md](12-privacy-and-medical.md).

`StatisticsCalculator` builds the `BmiSummary` by:

1. If `settings.heightCm == null` → `BmiSummary` is `null`.
2. Otherwise, take the in-period readings that have `weightKg != null`.
3. If that list is empty → `BmiSummary` is `null`.
4. `currentBmi` = BMI of the **latest** such reading.
5. `averageBmi` = mean of BMI computed per reading.
6. `category` = `categorize(currentBmi)`.

## Time-slot — `TimeSlotDetector` and `TimeSlotAggregator`

### `TimeSlotDetector`

Picks the time-of-day window where the user records most readings.

```dart
class TimeSlotDetector {
  /// Returns the best slot of [widthMinutes] for the supplied readings.
  /// Returns null when no slot has enough readings (see thresholds).
  TimeSlotPick? detect({
    required List<BloodPressureReading> readings,
    required int widthMinutes,
    int? pinnedStartMinutes, // if non-null, returns this slot without scanning
  });
}
```

Algorithm:

- If `pinnedStartMinutes != null`, return a `TimeSlotPick` with
  `isAutoDetected = false` and the count of readings inside the pinned slot.
- Otherwise, scan candidate start minutes on a **15-minute step** from
  `0` to `1440 - widthMinutes`. For each candidate, count readings whose
  *local* `measuredAt` minute-of-day is inside `[start, start + width)`.
- Pick the candidate with the highest count. Tie-break by earliest start.
- If the winning count is `< 5`, return `null` (UI shows the hint instead
  of the chart).
- Slots must not cross midnight; the scan stops at `1440 - widthMinutes`.

### Input window (binding)

The detector takes the **last 30 days of readings** by default, regardless
of the date-range chip selected on the overview. Rationale:

- The slot reflects the user's recent measurement habits, not the
  historical period being chart-reviewed.
- Decoupling the detector from the chart's selected period prevents the
  slot from oscillating when the user flips between 7/14/30/90-day chips.

A future setting may expose this window, but the MVP keeps it fixed at 30
days. The detector input is built by a dedicated provider
(`timeSlotDetectorInputProvider`, see [07-state-management.md](07-state-management.md))
which filters the readings stream to the last 30 days of local time.

When the auto-detected slot changes between renders (e.g., new data shifts
the most-frequent slot), the chart **updates silently** without a
notification or animation. The user can pin a slot from the card's
trailing icon if they want stability.

### `TimeSlotAggregator`

Builds the daily series for the chart.

```dart
class TimeSlotAggregator {
  TimeSlotSeries aggregate({
    required List<BloodPressureReading> readings,
    required TimeSlotPick pick,
  });
}
```

Per local day:

- Filter readings whose local time-of-day is inside the slot.
- If the day has at least one matching reading, emit one `TimeSlotPoint`:
  - `systolicAverage` = round(mean(systolic))
  - `diastolicAverage` = round(mean(diastolic))
  - `pulseAverage` = round(mean(pulse)) over readings where pulse is non-null;
    `null` if none.
  - `readingCount` = number of in-slot readings on that day.

Days with no in-slot reading are simply omitted from `points` — the chart
renders gaps where days are missing.

Time-zone changes between readings: aggregation always uses the **current**
device time zone to convert each `measuredAt` to local time, matching how
the chart is drawn.

## Trend — `TrendAnalyzer`

For each metric, the trend over a period is determined as follows:

1. Sort the readings by `measuredAt` ascending.
2. Split into halves. Compute the average of each half.
3. `delta = avg(secondHalf) - avg(firstHalf)`.
4. Map `delta` to direction using metric-specific thresholds:

| Metric | `up` if delta ≥ | `down` if delta ≤ | else |
|--------|-----------------|--------------------|------|
| Systolic | +3 mmHg | -3 mmHg | stable |
| Diastolic | +2 mmHg | -2 mmHg | stable |
| Pulse | +3 bpm | -3 bpm | stable |
| Weight | +0.3 kg | -0.3 kg | stable |
| Pulse pressure | +2 mmHg | -2 mmHg | stable |
| MAP | +2 mmHg | -2 mmHg | stable |

5. If a metric has fewer than **4** valid readings in the period, its trend
   is `unknown`.

These thresholds live in `core/constants/app_constants.dart` so they can be
tuned in one place.

## Classification — `BloodPressureClassifier`

Each reading is mapped to exactly one `BloodPressureCategory`. Thresholds
follow the common ESC/ESH-style office-measurement ranges. **They are
configurable in one place** (`core/constants/blood_pressure_thresholds.dart`)
— never hard-coded inside widgets.

| Category | Systolic (mmHg) | Diastolic (mmHg) |
|----------|------------------|------------------|
| `hypotension` | < 90 | or < 60 |
| `optimal` | < 120 | and < 80 |
| `normal` | 120–129 | and/or 80–84 |
| `highNormal` | 130–139 | and/or 85–89 |
| `hypertensionGrade1` | 140–159 | and/or 90–99 |
| `hypertensionGrade2` | 160–179 | and/or 100–109 |
| `hypertensionGrade3` | ≥ 180 | or ≥ 110 |
| `isolatedSystolic` | ≥ 140 | and < 90 |

### Evaluation order (binding)

The classifier evaluates rules in this **exact order** and returns the first
match. This removes any ambiguity when a reading would fit multiple
categories:

1. `hypotension` — `systolic < 90` or `diastolic < 60`
2. `hypertensionGrade3` — `systolic ≥ 180` or `diastolic ≥ 110`
3. `isolatedSystolic` — `systolic ≥ 140` **and** `diastolic < 90`
4. `hypertensionGrade2` — `systolic ≥ 160` or `diastolic ≥ 100`
5. `hypertensionGrade1` — `systolic ≥ 140` or `diastolic ≥ 90`
6. `highNormal` — `systolic ≥ 130` or `diastolic ≥ 85`
7. `normal` — `systolic ≥ 120` or `diastolic ≥ 80`
8. `optimal` — otherwise

Examples:

- systolic 145 / diastolic 85 → step 3 matches → `isolatedSystolic`.
- systolic 145 / diastolic 92 → step 5 matches (step 3 needs dia < 90) → `hypertensionGrade1`.
- systolic 185 / diastolic 80 → step 2 matches → `hypertensionGrade3`.

There is no `unknown` category. Validation in `ReadingValidator` rejects
implausible values before they reach the classifier, so the classifier is
exhaustive on any persisted reading. Calling `classify` with values outside
the validator's hard ranges is a programmer error and **throws
`ArgumentError`**.

The classifier is a pure function:

```dart
BloodPressureCategory classify({required int systolic, required int diastolic});
```

A second helper returns the human-readable label per locale (handled via
i18n, not inside the classifier itself).

## Reading aggregation by period

Periods supported in the MVP:

- Last 7 days
- Last 14 days
- Last 30 days
- Last 90 days
- Custom range

Period boundaries are **local-time day boundaries** (00:00:00 to 23:59:59.999
in the user's timezone), then converted to UTC for the database query.

## Insight engine — `RuleBasedInsightEngine`

The MVP ships only rule-based insights. The engine is a pure function:

```dart
class RuleBasedInsightEngine {
  List<Insight> generate({
    required StatisticsResult stats,
    required List<BloodPressureReading> readings, // already in-period
    required Duration periodLength,
    required AppLocalizations l10n,
  });
}
```

Returns **0..3** `Insight` items, evaluated in the order below. Stop after
3 are emitted. Each rule may emit at most one insight. All phrasing is read
from ARB — never inlined here.

### Rule set (binding)

| # | Severity | Fires when | i18n key |
|---|----------|-----------|----------|
| 1 | `info` | `stats.entryCount == 0` | `insight.noData` |
| 2 | `info` | `periodLength >= 7d` AND `stats.entryCount < 5` | `insight.fewEntries` |
| 3 | `info` | `stats.entryCount >= 5` AND `stats.entryCount < 4 * periodDays / 7` (less than ~4 per week) | `insight.measureMoreOften` |
| 4 | `warning` | `stats.systolic.trend == up` OR `stats.diastolic.trend == up` (and the period has ≥ 4 readings — already enforced by `TrendAnalyzer`) | `insight.bpRising` |
| 5 | `info` | `stats.systolic.trend == down` AND `stats.diastolic.trend == down` | `insight.bpFalling` |
| 6 | `info` | `share of readings in {hypertensionGrade1, grade2, grade3, isolatedSystolic} >= 0.5` | `insight.frequentlyElevated` (with the count, e.g. "8 / 12") |
| 7 | `info` | `share of readings in {hypotension} >= 0.3` | `insight.frequentlyLow` (with the count) |
| 8 | `neutral` | `stats.entryCount >= 4 * periodDays / 7` AND none of 4–7 fired | `insight.wellDocumented` |

Rules:

- Severity `warning` uses the same `caution`/`warn` palette tokens as the
  classification card; **never** the `alert` color.
- The engine does not consult BMI or Fitbit data in the MVP — those
  surfaces are owned by their own cards.
- If data is insufficient (rule 1 fires), the engine returns **only** that
  insight; do not pile on rule 2 as well.
- If 4 fires, 6 may still fire (a rising trend with a high elevated share
  is two separate signals).

Strict prohibitions (apply to every rule):

- No diagnosis. No "You have hypertension."
- No medication or treatment suggestions.
- No "danger", "kritisch", "abnormal", emergency framing.
- No causal claims ("because you slept badly…").
- Plural counts use ICU `plural` in ARB, not concatenation.

### Determinism

Given the same `StatisticsResult` and readings list, `generate` returns
the same insights in the same order. No randomness, no time-of-day
variation.

## Edge cases

- Duplicate timestamps are allowed; the UI sorts deterministically by
  `measuredAt` then by `createdAt`.
- Timezone changes between readings: keep raw UTC; recompute "today" using
  the current device timezone.
- Daylight saving boundary: never affects storage (UTC); only display.
