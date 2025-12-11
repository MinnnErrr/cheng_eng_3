// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'redeemed_reward_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RedeemedReward {

 String get id; DateTime get createdAt; String get code; String get name; String get description; String? get conditions; int get points; DateTime? get expiryDate; List<String> get photoPaths; bool get isClaimed; String get rewardId; String get userId; DateTime? get updatedAt;
/// Create a copy of RedeemedReward
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RedeemedRewardCopyWith<RedeemedReward> get copyWith => _$RedeemedRewardCopyWithImpl<RedeemedReward>(this as RedeemedReward, _$identity);

  /// Serializes this RedeemedReward to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RedeemedReward&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&(identical(other.points, points) || other.points == points)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&const DeepCollectionEquality().equals(other.photoPaths, photoPaths)&&(identical(other.isClaimed, isClaimed) || other.isClaimed == isClaimed)&&(identical(other.rewardId, rewardId) || other.rewardId == rewardId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,code,name,description,conditions,points,expiryDate,const DeepCollectionEquality().hash(photoPaths),isClaimed,rewardId,userId,updatedAt);

@override
String toString() {
  return 'RedeemedReward(id: $id, createdAt: $createdAt, code: $code, name: $name, description: $description, conditions: $conditions, points: $points, expiryDate: $expiryDate, photoPaths: $photoPaths, isClaimed: $isClaimed, rewardId: $rewardId, userId: $userId, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RedeemedRewardCopyWith<$Res>  {
  factory $RedeemedRewardCopyWith(RedeemedReward value, $Res Function(RedeemedReward) _then) = _$RedeemedRewardCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String code, String name, String description, String? conditions, int points, DateTime? expiryDate, List<String> photoPaths, bool isClaimed, String rewardId, String userId, DateTime? updatedAt
});




}
/// @nodoc
class _$RedeemedRewardCopyWithImpl<$Res>
    implements $RedeemedRewardCopyWith<$Res> {
  _$RedeemedRewardCopyWithImpl(this._self, this._then);

  final RedeemedReward _self;
  final $Res Function(RedeemedReward) _then;

/// Create a copy of RedeemedReward
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? code = null,Object? name = null,Object? description = null,Object? conditions = freezed,Object? points = null,Object? expiryDate = freezed,Object? photoPaths = null,Object? isClaimed = null,Object? rewardId = null,Object? userId = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,isClaimed: null == isClaimed ? _self.isClaimed : isClaimed // ignore: cast_nullable_to_non_nullable
as bool,rewardId: null == rewardId ? _self.rewardId : rewardId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RedeemedReward].
extension RedeemedRewardPatterns on RedeemedReward {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RedeemedReward value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RedeemedReward() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RedeemedReward value)  $default,){
final _that = this;
switch (_that) {
case _RedeemedReward():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RedeemedReward value)?  $default,){
final _that = this;
switch (_that) {
case _RedeemedReward() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  String code,  String name,  String description,  String? conditions,  int points,  DateTime? expiryDate,  List<String> photoPaths,  bool isClaimed,  String rewardId,  String userId,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RedeemedReward() when $default != null:
return $default(_that.id,_that.createdAt,_that.code,_that.name,_that.description,_that.conditions,_that.points,_that.expiryDate,_that.photoPaths,_that.isClaimed,_that.rewardId,_that.userId,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  String code,  String name,  String description,  String? conditions,  int points,  DateTime? expiryDate,  List<String> photoPaths,  bool isClaimed,  String rewardId,  String userId,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RedeemedReward():
return $default(_that.id,_that.createdAt,_that.code,_that.name,_that.description,_that.conditions,_that.points,_that.expiryDate,_that.photoPaths,_that.isClaimed,_that.rewardId,_that.userId,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  String code,  String name,  String description,  String? conditions,  int points,  DateTime? expiryDate,  List<String> photoPaths,  bool isClaimed,  String rewardId,  String userId,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RedeemedReward() when $default != null:
return $default(_that.id,_that.createdAt,_that.code,_that.name,_that.description,_that.conditions,_that.points,_that.expiryDate,_that.photoPaths,_that.isClaimed,_that.rewardId,_that.userId,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RedeemedReward implements RedeemedReward {
  const _RedeemedReward({required this.id, required this.createdAt, required this.code, required this.name, required this.description, required this.conditions, required this.points, required this.expiryDate, required final  List<String> photoPaths, required this.isClaimed, required this.rewardId, required this.userId, required this.updatedAt}): _photoPaths = photoPaths;
  factory _RedeemedReward.fromJson(Map<String, dynamic> json) => _$RedeemedRewardFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  String code;
@override final  String name;
@override final  String description;
@override final  String? conditions;
@override final  int points;
@override final  DateTime? expiryDate;
 final  List<String> _photoPaths;
@override List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}

@override final  bool isClaimed;
@override final  String rewardId;
@override final  String userId;
@override final  DateTime? updatedAt;

/// Create a copy of RedeemedReward
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RedeemedRewardCopyWith<_RedeemedReward> get copyWith => __$RedeemedRewardCopyWithImpl<_RedeemedReward>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RedeemedRewardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RedeemedReward&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.conditions, conditions) || other.conditions == conditions)&&(identical(other.points, points) || other.points == points)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&const DeepCollectionEquality().equals(other._photoPaths, _photoPaths)&&(identical(other.isClaimed, isClaimed) || other.isClaimed == isClaimed)&&(identical(other.rewardId, rewardId) || other.rewardId == rewardId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,code,name,description,conditions,points,expiryDate,const DeepCollectionEquality().hash(_photoPaths),isClaimed,rewardId,userId,updatedAt);

@override
String toString() {
  return 'RedeemedReward(id: $id, createdAt: $createdAt, code: $code, name: $name, description: $description, conditions: $conditions, points: $points, expiryDate: $expiryDate, photoPaths: $photoPaths, isClaimed: $isClaimed, rewardId: $rewardId, userId: $userId, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RedeemedRewardCopyWith<$Res> implements $RedeemedRewardCopyWith<$Res> {
  factory _$RedeemedRewardCopyWith(_RedeemedReward value, $Res Function(_RedeemedReward) _then) = __$RedeemedRewardCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, String code, String name, String description, String? conditions, int points, DateTime? expiryDate, List<String> photoPaths, bool isClaimed, String rewardId, String userId, DateTime? updatedAt
});




}
/// @nodoc
class __$RedeemedRewardCopyWithImpl<$Res>
    implements _$RedeemedRewardCopyWith<$Res> {
  __$RedeemedRewardCopyWithImpl(this._self, this._then);

  final _RedeemedReward _self;
  final $Res Function(_RedeemedReward) _then;

/// Create a copy of RedeemedReward
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? code = null,Object? name = null,Object? description = null,Object? conditions = freezed,Object? points = null,Object? expiryDate = freezed,Object? photoPaths = null,Object? isClaimed = null,Object? rewardId = null,Object? userId = null,Object? updatedAt = freezed,}) {
  return _then(_RedeemedReward(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as String?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,isClaimed: null == isClaimed ? _self.isClaimed : isClaimed // ignore: cast_nullable_to_non_nullable
as bool,rewardId: null == rewardId ? _self.rewardId : rewardId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
