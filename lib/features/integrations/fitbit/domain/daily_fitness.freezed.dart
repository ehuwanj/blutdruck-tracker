// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_fitness.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DailyFitness {
  /// 00:00 of the local day this row represents.
  DateTime get date => throw _privateConstructorUsedError;
  Duration? get sleepDuration => throw _privateConstructorUsedError;
  int? get sleepScore => throw _privateConstructorUsedError;
  int? get restingHeartRate => throw _privateConstructorUsedError;
  int? get steps => throw _privateConstructorUsedError;
  int? get activeMinutes => throw _privateConstructorUsedError;

  /// Create a copy of DailyFitness
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyFitnessCopyWith<DailyFitness> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyFitnessCopyWith<$Res> {
  factory $DailyFitnessCopyWith(
    DailyFitness value,
    $Res Function(DailyFitness) then,
  ) = _$DailyFitnessCopyWithImpl<$Res, DailyFitness>;
  @useResult
  $Res call({
    DateTime date,
    Duration? sleepDuration,
    int? sleepScore,
    int? restingHeartRate,
    int? steps,
    int? activeMinutes,
  });
}

/// @nodoc
class _$DailyFitnessCopyWithImpl<$Res, $Val extends DailyFitness>
    implements $DailyFitnessCopyWith<$Res> {
  _$DailyFitnessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyFitness
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? sleepDuration = freezed,
    Object? sleepScore = freezed,
    Object? restingHeartRate = freezed,
    Object? steps = freezed,
    Object? activeMinutes = freezed,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            sleepDuration: freezed == sleepDuration
                ? _value.sleepDuration
                : sleepDuration // ignore: cast_nullable_to_non_nullable
                      as Duration?,
            sleepScore: freezed == sleepScore
                ? _value.sleepScore
                : sleepScore // ignore: cast_nullable_to_non_nullable
                      as int?,
            restingHeartRate: freezed == restingHeartRate
                ? _value.restingHeartRate
                : restingHeartRate // ignore: cast_nullable_to_non_nullable
                      as int?,
            steps: freezed == steps
                ? _value.steps
                : steps // ignore: cast_nullable_to_non_nullable
                      as int?,
            activeMinutes: freezed == activeMinutes
                ? _value.activeMinutes
                : activeMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DailyFitnessImplCopyWith<$Res>
    implements $DailyFitnessCopyWith<$Res> {
  factory _$$DailyFitnessImplCopyWith(
    _$DailyFitnessImpl value,
    $Res Function(_$DailyFitnessImpl) then,
  ) = __$$DailyFitnessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    Duration? sleepDuration,
    int? sleepScore,
    int? restingHeartRate,
    int? steps,
    int? activeMinutes,
  });
}

/// @nodoc
class __$$DailyFitnessImplCopyWithImpl<$Res>
    extends _$DailyFitnessCopyWithImpl<$Res, _$DailyFitnessImpl>
    implements _$$DailyFitnessImplCopyWith<$Res> {
  __$$DailyFitnessImplCopyWithImpl(
    _$DailyFitnessImpl _value,
    $Res Function(_$DailyFitnessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DailyFitness
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? sleepDuration = freezed,
    Object? sleepScore = freezed,
    Object? restingHeartRate = freezed,
    Object? steps = freezed,
    Object? activeMinutes = freezed,
  }) {
    return _then(
      _$DailyFitnessImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        sleepDuration: freezed == sleepDuration
            ? _value.sleepDuration
            : sleepDuration // ignore: cast_nullable_to_non_nullable
                  as Duration?,
        sleepScore: freezed == sleepScore
            ? _value.sleepScore
            : sleepScore // ignore: cast_nullable_to_non_nullable
                  as int?,
        restingHeartRate: freezed == restingHeartRate
            ? _value.restingHeartRate
            : restingHeartRate // ignore: cast_nullable_to_non_nullable
                  as int?,
        steps: freezed == steps
            ? _value.steps
            : steps // ignore: cast_nullable_to_non_nullable
                  as int?,
        activeMinutes: freezed == activeMinutes
            ? _value.activeMinutes
            : activeMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$DailyFitnessImpl implements _DailyFitness {
  const _$DailyFitnessImpl({
    required this.date,
    this.sleepDuration,
    this.sleepScore,
    this.restingHeartRate,
    this.steps,
    this.activeMinutes,
  });

  /// 00:00 of the local day this row represents.
  @override
  final DateTime date;
  @override
  final Duration? sleepDuration;
  @override
  final int? sleepScore;
  @override
  final int? restingHeartRate;
  @override
  final int? steps;
  @override
  final int? activeMinutes;

  @override
  String toString() {
    return 'DailyFitness(date: $date, sleepDuration: $sleepDuration, sleepScore: $sleepScore, restingHeartRate: $restingHeartRate, steps: $steps, activeMinutes: $activeMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyFitnessImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.sleepDuration, sleepDuration) ||
                other.sleepDuration == sleepDuration) &&
            (identical(other.sleepScore, sleepScore) ||
                other.sleepScore == sleepScore) &&
            (identical(other.restingHeartRate, restingHeartRate) ||
                other.restingHeartRate == restingHeartRate) &&
            (identical(other.steps, steps) || other.steps == steps) &&
            (identical(other.activeMinutes, activeMinutes) ||
                other.activeMinutes == activeMinutes));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    sleepDuration,
    sleepScore,
    restingHeartRate,
    steps,
    activeMinutes,
  );

  /// Create a copy of DailyFitness
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyFitnessImplCopyWith<_$DailyFitnessImpl> get copyWith =>
      __$$DailyFitnessImplCopyWithImpl<_$DailyFitnessImpl>(this, _$identity);
}

abstract class _DailyFitness implements DailyFitness {
  const factory _DailyFitness({
    required final DateTime date,
    final Duration? sleepDuration,
    final int? sleepScore,
    final int? restingHeartRate,
    final int? steps,
    final int? activeMinutes,
  }) = _$DailyFitnessImpl;

  /// 00:00 of the local day this row represents.
  @override
  DateTime get date;
  @override
  Duration? get sleepDuration;
  @override
  int? get sleepScore;
  @override
  int? get restingHeartRate;
  @override
  int? get steps;
  @override
  int? get activeMinutes;

  /// Create a copy of DailyFitness
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyFitnessImplCopyWith<_$DailyFitnessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
