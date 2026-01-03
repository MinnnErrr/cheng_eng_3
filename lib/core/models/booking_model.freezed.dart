// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Booking {

 String get id; List<BookingServiceType> get services; DateTime get date;@TimeOfDayConverter() TimeOfDay get time; String? get remarks; BookingStatus get status; String? get vehiclePhoto; String get vehicleRegNum; String get vehicleMake; String get vehicleModel; String get vehicleColour; int get vehicleYear; DateTime get createdAt; DateTime? get updatedAt; String get vehicleId; String get userId;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.status, status) || other.status == status)&&(identical(other.vehiclePhoto, vehiclePhoto) || other.vehiclePhoto == vehiclePhoto)&&(identical(other.vehicleRegNum, vehicleRegNum) || other.vehicleRegNum == vehicleRegNum)&&(identical(other.vehicleMake, vehicleMake) || other.vehicleMake == vehicleMake)&&(identical(other.vehicleModel, vehicleModel) || other.vehicleModel == vehicleModel)&&(identical(other.vehicleColour, vehicleColour) || other.vehicleColour == vehicleColour)&&(identical(other.vehicleYear, vehicleYear) || other.vehicleYear == vehicleYear)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(services),date,time,remarks,status,vehiclePhoto,vehicleRegNum,vehicleMake,vehicleModel,vehicleColour,vehicleYear,createdAt,updatedAt,vehicleId,userId);

@override
String toString() {
  return 'Booking(id: $id, services: $services, date: $date, time: $time, remarks: $remarks, status: $status, vehiclePhoto: $vehiclePhoto, vehicleRegNum: $vehicleRegNum, vehicleMake: $vehicleMake, vehicleModel: $vehicleModel, vehicleColour: $vehicleColour, vehicleYear: $vehicleYear, createdAt: $createdAt, updatedAt: $updatedAt, vehicleId: $vehicleId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id, List<BookingServiceType> services, DateTime date,@TimeOfDayConverter() TimeOfDay time, String? remarks, BookingStatus status, String? vehiclePhoto, String vehicleRegNum, String vehicleMake, String vehicleModel, String vehicleColour, int vehicleYear, DateTime createdAt, DateTime? updatedAt, String vehicleId, String userId
});




}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? services = null,Object? date = null,Object? time = null,Object? remarks = freezed,Object? status = null,Object? vehiclePhoto = freezed,Object? vehicleRegNum = null,Object? vehicleMake = null,Object? vehicleModel = null,Object? vehicleColour = null,Object? vehicleYear = null,Object? createdAt = null,Object? updatedAt = freezed,Object? vehicleId = null,Object? userId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<BookingServiceType>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,vehiclePhoto: freezed == vehiclePhoto ? _self.vehiclePhoto : vehiclePhoto // ignore: cast_nullable_to_non_nullable
as String?,vehicleRegNum: null == vehicleRegNum ? _self.vehicleRegNum : vehicleRegNum // ignore: cast_nullable_to_non_nullable
as String,vehicleMake: null == vehicleMake ? _self.vehicleMake : vehicleMake // ignore: cast_nullable_to_non_nullable
as String,vehicleModel: null == vehicleModel ? _self.vehicleModel : vehicleModel // ignore: cast_nullable_to_non_nullable
as String,vehicleColour: null == vehicleColour ? _self.vehicleColour : vehicleColour // ignore: cast_nullable_to_non_nullable
as String,vehicleYear: null == vehicleYear ? _self.vehicleYear : vehicleYear // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<BookingServiceType> services,  DateTime date, @TimeOfDayConverter()  TimeOfDay time,  String? remarks,  BookingStatus status,  String? vehiclePhoto,  String vehicleRegNum,  String vehicleMake,  String vehicleModel,  String vehicleColour,  int vehicleYear,  DateTime createdAt,  DateTime? updatedAt,  String vehicleId,  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.services,_that.date,_that.time,_that.remarks,_that.status,_that.vehiclePhoto,_that.vehicleRegNum,_that.vehicleMake,_that.vehicleModel,_that.vehicleColour,_that.vehicleYear,_that.createdAt,_that.updatedAt,_that.vehicleId,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<BookingServiceType> services,  DateTime date, @TimeOfDayConverter()  TimeOfDay time,  String? remarks,  BookingStatus status,  String? vehiclePhoto,  String vehicleRegNum,  String vehicleMake,  String vehicleModel,  String vehicleColour,  int vehicleYear,  DateTime createdAt,  DateTime? updatedAt,  String vehicleId,  String userId)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.services,_that.date,_that.time,_that.remarks,_that.status,_that.vehiclePhoto,_that.vehicleRegNum,_that.vehicleMake,_that.vehicleModel,_that.vehicleColour,_that.vehicleYear,_that.createdAt,_that.updatedAt,_that.vehicleId,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<BookingServiceType> services,  DateTime date, @TimeOfDayConverter()  TimeOfDay time,  String? remarks,  BookingStatus status,  String? vehiclePhoto,  String vehicleRegNum,  String vehicleMake,  String vehicleModel,  String vehicleColour,  int vehicleYear,  DateTime createdAt,  DateTime? updatedAt,  String vehicleId,  String userId)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.services,_that.date,_that.time,_that.remarks,_that.status,_that.vehiclePhoto,_that.vehicleRegNum,_that.vehicleMake,_that.vehicleModel,_that.vehicleColour,_that.vehicleYear,_that.createdAt,_that.updatedAt,_that.vehicleId,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Booking implements Booking {
  const _Booking({required this.id, required final  List<BookingServiceType> services, required this.date, @TimeOfDayConverter() required this.time, required this.remarks, required this.status, required this.vehiclePhoto, required this.vehicleRegNum, required this.vehicleMake, required this.vehicleModel, required this.vehicleColour, required this.vehicleYear, required this.createdAt, required this.updatedAt, required this.vehicleId, required this.userId}): _services = services;
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override final  String id;
 final  List<BookingServiceType> _services;
