// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StatisticsResult {
  /// UTC, inclusive.
  DateTime get from => throw _privateConstructorUsedError;

  /// UTC, inclusive.
  DateTime get to => throw _privateConstructorUsedError;
  int get entryCount => throw _privateConstructorUsedError;
  MetricSummary get systolic => throw _privateConstructorUsedError;
  MetricSummary get diastolic => throw _privateConstructorUsedError;
  MetricSummary get pulse => throw _privateConstructorUsedError;
  MetricSummary get pulsePressure => throw _privateConstructorUsedError;
  MetricSummary get meanArterialPressure => throw _privateConstructorUsedError;
  Map<BloodPressureCategory, int> get categoryDistribution =>
      throw _privateConstructorUsedError;

  /// `null` when height is unset or no in-period reading has weight.
  BmiSummary? get bmi => throw _privateConstructorUsedError;

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatisticsResultCopyWith<StatisticsResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticsResultCopyWith<$Res> {
  factory $StatisticsResultCopyWith(
    StatisticsResult value,
    $Res Function(StatisticsResult) then,
  ) = _$StatisticsResultCopyWithImpl<$Res, StatisticsResult>;
  @useResult
  $Res call({
    DateTime from,
    DateTime to,
    int entryCount,
    MetricSummary systolic,
    MetricSummary diastolic,
    MetricSummary pulse,
    MetricSummary pulsePressure,
    MetricSummary meanArterialPressure,
    Map<BloodPressureCategory, int> categoryDistribution,
    BmiSummary? bmi,
  });

  $MetricSummaryCopyWith<$Res> get systolic;
  $MetricSummaryCopyWith<$Res> get diastolic;
  $MetricSummaryCopyWith<$Res> get pulse;
  $MetricSummaryCopyWith<$Res> get pulsePressure;
  $MetricSummaryCopyWith<$Res> get meanArterialPressure;
  $BmiSummaryCopyWith<$Res>? get bmi;
}

