import 'package:blutdruck_tracker/core/database/app_database.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/locale_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/theme_mode_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/weight_unit.dart';

class AppSettingsMapper {
  const AppSettingsMapper();

  AppSettings fromRows(List<AppSettingRow> rows) {
    final values = {for (final row in rows) row.key: row.value};
    return AppSettings(
      locale: _enumValue(
        values[_Keys.locale],
        LocaleSetting.values,
        LocaleSetting.system,
      ),
      themeMode: _enumValue(
        values[_Keys.themeMode],
        ThemeModeSetting.values,
        ThemeModeSetting.system,
      ),
      weightUnit: _enumValue(
        values[_Keys.weightUnit],
        WeightUnit.values,
        WeightUnit.kg,
      ),
      remindersEnabled: values[_Keys.remindersEnabled] == 'true',
      heightCm: _double(values[_Keys.heightCm]),
      timeSlotWidthMinutes: _int(values[_Keys.timeSlotWidthMinutes]) ?? 60,
      pinnedTimeSlotStartMinutes: _int(
        values[_Keys.pinnedTimeSlotStartMinutes],
      ),
      disclaimerAcceptedVersion: _int(values[_Keys.disclaimerAcceptedVersion]),
      lastExportDirectoryHint: values[_Keys.lastExportDirectoryHint],
    );
  }

  List<AppSettingRow> toRows(AppSettings settings) {
    return [
      AppSettingRow(key: _Keys.locale, value: settings.locale.name),
      AppSettingRow(key: _Keys.themeMode, value: settings.themeMode.name),
      AppSettingRow(key: _Keys.weightUnit, value: settings.weightUnit.name),
      AppSettingRow(
        key: _Keys.remindersEnabled,
        value: settings.remindersEnabled.toString(),
      ),
      AppSettingRow(
        key: _Keys.timeSlotWidthMinutes,
        value: settings.timeSlotWidthMinutes.toString(),
      ),
      if (settings.heightCm case final heightCm?)
        AppSettingRow(key: _Keys.heightCm, value: _decimal(heightCm)),
      if (settings.pinnedTimeSlotStartMinutes case final start?)
        AppSettingRow(
          key: _Keys.pinnedTimeSlotStartMinutes,
          value: start.toString(),
        ),
      if (settings.disclaimerAcceptedVersion case final version?)
        AppSettingRow(
          key: _Keys.disclaimerAcceptedVersion,
          value: version.toString(),
        ),
      if (settings.lastExportDirectoryHint case final hint?)
        AppSettingRow(key: _Keys.lastExportDirectoryHint, value: hint),
    ];
  }

  T _enumValue<T extends Enum>(String? value, List<T> values, T fallback) {
    if (value == null) {
      return fallback;
    }
    for (final candidate in values) {
      if (candidate.name == value) {
        return candidate;
      }
    }
    return fallback;
  }

  int? _int(String? value) => value == null ? null : int.tryParse(value);

  double? _double(String? value) {
    if (value == null) {
      return null;
    }
    return double.tryParse(value);
  }

  String _decimal(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(1);
    }
    return value.toString();
  }
}

abstract final class _Keys {
  static const locale = 'locale';
  static const themeMode = 'themeMode';
  static const weightUnit = 'weightUnit';
  static const remindersEnabled = 'remindersEnabled';
  static const heightCm = 'heightCm';
  static const timeSlotWidthMinutes = 'timeSlotWidthMinutes';
  static const pinnedTimeSlotStartMinutes = 'pinnedTimeSlotStartMinutes';
  static const disclaimerAcceptedVersion = 'disclaimerAcceptedVersion';
  static const lastExportDirectoryHint = 'lastExportDirectoryHint';
}
