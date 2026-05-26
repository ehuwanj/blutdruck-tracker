/// Wipes every user-data table and reclaims free pages. Kept as an
/// abstract interface (not a typedef) so tests can swap in a mock that
/// records calls without touching Drift.
// ignore: one_member_abstracts
abstract class DataWiper {
  /// Deletes every row from `blood_pressure_readings`, `reminders`,
  /// `export_history`, and `app_settings` inside a single transaction,
  /// then runs `PRAGMA wal_checkpoint(TRUNCATE)` and `VACUUM` so deleted
  /// rows aren't recoverable via filesystem inspection. See
  /// docs/specs/12-privacy-and-medical.md §Data lifecycle.
  Future<void> wipeAll();
}
