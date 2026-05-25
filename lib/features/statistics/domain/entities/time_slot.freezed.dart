// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_slot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TimeSlot {
  /// 0..1439, minutes since local midnight.
  int get startMinutes => throw _privateConstructorUsedError;

  /// Must be `> 0`. Default exposed via settings is 60.
  int get widthMinutes => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotCopyWith<TimeSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotCopyWith<$Res> {
  factory $TimeSlotCopyWith(TimeSlot value, $Res Function(TimeSlot) then) =
      _$TimeSlotCopyWithImpl<$Res, TimeSlot>;
  @useResult
  $Res call({int startMinutes, int widthMinutes});
}

/// @nodoc
class _$TimeSlotCopyWithImpl<$Res, $Val extends TimeSlot>
    implements $TimeSlotCopyWith<$Res> {
  _$TimeSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startMinutes = null, Object? widthMinutes = null}) {
    return _then(
      _value.copyWith(
            startMinutes: null == startMinutes
                ? _value.startMinutes
                : startMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            widthMinutes: null == widthMinutes
                ? _value.widthMinutes
                : widthMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimeSlotImplCopyWith<$Res>
    implements $TimeSlotCopyWith<$Res> {
  factory _$$TimeSlotImplCopyWith(
    _$TimeSlotImpl value,
    $Res Function(_$TimeSlotImpl) then,
  ) = __$$TimeSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int startMinutes, int widthMinutes});
}

/// @nodoc
class __$$TimeSlotImplCopyWithImpl<$Res>
    extends _$TimeSlotCopyWithImpl<$Res, _$TimeSlotImpl>
    implements _$$TimeSlotImplCopyWith<$Res> {
  __$$TimeSlotImplCopyWithImpl(
    _$TimeSlotImpl _value,
    $Res Function(_$TimeSlotImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? startMinutes = null, Object? widthMinutes = null}) {
    return _then(
      _$TimeSlotImpl(
        startMinutes: null == startMinutes
            ? _value.startMinutes
            : startMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        widthMinutes: null == widthMinutes
            ? _value.widthMinutes
            : widthMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$TimeSlotImpl extends _TimeSlot {
  const _$TimeSlotImpl({required this.startMinutes, required this.widthMinutes})
    : super._();

  /// 0..1439, minutes since local midnight.
  @override
  final int startMinutes;

  /// Must be `> 0`. Default exposed via settings is 60.
  @override
  final int widthMinutes;

  @override
  String toString() {
    return 'TimeSlot(startMinutes: $startMinutes, widthMinutes: $widthMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotImpl &&
            (identical(other.startMinutes, startMinutes) ||
                other.startMinutes == startMinutes) &&
            (identical(other.widthMinutes, widthMinutes) ||
                other.widthMinutes == widthMinutes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, startMinutes, widthMinutes);

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotImplCopyWith<_$TimeSlotImpl> get copyWith =>
      __$$TimeSlotImplCopyWithImpl<_$TimeSlotImpl>(this, _$identity);
}

abstract class _TimeSlot extends TimeSlot {
  const factory _TimeSlot({
    required final int startMinutes,
    required final int widthMinutes,
  }) = _$TimeSlotImpl;
  const _TimeSlot._() : super._();

  /// 0..1439, minutes since local midnight.
  @override
  int get startMinutes;

  /// Must be `> 0`. Default exposed via settings is 60.
  @override
  int get widthMinutes;

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotImplCopyWith<_$TimeSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
