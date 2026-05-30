import 'package:blutdruck_tracker/features/settings/domain/entities/locale_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/theme_mode_setting.dart';
import 'package:blutdruck_tracker/features/settings/domain/entities/weight_unit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

/// Application-wide settings. Persisted as key/value rows in the
/// `app_settings` table (step 3); absent keys fall back to the defaults
/// declared by `AppSettings.defaults()`.
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required LocaleSetting locale,
    required ThemeModeSetting themeMode,
    required WeightUnit weightUnit,
    required bool remindersEnabled,

    /// Default `60`; allowed `60`, `120`, `180`.
    required int timeSlotWidthMinutes,

    /// Default `10`; allowed `5`, `7`, `10`, `15`, `20`. Controls how many
    /// recent entries the Status tab's tap-Latest bottom sheet renders.
    required int recentEntriesCount,

    /// Profile height in centimetres. `null` = unset; BMI is not computed.
    double? heightCm,

    /// Profile weight in kilograms. `null` = unset. Weight is a single
    /// setting (not per-reading) per user request — BMI uses this paired
    /// with `heightCm` to produce a single value.
    double? weightKg,

    /// `0..1439` minutes since local midnight, or `null` to auto-detect.
    int? pinnedTimeSlotStartMinutes,

    /// Version of the disclaimer the user most recently accepted, or
    /// `null` when never accepted. See `kDisclaimerVersion`.
    int? disclaimerAcceptedVersion,
    String? lastExportDirectoryHint,
  }) = _AppSettings;

  factory AppSettings.defaults() => const AppSettings(
    locale: LocaleSetting.system,
    themeMode: ThemeModeSetting.system,
    weightUnit: WeightUnit.kg,
    remindersEnabled: false,
    timeSlotWidthMinutes: 60,
    recentEntriesCount: 10,
  );
}
