// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vehicle_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VehicleList {

 List<Vehicle> get vehicles;
/// Create a copy of VehicleList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleListCopyWith<VehicleList> get copyWith => _$VehicleListCopyWithImpl<VehicleList>(this as VehicleList, _$identity);

  /// Serializes this VehicleList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VehicleList&&const DeepCollectionEquality().equals(other.vehicles, vehicles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(vehicles));

@override
String toString() {
  return 'VehicleList(vehicles: $vehicles)';
}


}

/// @nodoc
abstract mixin class $VehicleListCopyWith<$Res>  {
  factory $VehicleListCopyWith(VehicleList value, $Res Function(VehicleList) _then) = _$VehicleListCopyWithImpl;
@useResult
$Res call({
 List<Vehicle> vehicles
});




}
/// @nodoc
class _$VehicleListCopyWithImpl<$Res>
    implements $VehicleListCopyWith<$Res> {
  _$VehicleListCopyWithImpl(this._self, this._then);

  final VehicleList _self;
  final $Res Function(VehicleList) _then;

/// Create a copy of VehicleList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? vehicles = null,}) {
  return _then(_self.copyWith(
vehicles: null == vehicles ? _self.vehicles : vehicles // ignore: cast_nullable_to_non_nullable
as List<Vehicle>,
  ));
}

}


