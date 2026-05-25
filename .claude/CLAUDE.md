# CLAUDE.md

Project context and rules for the Blutdruck Tracker MVP. The detailed
design lives in [`docs/specs/`](../docs/specs/); the step-by-step
implementation prompts live in
[`docs/IMPLEMENTATION_PROMPTS.md`](../docs/IMPLEMENTATION_PROMPTS.md).
This file is the always-loaded spine: non-negotiables and how to drive
the work.

## What this is

A Flutter app for personal blood pressure tracking. Local-first, no
backend in the MVP, Android-first but iOS-compatible. The user records
readings manually; the app shows the latest reading, trends, statistics,
classification, and a time-slot chart. Height lives in settings (single
value) and feeds BMI in statistics. Future extensions (LLM insights,
on-device Health Connect / HealthKit, Fitbit / Google Health) are present
in the codebase only as **disabled gateway interfaces**.

## Non-negotiables

These apply to every step. Violations are reverted, not patched.

**Medical**

- Not a medical device. No diagnosis, no treatment advice, no medication
  suggestions, no "safe / unsafe" labels for individual values, no
  cardiovascular-risk scores, no emergency prompts.
- No alarming language: *danger*, *critical*, *abnormal*, *gefährlich*,
  *kritisch* — never. Neutral category labels only.
- BMI is shown as value + WHO category; never tied to a BP-control
  suggestion in the UI copy.
- The disclaimer in [docs/specs/12-privacy-and-medical.md](../docs/specs/12-privacy-and-medical.md)
  is canonical. Don't re-author it in widgets — read from i18n.

**Privacy & security**

- No remote network calls in the MVP. No analytics SDKs, no crash
  reporters, no ad SDKs, no Firebase, no third-party telemetry.
- Health values (systolic, diastolic, pulse, weight, notes, medication
  notes) **never appear in logs**, including `debugPrint`, `print`, or
  stack traces. Error logs may include error class + row id, never field
  values.
- Secrets, API keys, tokens: not in source control. Future secrets go in
  `flutter_secure_storage` only — never the SQLite DB, never logs.
- Disabled gateways throw `UnsupportedError`. They do not reference real
  endpoints, even commented out.

**Architecture**

- Domain layer is pure Dart: no `flutter/material.dart` imports, no
  Drift, no platform plugins, no JSON.
- UI never imports Drift, files, or platform plugins — always go through
  repository → datasource.
- Cross-feature coupling goes through `domain/` only; never reach into
  another feature's `data/` or `presentation/`.
- One public class per file, files ≲ 250 lines.

**Localization**

- English is the default and template ARB. German and Chinese
  (Simplified, `zh-Hans`) are the other supported locales. Traditional
  Chinese device locales resolve to `zh`.
- No hardcoded UI strings in widgets. Every visible string lives in ARB
  and is read via `AppLocalizations`.

## Where things live

| Path | Contents |
|---|---|
| [`docs/specs/00..12`](../docs/specs/) | Design specifications — source of truth |
| [`docs/IMPLEMENTATION_PROMPTS.md`](../docs/IMPLEMENTATION_PROMPTS.md) | Numbered step-by-step prompts |
| `.claude/CLAUDE.md` (this file) | Rules and protocol; always loaded |
| `lib/` | App code (created during step 0) |
| `test/`, `integration_test/` | Tests |

When a spec and this file disagree, the spec wins. Fix the spec, then
fix this file if the contradiction is in the non-negotiables.

## `implement <N>` protocol

When the user types **`implement <N>`** (e.g. `implement 2`):

1. Open [`docs/IMPLEMENTATION_PROMPTS.md`](../docs/IMPLEMENTATION_PROMPTS.md).
2. Find the section for step `<N>`.
3. Read every spec listed under "Specs to read" in that section **before**
   writing code.
4. Implement exactly the "Deliverables".
5. Add exactly the "Tests".
6. Do not touch anything under "Out of scope".
7. Run `flutter format . && flutter analyze && flutter test` and paste
   the actual output in the step summary. If any of those fail, fix it
   inside the step — do not declare done.

Steps `0..15` are listed in
[`docs/IMPLEMENTATION_PROMPTS.md`](../docs/IMPLEMENTATION_PROMPTS.md).

## Per-step workflow gates

