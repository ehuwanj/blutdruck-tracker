# 02 — Domain Model

All domain types live under `lib/features/<feature>/domain/entities/` and are
**immutable**. Use `freezed` for value types with more than two fields or any
union/sum type.

## Identifiers

- All ids are string UUIDs (v4) generated via the `uuid` package.
- Generation happens in the use case or repository layer, never in the UI.

## Timestamps

- All `DateTime` values are stored as **UTC** in the database.
- They are rendered in the **device local time zone** in the UI.
- Helpers in [`core/utils/date_time_utils.dart`](../../lib/core/utils/date_time_utils.dart) wrap conversion to keep this consistent.

## Core entity — `BloodPressureReading`

```dart
@freezed
class BloodPressureReading with _$BloodPressureReading {
  const factory BloodPressureReading({
    required String id,
    required DateTime measuredAt,          // UTC
    required int systolic,                 // mmHg
    required int diastolic,                // mmHg
    int? pulse,                            // bpm
    double? weightKg,                      // kilograms
    String? note,
    MeasurementArm? arm,                   // null = unspecified
    String? medicationNote,
    int? stressLevel,                      // 1..5, see below
    required ReadingSource source,
    required DateTime createdAt,           // UTC
    required DateTime updatedAt,           // UTC
  }) = _BloodPressureReading;

  const BloodPressureReading._();

  int get pulsePressure => systolic - diastolic;

  double get meanArterialPressure =>
      diastolic + (pulsePressure / 3.0);
}
```

### Field-level validation ranges

These are **plausibility checks**, not medical assessments. Outside the range =
hard error. Inside the range but unusual = soft warning (see
[04-business-logic.md](04-business-logic.md)).

| Field         | Required | Range (hard) | Soft warning band              |
|---------------|----------|--------------|---------------------------------|
| `systolic`    | yes      | 50..260      | <80 or >200                     |
| `diastolic`   | yes      | 30..200      | <40 or >130                     |
| `pulse`       | no       | 25..220      | <40 or >150                     |
| `weightKg`    | no       | 20..400      | step > 5 kg vs last entry      |
| `stressLevel` | no       | 1..5         | n/a                             |
| `note`        | no       | length ≤ 500 | n/a                             |
| `medicationNote` | no    | length ≤ 200 | n/a                             |

Additional cross-field rule:

- **`systolic` must be > `diastolic`.** If not, show a warning, not an error
  — the user may have typed unusual values intentionally.

## Enums

```dart
enum MeasurementArm { left, right }

enum ReadingSource {
  manual,            // entered by the user
  import,            // CSV import, future
  healthConnect,     // future, on-device Android
}
// Note: Fitbit / Google Health is a read-only fitness-context gateway,
// not a blood-pressure source. There is no `fitbit` value here.

enum TrendDirection { up, down, stable, unknown }

enum InsightSeverity { info, warning, neutral }

/// Blood pressure category — used for the classification screen and the
/// status label on the latest reading card. Thresholds are configurable in
/// one place: see [04-business-logic.md]. The classifier is exhaustive on
/// validated input, so there is no `unknown` variant; validation rejects
/// implausible inputs before they reach the classifier.
enum BloodPressureCategory {
  hypotension,
  optimal,
  normal,
  highNormal,
  hypertensionGrade1,
  hypertensionGrade2,
  hypertensionGrade3,
  isolatedSystolic,
}
```

Persisted as their `name` string in the database. Mappers handle the
conversion and treat unknown strings defensively:

- `MeasurementArm`: unknown string → `null` (arm unspecified).
- `ReadingSource`: unknown string → `ReadingSource.manual` plus a single
  warning-level log of the offending value (no row id, no health data).
- `BloodPressureCategory`: never persisted on the reading row; always
  computed on read by the classifier.
- `TrendDirection`: not persisted; computed at query time.

`BodyPosition` was removed during spec review; the entry form no longer
asks for it. If product asks for it back later, treat it as a new
nullable column with a migration, not a re-introduction of an `unknown`
enum value.

## Statistics value types

```dart
@freezed
class MetricSummary with _$MetricSummary {
  const factory MetricSummary({
    num? min,
    num? max,
    num? average,
    @Default(TrendDirection.unknown) TrendDirection trend,
  }) = _MetricSummary;
}

@freezed
class StatisticsResult with _$StatisticsResult {
  const factory StatisticsResult({
    required DateTime from,   // UTC, inclusive
    required DateTime to,     // UTC, inclusive
    required int entryCount,
    required MetricSummary systolic,
    required MetricSummary diastolic,
    required MetricSummary pulse,
    required MetricSummary pulsePressure,
    required MetricSummary meanArterialPressure,
    required Map<BloodPressureCategory, int> categoryDistribution,
    /// Null when either height (settings) is missing or no weight entries
    /// exist in the period.
    BmiSummary? bmi,
  }) = _StatisticsResult;
}
```

## BMI

