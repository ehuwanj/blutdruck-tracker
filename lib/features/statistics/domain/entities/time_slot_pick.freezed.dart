// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_slot_pick.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TimeSlotPick {
  TimeSlot get slot => throw _privateConstructorUsedError;

  /// `true` = picked from data; `false` = user-pinned in settings.
  bool get isAutoDetected => throw _privateConstructorUsedError;
  int get matchingReadings => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlotPick
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotPickCopyWith<TimeSlotPick> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotPickCopyWith<$Res> {
  factory $TimeSlotPickCopyWith(
    TimeSlotPick value,
    $Res Function(TimeSlotPick) then,
  ) = _$TimeSlotPickCopyWithImpl<$Res, TimeSlotPick>;
  @useResult
  $Res call({TimeSlot slot, bool isAutoDetected, int matchingReadings});

  $TimeSlotCopyWith<$Res> get slot;
}

/// @nodoc
class _$TimeSlotPickCopyWithImpl<$Res, $Val extends TimeSlotPick>
    implements $TimeSlotPickCopyWith<$Res> {
  _$TimeSlotPickCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlotPick
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slot = null,
    Object? isAutoDetected = null,
    Object? matchingReadings = null,
  }) {
    return _then(
      _value.copyWith(
            slot: null == slot
                ? _value.slot
                : slot // ignore: cast_nullable_to_non_nullable
                      as TimeSlot,
            isAutoDetected: null == isAutoDetected
                ? _value.isAutoDetected
                : isAutoDetected // ignore: cast_nullable_to_non_nullable
                      as bool,
            matchingReadings: null == matchingReadings
                ? _value.matchingReadings
                : matchingReadings // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of TimeSlotPick
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeSlotCopyWith<$Res> get slot {
    return $TimeSlotCopyWith<$Res>(_value.slot, (value) {
      return _then(_value.copyWith(slot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TimeSlotPickImplCopyWith<$Res>
    implements $TimeSlotPickCopyWith<$Res> {
  factory _$$TimeSlotPickImplCopyWith(
    _$TimeSlotPickImpl value,
    $Res Function(_$TimeSlotPickImpl) then,
  ) = __$$TimeSlotPickImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TimeSlot slot, bool isAutoDetected, int matchingReadings});

  @override
  $TimeSlotCopyWith<$Res> get slot;
}

/// @nodoc
class __$$TimeSlotPickImplCopyWithImpl<$Res>
    extends _$TimeSlotPickCopyWithImpl<$Res, _$TimeSlotPickImpl>
    implements _$$TimeSlotPickImplCopyWith<$Res> {
  __$$TimeSlotPickImplCopyWithImpl(
    _$TimeSlotPickImpl _value,
    $Res Function(_$TimeSlotPickImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeSlotPick
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slot = null,
    Object? isAutoDetected = null,
    Object? matchingReadings = null,
  }) {
    return _then(
      _$TimeSlotPickImpl(
        slot: null == slot
            ? _value.slot
            : slot // ignore: cast_nullable_to_non_nullable
                  as TimeSlot,
        isAutoDetected: null == isAutoDetected
            ? _value.isAutoDetected
            : isAutoDetected // ignore: cast_nullable_to_non_nullable
                  as bool,
        matchingReadings: null == matchingReadings
            ? _value.matchingReadings
            : matchingReadings // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$TimeSlotPickImpl implements _TimeSlotPick {
  const _$TimeSlotPickImpl({
    required this.slot,
    required this.isAutoDetected,
    required this.matchingReadings,
  });

  @override
  final TimeSlot slot;

  /// `true` = picked from data; `false` = user-pinned in settings.
  @override
  final bool isAutoDetected;
  @override
  final int matchingReadings;

  @override
  String toString() {
    return 'TimeSlotPick(slot: $slot, isAutoDetected: $isAutoDetected, matchingReadings: $matchingReadings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotPickImpl &&
            (identical(other.slot, slot) || other.slot == slot) &&
            (identical(other.isAutoDetected, isAutoDetected) ||
                other.isAutoDetected == isAutoDetected) &&
            (identical(other.matchingReadings, matchingReadings) ||
                other.matchingReadings == matchingReadings));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, slot, isAutoDetected, matchingReadings);

  /// Create a copy of TimeSlotPick
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotPickImplCopyWith<_$TimeSlotPickImpl> get copyWith =>
      __$$TimeSlotPickImplCopyWithImpl<_$TimeSlotPickImpl>(this, _$identity);
}

abstract class _TimeSlotPick implements TimeSlotPick {
  const factory _TimeSlotPick({
    required final TimeSlot slot,
    required final bool isAutoDetected,
    required final int matchingReadings,
  }) = _$TimeSlotPickImpl;

  @override
  TimeSlot get slot;

  /// `true` = picked from data; `false` = user-pinned in settings.
  @override
  bool get isAutoDetected;
  @override
  int get matchingReadings;

  /// Create a copy of TimeSlotPick
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotPickImplCopyWith<_$TimeSlotPickImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
