// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'point_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PointHistory {

 String get id; DateTime get createdAt; DateTime? get expiredAt; String get reason; int get points; bool get isIssuedByStaff; PointType get type; String get userId;
/// Create a copy of PointHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointHistoryCopyWith<PointHistory> get copyWith => _$PointHistoryCopyWithImpl<PointHistory>(this as PointHistory, _$identity);

  /// Serializes this PointHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiredAt, expiredAt) || other.expiredAt == expiredAt)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.points, points) || other.points == points)&&(identical(other.isIssuedByStaff, isIssuedByStaff) || other.isIssuedByStaff == isIssuedByStaff)&&(identical(other.type, type) || other.type == type)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,expiredAt,reason,points,isIssuedByStaff,type,userId);

@override
String toString() {
  return 'PointHistory(id: $id, createdAt: $createdAt, expiredAt: $expiredAt, reason: $reason, points: $points, isIssuedByStaff: $isIssuedByStaff, type: $type, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $PointHistoryCopyWith<$Res>  {
  factory $PointHistoryCopyWith(PointHistory value, $Res Function(PointHistory) _then) = _$PointHistoryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime? expiredAt, String reason, int points, bool isIssuedByStaff, PointType type, String userId
});




}
/// @nodoc
class _$PointHistoryCopyWithImpl<$Res>
    implements $PointHistoryCopyWith<$Res> {
  _$PointHistoryCopyWithImpl(this._self, this._then);

  final PointHistory _self;
  final $Res Function(PointHistory) _then;

/// Create a copy of PointHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? expiredAt = freezed,Object? reason = null,Object? points = null,Object? isIssuedByStaff = null,Object? type = null,Object? userId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiredAt: freezed == expiredAt ? _self.expiredAt : expiredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,isIssuedByStaff: null == isIssuedByStaff ? _self.isIssuedByStaff : isIssuedByStaff // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PointType,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PointHistory].
extension PointHistoryPatterns on PointHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointHistory value)  $default,){
final _that = this;
switch (_that) {
case _PointHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PointHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime? expiredAt,  String reason,  int points,  bool isIssuedByStaff,  PointType type,  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointHistory() when $default != null:
return $default(_that.id,_that.createdAt,_that.expiredAt,_that.reason,_that.points,_that.isIssuedByStaff,_that.type,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime? expiredAt,  String reason,  int points,  bool isIssuedByStaff,  PointType type,  String userId)  $default,) {final _that = this;
switch (_that) {
case _PointHistory():
return $default(_that.id,_that.createdAt,_that.expiredAt,_that.reason,_that.points,_that.isIssuedByStaff,_that.type,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime? expiredAt,  String reason,  int points,  bool isIssuedByStaff,  PointType type,  String userId)?  $default,) {final _that = this;
switch (_that) {
case _PointHistory() when $default != null:
return $default(_that.id,_that.createdAt,_that.expiredAt,_that.reason,_that.points,_that.isIssuedByStaff,_that.type,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointHistory implements PointHistory {
  const _PointHistory({required this.id, required this.createdAt, required this.expiredAt, required this.reason, required this.points, required this.isIssuedByStaff, required this.type, required this.userId});
  factory _PointHistory.fromJson(Map<String, dynamic> json) => _$PointHistoryFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime? expiredAt;
@override final  String reason;
@override final  int points;
@override final  bool isIssuedByStaff;
@override final  PointType type;
@override final  String userId;

/// Create a copy of PointHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointHistoryCopyWith<_PointHistory> get copyWith => __$PointHistoryCopyWithImpl<_PointHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiredAt, expiredAt) || other.expiredAt == expiredAt)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.points, points) || other.points == points)&&(identical(other.isIssuedByStaff, isIssuedByStaff) || other.isIssuedByStaff == isIssuedByStaff)&&(identical(other.type, type) || other.type == type)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,expiredAt,reason,points,isIssuedByStaff,type,userId);

@override
String toString() {
  return 'PointHistory(id: $id, createdAt: $createdAt, expiredAt: $expiredAt, reason: $reason, points: $points, isIssuedByStaff: $isIssuedByStaff, type: $type, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$PointHistoryCopyWith<$Res> implements $PointHistoryCopyWith<$Res> {
  factory _$PointHistoryCopyWith(_PointHistory value, $Res Function(_PointHistory) _then) = __$PointHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime? expiredAt, String reason, int points, bool isIssuedByStaff, PointType type, String userId
});




}
/// @nodoc
class __$PointHistoryCopyWithImpl<$Res>
    implements _$PointHistoryCopyWith<$Res> {
  __$PointHistoryCopyWithImpl(this._self, this._then);

  final _PointHistory _self;
  final $Res Function(_PointHistory) _then;

/// Create a copy of PointHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? expiredAt = freezed,Object? reason = null,Object? points = null,Object? isIssuedByStaff = null,Object? type = null,Object? userId = null,}) {
  return _then(_PointHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiredAt: freezed == expiredAt ? _self.expiredAt : expiredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,isIssuedByStaff: null == isIssuedByStaff ? _self.isIssuedByStaff : isIssuedByStaff // ignore: cast_nullable_to_non_nullable
as bool,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PointType,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
