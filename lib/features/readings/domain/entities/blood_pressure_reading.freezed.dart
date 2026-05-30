// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blood_pressure_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BloodPressureReading {
  String get id => throw _privateConstructorUsedError;

  /// Always stored UTC; rendered in device-local time by the UI.
  DateTime get measuredAt => throw _privateConstructorUsedError;
  int get systolic => throw _privateConstructorUsedError;
  int get diastolic => throw _privateConstructorUsedError;
  ReadingSource get source => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int? get pulse => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Create a copy of BloodPressureReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BloodPressureReadingCopyWith<BloodPressureReading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BloodPressureReadingCopyWith<$Res> {
  factory $BloodPressureReadingCopyWith(
    BloodPressureReading value,
    $Res Function(BloodPressureReading) then,
  ) = _$BloodPressureReadingCopyWithImpl<$Res, BloodPressureReading>;
  @useResult
  $Res call({
    String id,
    DateTime measuredAt,
    int systolic,
    int diastolic,
    ReadingSource source,
    DateTime createdAt,
    DateTime updatedAt,
    int? pulse,
    String? note,
  });
}

/// @nodoc
class _$BloodPressureReadingCopyWithImpl<
  $Res,
  $Val extends BloodPressureReading
>
    implements $BloodPressureReadingCopyWith<$Res> {
  _$BloodPressureReadingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BloodPressureReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? measuredAt = null,
    Object? systolic = null,
    Object? diastolic = null,
    Object? source = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? pulse = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            measuredAt: null == measuredAt
                ? _value.measuredAt
                : measuredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            systolic: null == systolic
                ? _value.systolic
                : systolic // ignore: cast_nullable_to_non_nullable
                      as int,
            diastolic: null == diastolic
                ? _value.diastolic
                : diastolic // ignore: cast_nullable_to_non_nullable
                      as int,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as ReadingSource,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            pulse: freezed == pulse
                ? _value.pulse
                : pulse // ignore: cast_nullable_to_non_nullable
                      as int?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BloodPressureReadingImplCopyWith<$Res>
    implements $BloodPressureReadingCopyWith<$Res> {
  factory _$$BloodPressureReadingImplCopyWith(
    _$BloodPressureReadingImpl value,
    $Res Function(_$BloodPressureReadingImpl) then,
  ) = __$$BloodPressureReadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime measuredAt,
    int systolic,
    int diastolic,
    ReadingSource source,
    DateTime createdAt,
    DateTime updatedAt,
    int? pulse,
    String? note,
  });
}

/// @nodoc
class __$$BloodPressureReadingImplCopyWithImpl<$Res>
    extends _$BloodPressureReadingCopyWithImpl<$Res, _$BloodPressureReadingImpl>
    implements _$$BloodPressureReadingImplCopyWith<$Res> {
  __$$BloodPressureReadingImplCopyWithImpl(
    _$BloodPressureReadingImpl _value,
    $Res Function(_$BloodPressureReadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BloodPressureReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? measuredAt = null,
    Object? systolic = null,
    Object? diastolic = null,
    Object? source = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? pulse = freezed,
    Object? note = freezed,
  }) {
    return _then(
      _$BloodPressureReadingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        measuredAt: null == measuredAt
            ? _value.measuredAt
            : measuredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        systolic: null == systolic
            ? _value.systolic
            : systolic // ignore: cast_nullable_to_non_nullable
                  as int,
        diastolic: null == diastolic
            ? _value.diastolic
            : diastolic // ignore: cast_nullable_to_non_nullable
                  as int,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as ReadingSource,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        pulse: freezed == pulse
            ? _value.pulse
            : pulse // ignore: cast_nullable_to_non_nullable
                  as int?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BloodPressureReadingImpl extends _BloodPressureReading {
  const _$BloodPressureReadingImpl({
    required this.id,
    required this.measuredAt,
    required this.systolic,
    required this.diastolic,
    required this.source,
    required this.createdAt,
    required this.updatedAt,
    this.pulse,
    this.note,
  }) : super._();

  @override
  final String id;

  /// Always stored UTC; rendered in device-local time by the UI.
  @override
  final DateTime measuredAt;
  @override
  final int systolic;
  @override
  final int diastolic;
  @override
  final ReadingSource source;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int? pulse;
  @override
  final String? note;

  @override
  String toString() {
    return 'BloodPressureReading(id: $id, measuredAt: $measuredAt, systolic: $systolic, diastolic: $diastolic, source: $source, createdAt: $createdAt, updatedAt: $updatedAt, pulse: $pulse, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BloodPressureReadingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.measuredAt, measuredAt) ||
                other.measuredAt == measuredAt) &&
            (identical(other.systolic, systolic) ||
                other.systolic == systolic) &&
            (identical(other.diastolic, diastolic) ||
                other.diastolic == diastolic) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.pulse, pulse) || other.pulse == pulse) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    measuredAt,
    systolic,
    diastolic,
    source,
    createdAt,
    updatedAt,
    pulse,
    note,
  );

  /// Create a copy of BloodPressureReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BloodPressureReadingImplCopyWith<_$BloodPressureReadingImpl>
  get copyWith =>
      __$$BloodPressureReadingImplCopyWithImpl<_$BloodPressureReadingImpl>(
        this,
        _$identity,
      );
}

abstract class _BloodPressureReading extends BloodPressureReading {
  const factory _BloodPressureReading({
    required final String id,
    required final DateTime measuredAt,
    required final int systolic,
    required final int diastolic,
    required final ReadingSource source,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final int? pulse,
    final String? note,
  }) = _$BloodPressureReadingImpl;
  const _BloodPressureReading._() : super._();

  @override
  String get id;

  /// Always stored UTC; rendered in device-local time by the UI.
  @override
  DateTime get measuredAt;
  @override
  int get systolic;
  @override
  int get diastolic;
  @override
  ReadingSource get source;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int? get pulse;
  @override
  String? get note;

  /// Create a copy of BloodPressureReading
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BloodPressureReadingImplCopyWith<_$BloodPressureReadingImpl>
  get copyWith => throw _privateConstructorUsedError;
}
