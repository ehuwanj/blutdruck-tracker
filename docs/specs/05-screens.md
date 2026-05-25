# 05 — Screens & Navigation

## Navigation

Use `go_router` with a `ShellRoute` for the main scaffold and child routes
per screen. Deep links are not a goal for the MVP, but the structure should
not block them.

```
/                           ─▶ Overview (tabs: Verlauf / Statistiken / Status)
/readings/new               ─▶ ReadingEntryScreen
/readings/:id/edit          ─▶ ReadingEntryScreen in edit mode
/history                    ─▶ HistoryScreen          (also reachable via Verlauf tab)
/statistics                 ─▶ StatisticsScreen       (also reachable via Statistiken tab)
/status                     ─▶ StatusScreen           (also reachable via Status tab)
/export                     ─▶ ExportScreen
/settings                   ─▶ SettingsScreen
/settings/reminders         ─▶ ReminderSettingsScreen
/settings/privacy           ─▶ PrivacyInfoScreen
```

The bottom of the scaffold has a **floating action button** that always
opens `/readings/new`.

## Overview

Header: app title **Überblick** (DE) / **Overview** (EN). No back button.

Tabs (top of the screen, segmented control style):

- Verlauf
- Statistiken
- Status

### Verlauf tab

Cards top-to-bottom:

1. **Latest reading card**
   - Large numbers for systolic / diastolic, "/" separator.
   - Pulse below in smaller type, "♥ 72 bpm" style — no medical iconography.
   - Status label (category from classifier), color from theme tokens.
   - "Vor 2 Stunden" relative-time line and absolute time tooltip.
   - Empty state: friendly message + "Erste Messung erfassen" CTA.

2. **Blood pressure chart card**
   - 30-day default, time-range chips (7 / 14 / 30 / 90 / Benutzerdefiniert).
   - Two lines: systolic and diastolic; pulse as an optional toggle.
   - Average reference lines for systolic/diastolic across the visible range.
   - Tap a data point ⇒ bottom sheet with the full reading.

3. **Time-slot chart card** ("Zeitfenster")
   - Goal: compare day-over-day BP at a consistent time of day so morning-
     vs.-evening variance doesn't muddy the trend.
   - Header line shows the slot range, slot width, and source:
     - "07:00 – 08:00 · 1 h · automatisch erkannt", or
     - "07:00 – 08:00 · 1 h · festgelegt".
   - Two lines (systolic + diastolic), one point per local day with at least
     one in-slot reading. Days without a matching reading are gaps, not zeros.
   - Same colors as the blood pressure chart; pulse is not shown here.
   - Source decision happens in `TimeSlotDetector` (see
     [04-business-logic.md](04-business-logic.md)).
   - Hidden if no slot has ≥ 5 in-period readings. Replace with a short
     hint: "Sammeln Sie mehr Messungen zur gleichen Tageszeit, um diese
     Auswertung zu sehen."
   - Trailing icon opens a small sheet:
     - "Slot automatisch wählen" toggle (off = pinned to current start).
     - Time picker for the pinned start, disabled when auto is on.
     - Link to Settings → Time slot to change width.

4. **Weight chart card**
   - Shown only if there are ≥ 2 weight entries in the period.
   - Single line. One-decimal labels.

### Statistiken tab

Lives at `/statistics` — see below.

### Status tab

Lives at `/status` — see below.

## Reading entry (`/readings/new`, `/readings/:id/edit`)

Form fields, in order:

1. Date/time picker (default = now, local).
2. Systolic — numeric, required.
3. Diastolic — numeric, required.
4. Pulse — numeric, optional.
5. Weight — numeric with unit suffix from settings, optional.
6. Arm — segmented control: links / rechts / —. The "—" option clears the
   field to `null` (no `unknown` enum value; see
   [02-domain-model.md](02-domain-model.md)).
7. Stress level — 1..5 segmented control, optional.
8. Medication note — single-line text, optional.
9. Notes — multi-line text, optional, 500-char counter.

Behavior:

- Validate on blur, on field change after first blur, and on submit.
- Show warnings inline; submission stays enabled.
- Show errors inline; submission disabled until cleared.
- Edit mode pre-fills fields and renames the AppBar action to "Speichern".
- Delete action (icon in AppBar) is **only** visible in edit mode and
  requires a confirmation dialog.

After a successful save, navigate back and show a snackbar
"Eintrag gespeichert" / "Reading saved".

## History (`/history`)

- Sectioned list of readings grouped by **local day**, newest day first.
- Day header shows the date in localized long form and the count of entries.
- Each row shows: time, systolic/diastolic, pulse (if any), category dot.
- Tap a row ⇒ navigate to `/readings/:id/edit`.
- Swipe-to-delete on each row, with confirmation dialog.
- Search/filter bar pinned at the top:
  - Date range picker.
  - Optional category filter chips.
- Empty state: "Noch keine Einträge." with CTA.

## Statistics (`/statistics`)

Sections:

1. **Period selector** card with chips: 7 / 14 / 30 / 90 / Benutzerdefiniert.
   "Benutzerdefiniert" opens Material's `showDateRangePicker` with the
   current period pre-selected. Saved range becomes the new value of the
   shared `periodProvider` (see [07-state-management.md](07-state-management.md))
   — i.e., the same provider that drives Statistics, Status, and the
   blood-pressure chart card on the overview. The time-slot chart card has
   its **own** 30-day detector input and is not bound to this provider
   (see [04-business-logic.md](04-business-logic.md)).