/// @nodoc
class _$StatisticsResultCopyWithImpl<$Res, $Val extends StatisticsResult>
    implements $StatisticsResultCopyWith<$Res> {
  _$StatisticsResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? entryCount = null,
    Object? systolic = null,
    Object? diastolic = null,
    Object? pulse = null,
    Object? pulsePressure = null,
    Object? meanArterialPressure = null,
    Object? categoryDistribution = null,
    Object? bmi = freezed,
  }) {
    return _then(
      _value.copyWith(
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            entryCount: null == entryCount
                ? _value.entryCount
                : entryCount // ignore: cast_nullable_to_non_nullable
                      as int,
            systolic: null == systolic
                ? _value.systolic
                : systolic // ignore: cast_nullable_to_non_nullable
                      as MetricSummary,
            diastolic: null == diastolic
                ? _value.diastolic
                : diastolic // ignore: cast_nullable_to_non_nullable
                      as MetricSummary,
            pulse: null == pulse
                ? _value.pulse
                : pulse // ignore: cast_nullable_to_non_nullable
                      as MetricSummary,
            pulsePressure: null == pulsePressure
                ? _value.pulsePressure
                : pulsePressure // ignore: cast_nullable_to_non_nullable
                      as MetricSummary,
            meanArterialPressure: null == meanArterialPressure
                ? _value.meanArterialPressure
                : meanArterialPressure // ignore: cast_nullable_to_non_nullable
                      as MetricSummary,
            categoryDistribution: null == categoryDistribution
                ? _value.categoryDistribution
                : categoryDistribution // ignore: cast_nullable_to_non_nullable
                      as Map<BloodPressureCategory, int>,
            bmi: freezed == bmi
                ? _value.bmi
                : bmi // ignore: cast_nullable_to_non_nullable
                      as BmiSummary?,
          )
          as $Val,
    );
  }

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetricSummaryCopyWith<$Res> get systolic {
    return $MetricSummaryCopyWith<$Res>(_value.systolic, (value) {
      return _then(_value.copyWith(systolic: value) as $Val);
    });
  }

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetricSummaryCopyWith<$Res> get diastolic {
    return $MetricSummaryCopyWith<$Res>(_value.diastolic, (value) {
      return _then(_value.copyWith(diastolic: value) as $Val);
    });
  }

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetricSummaryCopyWith<$Res> get pulse {
    return $MetricSummaryCopyWith<$Res>(_value.pulse, (value) {
      return _then(_value.copyWith(pulse: value) as $Val);
    });
  }

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetricSummaryCopyWith<$Res> get pulsePressure {
    return $MetricSummaryCopyWith<$Res>(_value.pulsePressure, (value) {
      return _then(_value.copyWith(pulsePressure: value) as $Val);
    });
  }

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MetricSummaryCopyWith<$Res> get meanArterialPressure {
    return $MetricSummaryCopyWith<$Res>(_value.meanArterialPressure, (value) {
      return _then(_value.copyWith(meanArterialPressure: value) as $Val);
    });
  }

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BmiSummaryCopyWith<$Res>? get bmi {
    if (_value.bmi == null) {
      return null;
    }

    return $BmiSummaryCopyWith<$Res>(_value.bmi!, (value) {
      return _then(_value.copyWith(bmi: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StatisticsResultImplCopyWith<$Res>
    implements $StatisticsResultCopyWith<$Res> {
  factory _$$StatisticsResultImplCopyWith(
    _$StatisticsResultImpl value,
    $Res Function(_$StatisticsResultImpl) then,
  ) = __$$StatisticsResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime from,
    DateTime to,
    int entryCount,
    MetricSummary systolic,
    MetricSummary diastolic,
    MetricSummary pulse,
    MetricSummary pulsePressure,
    MetricSummary meanArterialPressure,
    Map<BloodPressureCategory, int> categoryDistribution,
    BmiSummary? bmi,
  });

  @override
  $MetricSummaryCopyWith<$Res> get systolic;
  @override
  $MetricSummaryCopyWith<$Res> get diastolic;
  @override
  $MetricSummaryCopyWith<$Res> get pulse;
  @override
  $MetricSummaryCopyWith<$Res> get pulsePressure;
  @override
  $MetricSummaryCopyWith<$Res> get meanArterialPressure;
  @override
  $BmiSummaryCopyWith<$Res>? get bmi;
}

/// @nodoc
class __$$StatisticsResultImplCopyWithImpl<$Res>
    extends _$StatisticsResultCopyWithImpl<$Res, _$StatisticsResultImpl>
    implements _$$StatisticsResultImplCopyWith<$Res> {
  __$$StatisticsResultImplCopyWithImpl(
    _$StatisticsResultImpl _value,
    $Res Function(_$StatisticsResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? entryCount = null,
    Object? systolic = null,
    Object? diastolic = null,
    Object? pulse = null,
    Object? pulsePressure = null,
    Object? meanArterialPressure = null,
    Object? categoryDistribution = null,
    Object? bmi = freezed,
  }) {
    return _then(
      _$StatisticsResultImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        entryCount: null == entryCount
            ? _value.entryCount
            : entryCount // ignore: cast_nullable_to_non_nullable
                  as int,
        systolic: null == systolic
            ? _value.systolic
            : systolic // ignore: cast_nullable_to_non_nullable
                  as MetricSummary,
        diastolic: null == diastolic
            ? _value.diastolic
            : diastolic // ignore: cast_nullable_to_non_nullable
                  as MetricSummary,
        pulse: null == pulse
            ? _value.pulse
            : pulse // ignore: cast_nullable_to_non_nullable
                  as MetricSummary,
        pulsePressure: null == pulsePressure
            ? _value.pulsePressure
            : pulsePressure // ignore: cast_nullable_to_non_nullable
                  as MetricSummary,
        meanArterialPressure: null == meanArterialPressure
            ? _value.meanArterialPressure
            : meanArterialPressure // ignore: cast_nullable_to_non_nullable
                  as MetricSummary,
        categoryDistribution: null == categoryDistribution
            ? _value._categoryDistribution
            : categoryDistribution // ignore: cast_nullable_to_non_nullable
                  as Map<BloodPressureCategory, int>,
        bmi: freezed == bmi
            ? _value.bmi
            : bmi // ignore: cast_nullable_to_non_nullable
                  as BmiSummary?,
      ),
    );
  }
}

/// @nodoc

class _$StatisticsResultImpl implements _StatisticsResult {
  const _$StatisticsResultImpl({
    required this.from,
    required this.to,
    required this.entryCount,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.pulsePressure,
    required this.meanArterialPressure,
    required final Map<BloodPressureCategory, int> categoryDistribution,
    this.bmi,
  }) : _categoryDistribution = categoryDistribution;

  /// UTC, inclusive.
  @override
  final DateTime from;

  /// UTC, inclusive.
  @override
  final DateTime to;
  @override
  final int entryCount;
  @override
  final MetricSummary systolic;
  @override
  final MetricSummary diastolic;
  @override
  final MetricSummary pulse;
  @override
  final MetricSummary pulsePressure;
  @override
  final MetricSummary meanArterialPressure;
  final Map<BloodPressureCategory, int> _categoryDistribution;
  @override
  Map<BloodPressureCategory, int> get categoryDistribution {
    if (_categoryDistribution is EqualUnmodifiableMapView)
      return _categoryDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryDistribution);
  }

  /// `null` when height is unset or no in-period reading has weight.
  @override
  final BmiSummary? bmi;

  @override
  String toString() {
    return 'StatisticsResult(from: $from, to: $to, entryCount: $entryCount, systolic: $systolic, diastolic: $diastolic, pulse: $pulse, pulsePressure: $pulsePressure, meanArterialPressure: $meanArterialPressure, categoryDistribution: $categoryDistribution, bmi: $bmi)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticsResultImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.entryCount, entryCount) ||
                other.entryCount == entryCount) &&
            (identical(other.systolic, systolic) ||
                other.systolic == systolic) &&
            (identical(other.diastolic, diastolic) ||
                other.diastolic == diastolic) &&
            (identical(other.pulse, pulse) || other.pulse == pulse) &&
            (identical(other.pulsePressure, pulsePressure) ||
                other.pulsePressure == pulsePressure) &&
            (identical(other.meanArterialPressure, meanArterialPressure) ||
                other.meanArterialPressure == meanArterialPressure) &&
            const DeepCollectionEquality().equals(
              other._categoryDistribution,
              _categoryDistribution,
            ) &&
            (identical(other.bmi, bmi) || other.bmi == bmi));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    from,
    to,
    entryCount,
    systolic,
    diastolic,
    pulse,
    pulsePressure,
    meanArterialPressure,
    const DeepCollectionEquality().hash(_categoryDistribution),
    bmi,
  );

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticsResultImplCopyWith<_$StatisticsResultImpl> get copyWith =>
      __$$StatisticsResultImplCopyWithImpl<_$StatisticsResultImpl>(
        this,
        _$identity,
      );
}

abstract class _StatisticsResult implements StatisticsResult {
  const factory _StatisticsResult({
    required final DateTime from,
    required final DateTime to,
    required final int entryCount,
    required final MetricSummary systolic,
    required final MetricSummary diastolic,
    required final MetricSummary pulse,
    required final MetricSummary pulsePressure,
    required final MetricSummary meanArterialPressure,
    required final Map<BloodPressureCategory, int> categoryDistribution,
    final BmiSummary? bmi,
  }) = _$StatisticsResultImpl;

  /// UTC, inclusive.
  @override
  DateTime get from;

  /// UTC, inclusive.
  @override
  DateTime get to;
  @override
  int get entryCount;
  @override
  MetricSummary get systolic;
  @override
  MetricSummary get diastolic;
  @override
  MetricSummary get pulse;
  @override
  MetricSummary get pulsePressure;
  @override
  MetricSummary get meanArterialPressure;
  @override
  Map<BloodPressureCategory, int> get categoryDistribution;

  /// `null` when height is unset or no in-period reading has weight.
  @override
  BmiSummary? get bmi;

  /// Create a copy of StatisticsResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticsResultImplCopyWith<_$StatisticsResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
