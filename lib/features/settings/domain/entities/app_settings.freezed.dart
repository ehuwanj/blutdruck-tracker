// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppSettings {
  LocaleSetting get locale => throw _privateConstructorUsedError;
  ThemeModeSetting get themeMode => throw _privateConstructorUsedError;
  WeightUnit get weightUnit => throw _privateConstructorUsedError;
  bool get remindersEnabled => throw _privateConstructorUsedError;

  /// Default `60`; allowed `60`, `120`, `180`.
  int get timeSlotWidthMinutes => throw _privateConstructorUsedError;

  /// Default `10`; allowed `5`, `7`, `10`, `15`, `20`. Controls how many
  /// recent entries the Status tab's tap-Latest bottom sheet renders.
  int get recentEntriesCount => throw _privateConstructorUsedError;

  /// Profile height in centimetres. `null` = unset; BMI is not computed.
  double? get heightCm => throw _privateConstructorUsedError;

  /// Profile weight in kilograms. `null` = unset. Weight is a single
  /// setting (not per-reading) per user request — BMI uses this paired
  /// with `heightCm` to produce a single value.
  double? get weightKg => throw _privateConstructorUsedError;

  /// `0..1439` minutes since local midnight, or `null` to auto-detect.
  int? get pinnedTimeSlotStartMinutes => throw _privateConstructorUsedError;

  /// Version of the disclaimer the user most recently accepted, or
  /// `null` when never accepted. See `kDisclaimerVersion`.
  int? get disclaimerAcceptedVersion => throw _privateConstructorUsedError;
  String? get lastExportDirectoryHint => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    LocaleSetting locale,
    ThemeModeSetting themeMode,
    WeightUnit weightUnit,
    bool remindersEnabled,
    int timeSlotWidthMinutes,
    int recentEntriesCount,
    double? heightCm,
    double? weightKg,
    int? pinnedTimeSlotStartMinutes,
    int? disclaimerAcceptedVersion,
    String? lastExportDirectoryHint,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locale = null,
    Object? themeMode = null,
    Object? weightUnit = null,
    Object? remindersEnabled = null,
    Object? timeSlotWidthMinutes = null,
    Object? recentEntriesCount = null,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
    Object? pinnedTimeSlotStartMinutes = freezed,
    Object? disclaimerAcceptedVersion = freezed,
    Object? lastExportDirectoryHint = freezed,
  }) {
    return _then(
      _value.copyWith(
            locale: null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                      as LocaleSetting,
            themeMode: null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                      as ThemeModeSetting,
            weightUnit: null == weightUnit
                ? _value.weightUnit
                : weightUnit // ignore: cast_nullable_to_non_nullable
                      as WeightUnit,
            remindersEnabled: null == remindersEnabled
                ? _value.remindersEnabled
                : remindersEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            timeSlotWidthMinutes: null == timeSlotWidthMinutes
                ? _value.timeSlotWidthMinutes
                : timeSlotWidthMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            recentEntriesCount: null == recentEntriesCount
                ? _value.recentEntriesCount
                : recentEntriesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            heightCm: freezed == heightCm
                ? _value.heightCm
                : heightCm // ignore: cast_nullable_to_non_nullable
                      as double?,
            weightKg: freezed == weightKg
                ? _value.weightKg
                : weightKg // ignore: cast_nullable_to_non_nullable
                      as double?,
            pinnedTimeSlotStartMinutes: freezed == pinnedTimeSlotStartMinutes
                ? _value.pinnedTimeSlotStartMinutes
                : pinnedTimeSlotStartMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            disclaimerAcceptedVersion: freezed == disclaimerAcceptedVersion
                ? _value.disclaimerAcceptedVersion
                : disclaimerAcceptedVersion // ignore: cast_nullable_to_non_nullable
                      as int?,
            lastExportDirectoryHint: freezed == lastExportDirectoryHint
                ? _value.lastExportDirectoryHint
                : lastExportDirectoryHint // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    LocaleSetting locale,
    ThemeModeSetting themeMode,
    WeightUnit weightUnit,
    bool remindersEnabled,
    int timeSlotWidthMinutes,
    int recentEntriesCount,
    double? heightCm,
    double? weightKg,
    int? pinnedTimeSlotStartMinutes,
    int? disclaimerAcceptedVersion,
    String? lastExportDirectoryHint,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locale = null,
    Object? themeMode = null,
    Object? weightUnit = null,
    Object? remindersEnabled = null,
    Object? timeSlotWidthMinutes = null,
    Object? recentEntriesCount = null,
    Object? heightCm = freezed,
    Object? weightKg = freezed,
    Object? pinnedTimeSlotStartMinutes = freezed,
    Object? disclaimerAcceptedVersion = freezed,
    Object? lastExportDirectoryHint = freezed,
  }) {
    return _then(
      _$AppSettingsImpl(
        locale: null == locale
            ? _value.locale
            : locale // ignore: cast_nullable_to_non_nullable
                  as LocaleSetting,
        themeMode: null == themeMode
            ? _value.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as ThemeModeSetting,
        weightUnit: null == weightUnit
            ? _value.weightUnit
            : weightUnit // ignore: cast_nullable_to_non_nullable
                  as WeightUnit,
        remindersEnabled: null == remindersEnabled
            ? _value.remindersEnabled
            : remindersEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        timeSlotWidthMinutes: null == timeSlotWidthMinutes
            ? _value.timeSlotWidthMinutes
            : timeSlotWidthMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        recentEntriesCount: null == recentEntriesCount
            ? _value.recentEntriesCount
            : recentEntriesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        heightCm: freezed == heightCm
            ? _value.heightCm
            : heightCm // ignore: cast_nullable_to_non_nullable
                  as double?,
        weightKg: freezed == weightKg
            ? _value.weightKg
            : weightKg // ignore: cast_nullable_to_non_nullable
                  as double?,
        pinnedTimeSlotStartMinutes: freezed == pinnedTimeSlotStartMinutes
            ? _value.pinnedTimeSlotStartMinutes
            : pinnedTimeSlotStartMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        disclaimerAcceptedVersion: freezed == disclaimerAcceptedVersion
            ? _value.disclaimerAcceptedVersion
            : disclaimerAcceptedVersion // ignore: cast_nullable_to_non_nullable
                  as int?,
        lastExportDirectoryHint: freezed == lastExportDirectoryHint
            ? _value.lastExportDirectoryHint
            : lastExportDirectoryHint // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    required this.locale,
    required this.themeMode,
    required this.weightUnit,
    required this.remindersEnabled,
    required this.timeSlotWidthMinutes,
    required this.recentEntriesCount,
    this.heightCm,
    this.weightKg,
    this.pinnedTimeSlotStartMinutes,
    this.disclaimerAcceptedVersion,
    this.lastExportDirectoryHint,
  });

  @override
  final LocaleSetting locale;
  @override
  final ThemeModeSetting themeMode;
  @override
  final WeightUnit weightUnit;
  @override
  final bool remindersEnabled;

  /// Default `60`; allowed `60`, `120`, `180`.
  @override
  final int timeSlotWidthMinutes;

  /// Default `10`; allowed `5`, `7`, `10`, `15`, `20`. Controls how many
  /// recent entries the Status tab's tap-Latest bottom sheet renders.
  @override
  final int recentEntriesCount;

  /// Profile height in centimetres. `null` = unset; BMI is not computed.
  @override
  final double? heightCm;

  /// Profile weight in kilograms. `null` = unset. Weight is a single
  /// setting (not per-reading) per user request — BMI uses this paired
  /// with `heightCm` to produce a single value.
  @override
  final double? weightKg;

  /// `0..1439` minutes since local midnight, or `null` to auto-detect.
  @override
  final int? pinnedTimeSlotStartMinutes;

  /// Version of the disclaimer the user most recently accepted, or
  /// `null` when never accepted. See `kDisclaimerVersion`.
  @override
  final int? disclaimerAcceptedVersion;
  @override
  final String? lastExportDirectoryHint;

  @override
  String toString() {
    return 'AppSettings(locale: $locale, themeMode: $themeMode, weightUnit: $weightUnit, remindersEnabled: $remindersEnabled, timeSlotWidthMinutes: $timeSlotWidthMinutes, recentEntriesCount: $recentEntriesCount, heightCm: $heightCm, weightKg: $weightKg, pinnedTimeSlotStartMinutes: $pinnedTimeSlotStartMinutes, disclaimerAcceptedVersion: $disclaimerAcceptedVersion, lastExportDirectoryHint: $lastExportDirectoryHint)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.weightUnit, weightUnit) ||
                other.weightUnit == weightUnit) &&
            (identical(other.remindersEnabled, remindersEnabled) ||
                other.remindersEnabled == remindersEnabled) &&
            (identical(other.timeSlotWidthMinutes, timeSlotWidthMinutes) ||
                other.timeSlotWidthMinutes == timeSlotWidthMinutes) &&
            (identical(other.recentEntriesCount, recentEntriesCount) ||
                other.recentEntriesCount == recentEntriesCount) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(
                  other.pinnedTimeSlotStartMinutes,
                  pinnedTimeSlotStartMinutes,
                ) ||
                other.pinnedTimeSlotStartMinutes ==
                    pinnedTimeSlotStartMinutes) &&
            (identical(
                  other.disclaimerAcceptedVersion,
                  disclaimerAcceptedVersion,
                ) ||
                other.disclaimerAcceptedVersion == disclaimerAcceptedVersion) &&
            (identical(
                  other.lastExportDirectoryHint,
                  lastExportDirectoryHint,
                ) ||
                other.lastExportDirectoryHint == lastExportDirectoryHint));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    locale,
    themeMode,
    weightUnit,
    remindersEnabled,
    timeSlotWidthMinutes,
    recentEntriesCount,
    heightCm,
    weightKg,
    pinnedTimeSlotStartMinutes,
    disclaimerAcceptedVersion,
    lastExportDirectoryHint,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    required final LocaleSetting locale,
    required final ThemeModeSetting themeMode,
    required final WeightUnit weightUnit,
    required final bool remindersEnabled,
    required final int timeSlotWidthMinutes,
    required final int recentEntriesCount,
    final double? heightCm,
    final double? weightKg,
    final int? pinnedTimeSlotStartMinutes,
    final int? disclaimerAcceptedVersion,
    final String? lastExportDirectoryHint,
  }) = _$AppSettingsImpl;

  @override
  LocaleSetting get locale;
  @override
  ThemeModeSetting get themeMode;
  @override
  WeightUnit get weightUnit;
  @override
  bool get remindersEnabled;

  /// Default `60`; allowed `60`, `120`, `180`.
  @override
  int get timeSlotWidthMinutes;

  /// Default `10`; allowed `5`, `7`, `10`, `15`, `20`. Controls how many
  /// recent entries the Status tab's tap-Latest bottom sheet renders.
  @override
  int get recentEntriesCount;

  /// Profile height in centimetres. `null` = unset; BMI is not computed.
  @override
  double? get heightCm;

  /// Profile weight in kilograms. `null` = unset. Weight is a single
  /// setting (not per-reading) per user request — BMI uses this paired
  /// with `heightCm` to produce a single value.
  @override
  double? get weightKg;

  /// `0..1439` minutes since local midnight, or `null` to auto-detect.
  @override
  int? get pinnedTimeSlotStartMinutes;

  /// Version of the disclaimer the user most recently accepted, or
  /// `null` when never accepted. See `kDisclaimerVersion`.
  @override
  int? get disclaimerAcceptedVersion;
  @override
  String? get lastExportDirectoryHint;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
