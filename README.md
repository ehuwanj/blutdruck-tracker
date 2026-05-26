# Blutdruck Tracker

A calm, local-first mobile app for personal blood pressure tracking. Built with
Flutter; primary target is Android (API 26+), iOS support is preserved
structurally. No backend, no analytics, no remote network calls in the MVP.

> **Not a medical device.** The app records values you enter yourself and shows
> them back as charts, statistics, and neutral category labels. It does not
> diagnose, recommend medication, or score cardiovascular risk. See
> [docs/specs/12-privacy-and-medical.md](docs/specs/12-privacy-and-medical.md).

## What the app does

The app is built around five focused jobs the user repeats around home
blood-pressure measurements:

| Function | What you get |
|----------|--------------|
| **Record a reading** | A short form for systolic / diastolic / pulse, plus optional weight, arm, note, and timestamp. The FAB on every screen jumps straight to it. Validators block clearly impossible values (e.g. systolic ≤ diastolic, future timestamps > 1 h ahead). |
| **See where you stand** | An overview tab with a latest-reading card (large numbers, relative time, category color), a 30-day chart with selectable 7 / 14 / 30 / 90-day windows, and a time-slot chart that auto-detects your most-used measurement window from the last 30 days and plots one point per day inside it. |
| **Understand the trend** | A statistics tab with min / max / average for systolic, diastolic, pulse, plus pulse pressure, mean arterial pressure (MAP), and a directional trend indicator over a chosen period. BMI appears when you have set your height in settings and at least one reading in the period has a weight. |
| **Classification + insights** | A status tab with the distribution of readings across WHO/ESC categories (Optimal, Normal, High-normal, Hypertension Grade 1–3, Isolated systolic, Hypotension) and a small rule-based insight engine that surfaces neutral observations like "frequently elevated in this period." All copy is non-alarming. |
| **Share with a doctor** | CSV export (14 columns, UTF-8 BOM, `;` separator, locale-independent enum names) and a 1–2 page PDF report including the disclaimer. Both go through the system share sheet. |
| **Stay on schedule** | Local reminders via `flutter_local_notifications`. Per-reminder time + weekday picker, master toggle, OS notification permission requested only on first enable. No alarming priority — quiet defaults. |
| **Settings & data control** | Height (cm) for BMI, slot-width preference (60 / 120 / 180 min), pinned time-slot start (optional), theme mode, locale (English / German / Simplified Chinese), and a two-step "delete all data" flow that VACUUMs the database afterwards. |

Three integrations — LLM insights, on-device Health Connect / HealthKit, and
Fitbit / Google Health — are scaffolded as **disabled gateway interfaces** that
throw `UnsupportedError`. Enabling them is an additive change, not a refactor.

### Localization

English (default), German (`de`), and Simplified Chinese (`zh-Hans`). All
visible strings live in `lib/app/localization/arb/` and are read through
`AppLocalizations`. Traditional Chinese device locales resolve to `zh`.

## Architecture at a glance

Feature-based Clean Architecture under `lib/features/`, one folder per feature
(`readings`, `overview`, `statistics`, `status`, `insights`, `export`,
`reminders`, `settings`, `integrations/{llm,health,fitbit}`). Each feature
splits into `domain/` (pure Dart entities + repository interfaces),
`data/` (Drift datasources, mappers, repository impls), and `presentation/`
(Riverpod-facing screens and widgets). State management is Riverpod 2.x;
persistence is Drift over SQLite; routing is `go_router`; charts are
`fl_chart`; PDF is the `pdf` + `printing` packages.

Full layout: [docs/specs/01-architecture.md](docs/specs/01-architecture.md).
Reading order for all design specs: [docs/specs/README.md](docs/specs/README.md).

## Installation

### Prerequisites

- Flutter SDK on the `^3.11.4` channel (Dart 3.11+).
  Check with `flutter --version`. Install instructions:
  https://docs.flutter.dev/get-started/install.
- For Android builds: Android Studio + the Android SDK + an Android 8 (API 26)
  or newer emulator or physical device.
- For iOS builds (optional, secondary target): Xcode and CocoaPods on macOS.
- Git.

### Clone and bootstrap