@override List<BookingServiceType> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

@override final  DateTime date;
@override@TimeOfDayConverter() final  TimeOfDay time;
@override final  String? remarks;
@override final  BookingStatus status;
@override final  String? vehiclePhoto;
@override final  String vehicleRegNum;
@override final  String vehicleMake;
@override final  String vehicleModel;
@override final  String vehicleColour;
@override final  int vehicleYear;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
@override final  String vehicleId;
@override final  String userId;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.status, status) || other.status == status)&&(identical(other.vehiclePhoto, vehiclePhoto) || other.vehiclePhoto == vehiclePhoto)&&(identical(other.vehicleRegNum, vehicleRegNum) || other.vehicleRegNum == vehicleRegNum)&&(identical(other.vehicleMake, vehicleMake) || other.vehicleMake == vehicleMake)&&(identical(other.vehicleModel, vehicleModel) || other.vehicleModel == vehicleModel)&&(identical(other.vehicleColour, vehicleColour) || other.vehicleColour == vehicleColour)&&(identical(other.vehicleYear, vehicleYear) || other.vehicleYear == vehicleYear)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_services),date,time,remarks,status,vehiclePhoto,vehicleRegNum,vehicleMake,vehicleModel,vehicleColour,vehicleYear,createdAt,updatedAt,vehicleId,userId);

@override
String toString() {
  return 'Booking(id: $id, services: $services, date: $date, time: $time, remarks: $remarks, status: $status, vehiclePhoto: $vehiclePhoto, vehicleRegNum: $vehicleRegNum, vehicleMake: $vehicleMake, vehicleModel: $vehicleModel, vehicleColour: $vehicleColour, vehicleYear: $vehicleYear, createdAt: $createdAt, updatedAt: $updatedAt, vehicleId: $vehicleId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id, List<BookingServiceType> services, DateTime date,@TimeOfDayConverter() TimeOfDay time, String? remarks, BookingStatus status, String? vehiclePhoto, String vehicleRegNum, String vehicleMake, String vehicleModel, String vehicleColour, int vehicleYear, DateTime createdAt, DateTime? updatedAt, String vehicleId, String userId
});




}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? services = null,Object? date = null,Object? time = null,Object? remarks = freezed,Object? status = null,Object? vehiclePhoto = freezed,Object? vehicleRegNum = null,Object? vehicleMake = null,Object? vehicleModel = null,Object? vehicleColour = null,Object? vehicleYear = null,Object? createdAt = null,Object? updatedAt = freezed,Object? vehicleId = null,Object? userId = null,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<BookingServiceType>,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BookingStatus,vehiclePhoto: freezed == vehiclePhoto ? _self.vehiclePhoto : vehiclePhoto // ignore: cast_nullable_to_non_nullable
as String?,vehicleRegNum: null == vehicleRegNum ? _self.vehicleRegNum : vehicleRegNum // ignore: cast_nullable_to_non_nullable
as String,vehicleMake: null == vehicleMake ? _self.vehicleMake : vehicleMake // ignore: cast_nullable_to_non_nullable
as String,vehicleModel: null == vehicleModel ? _self.vehicleModel : vehicleModel // ignore: cast_nullable_to_non_nullable
as String,vehicleColour: null == vehicleColour ? _self.vehicleColour : vehicleColour // ignore: cast_nullable_to_non_nullable
as String,vehicleYear: null == vehicleYear ? _self.vehicleYear : vehicleYear // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
