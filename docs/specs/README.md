# Blutdruck Tracker — Design Specifications

This folder contains the design specifications for the Blutdruck Tracker app.
Each file covers one focused area. Read them in order, or jump to the area you
need to review.

These specs are the source of truth for implementation. They expand on
[`.claude/CLAUDE.md`](../../.claude/CLAUDE.md) — when the two disagree,
update both to match.

## Reading order

| # | File | Purpose |
|---|------|---------|
| 00 | [Project overview](00-project-overview.md) | Vision, target user, MVP scope, non-goals, success criteria |
| 01 | [Architecture](01-architecture.md) | Clean Architecture layers, folder structure, dependencies, layering rules |
| 02 | [Domain model](02-domain-model.md) | Entities, enums, value objects, validation ranges |
| 03 | [Database](03-database.md) | Drift schema, tables, indexes, migrations, date handling |
| 04 | [Business logic](04-business-logic.md) | Statistics math, classification, trend analysis, validation |
| 05 | [Screens & navigation](05-screens.md) | All screens, content, interactions, go_router routes |
| 06 | [Design system](06-design-system.md) | Theme, colors, typography, shared widgets, accessibility |
| 07 | [State management](07-state-management.md) | Riverpod provider layering, async patterns |
| 08 | [Export & reminders](08-export-and-reminders.md) | CSV, PDF, local notifications |
| 09 | [Localization](09-localization.md) | i18n setup, German/English terminology |
| 10 | [Future integrations](10-future-integrations.md) | LLM and Health Connect/HealthKit gateway interfaces |
| 11 | [Testing](11-testing.md) | Unit, widget, integration test requirements |
| 12 | [Privacy & medical rules](12-privacy-and-medical.md) | Disclaimers, privacy principles, security rules |

## How to use these specs

1. Review each spec and add corrections/supplements inline.
2. Mark resolved questions and decisions.
3. Once approved, ask Claude to implement against a specific spec
   (e.g. "implement [03-database.md](03-database.md)").
4. Keep specs in sync when implementation reveals better designs.

## Status

| Spec | Status |
|------|--------|
| 00–12 | Draft — pending user review |