```bash
git clone <this-repo-url>
cd blutdruck-tracker
flutter pub get
```

### Generated files

Generated files (`*.freezed.dart`, `*.g.dart`, `*.drift.dart`) are committed,
so you do **not** need to run code generation for a normal build. Re-run it
only when you change a Drift table, a freezed class, or a JSON model:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Localizations are also generated. Regenerate after editing an ARB file with:

```bash
flutter gen-l10n
```

### Running the app

```bash
flutter run                     # picks up a connected device or running emulator
flutter run -d <device-id>      # explicit device; list devices with `flutter devices`
```

For a release build:

```bash
flutter build apk --release          # Android
flutter build appbundle --release    # Android (Play Store)
flutter build ios --release          # iOS (requires Xcode + signing)
```

### Verifying your setup

The project's quality gates — match these before opening a PR:

```bash
dart format --set-exit-if-changed .
flutter analyze
flutter test
```

`flutter test integration_test/` requires a connected Android emulator or
device. To exercise the end-to-end scenario on the host VM instead, run the
file directly:

```bash
flutter test integration_test/app_test.dart
```

## Using the app

### First launch

A disclaimer dialog appears on first launch. Tap **I understand** to continue.
It will reappear only if the canonical disclaimer copy changes (controlled by
`kDisclaimerVersion`).

### Recording a reading

1. Tap the **+** floating action button on any screen.
2. Enter at least systolic and diastolic. Pulse, weight, arm, timestamp,
   note, and medication note are optional.
3. Tap **Save**. The reading appears immediately on the overview tab.

You can edit or delete a reading from the history tab.

### Browsing your data

- **Overview tab** — Latest reading + 30-day chart + time-slot chart.
- **Statistics tab** — Pick a period; see averages, min/max, pulse pressure,
  MAP, trend, and BMI (when height + a weighed reading are both present).
- **Status tab** — Category distribution and rule-based insights.

### Exporting

Go to **Settings → Export** (or `/export`) and pick CSV or PDF. The system
share sheet opens with the generated file attached.

### Reminders

1. Open **Settings → Reminders**.
2. Add a reminder time (and optional weekdays / label). The first time you add
   a reminder or flip the master toggle on, Android / iOS asks for notification
   permission.
3. The notification copy follows the active app locale.

### Settings & privacy

- **Height** lives in settings and is the only source for BMI.
- **Time-slot** — auto-detected by default; you can pin a start minute.
- **Locale & theme** — switchable at runtime.
- **Delete all data** — two-step confirmation, then VACUUM. No undo.

All data stays on the device. The app has no network code in any path.

## Project layout

```
lib/
  main.dart
  app/                     # MaterialApp, router, theme, localization
  core/                    # database, generic widgets, utils, constants
  features/
    readings/              # entry / edit / delete / fetch
    overview/              # latest card + charts
    statistics/            # calculators + UI
    status/                # classification view
    insights/              # rule-based insight engine
    export/                # CSV + PDF
    reminders/             # local notifications
    settings/              # preferences, delete-all-data
    integrations/          # disabled gateways (LLM, Health, Fitbit)
docs/specs/                # design specs (00 .. 12) — source of truth
docs/IMPLEMENTATION_PROMPTS.md   # per-step implementation log
test/                      # unit + widget tests
integration_test/          # end-to-end flow
```

## Documentation

- [docs/specs/00-project-overview.md](docs/specs/00-project-overview.md) — vision, scope, success criteria
- [docs/specs/01-architecture.md](docs/specs/01-architecture.md) — layers and folder rules
- [docs/specs/04-business-logic.md](docs/specs/04-business-logic.md) — statistics, classification, trend, time-slot math
- [docs/specs/11-testing.md](docs/specs/11-testing.md) — testing tiers and required tests
- [docs/specs/12-privacy-and-medical.md](docs/specs/12-privacy-and-medical.md) — what the app must never say or do
- [.claude/CLAUDE.md](.claude/CLAUDE.md) — non-negotiables and contribution protocol

## License

Personal project. No license granted for redistribution. See
[docs/specs/12-privacy-and-medical.md](docs/specs/12-privacy-and-medical.md) for
medical-context limits.