2. **Report period summary**: "1. Mai – 30. Mai 2026 · 24 Einträge".
3. **Key metrics card** — table:

   | Metric | Mittel | Min | Max | Trend |
   |---|---|---|---|---|
   | Systolisch | 132 | 118 | 154 | ↑ |
   | Diastolisch | 84 | 70 | 96 | → |
   | Puls | 72 | 58 | 95 | → |
   | Pulsdruck | 48 | 30 | 64 | → |
   | MAD | 100 | 86 | 115 | ↑ |

   Trend cells use icons + a textual label for accessibility.

4. **Classification card** — distribution bar showing share of readings by
   category, with a legend. Tapping the card opens `/status`.

5. **BMI card** — shown only when `bmi` on the `StatisticsResult` is non-null
   (i.e., height is set in settings **and** at least one weight entry exists
   in the period).
   - Row 1: current BMI (one decimal) + category label
     (Untergewicht / Normalgewicht / Übergewicht / Adipositas).
   - Row 2: average BMI in period.
   - Row 3: subdued helper text: "Berechnet aus Größe (Profil) und Gewicht."
   - No medical advice text. No "you should lose weight". No link between
     BMI and blood pressure category in the UI copy.
   - If height is not set, the card is replaced by a small inline link:
     "Größe im Profil eintragen, um BMI zu berechnen."

6. **Insights card** — up to 3 rule-based insight rows.

## Status / classification (`/status`)

- Distribution chart (donut or stacked bar) showing all categories in the
  current period.
- Legend with category name and count.
- An expandable "Was bedeuten die Kategorien?" panel that explains each
  category in neutral language with thresholds.
- Persistent disclaimer at the bottom of the screen — text in
  [12-privacy-and-medical.md](12-privacy-and-medical.md).

## Export (`/export`)

- Period picker (defaults to the last period viewed in Statistics).
- Format selection: CSV / PDF (radio).
- Options:
  - CSV: include context fields? (default yes)
  - PDF: include chart image? (default yes)
- Generate button ⇒ progress indicator ⇒ system share sheet via `share_plus`.
- Below: "Letzte Exporte" list from `export_history` (re-share or delete).

## Settings (`/settings`)

Grouped list:

- **Profil**: Größe (cm), optional. Numeric input, range 80–250, validated
  on save. Empty input clears the value. Helper text:
  "Wird für die BMI-Berechnung verwendet."
- **Erscheinungsbild**: Theme (system/hell/dunkel), Sprache.
- **Einheiten**: Gewicht (kg/lb).
- **Zeitfenster** (time-slot chart):
  - **Fensterbreite** dropdown: 1 h (default), 2 h, 3 h.
  - **Slot-Start automatisch wählen** toggle. On by default.
  - **Fester Slot-Start** time picker, enabled only when the toggle is off.
    Saves as minutes-since-midnight; constrained so `start + width ≤ 24:00`.
- **Erinnerungen**: opens `/settings/reminders`.
- **Daten**: Export, alle Daten löschen (with double confirmation).
- **Datenschutz & rechtliche Hinweise**: opens `/settings/privacy`.
- **Integrationen** (future, all disabled in MVP — show as inert rows with
  a "Bald verfügbar" tag):
  - Health Connect
  - Fitbit / Google Health
  - KI-Zusammenfassung (LLM)
- **Über die App**: version, build number, license credits.

## Reminder settings (`/settings/reminders`)

- Master toggle for reminders.
- List of configured reminders, each row: time, weekdays summary, enabled toggle.
- "Erinnerung hinzufügen" ⇒ add screen / bottom sheet: time picker,
  weekday checkboxes, optional label.

## Privacy info (`/settings/privacy`)

- Static, localized markdown-style content.
- Includes the medical disclaimer in full.
- Explains: data is local, no network calls, export is the user's
  responsibility.

## First-launch disclaimer dialog

- Shown on app start when
  `settings.disclaimerAcceptedVersion == null` OR
  `settings.disclaimerAcceptedVersion < kDisclaimerVersion`
  (see [02-domain-model.md](02-domain-model.md)).
- Modal, non-dismissable except by the explicit "Verstanden" / "Got it" /
  "明白了" button. No back gesture, no scrim tap to dismiss.
- Renders the full disclaimer string from i18n.
- On accept, writes `disclaimerAcceptedVersion = kDisclaimerVersion` to
  `app_settings` and dismisses.
- A "Erneut anzeigen" button in `/settings/privacy` resets
  `disclaimerAcceptedVersion` to `null` so the user can re-read it.

## Empty states & errors

Every screen with async data uses `AppLoadingView`, `AppEmptyState`, and
`AppErrorView` from `core/widgets/`. Never use raw `CircularProgressIndicator`
or plain `Text("Error")` in feature code.

## Animations

- Subtle. No celebratory animations on save.
- Use Material defaults (200–300 ms) for transitions.

## Accessibility

- All interactive elements have semantic labels.
- Minimum hit target 48×48 dp.
- Color is never the only carrier of meaning (always pair with an icon or
  label, especially in the classification view).
- Numeric values use a tabular figures font feature where available.
