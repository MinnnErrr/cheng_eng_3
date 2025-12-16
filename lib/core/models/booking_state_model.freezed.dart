// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingState {

 Vehicle? get vehicle; List<BookingServiceType>? get services; DateTime? get date; TimeOfDay? get time; String? get remarks;
/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingStateCopyWith<BookingState> get copyWith => _$BookingStateCopyWithImpl<BookingState>(this as BookingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingState&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.remarks, remarks) || other.remarks == remarks));
}


@override
int get hashCode => Object.hash(runtimeType,vehicle,const DeepCollectionEquality().hash(services),date,time,remarks);

@override
String toString() {
  return 'BookingState(vehicle: $vehicle, services: $services, date: $date, time: $time, remarks: $remarks)';
}


}

/// @nodoc
abstract mixin class $BookingStateCopyWith<$Res>  {
  factory $BookingStateCopyWith(BookingState value, $Res Function(BookingState) _then) = _$BookingStateCopyWithImpl;
@useResult
$Res call({
 Vehicle? vehicle, List<BookingServiceType>? services, DateTime? date, TimeOfDay? time, String? remarks
});


$VehicleCopyWith<$Res>? get vehicle;

}
/// @nodoc
class _$BookingStateCopyWithImpl<$Res>
    implements $BookingStateCopyWith<$Res> {
  _$BookingStateCopyWithImpl(this._self, this._then);

  final BookingState _self;
  final $Res Function(BookingState) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vehicle = freezed,Object? services = freezed,Object? date = freezed,Object? time = freezed,Object? remarks = freezed,}) {
  return _then(_self.copyWith(
vehicle: freezed == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as Vehicle?,services: freezed == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<BookingServiceType>?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleCopyWith<$Res>? get vehicle {
    if (_self.vehicle == null) {
    return null;
  }

  return $VehicleCopyWith<$Res>(_self.vehicle!, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}


/// Adds pattern-matching-related methods to [BookingState].
extension BookingStatePatterns on BookingState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingState value)  $default,){
final _that = this;
switch (_that) {
case _BookingState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingState value)?  $default,){
final _that = this;
switch (_that) {
case _BookingState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Vehicle? vehicle,  List<BookingServiceType>? services,  DateTime? date,  TimeOfDay? time,  String? remarks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingState() when $default != null:
return $default(_that.vehicle,_that.services,_that.date,_that.time,_that.remarks);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Vehicle? vehicle,  List<BookingServiceType>? services,  DateTime? date,  TimeOfDay? time,  String? remarks)  $default,) {final _that = this;
switch (_that) {
case _BookingState():
return $default(_that.vehicle,_that.services,_that.date,_that.time,_that.remarks);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Vehicle? vehicle,  List<BookingServiceType>? services,  DateTime? date,  TimeOfDay? time,  String? remarks)?  $default,) {final _that = this;
switch (_that) {
case _BookingState() when $default != null:
return $default(_that.vehicle,_that.services,_that.date,_that.time,_that.remarks);case _:
  return null;

}
}

}

/// @nodoc


class _BookingState implements BookingState {
  const _BookingState({this.vehicle, final  List<BookingServiceType>? services, this.date, this.time, this.remarks}): _services = services;
  

@override final  Vehicle? vehicle;
 final  List<BookingServiceType>? _services;
@override List<BookingServiceType>? get services {
  final value = _services;
  if (value == null) return null;
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? date;
@override final  TimeOfDay? time;
@override final  String? remarks;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingStateCopyWith<_BookingState> get copyWith => __$BookingStateCopyWithImpl<_BookingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingState&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.remarks, remarks) || other.remarks == remarks));
}


@override
int get hashCode => Object.hash(runtimeType,vehicle,const DeepCollectionEquality().hash(_services),date,time,remarks);

@override
String toString() {
  return 'BookingState(vehicle: $vehicle, services: $services, date: $date, time: $time, remarks: $remarks)';
}


}

/// @nodoc
abstract mixin class _$BookingStateCopyWith<$Res> implements $BookingStateCopyWith<$Res> {
  factory _$BookingStateCopyWith(_BookingState value, $Res Function(_BookingState) _then) = __$BookingStateCopyWithImpl;
@override @useResult
$Res call({
 Vehicle? vehicle, List<BookingServiceType>? services, DateTime? date, TimeOfDay? time, String? remarks
});


@override $VehicleCopyWith<$Res>? get vehicle;

}
/// @nodoc
class __$BookingStateCopyWithImpl<$Res>
    implements _$BookingStateCopyWith<$Res> {
  __$BookingStateCopyWithImpl(this._self, this._then);

  final _BookingState _self;
  final $Res Function(_BookingState) _then;

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vehicle = freezed,Object? services = freezed,Object? date = freezed,Object? time = freezed,Object? remarks = freezed,}) {
  return _then(_BookingState(
vehicle: freezed == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as Vehicle?,services: freezed == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<BookingServiceType>?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BookingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VehicleCopyWith<$Res>? get vehicle {
    if (_self.vehicle == null) {
    return null;
  }

  return $VehicleCopyWith<$Res>(_self.vehicle!, (value) {
    return _then(_self.copyWith(vehicle: value));
  });
}
}

// dart format on
