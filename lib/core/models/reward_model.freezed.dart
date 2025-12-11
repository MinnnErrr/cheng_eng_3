// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reward_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reward {

 String get id; DateTime get createdAt; String get code; String get name; String get description; String? get conditions; int get points; int get quantity; DateTime? get availableUntil; bool get hasExpiry; List<String> get photoPaths; bool get status; DateTime? get deletedAt; DateTime? get updatedAt;
/// Create a copy of Reward
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RewardCopyWith<Reward> get copyWith => _$RewardCopyWithImpl<Reward>(this as Reward, _$identity);

  /// Serializes this Reward to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reward&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&(identical(other.points, points) || other.points == points)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.availableUntil, availableUntil) || other.availableUntil == availableUntil)&&(identical(other.hasExpiry, hasExpiry) || other.hasExpiry == hasExpiry)&&const DeepCollectionEquality().equals(other.photoPaths, photoPaths)&&(identical(other.status, status) || other.status == status)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,code,name,description,conditions,points,quantity,availableUntil,hasExpiry,const DeepCollectionEquality().hash(photoPaths),status,deletedAt,updatedAt);

@override
String toString() {
  return 'Reward(id: $id, createdAt: $createdAt, code: $code, name: $name, description: $description, conditions: $conditions, points: $points, quantity: $quantity, availableUntil: $availableUntil, hasExpiry: $hasExpiry, photoPaths: $photoPaths, status: $status, deletedAt: $deletedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RewardCopyWith<$Res>  {
  factory $RewardCopyWith(Reward value, $Res Function(Reward) _then) = _$RewardCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String code, String name, String description, String? conditions, int points, int quantity, DateTime? availableUntil, bool hasExpiry, List<String> photoPaths, bool status, DateTime? deletedAt, DateTime? updatedAt
});




}
/// @nodoc
class _$RewardCopyWithImpl<$Res>
    implements $RewardCopyWith<$Res> {
  _$RewardCopyWithImpl(this._self, this._then);

  final Reward _self;
  final $Res Function(Reward) _then;

/// Create a copy of Reward
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? code = null,Object? name = null,Object? description = null,Object? conditions = freezed,Object? points = null,Object? quantity = null,Object? availableUntil = freezed,Object? hasExpiry = null,Object? photoPaths = null,Object? status = null,Object? deletedAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,availableUntil: freezed == availableUntil ? _self.availableUntil : availableUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,hasExpiry: null == hasExpiry ? _self.hasExpiry : hasExpiry // ignore: cast_nullable_to_non_nullable
as bool,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Reward].
extension RewardPatterns on Reward {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reward value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reward() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reward value)  $default,){
final _that = this;
switch (_that) {
case _Reward():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reward value)?  $default,){
final _that = this;
switch (_that) {
case _Reward() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  String code,  String name,  String description,  String? conditions,  int points,  int quantity,  DateTime? availableUntil,  bool hasExpiry,  List<String> photoPaths,  bool status,  DateTime? deletedAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reward() when $default != null:
return $default(_that.id,_that.createdAt,_that.code,_that.name,_that.description,_that.conditions,_that.points,_that.quantity,_that.availableUntil,_that.hasExpiry,_that.photoPaths,_that.status,_that.deletedAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  String code,  String name,  String description,  String? conditions,  int points,  int quantity,  DateTime? availableUntil,  bool hasExpiry,  List<String> photoPaths,  bool status,  DateTime? deletedAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Reward():
return $default(_that.id,_that.createdAt,_that.code,_that.name,_that.description,_that.conditions,_that.points,_that.quantity,_that.availableUntil,_that.hasExpiry,_that.photoPaths,_that.status,_that.deletedAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  String code,  String name,  String description,  String? conditions,  int points,  int quantity,  DateTime? availableUntil,  bool hasExpiry,  List<String> photoPaths,  bool status,  DateTime? deletedAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Reward() when $default != null:
return $default(_that.id,_that.createdAt,_that.code,_that.name,_that.description,_that.conditions,_that.points,_that.quantity,_that.availableUntil,_that.hasExpiry,_that.photoPaths,_that.status,_that.deletedAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reward implements Reward {
  const _Reward({required this.id, required this.createdAt, required this.code, required this.name, required this.description, this.conditions, required this.points, required this.quantity, this.availableUntil, required this.hasExpiry, required final  List<String> photoPaths, required this.status, this.deletedAt, this.updatedAt}): _photoPaths = photoPaths;
  factory _Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  String code;
@override final  String name;
@override final  String description;
@override final  String? conditions;
@override final  int points;
@override final  int quantity;
@override final  DateTime? availableUntil;
@override final  bool hasExpiry;
 final  List<String> _photoPaths;
@override List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}

@override final  bool status;
@override final  DateTime? deletedAt;
@override final  DateTime? updatedAt;

/// Create a copy of Reward
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RewardCopyWith<_Reward> get copyWith => __$RewardCopyWithImpl<_Reward>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RewardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reward&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&(identical(other.points, points) || other.points == points)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.availableUntil, availableUntil) || other.availableUntil == availableUntil)&&(identical(other.hasExpiry, hasExpiry) || other.hasExpiry == hasExpiry)&&const DeepCollectionEquality().equals(other._photoPaths, _photoPaths)&&(identical(other.status, status) || other.status == status)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,code,name,description,conditions,points,quantity,availableUntil,hasExpiry,const DeepCollectionEquality().hash(_photoPaths),status,deletedAt,updatedAt);

@override
String toString() {
  return 'Reward(id: $id, createdAt: $createdAt, code: $code, name: $name, description: $description, conditions: $conditions, points: $points, quantity: $quantity, availableUntil: $availableUntil, hasExpiry: $hasExpiry, photoPaths: $photoPaths, status: $status, deletedAt: $deletedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RewardCopyWith<$Res> implements $RewardCopyWith<$Res> {
  factory _$RewardCopyWith(_Reward value, $Res Function(_Reward) _then) = __$RewardCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, String code, String name, String description, String? conditions, int points, int quantity, DateTime? availableUntil, bool hasExpiry, List<String> photoPaths, bool status, DateTime? deletedAt, DateTime? updatedAt
});




}
/// @nodoc
class __$RewardCopyWithImpl<$Res>
    implements _$RewardCopyWith<$Res> {
  __$RewardCopyWithImpl(this._self, this._then);

  final _Reward _self;
  final $Res Function(_Reward) _then;

/// Create a copy of Reward
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? code = null,Object? name = null,Object? description = null,Object? conditions = freezed,Object? points = null,Object? quantity = null,Object? availableUntil = freezed,Object? hasExpiry = null,Object? photoPaths = null,Object? status = null,Object? deletedAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Reward(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,availableUntil: freezed == availableUntil ? _self.availableUntil : availableUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,hasExpiry: null == hasExpiry ? _self.hasExpiry : hasExpiry // ignore: cast_nullable_to_non_nullable
as bool,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
