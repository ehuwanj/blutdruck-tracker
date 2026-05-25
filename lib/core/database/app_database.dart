import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [BloodPressureReadings, Reminders, AppSettingsRows, ExportHistory],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  factory AppDatabase.open() {
    return AppDatabase(
      LazyDatabase(() async {
        final directory = await getApplicationDocumentsDirectory();
        final file = File(p.join(directory.path, 'blutdruck.sqlite'));
        return NativeDatabase.createInBackground(file);
      }),
    );
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await customStatement(
        'CREATE INDEX idx_readings_measured_at '
        'ON blood_pressure_readings(measured_at DESC);',
      );
      await customStatement(
        'CREATE INDEX idx_readings_source '
        'ON blood_pressure_readings(source);',
      );
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );
}

@DataClassName('BloodPressureReadingRow')
class BloodPressureReadings extends Table {
  @override
  String get tableName => 'blood_pressure_readings';

  TextColumn get id => text()();
  IntColumn get measuredAt => integer().named('measured_at')();
  IntColumn get systolic => integer()();
  IntColumn get diastolic => integer()();
  IntColumn get pulse => integer().nullable()();
  RealColumn get weightKg => real().named('weight_kg').nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get arm => text().nullable()();
  TextColumn get medicationNote => text().named('medication_note').nullable()();
  IntColumn get stressLevel => integer().named('stress_level').nullable()();
  TextColumn get source => text()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ReminderRow')
class Reminders extends Table {
  TextColumn get id => text()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  IntColumn get weekdaysMask => integer().named('weekdays_mask')();
  BoolColumn get enabled => boolean()();
  TextColumn get label => text().nullable()();
  IntColumn get createdAt => integer().named('created_at')();
  IntColumn get updatedAt => integer().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AppSettingRow')
class AppSettingsRows extends Table {
  @override
  String get tableName => 'app_settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DataClassName('ExportHistoryRow')
class ExportHistory extends Table {
  @override
  String get tableName => 'export_history';

  TextColumn get id => text()();
  TextColumn get format => text()();
  IntColumn get periodFrom => integer().named('period_from')();
  IntColumn get periodTo => integer().named('period_to')();
  TextColumn get filePath => text().named('file_path')();
  IntColumn get createdAt => integer().named('created_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
