// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fitness_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FitnessSummary {
  List<DailyFitness> get days => throw _privateConstructorUsedError;

  /// Create a copy of FitnessSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FitnessSummaryCopyWith<FitnessSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FitnessSummaryCopyWith<$Res> {
  factory $FitnessSummaryCopyWith(
    FitnessSummary value,
    $Res Function(FitnessSummary) then,
  ) = _$FitnessSummaryCopyWithImpl<$Res, FitnessSummary>;
  @useResult
  $Res call({List<DailyFitness> days});
}

/// @nodoc
class _$FitnessSummaryCopyWithImpl<$Res, $Val extends FitnessSummary>
    implements $FitnessSummaryCopyWith<$Res> {
  _$FitnessSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FitnessSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? days = null}) {
    return _then(
      _value.copyWith(
            days: null == days
                ? _value.days
                : days // ignore: cast_nullable_to_non_nullable
                      as List<DailyFitness>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FitnessSummaryImplCopyWith<$Res>
    implements $FitnessSummaryCopyWith<$Res> {
  factory _$$FitnessSummaryImplCopyWith(
    _$FitnessSummaryImpl value,
    $Res Function(_$FitnessSummaryImpl) then,
  ) = __$$FitnessSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<DailyFitness> days});
}

/// @nodoc
class __$$FitnessSummaryImplCopyWithImpl<$Res>
    extends _$FitnessSummaryCopyWithImpl<$Res, _$FitnessSummaryImpl>
    implements _$$FitnessSummaryImplCopyWith<$Res> {
  __$$FitnessSummaryImplCopyWithImpl(
    _$FitnessSummaryImpl _value,
    $Res Function(_$FitnessSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FitnessSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? days = null}) {
    return _then(
      _$FitnessSummaryImpl(
        days: null == days
            ? _value._days
            : days // ignore: cast_nullable_to_non_nullable
                  as List<DailyFitness>,
      ),
    );
  }
}

/// @nodoc

class _$FitnessSummaryImpl implements _FitnessSummary {
  const _$FitnessSummaryImpl({required final List<DailyFitness> days})
    : _days = days;

  final List<DailyFitness> _days;
  @override
  List<DailyFitness> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  String toString() {
    return 'FitnessSummary(days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FitnessSummaryImpl &&
            const DeepCollectionEquality().equals(other._days, _days));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_days));

  /// Create a copy of FitnessSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FitnessSummaryImplCopyWith<_$FitnessSummaryImpl> get copyWith =>
      __$$FitnessSummaryImplCopyWithImpl<_$FitnessSummaryImpl>(
        this,
        _$identity,
      );
}

abstract class _FitnessSummary implements FitnessSummary {
  const factory _FitnessSummary({required final List<DailyFitness> days}) =
      _$FitnessSummaryImpl;

  @override
  List<DailyFitness> get days;

  /// Create a copy of FitnessSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FitnessSummaryImplCopyWith<_$FitnessSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
