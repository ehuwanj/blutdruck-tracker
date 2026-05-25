# 03 — Database

## Engine

- **Drift** on top of **SQLite** (`sqlite3_flutter_libs`).
- Single database file per app install, stored under
  `path_provider.getApplicationDocumentsDirectory()`.
- File name: `blutdruck.sqlite`.
- Foreign keys are enabled on open: `PRAGMA foreign_keys = ON`.

## Layering

The database is referenced **only by data-layer classes**. UI and domain
must not import `app_database.dart` directly. All access goes through
datasources → repositories → use cases.

```
UI ─▶ Provider ─▶ UseCase ─▶ Repository ─▶ Datasource ─▶ Drift DAO
```

## Tables

### `blood_pressure_readings`

| Column | Type | Null | Notes |
|--------|------|------|-------|
| `id` | TEXT | PK | UUID v4 |
| `measured_at` | INTEGER | NOT NULL | Unix milliseconds, UTC |
| `systolic` | INTEGER | NOT NULL | mmHg |
| `diastolic` | INTEGER | NOT NULL | mmHg |
| `pulse` | INTEGER | NULL | bpm |
| `weight_kg` | REAL | NULL | kilograms, stored canonical |
| `note` | TEXT | NULL | trimmed, ≤ 500 chars |
| `arm` | TEXT | NULL | enum `MeasurementArm.name` (`left`/`right`); NULL = unspecified |
| `medication_note` | TEXT | NULL | trimmed, ≤ 200 chars |
| `stress_level` | INTEGER | NULL | 1..5 |
| `source` | TEXT | NOT NULL | enum `ReadingSource.name` |
| `created_at` | INTEGER | NOT NULL | Unix ms, UTC |
| `updated_at` | INTEGER | NOT NULL | Unix ms, UTC |

Indexes:

- `idx_readings_measured_at` on `measured_at DESC`.
- `idx_readings_source` on `source`.

### `reminders`

| Column | Type | Null | Notes |
|--------|------|------|-------|
| `id` | TEXT | PK | UUID v4 |
| `hour` | INTEGER | NOT NULL | 0..23, local time |
| `minute` | INTEGER | NOT NULL | 0..59 |
| `weekdays_mask` | INTEGER | NOT NULL | bitmask, bit 0 = Monday … bit 6 = Sunday |
| `enabled` | INTEGER | NOT NULL | 0/1 |
| `label` | TEXT | NULL | |
| `created_at` | INTEGER | NOT NULL | |
| `updated_at` | INTEGER | NOT NULL | |

### `app_settings`

Single-row key/value table for simplicity.

| Column | Type | Null | Notes |
|--------|------|------|-------|
| `key` | TEXT | PK | see reserved keys below |
| `value` | TEXT | NOT NULL | string serialization; bool encoded as `"true"`/`"false"` |

Reserved keys:

| Key | Type | Notes |
|-----|------|-------|
| `locale` | string | enum `name`: `system`/`en`/`de`/`zh` |
| `themeMode` | string | enum `name`: `system`/`light`/`dark` |
| `weightUnit` | string | enum `name`: `kg`/`lb` |
| `remindersEnabled` | bool string | `true`/`false` |
| `heightCm` | decimal string | profile height; absent row when unset; validated `80..250` on write |
| `timeSlotWidthMinutes` | int string | default `"60"`; allowed `"60"`, `"120"`, `"180"` |
| `pinnedTimeSlotStartMinutes` | int string | `"0".."1439"`; absent row = auto-detect |
| `disclaimerAcceptedVersion` | int string | last accepted disclaimer version; absent = never accepted |
| `lastExportDirectoryHint` | string | optional UX hint |

### Value serialization rules

These rules apply uniformly across all `app_settings` rows so the mapper
can be a single small function:

- **Bool** → `"true"` / `"false"`.
- **Enum** → the Dart `enum.name` string. Unknown strings on read fall
  back to the documented default for that key (e.g., unknown `themeMode`
  → `system`).
- **Int** → base-10 string, no leading zeros, no separators.
- **Decimal** → `.` decimal separator, no thousands separators, **regardless
  of locale**. The setting layer is not locale-formatted; UI does its own
  formatting via `intl`.
- **Absent row** → the field is unset / null / falls back to the documented
  default. Writing `null` deletes the row; writing any value upserts it.

Height is **not** a column on `blood_pressure_readings` — it is part of the
user profile and lives here. This decision is recorded in
[02-domain-model.md](02-domain-model.md).

### `export_history` (optional, included)

Tracks the last few generated exports so the UI can show a "recent exports"
list and so PDF/CSV writes can be re-shared without regenerating.

| Column | Type | Null | Notes |
|--------|------|------|-------|
| `id` | TEXT | PK | UUID |
| `format` | TEXT | NOT NULL | `csv` or `pdf` |
| `period_from` | INTEGER | NOT NULL | UTC ms |
| `period_to` | INTEGER | NOT NULL | UTC ms |
| `file_path` | TEXT | NOT NULL | absolute path on device |
| `created_at` | INTEGER | NOT NULL | |

### `insight_cache` (reserved, MVP unused)

Schema reserved for caching LLM responses post-MVP. Not created until that
feature ships. Keep the migration slot free.

## Migrations

- Migrations are explicit, numbered, and live in `core/database/migrations/`.
- The Drift `schemaVersion` starts at `1`.
- Every schema change bumps `schemaVersion` and adds a migration function.
- Each migration has a unit test that builds a v(n-1) database with fixture
  rows, runs the migration, and asserts the v(n) shape and data.
- **Never** modify an existing migration after it has shipped to a build that
  reached a real device. Append a new one instead.

## Date handling

- Persist timestamps as `int` Unix milliseconds **UTC** (`DateTime.toUtc().millisecondsSinceEpoch`).
- Convert to local time only at the presentation layer.
- A reading's "day" for grouping in the UI is the *local* day of its
  `measuredAt` — implement via a date helper, not via SQL.

## Soft delete

Not used in the MVP. Deletes are hard. If undo is needed later, add a
`deleted_at` column in a migration and update the repository contract.

## Backups

Out of scope for the MVP. The CSV/PDF export is the user's manual backup
path. Document this in the privacy info screen.

## Datasource contract example

```dart
abstract class ReadingLocalDataSource {
  Future<void> upsert(ReadingRow row);
  Future<void> deleteById(String id);
  Future<ReadingRow?> findById(String id);
  Stream<List<ReadingRow>> watchAll();
  Stream<List<ReadingRow>> watchByRange(DateTime fromUtc, DateTime toUtc);
  Future<ReadingRow?> findLatest();
}
```

Streams are preferred over one-shot reads for any screen that should react to
changes (overview, history, statistics).
