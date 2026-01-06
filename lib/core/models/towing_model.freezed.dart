// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'towing_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Towing {

 String get id; String? get remarks; double get latitude; double get longitude; String get address; String get phoneNum; String get countryCode; String get dialCode; String? get photoPath; TowingStatus get status; String get regNum; String get make; String get model; String get colour; String? get vehiclePhoto; DateTime get createdAt; DateTime? get updatedAt; DateTime? get deletedAt; String get vehicleId; String get userId;
/// Create a copy of Towing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TowingCopyWith<Towing> get copyWith => _$TowingCopyWithImpl<Towing>(this as Towing, _$identity);

  /// Serializes this Towing to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Towing&&(identical(other.id, id) || other.id == id)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNum, phoneNum) || other.phoneNum == phoneNum)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.dialCode, dialCode) || other.dialCode == dialCode)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.regNum, regNum) || other.regNum == regNum)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.colour, colour) || other.colour == colour)&&(identical(other.vehiclePhoto, vehiclePhoto) || other.vehiclePhoto == vehiclePhoto)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,remarks,latitude,longitude,address,phoneNum,countryCode,dialCode,photoPath,status,regNum,make,model,colour,vehiclePhoto,createdAt,updatedAt,deletedAt,vehicleId,userId]);

@override
String toString() {
  return 'Towing(id: $id, remarks: $remarks, latitude: $latitude, longitude: $longitude, address: $address, phoneNum: $phoneNum, countryCode: $countryCode, dialCode: $dialCode, photoPath: $photoPath, status: $status, regNum: $regNum, make: $make, model: $model, colour: $colour, vehiclePhoto: $vehiclePhoto, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, vehicleId: $vehicleId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $TowingCopyWith<$Res>  {
  factory $TowingCopyWith(Towing value, $Res Function(Towing) _then) = _$TowingCopyWithImpl;
@useResult
$Res call({
 String id, String? remarks, double latitude, double longitude, String address, String phoneNum, String countryCode, String dialCode, String? photoPath, TowingStatus status, String regNum, String make, String model, String colour, String? vehiclePhoto, DateTime createdAt, DateTime? updatedAt, DateTime? deletedAt, String vehicleId, String userId
});




}
/// @nodoc
class _$TowingCopyWithImpl<$Res>
    implements $TowingCopyWith<$Res> {
  _$TowingCopyWithImpl(this._self, this._then);

  final Towing _self;
  final $Res Function(Towing) _then;

/// Create a copy of Towing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? remarks = freezed,Object? latitude = null,Object? longitude = null,Object? address = null,Object? phoneNum = null,Object? countryCode = null,Object? dialCode = null,Object? photoPath = freezed,Object? status = null,Object? regNum = null,Object? make = null,Object? model = null,Object? colour = null,Object? vehiclePhoto = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? vehicleId = null,Object? userId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phoneNum: null == phoneNum ? _self.phoneNum : phoneNum // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,dialCode: null == dialCode ? _self.dialCode : dialCode // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TowingStatus,regNum: null == regNum ? _self.regNum : regNum // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,colour: null == colour ? _self.colour : colour // ignore: cast_nullable_to_non_nullable
as String,vehiclePhoto: freezed == vehiclePhoto ? _self.vehiclePhoto : vehiclePhoto // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Towing].
extension TowingPatterns on Towing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Towing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Towing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Towing value)  $default,){
final _that = this;
switch (_that) {
case _Towing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Towing value)?  $default,){
final _that = this;
switch (_that) {
case _Towing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? remarks,  double latitude,  double longitude,  String address,  String phoneNum,  String countryCode,  String dialCode,  String? photoPath,  TowingStatus status,  String regNum,  String make,  String model,  String colour,  String? vehiclePhoto,  DateTime createdAt,  DateTime? updatedAt,  DateTime? deletedAt,  String vehicleId,  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Towing() when $default != null:
return $default(_that.id,_that.remarks,_that.latitude,_that.longitude,_that.address,_that.phoneNum,_that.countryCode,_that.dialCode,_that.photoPath,_that.status,_that.regNum,_that.make,_that.model,_that.colour,_that.vehiclePhoto,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.vehicleId,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? remarks,  double latitude,  double longitude,  String address,  String phoneNum,  String countryCode,  String dialCode,  String? photoPath,  TowingStatus status,  String regNum,  String make,  String model,  String colour,  String? vehiclePhoto,  DateTime createdAt,  DateTime? updatedAt,  DateTime? deletedAt,  String vehicleId,  String userId)  $default,) {final _that = this;
switch (_that) {
case _Towing():
return $default(_that.id,_that.remarks,_that.latitude,_that.longitude,_that.address,_that.phoneNum,_that.countryCode,_that.dialCode,_that.photoPath,_that.status,_that.regNum,_that.make,_that.model,_that.colour,_that.vehiclePhoto,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.vehicleId,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? remarks,  double latitude,  double longitude,  String address,  String phoneNum,  String countryCode,  String dialCode,  String? photoPath,  TowingStatus status,  String regNum,  String make,  String model,  String colour,  String? vehiclePhoto,  DateTime createdAt,  DateTime? updatedAt,  DateTime? deletedAt,  String vehicleId,  String userId)?  $default,) {final _that = this;
switch (_that) {
case _Towing() when $default != null:
return $default(_that.id,_that.remarks,_that.latitude,_that.longitude,_that.address,_that.phoneNum,_that.countryCode,_that.dialCode,_that.photoPath,_that.status,_that.regNum,_that.make,_that.model,_that.colour,_that.vehiclePhoto,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.vehicleId,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Towing implements Towing {
  const _Towing({required this.id, this.remarks, required this.latitude, required this.longitude, required this.address, required this.phoneNum, required this.countryCode, required this.dialCode, this.photoPath, required this.status, required this.regNum, required this.make, required this.model, required this.colour, this.vehiclePhoto, required this.createdAt, this.updatedAt, this.deletedAt, required this.vehicleId, required this.userId});
  factory _Towing.fromJson(Map<String, dynamic> json) => _$TowingFromJson(json);

@override final  String id;
@override final  String? remarks;
@override final  double latitude;
@override final  double longitude;
@override final  String address;
@override final  String phoneNum;
@override final  String countryCode;
@override final  String dialCode;
@override final  String? photoPath;
@override final  TowingStatus status;
@override final  String regNum;
@override final  String make;
@override final  String model;
@override final  String colour;
@override final  String? vehiclePhoto;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
@override final  DateTime? deletedAt;
@override final  String vehicleId;
@override final  String userId;

/// Create a copy of Towing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TowingCopyWith<_Towing> get copyWith => __$TowingCopyWithImpl<_Towing>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TowingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Towing&&(identical(other.id, id) || other.id == id)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.address, address) || other.address == address)&&(identical(other.phoneNum, phoneNum) || other.phoneNum == phoneNum)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.dialCode, dialCode) || other.dialCode == dialCode)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.regNum, regNum) || other.regNum == regNum)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.colour, colour) || other.colour == colour)&&(identical(other.vehiclePhoto, vehiclePhoto) || other.vehiclePhoto == vehiclePhoto)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,remarks,latitude,longitude,address,phoneNum,countryCode,dialCode,photoPath,status,regNum,make,model,colour,vehiclePhoto,createdAt,updatedAt,deletedAt,vehicleId,userId]);

@override
String toString() {
  return 'Towing(id: $id, remarks: $remarks, latitude: $latitude, longitude: $longitude, address: $address, phoneNum: $phoneNum, countryCode: $countryCode, dialCode: $dialCode, photoPath: $photoPath, status: $status, regNum: $regNum, make: $make, model: $model, colour: $colour, vehiclePhoto: $vehiclePhoto, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, vehicleId: $vehicleId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$TowingCopyWith<$Res> implements $TowingCopyWith<$Res> {
  factory _$TowingCopyWith(_Towing value, $Res Function(_Towing) _then) = __$TowingCopyWithImpl;
@override @useResult
$Res call({
 String id, String? remarks, double latitude, double longitude, String address, String phoneNum, String countryCode, String dialCode, String? photoPath, TowingStatus status, String regNum, String make, String model, String colour, String? vehiclePhoto, DateTime createdAt, DateTime? updatedAt, DateTime? deletedAt, String vehicleId, String userId
});




}
/// @nodoc
class __$TowingCopyWithImpl<$Res>
    implements _$TowingCopyWith<$Res> {
  __$TowingCopyWithImpl(this._self, this._then);

  final _Towing _self;
  final $Res Function(_Towing) _then;

/// Create a copy of Towing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? remarks = freezed,Object? latitude = null,Object? longitude = null,Object? address = null,Object? phoneNum = null,Object? countryCode = null,Object? dialCode = null,Object? photoPath = freezed,Object? status = null,Object? regNum = null,Object? make = null,Object? model = null,Object? colour = null,Object? vehiclePhoto = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? deletedAt = freezed,Object? vehicleId = null,Object? userId = null,}) {
  return _then(_Towing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,phoneNum: null == phoneNum ? _self.phoneNum : phoneNum // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,dialCode: null == dialCode ? _self.dialCode : dialCode // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TowingStatus,regNum: null == regNum ? _self.regNum : regNum // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,colour: null == colour ? _self.colour : colour // ignore: cast_nullable_to_non_nullable
as String,vehiclePhoto: freezed == vehiclePhoto ? _self.vehiclePhoto : vehiclePhoto // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
