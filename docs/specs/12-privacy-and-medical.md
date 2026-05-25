# 12 — Privacy & Medical Rules

This spec is binding for **every** feature. When in doubt, it overrides
the others.

## Medical rules

This app is a personal tracker. It is **not** a medical device.

The app **must not**:

- Diagnose any condition (e.g., "Sie haben Bluthochdruck").
- Recommend medication changes, dosages, or schedules.
- Recommend a treatment, exercise, or diet plan.
- Tell the user a value is "safe", "dangerous", "normal for them".
- Use alarming language: *kritisch*, *gefährlich*, *alarming*, *danger*.
- Imply medical certification (CE, FDA, MDR, ISO 13485…).
- Claim to measure blood pressure on its own.
- Show emergency contact prompts based on values.
- Compute or display "cardiovascular risk" scores.

The app **may**:

- Show neutral category labels (e.g., "hochnormal", "Bluthochdruck Grad 1")
  as a description of the entered value range, with thresholds shown.
- Render trend arrows over a chosen period.
- Suggest a user might want to talk to a doctor about their data — only
  as part of the standard disclaimer, never tied to a specific reading.

### Disclaimer text (canonical)

Show on:

- Status / classification screen (persistent).
- Last page of the PDF report.
- Privacy info screen.
- Once on first launch, in an accept dialog (user taps "Verstanden").

**Deutsch:**

> Diese App dient nur der persönlichen Dokumentation und Information.
> Sie ist kein Medizinprodukt und bietet keine Diagnose, Behandlung oder
> medizinische Beratung. Bitte wenden Sie sich bei medizinischen Fragen
> an qualifiziertes medizinisches Fachpersonal.

**English:**

> This app is for personal tracking and informational purposes only. It
> is not a medical device and does not provide diagnosis, treatment, or
> medical advice. Please consult a qualified healthcare professional for
> medical decisions.

These strings live in the ARB files and are referenced by widget code
via the generated `AppLocalizations`. Do not re-type them inline.

## Privacy principles

- **Local-first.** All health data lives in the device's app-private
  SQLite database. No network calls in the MVP.
- **No accounts.** No login. No identifier created server-side.
- **No analytics SDKs.** No Firebase Analytics, no Mixpanel, no
  Sentry/Crashlytics in the MVP. Crash reports rely on the OS-level
  store reporting, which never receives health data.
- **No advertising SDKs.** Ever.
- **No background data collection.** The app does no work in the
  background other than scheduled local notifications.
- **No third-party share by default.** The user explicitly invokes the
  share sheet for export; nothing leaves the device otherwise.

## Storage & logging

- Health values (systolic, diastolic, pulse, weight) **must not appear**
  in any log line (`debugPrint`, `print`, `logger.d`, ...).
- Error logs may include error class names, stack traces, and the IDs
  of affected rows — but not field values.
- Notes and medication notes are user-authored free text and are
  treated as **at least as sensitive** as numeric values. Same rule:
  never log.
- `flutter_secure_storage` is reserved for future secrets (e.g., a
  user-provided LLM API key). The MVP writes nothing there.

## Data lifecycle

- **Create / read / update / delete** all happen locally and immediately.
- **Export** is initiated by the user. Files are written to the app's
  documents directory and offered via the system share sheet. The app
  never auto-uploads.
- **Delete all data** is available from Settings → Daten. Two-step
  confirmation:
  1. "Wirklich löschen?" dialog.
  2. Second confirmation typing or long-press.
  Effect: clears all readings, reminders, export history, and resets
  settings to defaults. Implementation (binding):
  - In a single Drift transaction:
    `DELETE FROM blood_pressure_readings; DELETE FROM reminders;
     DELETE FROM export_history; DELETE FROM app_settings;`.
  - Re-seed the `app_settings` defaults (locale, themeMode, etc.) so the
    next launch behaves like a fresh install.
  - Then run `PRAGMA wal_checkpoint(TRUNCATE);` and `VACUUM;` to shrink
    the file and clear free-list pages so deleted rows are not
    recoverable via filesystem inspection.
  - Do **not** delete the SQLite file while the connection is open; on
    Windows/Android this corrupts the running handle.
  - Cancel and re-schedule local notifications afterward (no reminders
    survive the delete).
- **Uninstall** removes the app-private directory and the SQLite file
  with it. Document this behavior in the privacy info screen.

## Permissions

- **Notifications:** request only when the user first enables a reminder.
  Don't prompt on launch.
- **Storage:** none needed — `share_plus` writes to the app sandbox.
- **Sensors / camera / location / contacts:** never requested.
- On iOS, all permission usage descriptions in `Info.plist` must explain
  the user-visible reason (only notifications applies to the MVP).

## Security

- **No hard-coded API keys, secrets, or tokens** in source control.
- **No remote endpoints** are referenced in MVP code, even commented
  out. Disabled gateways throw; they do not point at URLs.
- **TLS, certificates, network security configs**: not relevant to the
  MVP since there is no networking. Do not pre-configure them in a way
  that would silently allow future cleartext traffic.
- **Dependencies** are listed in [01-architecture.md](01-architecture.md).
  Anything added must be reviewed for: maintenance status, license,
  permissions it pulls in, and whether it phones home.

## Consent (future)

Any future feature that crosses a privacy boundary (LLM call, Health
Connect/HealthKit, cloud sync) requires:

- An opt-in screen the user must positively confirm.
- Clear text on what is sent, where, and for how long it is retained.
- The ability to turn the feature off again, which also deletes any
  related cached data on the device.

These consent surfaces are not part of the MVP, but the **disabled
gateways** in [10-future-integrations.md](10-future-integrations.md) are
the only allowed integration points.

## What to do when in doubt

Default to **less data, less language, less inference**. If a feature
would benefit users by saying more about their health, but risks
crossing into medical advice, prefer to show the raw numbers and let the
user (or their doctor) interpret them.
