import 'package:blutdruck_tracker/core/database/app_database.dart' as db;
import 'package:blutdruck_tracker/features/readings/data/mappers/reading_mapper.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/blood_pressure_reading.dart';
import 'package:blutdruck_tracker/features/readings/domain/entities/reading_source.dart';
import 'package:blutdruck_tracker/features/settings/data/mappers/app_settings_mapper.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/locale_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/theme_mode_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/weight_unit.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('schema v1', () {
    late db.AppDatabase database;

    setUp(() {
      database = db.AppDatabase(NativeDatabase.memory());
    });

    tearDown(() => database.close());

    test('creates expected tables, columns, indexes, and pragmas', () async {
      await database.customSelect('SELECT 1').get();

      expect(await _columns(database, 'blood_pressure_readings'), {
        'id': 'TEXT|required|pk',
        'measured_at': 'INTEGER|required',
        'systolic': 'INTEGER|required',
        'diastolic': 'INTEGER|required',
        'pulse': 'INTEGER|nullable',
        'note': 'TEXT|nullable',
        'source': 'TEXT|required',
        'created_at': 'INTEGER|required',
        'updated_at': 'INTEGER|required',
      });
      expect(await _columns(database, 'reminders'), {
        'id': 'TEXT|required|pk',
        'hour': 'INTEGER|required',
        'minute': 'INTEGER|required',
        'weekdays_mask': 'INTEGER|required',
        'enabled': 'INTEGER|required',
        'label': 'TEXT|nullable',
        'created_at': 'INTEGER|required',
        'updated_at': 'INTEGER|required',
      });
      expect(await _columns(database, 'app_settings'), {
        'key': 'TEXT|required|pk',
        'value': 'TEXT|required',
      });
      expect(await _columns(database, 'export_history'), {
        'id': 'TEXT|required|pk',
        'format': 'TEXT|required',
        'period_from': 'INTEGER|required',
        'period_to': 'INTEGER|required',
        'file_path': 'TEXT|required',
        'created_at': 'INTEGER|required',
      });

      expect(await _indexes(database, 'blood_pressure_readings'), {
        'sqlite_autoindex_blood_pressure_readings_1',
        'idx_readings_measured_at',
        'idx_readings_source',
      });

      final pragma = await database
          .customSelect('PRAGMA foreign_keys;')
          .getSingle();
      expect(pragma.data['foreign_keys'], 1);
    });
  });

  group('ReadingMapper', () {
    test('round-trips row and entity', () {
      const mapper = ReadingMapper();
      final entity = BloodPressureReading(
        id: 'reading-1',
        measuredAt: DateTime.utc(2026, 5, 25, 7, 30),
        systolic: 132,
        diastolic: 84,
        pulse: 72,
        note: '  after coffee  ',
        source: ReadingSource.manual,
        createdAt: DateTime.utc(2026, 5, 25, 7, 31),
        updatedAt: DateTime.utc(2026, 5, 25, 7, 32),
      );

      final row = mapper.toRow(entity);
      final roundTrip = mapper.toEntity(row);

      expect(row.measuredAt, entity.measuredAt.millisecondsSinceEpoch);
      expect(row.note, 'after coffee');
      expect(roundTrip, entity.copyWith(note: 'after coffee'));
    });

    test('handles unknown source defensively without PHI', () {
      final warnings = <String>[];
      final mapper = ReadingMapper(warn: warnings.add);
      final row = db.BloodPressureReadingRow(
        id: 'row-1',
        measuredAt: DateTime.utc(2026, 5, 25).millisecondsSinceEpoch,
        systolic: 150,
        diastolic: 95,
        pulse: 80,
        note: 'private note',
        source: 'surprise',
        createdAt: DateTime.utc(2026, 5, 25).millisecondsSinceEpoch,
        updatedAt: DateTime.utc(2026, 5, 25).millisecondsSinceEpoch,
      );

      final entity = mapper.toEntity(row);

      expect(entity.source, ReadingSource.manual);
      expect(warnings, hasLength(1));
      expect(warnings.single, contains('surprise'));
      expect(warnings.single, isNot(contains('row-1')));
      expect(warnings.single, isNot(contains('150')));
      expect(warnings.single, isNot(contains('private')));
    });
  });

  group('AppSettingsMapper', () {
    const mapper = AppSettingsMapper();

    test(
      'round-trips enums, bools, ints, decimal dots, and optional values',
      () {
        const settings = AppSettings(
          locale: LocaleSetting.de,
          themeMode: ThemeModeSetting.dark,
          weightUnit: WeightUnit.lb,
          remindersEnabled: true,
          heightCm: 180.5,
          weightKg: 80,
          timeSlotWidthMinutes: 120,
          recentEntriesCount: 15,
          pinnedTimeSlotStartMinutes: 480,
          disclaimerAcceptedVersion: 1,
          lastExportDirectoryHint: r'C:\exports',
        );

        final rows = mapper.toRows(settings);
        final byKey = {for (final row in rows) row.key: row.value};

        expect(byKey['locale'], 'de');
        expect(byKey['themeMode'], 'dark');
        expect(byKey['weightUnit'], 'lb');
        expect(byKey['remindersEnabled'], 'true');
        expect(byKey['heightCm'], '180.5');
        expect(byKey['heightCm'], isNot(contains(',')));
        expect(byKey['weightKg'], '80.0');
        expect(byKey['recentEntriesCount'], '15');
        expect(mapper.fromRows(rows), settings);
      },
    );

    test('absent rows resolve to documented defaults and nulls', () {
      final settings = mapper.fromRows(const []);

      expect(settings.locale, LocaleSetting.system);
      expect(settings.themeMode, ThemeModeSetting.system);
      expect(settings.weightUnit, WeightUnit.kg);
      expect(settings.remindersEnabled, isFalse);
      expect(settings.timeSlotWidthMinutes, 60);
      expect(settings.recentEntriesCount, 10);
      expect(settings.heightCm, isNull);
      expect(settings.weightKg, isNull);
      expect(settings.pinnedTimeSlotStartMinutes, isNull);
      expect(settings.disclaimerAcceptedVersion, isNull);
      expect(settings.lastExportDirectoryHint, isNull);
    });

    test('unknown enum strings fall back to documented defaults', () {
      final settings = mapper.fromRows(const [
        db.AppSettingRow(key: 'locale', value: 'fr'),
        db.AppSettingRow(key: 'themeMode', value: 'amoled'),
        db.AppSettingRow(key: 'weightUnit', value: 'stone'),
      ]);

      expect(settings.locale, LocaleSetting.system);
      expect(settings.themeMode, ThemeModeSetting.system);
      expect(settings.weightUnit, WeightUnit.kg);
    });
  });
}

Future<Map<String, String>> _columns(
  db.AppDatabase database,
  String tableName,
) async {
  final rows = await database
      .customSelect('PRAGMA table_info($tableName);')
      .get();
  return {
    for (final row in rows)
      row.data['name']! as String: _columnSignature(
        type: row.data['type']! as String,
        notNull: row.data['notnull'] == 1 || row.data['pk'] == 1,
        primaryKey: row.data['pk'] == 1,
      ),
  };
}

Future<Set<String>> _indexes(db.AppDatabase database, String tableName) async {
  final rows = await database
      .customSelect('PRAGMA index_list($tableName);')
      .get();
  return {for (final row in rows) row.data['name']! as String};
}

String _columnSignature({
  required String type,
  required bool notNull,
  required bool primaryKey,
}) {
  final nullability = notNull ? 'required' : 'nullable';
  return primaryKey ? '$type|$nullability|pk' : '$type|$nullability';
}
