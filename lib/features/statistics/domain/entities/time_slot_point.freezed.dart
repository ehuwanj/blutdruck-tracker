// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_slot_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TimeSlotPoint {
  /// 00:00 local of the represented day.
  DateTime get localDay => throw _privateConstructorUsedError;
  int get systolicAverage => throw _privateConstructorUsedError;
  int get diastolicAverage => throw _privateConstructorUsedError;
  int get readingCount => throw _privateConstructorUsedError;

  /// `null` when no in-slot reading on this day had a pulse value.
  int? get pulseAverage => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlotPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotPointCopyWith<TimeSlotPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotPointCopyWith<$Res> {
  factory $TimeSlotPointCopyWith(
    TimeSlotPoint value,
    $Res Function(TimeSlotPoint) then,
  ) = _$TimeSlotPointCopyWithImpl<$Res, TimeSlotPoint>;
  @useResult
  $Res call({
    DateTime localDay,
    int systolicAverage,
    int diastolicAverage,
    int readingCount,
    int? pulseAverage,
  });
}

/// @nodoc
class _$TimeSlotPointCopyWithImpl<$Res, $Val extends TimeSlotPoint>
    implements $TimeSlotPointCopyWith<$Res> {
  _$TimeSlotPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlotPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localDay = null,
    Object? systolicAverage = null,
    Object? diastolicAverage = null,
    Object? readingCount = null,
    Object? pulseAverage = freezed,
  }) {
    return _then(
      _value.copyWith(
            localDay: null == localDay
                ? _value.localDay
                : localDay // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            systolicAverage: null == systolicAverage
                ? _value.systolicAverage
                : systolicAverage // ignore: cast_nullable_to_non_nullable
                      as int,
            diastolicAverage: null == diastolicAverage
                ? _value.diastolicAverage
                : diastolicAverage // ignore: cast_nullable_to_non_nullable
                      as int,
            readingCount: null == readingCount
                ? _value.readingCount
                : readingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            pulseAverage: freezed == pulseAverage
                ? _value.pulseAverage
                : pulseAverage // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeSlotPointImplCopyWith<$Res>
    implements $TimeSlotPointCopyWith<$Res> {
  factory _$$TimeSlotPointImplCopyWith(
    _$TimeSlotPointImpl value,
    $Res Function(_$TimeSlotPointImpl) then,
  ) = __$$TimeSlotPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime localDay,
    int systolicAverage,
    int diastolicAverage,
    int readingCount,
    int? pulseAverage,
  });
}

/// @nodoc
class __$$TimeSlotPointImplCopyWithImpl<$Res>
    extends _$TimeSlotPointCopyWithImpl<$Res, _$TimeSlotPointImpl>
    implements _$$TimeSlotPointImplCopyWith<$Res> {
  __$$TimeSlotPointImplCopyWithImpl(
    _$TimeSlotPointImpl _value,
    $Res Function(_$TimeSlotPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeSlotPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localDay = null,
    Object? systolicAverage = null,
    Object? diastolicAverage = null,
    Object? readingCount = null,
    Object? pulseAverage = freezed,
  }) {
    return _then(
      _$TimeSlotPointImpl(
        localDay: null == localDay
            ? _value.localDay
            : localDay // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        systolicAverage: null == systolicAverage
            ? _value.systolicAverage
            : systolicAverage // ignore: cast_nullable_to_non_nullable
                  as int,
        diastolicAverage: null == diastolicAverage
            ? _value.diastolicAverage
            : diastolicAverage // ignore: cast_nullable_to_non_nullable
                  as int,
        readingCount: null == readingCount
            ? _value.readingCount
            : readingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        pulseAverage: freezed == pulseAverage
            ? _value.pulseAverage
            : pulseAverage // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$TimeSlotPointImpl implements _TimeSlotPoint {
  const _$TimeSlotPointImpl({
    required this.localDay,
    required this.systolicAverage,
    required this.diastolicAverage,
    required this.readingCount,
    this.pulseAverage,
  });

  /// 00:00 local of the represented day.
  @override
  final DateTime localDay;
  @override
  final int systolicAverage;
  @override
  final int diastolicAverage;
  @override
  final int readingCount;

  /// `null` when no in-slot reading on this day had a pulse value.
  @override
  final int? pulseAverage;

  @override
  String toString() {
    return 'TimeSlotPoint(localDay: $localDay, systolicAverage: $systolicAverage, diastolicAverage: $diastolicAverage, readingCount: $readingCount, pulseAverage: $pulseAverage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotPointImpl &&
            (identical(other.localDay, localDay) ||
                other.localDay == localDay) &&
            (identical(other.systolicAverage, systolicAverage) ||
                other.systolicAverage == systolicAverage) &&
            (identical(other.diastolicAverage, diastolicAverage) ||
                other.diastolicAverage == diastolicAverage) &&
            (identical(other.readingCount, readingCount) ||
                other.readingCount == readingCount) &&
            (identical(other.pulseAverage, pulseAverage) ||
                other.pulseAverage == pulseAverage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    localDay,
    systolicAverage,
    diastolicAverage,
    readingCount,
    pulseAverage,
  );

  /// Create a copy of TimeSlotPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotPointImplCopyWith<_$TimeSlotPointImpl> get copyWith =>
      __$$TimeSlotPointImplCopyWithImpl<_$TimeSlotPointImpl>(this, _$identity);
}

abstract class _TimeSlotPoint implements TimeSlotPoint {
  const factory _TimeSlotPoint({
    required final DateTime localDay,
    required final int systolicAverage,
    required final int diastolicAverage,
    required final int readingCount,
    final int? pulseAverage,
  }) = _$TimeSlotPointImpl;

  /// 00:00 local of the represented day.
  @override
  DateTime get localDay;
  @override
  int get systolicAverage;
  @override
  int get diastolicAverage;
  @override
  int get readingCount;

  /// `null` when no in-slot reading on this day had a pulse value.
  @override
  int? get pulseAverage;

  /// Create a copy of TimeSlotPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotPointImplCopyWith<_$TimeSlotPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
