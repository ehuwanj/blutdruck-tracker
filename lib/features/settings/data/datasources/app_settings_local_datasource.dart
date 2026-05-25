import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:blutdruck_tracker/features/settings/data/mappers/app_settings_mapper.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';

abstract class AppSettingsLocalDataSource {
  Future<String?> readValue(String key);
  Future<void> writeValue(String key, String? value);
  Future<AppSettings> read();
  Future<void> write(AppSettings settings);
}

class DriftAppSettingsLocalDataSource implements AppSettingsLocalDataSource {
  const DriftAppSettingsLocalDataSource(
    this.database, {
    this.mapper = const AppSettingsMapper(),
  });

  final AppDatabase database;
  final AppSettingsMapper mapper;

  @override
  Future<String?> readValue(String key) async {
    final row = await (database.select(
      database.appSettingsRows,
    )..where((table) => table.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  @override
  Future<void> writeValue(String key, String? value) {
    if (value == null) {
      return (database.delete(
        database.appSettingsRows,
      )..where((table) => table.key.equals(key))).go();
    }
    return database
        .into(database.appSettingsRows)
        .insertOnConflictUpdate(AppSettingRow(key: key, value: value));
  }

  @override
  Future<AppSettings> read() async {
    final rows = await database.select(database.appSettingsRows).get();
    return mapper.fromRows(rows);
  }

  @override
  Future<void> write(AppSettings settings) async {
    final rows = mapper.toRows(settings);
    await database.transaction(() async {
      await database.delete(database.appSettingsRows).go();
      for (final row in rows) {
        await database.into(database.appSettingsRows).insert(row);
      }
    });
  }
}
