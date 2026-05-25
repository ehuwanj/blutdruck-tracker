# 08 — Export & Reminders

## Export — general

- Files are written to the app's documents directory and shared via the
  system share sheet (`share_plus`). The user picks where to save.
- File names: `blutdruck_{from}_{to}.{ext}` using ISO-8601 dates,
  e.g. `blutdruck_2026-04-01_2026-04-30.csv`.
- Generation runs on the main isolate for the MVP. If a single export
  takes > 200 ms in practice, move to `compute()`.
- Last 5 generated files are recorded in `export_history` (see
  [03-database.md](03-database.md)) so the user can re-share without
  regenerating.

## CSV export

Service: `CsvExportService` in `features/export/domain/services/`.

- Encoding: UTF-8 **with BOM** (Excel-on-Windows compatibility).
- Separator: `;` (German locale convention). Configurable constant.
- Line ending: `\r\n` (broadest compatibility).
- Header row in the user's current language.

Columns (in order). Header text follows the active locale; the column
order is identical across all three locales so a CSV written in DE opens
identically in EN/ZH and vice versa.

| # | EN | DE | ZH | Notes |
|---|----|----|----|-------|
| 1 | `Date` | `Datum` | `日期` | ISO local date `YYYY-MM-DD` |
| 2 | `Time` | `Uhrzeit` | `时间` | local time `HH:MM` |
| 3 | `Systolic` | `Systolisch` | `收缩压` | integer |
| 4 | `Diastolic` | `Diastolisch` | `舒张压` | integer |
| 5 | `Pulse` | `Puls` | `脉搏` | integer or empty |
| 6 | `PulsePressure` | `Pulsdruck` | `脉压` | computed |
| 7 | `MAP` | `MAD` | `MAP` | computed, integer |
| 8 | `Weight_kg` | `Gewicht_kg` | `体重_kg` | decimal point `.`, one decimal |
| 9 | `Arm` | `Arm` | `手臂` | localized label (`left`/`right`/`links`/`rechts`/`左`/`右`) or empty |
| 10 | `Stress` | `Stress` | `压力` | 1..5 or empty |
| 11 | `Medication` | `Medikament` | `用药` | trimmed string or empty |
| 12 | `Note` | `Notiz` | `备注` | trimmed string or empty |
| 13 | `Category` | `Kategorie` | `分类` | classifier output, localized |
| 14 | `Source` | `Quelle` | `来源` | enum `name`: `manual` / `import` / `healthConnect` (untranslated, stable for round-trips) |

Body position was removed during spec review and has no CSV column.

- Field escaping: values containing the separator, `"`, or newline are
  wrapped in `"` and inner `"` doubled.
- Decimal separator is **always** `.` regardless of locale, to make the
  file machine-readable.

## PDF export

Service: `PdfReportService` in `features/export/domain/services/`. Uses the
`pdf` package; preview via `printing` is optional and not required by the
MVP.

Layout: A4 portrait, single document, header + body + footer per page.

### Page 1

- Header: app name, period (e.g. "1. Mai – 30. Mai 2026"), generation
  timestamp in local time.
- Summary card:
  - Number of entries.
  - Min / mittel / max for systolic, diastolic, pulse, pulse pressure, MAP.
  - Trend arrows + text.
- Distribution row:
  - Category counts as a horizontal bar.

### Page 2+

- A table of all readings in the period, newest first. Columns: date,
  time, sys/dia, pulse, kategorie, notiz (truncated to ~40 chars).
- Page breaks handled automatically by the `pdf` package's `MultiPage`.

### Footer (every page)

- Page number.
- Disclaimer one-liner: "Diese Auswertung ersetzt keine ärztliche
  Beurteilung." (DE) / "This report does not replace medical advice." (EN).

### Full disclaimer

Render the full disclaimer (see [12-privacy-and-medical.md](12-privacy-and-medical.md))
as a small block on the **last page**.

### Charts in the PDF

For the MVP, include a **rendered chart image** of the systolic + diastolic
line over the period on page 1:

1. Build the chart with `fl_chart` inside a `RepaintBoundary` off-screen
   (use `OverlayPortal` or a fixed-size `RenderRepaintBoundary` in a
   short-lived `pumpFrame` cycle — implementation detail).
2. Capture to PNG via `boundary.toImage(pixelRatio: 2.0)` →
   `image.toByteData(format: ImageByteFormat.png)`.
3. Embed via `pw.MemoryImage(bytes)`.

If chart generation throws (e.g., no data), embed a small text block
instead — never crash PDF generation. There is no fallback to a
`pdf`-package-drawn sparkline; the implementation either embeds the
captured PNG or the text block. This keeps the path linear and testable.

### Platform: Android FileProvider config

`share_plus` writes files into the app's documents directory and exposes
them to the share sheet via a `FileProvider`. Two files must exist:

- `android/app/src/main/AndroidManifest.xml` — `<provider>` entry for
  `androidx.core.content.FileProvider` with authority
  `${applicationId}.fileprovider`.
- `android/app/src/main/res/xml/file_paths.xml` — declares the shared
  paths. Minimum content:

  ```xml
  <?xml version="1.0" encoding="utf-8"?>
  <paths>
    <files-path name="exports" path="exports/" />
    <cache-path name="cache" path="" />
  </paths>
  ```

Without these two files, the first export from a real Android build
crashes the share sheet. Add them as part of the initial project setup
(step 0 in the workflow), not when wiring export.

## Local reminders

Library: `flutter_local_notifications` + `timezone` for tz-aware scheduling.

Initialization:

- Initialize the plugin and tz database at app start (before the first
  `runApp`).
- Request notification permission on Android 13+ and iOS the first time
  the user enables reminders, not at app launch.

### Platform configuration (binding)

- **Android channel:**
  - Channel id: `reminders_default`
  - Channel name (DE): `Erinnerungen` · (EN): `Reminders` · (ZH): `提醒`
  - Importance: `Importance.defaultImportance` (no heads-up, no full-screen)
  - Sound: default. Vibration: default. LED: off.
  - Channel is created once at plugin initialization.
- **Android small icon:**
  - Drawable name: `ic_notification`
  - White silhouette PNG / vector drawable, declared in
    `android/app/src/main/res/drawable-*/`.
  - **Do not** reuse the launcher icon — Android renders it as a white
    square in the notification bar.
- **iOS:** standard `DarwinInitializationSettings` defaults. `Info.plist`
  needs `NSUserNotificationsUsageDescription` (English string; localized
  copies live in `.lproj` directories when iOS support is enabled).

### Domain

```dart
abstract class ReminderScheduler {
  Future<void> scheduleAll(List<Reminder> reminders);
  Future<void> cancelAll();
  Future<bool> requestPermission();
  Future<bool> hasPermission();
}
```

Implementation: `LocalNotificationReminderScheduler` in
`features/reminders/data/`.

### Scheduling rules

- One notification per (reminder × weekday) is scheduled in advance for
  the next 14 days. Re-scheduling happens:
  - When the app starts.
  - When a reminder is added/edited/deleted.
  - When the device timezone changes (best effort).
- Notification body in the user's current locale, e.g. "Zeit für eine
  Blutdruckmessung." Tap action opens the reading entry screen.
- Notification IDs are stable per `(reminder.id, weekday, index)` so
  re-scheduling replaces rather than duplicates.

### Quiet defaults

- Default sound. No high-priority/heads-up alarms.
- No vibration loop. A single default notification only.

### Failure handling

- If permission is denied, the reminder list stays editable but a banner
  explains that no notifications will fire. Don't repeatedly re-prompt.