For every step (`implement <N>` or ad-hoc):

- No unrelated refactoring. Touch only the files the step needs.
- No new dependencies beyond those in
  [docs/specs/01-architecture.md](../docs/specs/01-architecture.md)
  without a written reason in the PR description.
- Generated files (`*.freezed.dart`, `*.g.dart`, `*.drift.dart`) are
  committed. Run `dart run build_runner build --delete-conflicting-outputs`
  only when adding or changing Drift tables, freezed classes, or JSON
  models.
- Tests pass and analyzer is clean before the step is declared done.
- Do not skip git hooks (`--no-verify`, `--no-gpg-sign`) unless the user
  explicitly says so.

## Cross-cutting code rules

- **Timestamps:** stored as UTC milliseconds, rendered in device-local
  time. Helpers live in `core/utils/date_time_utils.dart`.
- **IDs:** UUID v4 from the `uuid` package, generated in the use case
  or repository layer, never in the UI.
- **Decimals:** `.` separator in storage and CSV; UI uses `intl`
  `NumberFormat` for locale-aware display. Never `toString()` on numbers
  for user-facing values.
- **Clock:** time-dependent logic reads from an injected `Clock`
  abstraction so tests can pin time.
- **State management:** Riverpod 2.x. `AsyncNotifier.build()` takes no
  arguments — use `FamilyAsyncNotifier` when per-instance arguments are
  needed (see [docs/specs/07-state-management.md](../docs/specs/07-state-management.md)).
- **Theme tokens:** semantic colors (`success`, `info`, `caution`,
  `warn`, `alert`, `textMuted`) live on a `ThemeExtension<AppColors>`,
  not on static fields. Surface/text come from `ColorScheme`.
- **Comments:** add one only when *why* is non-obvious. No "what" comments.
- **Disabled gateways:** `Disabled*` implementations throw
  `UnsupportedError`. No URLs, no client IDs.

## Git conventions

- Commit prefix: `feat:` / `fix:` / `test:` / `refactor:` / `docs:` /
  `chore:`. Imperative mood, concise subject.
- One commit per implementation step is the default; split only at a
  clean seam (e.g. generated files vs. handwritten code).
- Do not commit local build artifacts, secrets, or `.env` files.
- Do not commit changes to CLAUDE.md when finishing a feature step —
  update the relevant spec and let this file stay small.
- Pull requests are created only when the user asks.

## Quick reference

Load-bearing facts that come up across many steps; full detail in the
specs.

- **Height** is in settings (`AppSettings.heightCm`), not per reading.
  `BMI = weightKg / (heightCm / 100)²`. Categories: `<18.5` underweight,
  `18.5–25` normal, `25–30` overweight, `≥30` obese. Spec:
  [02-domain-model.md](../docs/specs/02-domain-model.md), [04-business-logic.md](../docs/specs/04-business-logic.md).
- **Time-slot chart** auto-detects the most-used time-of-day window
  from the **last 30 days**, independent of the chart period chip.
  Width configurable in settings (60 / 120 / 180 min). Spec:
  [04-business-logic.md](../docs/specs/04-business-logic.md) §Time-slot.
- **Classifier** uses the binding 8-step evaluation order in
  [04-business-logic.md](../docs/specs/04-business-logic.md) §Classification.
  Throws `ArgumentError` outside validator hard ranges. There is no
  `unknown` category.
- **`MeasurementArm`** has values `{left, right}`; `null` = unspecified.
  Body position is not in the domain.
- **`ReadingSource`** has values `{manual, import, healthConnect}`. No
  `healthKit` (no iOS BP source in scope); no `fitbit` (Fitbit is
  fitness context only, not a BP source).
- **`AppSettings` keys** are stored in the `app_settings` key/value
  table: enums as `name`, decimals always with `.`, absent row = default.
  Spec: [03-database.md](../docs/specs/03-database.md).
- **`kDisclaimerVersion`** in `core/constants/app_constants.dart`
  controls re-acceptance of the disclaimer. Bump it when the canonical
  disclaimer text changes; the dialog reappears whenever
  `disclaimerAcceptedVersion < kDisclaimerVersion`.
- **MVP acceptance criteria:**
  [00-project-overview.md](../docs/specs/00-project-overview.md).
