import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:blutdruck_tracker/features/settings/domain/services/data_wiper.dart';

/// Drift implementation of [DataWiper]. All deletes run in a single
/// transaction so the table set is consistent across failures; the
/// post-transaction `wal_checkpoint(TRUNCATE)` + `VACUUM` clears free-list
/// pages so deleted rows are not recoverable via filesystem inspection.
class DriftDataWiper implements DataWiper {
  const DriftDataWiper(this.database);

  final AppDatabase database;

  @override
  Future<void> wipeAll() async {
    await database.transaction(() async {
      await database.delete(database.bloodPressureReadings).go();
      await database.delete(database.reminders).go();
      await database.delete(database.exportHistory).go();
      await database.delete(database.appSettingsRows).go();
    });
    await database.customStatement('PRAGMA wal_checkpoint(TRUNCATE);');
    await database.customStatement('VACUUM;');
  }
}
