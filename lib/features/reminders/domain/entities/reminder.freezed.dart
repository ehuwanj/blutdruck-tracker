// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Reminder {
  String get id => throw _privateConstructorUsedError;

  /// 0..23 (validated at the use case / mapper layer).
  int get hour => throw _privateConstructorUsedError;

  /// 0..59 (validated at the use case / mapper layer).
  int get minute => throw _privateConstructorUsedError;

  /// ISO weekdays 1..7; empty set = every day.
  Set<int> get weekdays => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  String? get label => throw _privateConstructorUsedError;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReminderCopyWith<Reminder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderCopyWith<$Res> {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) then) =
      _$ReminderCopyWithImpl<$Res, Reminder>;
  @useResult
  $Res call({
    String id,
    int hour,
    int minute,
    Set<int> weekdays,
    bool enabled,
    String? label,
  });
}

/// @nodoc
class _$ReminderCopyWithImpl<$Res, $Val extends Reminder>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hour = null,
    Object? minute = null,
    Object? weekdays = null,
    Object? enabled = null,
    Object? label = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            hour: null == hour
                ? _value.hour
                : hour // ignore: cast_nullable_to_non_nullable
                      as int,
            minute: null == minute
                ? _value.minute
                : minute // ignore: cast_nullable_to_non_nullable
                      as int,
            weekdays: null == weekdays
                ? _value.weekdays
                : weekdays // ignore: cast_nullable_to_non_nullable
                      as Set<int>,
            enabled: null == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            label: freezed == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReminderImplCopyWith<$Res>
    implements $ReminderCopyWith<$Res> {
  factory _$$ReminderImplCopyWith(
    _$ReminderImpl value,
    $Res Function(_$ReminderImpl) then,
  ) = __$$ReminderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int hour,
    int minute,
    Set<int> weekdays,
    bool enabled,
    String? label,
  });
}

/// @nodoc
class __$$ReminderImplCopyWithImpl<$Res>
    extends _$ReminderCopyWithImpl<$Res, _$ReminderImpl>
    implements _$$ReminderImplCopyWith<$Res> {
  __$$ReminderImplCopyWithImpl(
    _$ReminderImpl _value,
    $Res Function(_$ReminderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? hour = null,
    Object? minute = null,
    Object? weekdays = null,
    Object? enabled = null,
    Object? label = freezed,
  }) {
    return _then(
      _$ReminderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        hour: null == hour
            ? _value.hour
            : hour // ignore: cast_nullable_to_non_nullable
                  as int,
        minute: null == minute
            ? _value.minute
            : minute // ignore: cast_nullable_to_non_nullable
                  as int,
        weekdays: null == weekdays
            ? _value._weekdays
            : weekdays // ignore: cast_nullable_to_non_nullable
                  as Set<int>,
        enabled: null == enabled
            ? _value.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        label: freezed == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ReminderImpl implements _Reminder {
  const _$ReminderImpl({
    required this.id,
    required this.hour,
    required this.minute,
    required final Set<int> weekdays,
    required this.enabled,
    this.label,
  }) : _weekdays = weekdays;

  @override
  final String id;

  /// 0..23 (validated at the use case / mapper layer).
  @override
  final int hour;

  /// 0..59 (validated at the use case / mapper layer).
  @override
  final int minute;

  /// ISO weekdays 1..7; empty set = every day.
  final Set<int> _weekdays;

  /// ISO weekdays 1..7; empty set = every day.
  @override
  Set<int> get weekdays {
    if (_weekdays is EqualUnmodifiableSetView) return _weekdays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_weekdays);
  }

  @override
  final bool enabled;
  @override
  final String? label;

  @override
  String toString() {
    return 'Reminder(id: $id, hour: $hour, minute: $minute, weekdays: $weekdays, enabled: $enabled, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute) &&
            const DeepCollectionEquality().equals(other._weekdays, _weekdays) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    hour,
    minute,
    const DeepCollectionEquality().hash(_weekdays),
    enabled,
    label,
  );

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      __$$ReminderImplCopyWithImpl<_$ReminderImpl>(this, _$identity);
}

abstract class _Reminder implements Reminder {
  const factory _Reminder({
    required final String id,
    required final int hour,
    required final int minute,
    required final Set<int> weekdays,
    required final bool enabled,
    final String? label,
  }) = _$ReminderImpl;

  @override
  String get id;

  /// 0..23 (validated at the use case / mapper layer).
  @override
  int get hour;

  /// 0..59 (validated at the use case / mapper layer).
  @override
  int get minute;

  /// ISO weekdays 1..7; empty set = every day.
  @override
  Set<int> get weekdays;
  @override
  bool get enabled;
  @override
  String? get label;

  /// Create a copy of Reminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReminderImplCopyWith<_$ReminderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