Height is **not** stored per reading. It lives on `AppSettings.heightCm`
as a single value (see [settings](#settings) below). Weight is per reading.
BMI is a derived value computed only when both are available.

```dart
@freezed
class BmiSummary with _$BmiSummary {
  const factory BmiSummary({
    double? currentBmi,         // from latest in-period reading with weight
    double? averageBmi,         // mean BMI over in-period readings with weight
    BmiCategory? category,      // category of currentBmi; null if no current BMI
  }) = _BmiSummary;
}

enum BmiCategory {
  underweight,   // bmi < 18.5
  normal,        // 18.5 <= bmi < 25
  overweight,    // 25  <= bmi < 30
  obese,         // bmi >= 30
}
```

BMI is calculated as:

```
bmi = weight_kg / (height_cm / 100)^2
```

Validation range for `heightCm` (hard error outside the band): 80..250.
Inside the band but unusual (< 120 or > 220) → soft warning. See
[04-business-logic.md](04-business-logic.md).

## Time-slot

The time-slot chart isolates readings taken within a fixed time-of-day
window so day-over-day trend is not contaminated by morning-vs-evening
variance.

```dart
@freezed
class TimeSlot with _$TimeSlot {
  const factory TimeSlot({
    required int startMinutes,    // 0..1439, minutes since local midnight
    required int widthMinutes,    // > 0; default 60
  }) = _TimeSlot;

  const TimeSlot._();

  int get endMinutesExclusive => startMinutes + widthMinutes;
}

@freezed
class TimeSlotPick with _$TimeSlotPick {
  const factory TimeSlotPick({
    required TimeSlot slot,
    required bool isAutoDetected,  // true = picked from data; false = user-pinned
    required int matchingReadings, // count of in-period readings inside the slot
  }) = _TimeSlotPick;
}

@freezed
class TimeSlotPoint with _$TimeSlotPoint {
  const factory TimeSlotPoint({
    required DateTime localDay,        // 00:00 of the local day
    required int systolicAverage,
    required int diastolicAverage,
    int? pulseAverage,
    required int readingCount,         // readings of this day inside the slot
  }) = _TimeSlotPoint;
}

@freezed
class TimeSlotSeries with _$TimeSlotSeries {
  const factory TimeSlotSeries({
    required TimeSlotPick pick,
    required List<TimeSlotPoint> points, // sorted ascending by localDay
  }) = _TimeSlotSeries;
}
```

Defaults and constraints:

- Default slot width: 60 minutes.
- Allowed widths in settings: 60, 120, 180 (1 h, 2 h, 3 h).
- Slot wraps midnight by truncation (no slot may cross midnight in the MVP;
  if a user pins 23:30 with 2 h width, the slot is clamped to end at 24:00).
- Minimum readings before the time-slot chart card is shown: 5 in the
  current period.

## Insight model

```dart
@freezed
class Insight with _$Insight {
  const factory Insight({
    required String id,
    required InsightSeverity severity,
    required String title,
    required String body,
    DateTime? generatedAt,
  }) = _Insight;
}
```

For the MVP, all insights come from a **rule-based engine** (no LLM). See
[10-future-integrations.md](10-future-integrations.md) for the LLM-ready
interface.

## Reminder

The domain layer is pure Dart and **must not import** `flutter/material.dart`.
`TimeOfDay` therefore does not appear on the domain entity. Hour and minute
are plain `int`s; widgets convert to/from `TimeOfDay` at the UI boundary.

```dart
@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required int hour,                 // 0..23, local time
    required int minute,               // 0..59, local time
    required Set<int> weekdays,        // 1..7, ISO; empty = every day
    required bool enabled,
    String? label,
  }) = _Reminder;
}
```

## Settings

Held as a single `AppSettings` value object loaded from the `app_settings`
table. Fields:

- `LocaleSetting locale` — `system`, `en`, `de`, `zh`. Default: `system`,
  which resolves via device locale and falls back to `en`. See
  [09-localization.md](09-localization.md) for resolution rules.
- `ThemeModeSetting themeMode` — `system`, `light`, `dark`.
- `WeightUnit weightUnit` — `kg`, `lb`.
- `bool remindersEnabled`.
- `String? lastExportDirectoryHint`.
- **Profile**
  - `double? heightCm` — single user height value, optional. Validated as
    `80 <= heightCm <= 250` on write.
- **Time-slot chart**
  - `int timeSlotWidthMinutes` — default `60`; allowed values `60, 120, 180`.
  - `int? pinnedTimeSlotStartMinutes` — `0..1439` in local minutes;
    `null` means auto-detect from data.
- **Disclaimer acceptance**
  - `int? disclaimerAcceptedVersion` — integer version of the disclaimer
    text most recently accepted by the user; `null` = never accepted, show
    the accept dialog on launch. Bump the constant
    `kDisclaimerVersion` (in `core/constants/app_constants.dart`)
    whenever the canonical disclaimer text in
    [12-privacy-and-medical.md](12-privacy-and-medical.md) is changed in a
    way that warrants re-acceptance. The dialog is shown again whenever
    `disclaimerAcceptedVersion < kDisclaimerVersion`.

Units other than `kg` only affect display and input formatting; storage stays
in kilograms. Height is always stored in centimetres regardless of locale;
the input UI may offer a feet/inches helper that converts on submit.
