// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight_prompt_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$InsightPromptData {
  DateTime get from => throw _privateConstructorUsedError;
  DateTime get to => throw _privateConstructorUsedError;
  StatisticsResult get stats => throw _privateConstructorUsedError;
  String get localeName => throw _privateConstructorUsedError;
  List<Insight> get ruleBasedInsights => throw _privateConstructorUsedError;

  /// Create a copy of InsightPromptData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightPromptDataCopyWith<InsightPromptData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightPromptDataCopyWith<$Res> {
  factory $InsightPromptDataCopyWith(
    InsightPromptData value,
    $Res Function(InsightPromptData) then,
  ) = _$InsightPromptDataCopyWithImpl<$Res, InsightPromptData>;
  @useResult
  $Res call({
    DateTime from,
    DateTime to,
    StatisticsResult stats,
    String localeName,
    List<Insight> ruleBasedInsights,
  });

  $StatisticsResultCopyWith<$Res> get stats;
}

/// @nodoc
class _$InsightPromptDataCopyWithImpl<$Res, $Val extends InsightPromptData>
    implements $InsightPromptDataCopyWith<$Res> {
  _$InsightPromptDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InsightPromptData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? stats = null,
    Object? localeName = null,
    Object? ruleBasedInsights = null,
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
            stats: null == stats
                ? _value.stats
                : stats // ignore: cast_nullable_to_non_nullable
                      as StatisticsResult,
            localeName: null == localeName
                ? _value.localeName
                : localeName // ignore: cast_nullable_to_non_nullable
                      as String,
            ruleBasedInsights: null == ruleBasedInsights
                ? _value.ruleBasedInsights
                : ruleBasedInsights // ignore: cast_nullable_to_non_nullable
                      as List<Insight>,
          )
          as $Val,
    );
  }

  /// Create a copy of InsightPromptData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StatisticsResultCopyWith<$Res> get stats {
    return $StatisticsResultCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InsightPromptDataImplCopyWith<$Res>
    implements $InsightPromptDataCopyWith<$Res> {
  factory _$$InsightPromptDataImplCopyWith(
    _$InsightPromptDataImpl value,
    $Res Function(_$InsightPromptDataImpl) then,
  ) = __$$InsightPromptDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime from,
    DateTime to,
    StatisticsResult stats,
    String localeName,
    List<Insight> ruleBasedInsights,
  });

  @override
  $StatisticsResultCopyWith<$Res> get stats;
}

/// @nodoc
class __$$InsightPromptDataImplCopyWithImpl<$Res>
    extends _$InsightPromptDataCopyWithImpl<$Res, _$InsightPromptDataImpl>
    implements _$$InsightPromptDataImplCopyWith<$Res> {
  __$$InsightPromptDataImplCopyWithImpl(
    _$InsightPromptDataImpl _value,
    $Res Function(_$InsightPromptDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InsightPromptData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? stats = null,
    Object? localeName = null,
    Object? ruleBasedInsights = null,
  }) {
    return _then(
      _$InsightPromptDataImpl(
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        stats: null == stats
            ? _value.stats
            : stats // ignore: cast_nullable_to_non_nullable
                  as StatisticsResult,
        localeName: null == localeName
            ? _value.localeName
            : localeName // ignore: cast_nullable_to_non_nullable
                  as String,
        ruleBasedInsights: null == ruleBasedInsights
            ? _value._ruleBasedInsights
            : ruleBasedInsights // ignore: cast_nullable_to_non_nullable
                  as List<Insight>,
      ),
    );
  }
}

/// @nodoc

class _$InsightPromptDataImpl implements _InsightPromptData {
  const _$InsightPromptDataImpl({
    required this.from,
    required this.to,
    required this.stats,
    required this.localeName,
    final List<Insight> ruleBasedInsights = const <Insight>[],
  }) : _ruleBasedInsights = ruleBasedInsights;

  @override
  final DateTime from;
  @override
  final DateTime to;
  @override
  final StatisticsResult stats;
  @override
  final String localeName;
  final List<Insight> _ruleBasedInsights;
  @override
  @JsonKey()
  List<Insight> get ruleBasedInsights {
    if (_ruleBasedInsights is EqualUnmodifiableListView)
      return _ruleBasedInsights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ruleBasedInsights);
  }

  @override
  String toString() {
    return 'InsightPromptData(from: $from, to: $to, stats: $stats, localeName: $localeName, ruleBasedInsights: $ruleBasedInsights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightPromptDataImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            (identical(other.localeName, localeName) ||
                other.localeName == localeName) &&
            const DeepCollectionEquality().equals(
              other._ruleBasedInsights,
              _ruleBasedInsights,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    from,
    to,
    stats,
    localeName,
    const DeepCollectionEquality().hash(_ruleBasedInsights),
  );

  /// Create a copy of InsightPromptData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightPromptDataImplCopyWith<_$InsightPromptDataImpl> get copyWith =>
      __$$InsightPromptDataImplCopyWithImpl<_$InsightPromptDataImpl>(
        this,
        _$identity,
      );
}

abstract class _InsightPromptData implements InsightPromptData {
  const factory _InsightPromptData({
    required final DateTime from,
    required final DateTime to,
    required final StatisticsResult stats,
    required final String localeName,
    final List<Insight> ruleBasedInsights,
  }) = _$InsightPromptDataImpl;

  @override
  DateTime get from;
  @override
  DateTime get to;
  @override
  StatisticsResult get stats;
  @override
  String get localeName;
  @override
  List<Insight> get ruleBasedInsights;

  /// Create a copy of InsightPromptData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightPromptDataImplCopyWith<_$InsightPromptDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