/// Adds pattern-matching-related methods to [VehicleList].
extension VehicleListPatterns on VehicleList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VehicleList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VehicleList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VehicleList value)  $default,){
final _that = this;
switch (_that) {
case _VehicleList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VehicleList value)?  $default,){
final _that = this;
switch (_that) {
case _VehicleList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Vehicle> vehicles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VehicleList() when $default != null:
return $default(_that.vehicles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Vehicle> vehicles)  $default,) {final _that = this;
switch (_that) {
case _VehicleList():
return $default(_that.vehicles);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Vehicle> vehicles)?  $default,) {final _that = this;
switch (_that) {
case _VehicleList() when $default != null:
return $default(_that.vehicles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VehicleList implements VehicleList {
  const _VehicleList({required final  List<Vehicle> vehicles}): _vehicles = vehicles;
  factory _VehicleList.fromJson(Map<String, dynamic> json) => _$VehicleListFromJson(json);

 final  List<Vehicle> _vehicles;
@override List<Vehicle> get vehicles {
  if (_vehicles is EqualUnmodifiableListView) return _vehicles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vehicles);
}


/// Create a copy of VehicleList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleListCopyWith<_VehicleList> get copyWith => __$VehicleListCopyWithImpl<_VehicleList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VehicleList&&const DeepCollectionEquality().equals(other._vehicles, _vehicles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_vehicles));

@override
String toString() {
  return 'VehicleList(vehicles: $vehicles)';
}


}

/// @nodoc
abstract mixin class _$VehicleListCopyWith<$Res> implements $VehicleListCopyWith<$Res> {
  factory _$VehicleListCopyWith(_VehicleList value, $Res Function(_VehicleList) _then) = __$VehicleListCopyWithImpl;
@override @useResult
$Res call({
 List<Vehicle> vehicles
});




}
/// @nodoc
class __$VehicleListCopyWithImpl<$Res>
    implements _$VehicleListCopyWith<$Res> {
  __$VehicleListCopyWithImpl(this._self, this._then);

  final _VehicleList _self;
  final $Res Function(_VehicleList) _then;

/// Create a copy of VehicleList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? vehicles = null,}) {
  return _then(_VehicleList(
vehicles: null == vehicles ? _self._vehicles : vehicles // ignore: cast_nullable_to_non_nullable
as List<Vehicle>,
  ));
}


}


/// @nodoc
mixin _$Vehicle {

 String get id; String? get description; String get regNum; String get make; String get model; String get colour; int get year; String? get photoPath; DateTime? get deletedAt; String get userId;
/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VehicleCopyWith<Vehicle> get copyWith => _$VehicleCopyWithImpl<Vehicle>(this as Vehicle, _$identity);

  /// Serializes this Vehicle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.regNum, regNum) || other.regNum == regNum)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.colour, colour) || other.colour == colour)&&(identical(other.year, year) || other.year == year)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,regNum,make,model,colour,year,photoPath,deletedAt,userId);

@override
String toString() {
  return 'Vehicle(id: $id, description: $description, regNum: $regNum, make: $make, model: $model, colour: $colour, year: $year, photoPath: $photoPath, deletedAt: $deletedAt, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $VehicleCopyWith<$Res>  {
  factory $VehicleCopyWith(Vehicle value, $Res Function(Vehicle) _then) = _$VehicleCopyWithImpl;
@useResult
$Res call({
 String id, String? description, String regNum, String make, String model, String colour, int year, String? photoPath, DateTime? deletedAt, String userId
});




}
/// @nodoc
class _$VehicleCopyWithImpl<$Res>
    implements $VehicleCopyWith<$Res> {
  _$VehicleCopyWithImpl(this._self, this._then);

  final Vehicle _self;
  final $Res Function(Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = freezed,Object? regNum = null,Object? make = null,Object? model = null,Object? colour = null,Object? year = null,Object? photoPath = freezed,Object? deletedAt = freezed,Object? userId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,regNum: null == regNum ? _self.regNum : regNum // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,colour: null == colour ? _self.colour : colour // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Vehicle].
extension VehiclePatterns on Vehicle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vehicle value)  $default,){
final _that = this;
switch (_that) {
case _Vehicle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vehicle value)?  $default,){
final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? description,  String regNum,  String make,  String model,  String colour,  int year,  String? photoPath,  DateTime? deletedAt,  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.description,_that.regNum,_that.make,_that.model,_that.colour,_that.year,_that.photoPath,_that.deletedAt,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? description,  String regNum,  String make,  String model,  String colour,  int year,  String? photoPath,  DateTime? deletedAt,  String userId)  $default,) {final _that = this;
switch (_that) {
case _Vehicle():
return $default(_that.id,_that.description,_that.regNum,_that.make,_that.model,_that.colour,_that.year,_that.photoPath,_that.deletedAt,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? description,  String regNum,  String make,  String model,  String colour,  int year,  String? photoPath,  DateTime? deletedAt,  String userId)?  $default,) {final _that = this;
switch (_that) {
case _Vehicle() when $default != null:
return $default(_that.id,_that.description,_that.regNum,_that.make,_that.model,_that.colour,_that.year,_that.photoPath,_that.deletedAt,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vehicle implements Vehicle {
  const _Vehicle({required this.id, this.description, required this.regNum, required this.make, required this.model, required this.colour, required this.year, this.photoPath, this.deletedAt, required this.userId});
  factory _Vehicle.fromJson(Map<String, dynamic> json) => _$VehicleFromJson(json);

@override final  String id;
@override final  String? description;
@override final  String regNum;
@override final  String make;
@override final  String model;
@override final  String colour;
@override final  int year;
@override final  String? photoPath;
@override final  DateTime? deletedAt;
@override final  String userId;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VehicleCopyWith<_Vehicle> get copyWith => __$VehicleCopyWithImpl<_Vehicle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VehicleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.regNum, regNum) || other.regNum == regNum)&&(identical(other.make, make) || other.make == make)&&(identical(other.model, model) || other.model == model)&&(identical(other.colour, colour) || other.colour == colour)&&(identical(other.year, year) || other.year == year)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,regNum,make,model,colour,year,photoPath,deletedAt,userId);

@override
String toString() {
  return 'Vehicle(id: $id, description: $description, regNum: $regNum, make: $make, model: $model, colour: $colour, year: $year, photoPath: $photoPath, deletedAt: $deletedAt, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$VehicleCopyWith<$Res> implements $VehicleCopyWith<$Res> {
  factory _$VehicleCopyWith(_Vehicle value, $Res Function(_Vehicle) _then) = __$VehicleCopyWithImpl;
@override @useResult
$Res call({
 String id, String? description, String regNum, String make, String model, String colour, int year, String? photoPath, DateTime? deletedAt, String userId
});




}
/// @nodoc
class __$VehicleCopyWithImpl<$Res>
    implements _$VehicleCopyWith<$Res> {
  __$VehicleCopyWithImpl(this._self, this._then);

  final _Vehicle _self;
  final $Res Function(_Vehicle) _then;

/// Create a copy of Vehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = freezed,Object? regNum = null,Object? make = null,Object? model = null,Object? colour = null,Object? year = null,Object? photoPath = freezed,Object? deletedAt = freezed,Object? userId = null,}) {
  return _then(_Vehicle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,regNum: null == regNum ? _self.regNum : regNum // ignore: cast_nullable_to_non_nullable
as String,make: null == make ? _self.make : make // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,colour: null == colour ? _self.colour : colour // ignore: cast_nullable_to_non_nullable
as String,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
