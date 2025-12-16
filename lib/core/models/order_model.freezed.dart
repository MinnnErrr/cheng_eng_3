// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Order {

 String get id; DateTime get createAt; DateTime? get updatedAt; double get subtotal; double? get deliveryFee; double get total; int get points; String? get firstName; String? get lastName; String? get phoneNum; String? get addressLine1; String? get addressLine2; String? get poscode; String? get city; State get state; String? get country; OrderStatus get status; String get userId;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.createAt, createAt) || other.createAt == createAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.total, total) || other.total == total)&&(identical(other.points, points) || other.points == points)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phoneNum, phoneNum) || other.phoneNum == phoneNum)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.poscode, poscode) || other.poscode == poscode)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createAt,updatedAt,subtotal,deliveryFee,total,points,firstName,lastName,phoneNum,addressLine1,addressLine2,poscode,city,state,country,status,userId);

@override
String toString() {
  return 'Order(id: $id, createAt: $createAt, updatedAt: $updatedAt, subtotal: $subtotal, deliveryFee: $deliveryFee, total: $total, points: $points, firstName: $firstName, lastName: $lastName, phoneNum: $phoneNum, addressLine1: $addressLine1, addressLine2: $addressLine2, poscode: $poscode, city: $city, state: $state, country: $country, status: $status, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createAt, DateTime? updatedAt, double subtotal, double? deliveryFee, double total, int points, String? firstName, String? lastName, String? phoneNum, String? addressLine1, String? addressLine2, String? poscode, String? city, State state, String? country, OrderStatus status, String userId
});




}
/// @nodoc
class _$OrderCopyWithImpl<$Res>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._self, this._then);

  final Order _self;
  final $Res Function(Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createAt = null,Object? updatedAt = freezed,Object? subtotal = null,Object? deliveryFee = freezed,Object? total = null,Object? points = null,Object? firstName = freezed,Object? lastName = freezed,Object? phoneNum = freezed,Object? addressLine1 = freezed,Object? addressLine2 = freezed,Object? poscode = freezed,Object? city = freezed,Object? state = null,Object? country = freezed,Object? status = null,Object? userId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createAt: null == createAt ? _self.createAt : createAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,phoneNum: freezed == phoneNum ? _self.phoneNum : phoneNum // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,poscode: freezed == poscode ? _self.poscode : poscode // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as State,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Order].
extension OrderPatterns on Order {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Order value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Order value)  $default,){
final _that = this;
switch (_that) {
case _Order():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Order value)?  $default,){
final _that = this;
switch (_that) {
case _Order() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createAt,  DateTime? updatedAt,  double subtotal,  double? deliveryFee,  double total,  int points,  String? firstName,  String? lastName,  String? phoneNum,  String? addressLine1,  String? addressLine2,  String? poscode,  String? city,  State state,  String? country,  OrderStatus status,  String userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createAt,_that.updatedAt,_that.subtotal,_that.deliveryFee,_that.total,_that.points,_that.firstName,_that.lastName,_that.phoneNum,_that.addressLine1,_that.addressLine2,_that.poscode,_that.city,_that.state,_that.country,_that.status,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createAt,  DateTime? updatedAt,  double subtotal,  double? deliveryFee,  double total,  int points,  String? firstName,  String? lastName,  String? phoneNum,  String? addressLine1,  String? addressLine2,  String? poscode,  String? city,  State state,  String? country,  OrderStatus status,  String userId)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.createAt,_that.updatedAt,_that.subtotal,_that.deliveryFee,_that.total,_that.points,_that.firstName,_that.lastName,_that.phoneNum,_that.addressLine1,_that.addressLine2,_that.poscode,_that.city,_that.state,_that.country,_that.status,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createAt,  DateTime? updatedAt,  double subtotal,  double? deliveryFee,  double total,  int points,  String? firstName,  String? lastName,  String? phoneNum,  String? addressLine1,  String? addressLine2,  String? poscode,  String? city,  State state,  String? country,  OrderStatus status,  String userId)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createAt,_that.updatedAt,_that.subtotal,_that.deliveryFee,_that.total,_that.points,_that.firstName,_that.lastName,_that.phoneNum,_that.addressLine1,_that.addressLine2,_that.poscode,_that.city,_that.state,_that.country,_that.status,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order implements Order {
  const _Order({required this.id, required this.createAt, required this.updatedAt, required this.subtotal, required this.deliveryFee, required this.total, required this.points, required this.firstName, required this.lastName, required this.phoneNum, required this.addressLine1, required this.addressLine2, required this.poscode, required this.city, required this.state, required this.country, required this.status, required this.userId});
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override final  DateTime createAt;
@override final  DateTime? updatedAt;
@override final  double subtotal;
@override final  double? deliveryFee;
@override final  double total;
@override final  int points;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? phoneNum;
@override final  String? addressLine1;
@override final  String? addressLine2;
@override final  String? poscode;
@override final  String? city;
@override final  State state;
@override final  String? country;
@override final  OrderStatus status;
@override final  String userId;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderCopyWith<_Order> get copyWith => __$OrderCopyWithImpl<_Order>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.createAt, createAt) || other.createAt == createAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.total, total) || other.total == total)&&(identical(other.points, points) || other.points == points)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phoneNum, phoneNum) || other.phoneNum == phoneNum)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.poscode, poscode) || other.poscode == poscode)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createAt,updatedAt,subtotal,deliveryFee,total,points,firstName,lastName,phoneNum,addressLine1,addressLine2,poscode,city,state,country,status,userId);

@override
String toString() {
  return 'Order(id: $id, createAt: $createAt, updatedAt: $updatedAt, subtotal: $subtotal, deliveryFee: $deliveryFee, total: $total, points: $points, firstName: $firstName, lastName: $lastName, phoneNum: $phoneNum, addressLine1: $addressLine1, addressLine2: $addressLine2, poscode: $poscode, city: $city, state: $state, country: $country, status: $status, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createAt, DateTime? updatedAt, double subtotal, double? deliveryFee, double total, int points, String? firstName, String? lastName, String? phoneNum, String? addressLine1, String? addressLine2, String? poscode, String? city, State state, String? country, OrderStatus status, String userId
});




}
/// @nodoc
class __$OrderCopyWithImpl<$Res>
    implements _$OrderCopyWith<$Res> {
  __$OrderCopyWithImpl(this._self, this._then);

  final _Order _self;
  final $Res Function(_Order) _then;

/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createAt = null,Object? updatedAt = freezed,Object? subtotal = null,Object? deliveryFee = freezed,Object? total = null,Object? points = null,Object? firstName = freezed,Object? lastName = freezed,Object? phoneNum = freezed,Object? addressLine1 = freezed,Object? addressLine2 = freezed,Object? poscode = freezed,Object? city = freezed,Object? state = null,Object? country = freezed,Object? status = null,Object? userId = null,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createAt: null == createAt ? _self.createAt : createAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,phoneNum: freezed == phoneNum ? _self.phoneNum : phoneNum // ignore: cast_nullable_to_non_nullable
as String?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,poscode: freezed == poscode ? _self.poscode : poscode // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as State,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
