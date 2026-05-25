# 00 — Project Overview

## Vision

A calm, trustworthy mobile app for personal blood pressure tracking. Local-first,
private by default, no backend required for the MVP. Built with Flutter so that
iOS support remains realistic without a rewrite.

## Target user

A person who measures blood pressure regularly — typically with a home cuff —
and wants to:

- Log readings quickly after each measurement.
- See whether values are trending up, down, or stable.
- Share a clean report with a doctor on demand.
- Keep all data on their own device.

## Platforms

- **Primary:** Android (Android 8 / API 26 and up).
- **Secondary, structurally supported:** iOS. iOS-specific APIs (HealthKit,
  notifications behavior) are not implemented in the MVP but the tech stack
  must not block them.

## MVP scope — in

| Area | Included in MVP |
|------|-----------------|
| Manual reading entry | Yes — full form with optional context fields |
| User profile — height (cm) | Yes — single value in settings, used for BMI |
| Local storage | Yes — Drift + SQLite |
| Overview dashboard | Yes — latest reading + charts |
| Time-slot chart | Yes — auto-picked slot (default 1 h wide), configurable in settings |
| History list | Yes — grouped by date, edit, delete |
| Statistics | Yes — min/max/avg, pulse pressure, MAP, trend, BMI |
| Classification view | Yes — distribution + explanation |
| Local reminders | Yes — `flutter_local_notifications` |
| CSV export | Yes |
| PDF export | Yes — simple report with disclaimer |
| Localization | Yes — German + English + Chinese|
| Dark mode | Yes |
| Disabled future integration interfaces | Yes — LLM, Health Connect, and Fitbit / Google Health gateways |

## MVP scope — out

These are deliberately excluded from the MVP:

- Online LLM calls (insight generation).
- Health Connect (Android) and HealthKit (iOS) integration.
- Fitbit / Google Health (Fitbit Web API) integration — sleep, activity,
  resting heart rate from a Fitbit watch is a future extension only.
- Cloud sync, accounts, login, multi-device.
- Analytics SDKs.
- Advertising SDKs.
- Automatic measurement from device sensors. The app never claims to *measure*
  blood pressure — only to *track* user-entered values.
- Diagnosis, treatment suggestions, or medication recommendations.

## Future extensions (designed for, not built)

- LLM-based insight summaries via a proxy backend (opt-in, consent-gated).
- Health Connect (Android) and HealthKit (iOS) read/write.
- Fitbit / Google Health integration via the Fitbit Web API (OAuth 2.0 PKCE),
  read-only, used to enrich BP context with sleep, activity, and resting
  heart rate from a connected Fitbit watch. Distinct from on-device
  Health Connect.
- Optional cloud sync or shared accounts.

These are represented in the MVP as **disabled gateway interfaces** under
`lib/features/integrations/` so that adding them later is an additive change.

## Success criteria

The MVP is considered done when:

- A user can add, edit, delete readings; nothing is lost across app restarts.
- The overview screen shows the latest reading and at least a 30-day chart.
- The overview screen shows the time-slot chart for the auto-detected
  most-frequent slot, with a header explaining the slot range and source.
  Slot width is configurable in settings (default 1 h).
- The user can set their height (cm) in settings; BMI and BMI category
  appear in the statistics screen when at least one weight is present in
  the selected period.
- The statistics screen renders min/max/avg, pulse pressure, MAP, and a trend
  indicator for a chosen period.
- The history screen lists readings grouped by date with edit + delete.
- The classification screen shows the distribution of readings by category
  and a clear non-diagnostic disclaimer.
- CSV export produces a file that round-trips into a spreadsheet cleanly.
- PDF export produces a 1–2 page report with summary, list, and disclaimer.
- Reminders fire at the user's chosen times.
- All UI strings are externalized; German, English and Chinese are present.
- `flutter analyze` is clean. All unit tests pass.
- No remote network calls happen in any code path.

## Non-goals (worth stating)

- Medical-grade accuracy claims.
- Replacing professional medical advice.
- Encouraging users to act on the data in a specific medical way.
- Gamification (streaks, badges, social sharing).
