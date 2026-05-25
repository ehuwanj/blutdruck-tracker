// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metric_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$MetricSummary {
  num? get min => throw _privateConstructorUsedError;
  num? get max => throw _privateConstructorUsedError;
  num? get average => throw _privateConstructorUsedError;
  TrendDirection get trend => throw _privateConstructorUsedError;

  /// Create a copy of MetricSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetricSummaryCopyWith<MetricSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetricSummaryCopyWith<$Res> {
  factory $MetricSummaryCopyWith(
    MetricSummary value,
    $Res Function(MetricSummary) then,
  ) = _$MetricSummaryCopyWithImpl<$Res, MetricSummary>;
  @useResult
  $Res call({num? min, num? max, num? average, TrendDirection trend});
}

/// @nodoc
class _$MetricSummaryCopyWithImpl<$Res, $Val extends MetricSummary>
    implements $MetricSummaryCopyWith<$Res> {
  _$MetricSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetricSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = freezed,
    Object? max = freezed,
    Object? average = freezed,
    Object? trend = null,
  }) {
    return _then(
      _value.copyWith(
            min: freezed == min
                ? _value.min
                : min // ignore: cast_nullable_to_non_nullable
                      as num?,
            max: freezed == max
                ? _value.max
                : max // ignore: cast_nullable_to_non_nullable
                      as num?,
            average: freezed == average
                ? _value.average
                : average // ignore: cast_nullable_to_non_nullable
                      as num?,
            trend: null == trend
                ? _value.trend
                : trend // ignore: cast_nullable_to_non_nullable
                      as TrendDirection,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetricSummaryImplCopyWith<$Res>
    implements $MetricSummaryCopyWith<$Res> {
  factory _$$MetricSummaryImplCopyWith(
    _$MetricSummaryImpl value,
    $Res Function(_$MetricSummaryImpl) then,
  ) = __$$MetricSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({num? min, num? max, num? average, TrendDirection trend});
}

/// @nodoc
class __$$MetricSummaryImplCopyWithImpl<$Res>
    extends _$MetricSummaryCopyWithImpl<$Res, _$MetricSummaryImpl>
    implements _$$MetricSummaryImplCopyWith<$Res> {
  __$$MetricSummaryImplCopyWithImpl(
    _$MetricSummaryImpl _value,
    $Res Function(_$MetricSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetricSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? min = freezed,
    Object? max = freezed,
    Object? average = freezed,
    Object? trend = null,
  }) {
    return _then(
      _$MetricSummaryImpl(
        min: freezed == min
            ? _value.min
            : min // ignore: cast_nullable_to_non_nullable
                  as num?,
        max: freezed == max
            ? _value.max
            : max // ignore: cast_nullable_to_non_nullable
                  as num?,
        average: freezed == average
            ? _value.average
            : average // ignore: cast_nullable_to_non_nullable
                  as num?,
        trend: null == trend
            ? _value.trend
            : trend // ignore: cast_nullable_to_non_nullable
                  as TrendDirection,
      ),
    );
  }
}

/// @nodoc

class _$MetricSummaryImpl implements _MetricSummary {
  const _$MetricSummaryImpl({
    this.min,
    this.max,
    this.average,
    this.trend = TrendDirection.unknown,
  });

  @override
  final num? min;
  @override
  final num? max;
  @override
  final num? average;
  @override
  @JsonKey()
  final TrendDirection trend;

  @override
  String toString() {
    return 'MetricSummary(min: $min, max: $max, average: $average, trend: $trend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetricSummaryImpl &&
            (identical(other.min, min) || other.min == min) &&
            (identical(other.max, max) || other.max == max) &&
            (identical(other.average, average) || other.average == average) &&
            (identical(other.trend, trend) || other.trend == trend));
  }

  @override
  int get hashCode => Object.hash(runtimeType, min, max, average, trend);

  /// Create a copy of MetricSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetricSummaryImplCopyWith<_$MetricSummaryImpl> get copyWith =>
      __$$MetricSummaryImplCopyWithImpl<_$MetricSummaryImpl>(this, _$identity);
}

abstract class _MetricSummary implements MetricSummary {
  const factory _MetricSummary({
    final num? min,
    final num? max,
    final num? average,
    final TrendDirection trend,
  }) = _$MetricSummaryImpl;

  @override
  num? get min;
  @override
  num? get max;
  @override
  num? get average;
  @override
  TrendDirection get trend;

  /// Create a copy of MetricSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetricSummaryImplCopyWith<_$MetricSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
