// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_slot_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TimeSlotSeries {
  TimeSlotPick get pick => throw _privateConstructorUsedError;
  List<TimeSlotPoint> get points => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlotSeries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotSeriesCopyWith<TimeSlotSeries> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotSeriesCopyWith<$Res> {
  factory $TimeSlotSeriesCopyWith(
    TimeSlotSeries value,
    $Res Function(TimeSlotSeries) then,
  ) = _$TimeSlotSeriesCopyWithImpl<$Res, TimeSlotSeries>;
  @useResult
  $Res call({TimeSlotPick pick, List<TimeSlotPoint> points});

  $TimeSlotPickCopyWith<$Res> get pick;
}

/// @nodoc
class _$TimeSlotSeriesCopyWithImpl<$Res, $Val extends TimeSlotSeries>
    implements $TimeSlotSeriesCopyWith<$Res> {
  _$TimeSlotSeriesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlotSeries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pick = null, Object? points = null}) {
    return _then(
      _value.copyWith(
            pick: null == pick
                ? _value.pick
                : pick // ignore: cast_nullable_to_non_nullable
                      as TimeSlotPick,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as List<TimeSlotPoint>,
          )
          as $Val,
    );
  }

  /// Create a copy of TimeSlotSeries
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeSlotPickCopyWith<$Res> get pick {
    return $TimeSlotPickCopyWith<$Res>(_value.pick, (value) {
      return _then(_value.copyWith(pick: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TimeSlotSeriesImplCopyWith<$Res>
    implements $TimeSlotSeriesCopyWith<$Res> {
  factory _$$TimeSlotSeriesImplCopyWith(
    _$TimeSlotSeriesImpl value,
    $Res Function(_$TimeSlotSeriesImpl) then,
  ) = __$$TimeSlotSeriesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TimeSlotPick pick, List<TimeSlotPoint> points});

  @override
  $TimeSlotPickCopyWith<$Res> get pick;
}

/// @nodoc
class __$$TimeSlotSeriesImplCopyWithImpl<$Res>
    extends _$TimeSlotSeriesCopyWithImpl<$Res, _$TimeSlotSeriesImpl>
    implements _$$TimeSlotSeriesImplCopyWith<$Res> {
  __$$TimeSlotSeriesImplCopyWithImpl(
    _$TimeSlotSeriesImpl _value,
    $Res Function(_$TimeSlotSeriesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeSlotSeries
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pick = null, Object? points = null}) {
    return _then(
      _$TimeSlotSeriesImpl(
        pick: null == pick
            ? _value.pick
            : pick // ignore: cast_nullable_to_non_nullable
                  as TimeSlotPick,
        points: null == points
            ? _value._points
            : points // ignore: cast_nullable_to_non_nullable
                  as List<TimeSlotPoint>,
      ),
    );
  }
}

/// @nodoc

class _$TimeSlotSeriesImpl implements _TimeSlotSeries {
  const _$TimeSlotSeriesImpl({
    required this.pick,
    required final List<TimeSlotPoint> points,
  }) : _points = points;

  @override
  final TimeSlotPick pick;
  final List<TimeSlotPoint> _points;
  @override
  List<TimeSlotPoint> get points {
    if (_points is EqualUnmodifiableListView) return _points;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_points);
  }

  @override
  String toString() {
    return 'TimeSlotSeries(pick: $pick, points: $points)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotSeriesImpl &&
            (identical(other.pick, pick) || other.pick == pick) &&
            const DeepCollectionEquality().equals(other._points, _points));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    pick,
    const DeepCollectionEquality().hash(_points),
  );

  /// Create a copy of TimeSlotSeries
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotSeriesImplCopyWith<_$TimeSlotSeriesImpl> get copyWith =>
      __$$TimeSlotSeriesImplCopyWithImpl<_$TimeSlotSeriesImpl>(
        this,
        _$identity,
      );
}

abstract class _TimeSlotSeries implements TimeSlotSeries {
  const factory _TimeSlotSeries({
    required final TimeSlotPick pick,
    required final List<TimeSlotPoint> points,
  }) = _$TimeSlotSeriesImpl;

  @override
  TimeSlotPick get pick;
  @override
  List<TimeSlotPoint> get points;

  /// Create a copy of TimeSlotSeries
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotSeriesImplCopyWith<_$TimeSlotSeriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
