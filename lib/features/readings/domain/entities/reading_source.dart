/// Provenance of a blood pressure reading. No `healthKit` (no iOS BP source
/// in scope) and no `fitbit` (Fitbit is a read-only fitness-context gateway,
/// not a BP source).
enum ReadingSource {
  /// Entered by the user via the reading form.
  manual,

  /// CSV import (future).
  import,

  /// On-device Health Connect (Android, future).
  healthConnect,
}
