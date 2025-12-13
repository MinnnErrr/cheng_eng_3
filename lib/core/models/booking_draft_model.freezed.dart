// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_draft_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookingDraft {

 Vehicle? get vehicle; BookingServiceType? get serviceType; DateTime? get date; TimeOfDay? get time;
/// Create a copy of BookingDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingDraftCopyWith<BookingDraft> get copyWith => _$BookingDraftCopyWithImpl<BookingDraft>(this as BookingDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookingDraft&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,vehicle,serviceType,date,time);

@override
String toString() {
  return 'BookingDraft(vehicle: $vehicle, serviceType: $serviceType, date: $date, time: $time)';
}


}

/// @nodoc
abstract mixin class $BookingDraftCopyWith<$Res>  {
  factory $BookingDraftCopyWith(BookingDraft value, $Res Function(BookingDraft) _then) = _$BookingDraftCopyWithImpl;
@useResult
$Res call({
 Vehicle? vehicle, BookingServiceType? serviceType, DateTime? date, TimeOfDay? time
});


$VehicleCopyWith<$Res>? get vehicle;

}
/// @nodoc
class _$BookingDraftCopyWithImpl<$Res>
    implements $BookingDraftCopyWith<$Res> {
  _$BookingDraftCopyWithImpl(this._self, this._then);

  final BookingDraft _self;
  final $Res Function(BookingDraft) _then;

/// Create a copy of BookingDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vehicle = freezed,Object? serviceType = freezed,Object? date = freezed,Object? time = freezed,}) {
  return _then(_self.copyWith(
vehicle: freezed == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as Vehicle?,serviceType: freezed == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as BookingServiceType?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,
  ));
}
/// Create a copy of BookingDraft
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


/// Adds pattern-matching-related methods to [BookingDraft].
extension BookingDraftPatterns on BookingDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookingDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookingDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookingDraft value)  $default,){
final _that = this;
switch (_that) {
case _BookingDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookingDraft value)?  $default,){
final _that = this;
switch (_that) {
case _BookingDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Vehicle? vehicle,  BookingServiceType? serviceType,  DateTime? date,  TimeOfDay? time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookingDraft() when $default != null:
return $default(_that.vehicle,_that.serviceType,_that.date,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Vehicle? vehicle,  BookingServiceType? serviceType,  DateTime? date,  TimeOfDay? time)  $default,) {final _that = this;
switch (_that) {
case _BookingDraft():
return $default(_that.vehicle,_that.serviceType,_that.date,_that.time);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Vehicle? vehicle,  BookingServiceType? serviceType,  DateTime? date,  TimeOfDay? time)?  $default,) {final _that = this;
switch (_that) {
case _BookingDraft() when $default != null:
return $default(_that.vehicle,_that.serviceType,_that.date,_that.time);case _:
  return null;

}
}

}

/// @nodoc


class _BookingDraft implements BookingDraft {
  const _BookingDraft({this.vehicle, this.serviceType, this.date, this.time});
  

@override final  Vehicle? vehicle;
@override final  BookingServiceType? serviceType;
@override final  DateTime? date;
@override final  TimeOfDay? time;

/// Create a copy of BookingDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingDraftCopyWith<_BookingDraft> get copyWith => __$BookingDraftCopyWithImpl<_BookingDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookingDraft&&(identical(other.vehicle, vehicle) || other.vehicle == vehicle)&&(identical(other.serviceType, serviceType) || other.serviceType == serviceType)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,vehicle,serviceType,date,time);

@override
String toString() {
  return 'BookingDraft(vehicle: $vehicle, serviceType: $serviceType, date: $date, time: $time)';
}


}

/// @nodoc
abstract mixin class _$BookingDraftCopyWith<$Res> implements $BookingDraftCopyWith<$Res> {
  factory _$BookingDraftCopyWith(_BookingDraft value, $Res Function(_BookingDraft) _then) = __$BookingDraftCopyWithImpl;
@override @useResult
$Res call({
 Vehicle? vehicle, BookingServiceType? serviceType, DateTime? date, TimeOfDay? time
});


@override $VehicleCopyWith<$Res>? get vehicle;

}
/// @nodoc
class __$BookingDraftCopyWithImpl<$Res>
    implements _$BookingDraftCopyWith<$Res> {
  __$BookingDraftCopyWithImpl(this._self, this._then);

  final _BookingDraft _self;
  final $Res Function(_BookingDraft) _then;

/// Create a copy of BookingDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vehicle = freezed,Object? serviceType = freezed,Object? date = freezed,Object? time = freezed,}) {
  return _then(_BookingDraft(
vehicle: freezed == vehicle ? _self.vehicle : vehicle // ignore: cast_nullable_to_non_nullable
as Vehicle?,serviceType: freezed == serviceType ? _self.serviceType : serviceType // ignore: cast_nullable_to_non_nullable
as BookingServiceType?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,
  ));
}

/// Create a copy of BookingDraft
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
