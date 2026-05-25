// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Insight {
  String get id => throw _privateConstructorUsedError;
  InsightSeverity get severity => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime? get generatedAt => throw _privateConstructorUsedError;

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InsightCopyWith<Insight> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InsightCopyWith<$Res> {
  factory $InsightCopyWith(Insight value, $Res Function(Insight) then) =
      _$InsightCopyWithImpl<$Res, Insight>;
  @useResult
  $Res call({
    String id,
    InsightSeverity severity,
    String title,
    String body,
    DateTime? generatedAt,
  });
}

/// @nodoc
class _$InsightCopyWithImpl<$Res, $Val extends Insight>
    implements $InsightCopyWith<$Res> {
  _$InsightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? severity = null,
    Object? title = null,
    Object? body = null,
    Object? generatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as InsightSeverity,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            generatedAt: freezed == generatedAt
                ? _value.generatedAt
                : generatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InsightImplCopyWith<$Res> implements $InsightCopyWith<$Res> {
  factory _$$InsightImplCopyWith(
    _$InsightImpl value,
    $Res Function(_$InsightImpl) then,
  ) = __$$InsightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    InsightSeverity severity,
    String title,
    String body,
    DateTime? generatedAt,
  });
}

/// @nodoc
class __$$InsightImplCopyWithImpl<$Res>
    extends _$InsightCopyWithImpl<$Res, _$InsightImpl>
    implements _$$InsightImplCopyWith<$Res> {
  __$$InsightImplCopyWithImpl(
    _$InsightImpl _value,
    $Res Function(_$InsightImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? severity = null,
    Object? title = null,
    Object? body = null,
    Object? generatedAt = freezed,
  }) {
    return _then(
      _$InsightImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as InsightSeverity,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        generatedAt: freezed == generatedAt
            ? _value.generatedAt
            : generatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc

class _$InsightImpl implements _Insight {
  const _$InsightImpl({
    required this.id,
    required this.severity,
    required this.title,
    required this.body,
    this.generatedAt,
  });

  @override
  final String id;
  @override
  final InsightSeverity severity;
  @override
  final String title;
  @override
  final String body;
  @override
  final DateTime? generatedAt;

  @override
  String toString() {
    return 'Insight(id: $id, severity: $severity, title: $title, body: $body, generatedAt: $generatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InsightImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.generatedAt, generatedAt) ||
                other.generatedAt == generatedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, severity, title, body, generatedAt);

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InsightImplCopyWith<_$InsightImpl> get copyWith =>
      __$$InsightImplCopyWithImpl<_$InsightImpl>(this, _$identity);
}

abstract class _Insight implements Insight {
  const factory _Insight({
    required final String id,
    required final InsightSeverity severity,
    required final String title,
    required final String body,
    final DateTime? generatedAt,
  }) = _$InsightImpl;

  @override
  String get id;
  @override
  InsightSeverity get severity;
  @override
  String get title;
  @override
  String get body;
  @override
  DateTime? get generatedAt;

  /// Create a copy of Insight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InsightImplCopyWith<_$InsightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
