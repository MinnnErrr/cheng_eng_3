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
mixin _$Address {

 String get firstName; String get lastName; String get countryCode; String get dialCode; String get phoneNum; String get line1; String? get line2; String get postcode; String get city; MalaysiaState get state; String get country;
/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressCopyWith<Address> get copyWith => _$AddressCopyWithImpl<Address>(this as Address, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Address&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.dialCode, dialCode) || other.dialCode == dialCode)&&(identical(other.phoneNum, phoneNum) || other.phoneNum == phoneNum)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.postcode, postcode) || other.postcode == postcode)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country));
}


@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,countryCode,dialCode,phoneNum,line1,line2,postcode,city,state,country);

@override
String toString() {
  return 'Address(firstName: $firstName, lastName: $lastName, countryCode: $countryCode, dialCode: $dialCode, phoneNum: $phoneNum, line1: $line1, line2: $line2, postcode: $postcode, city: $city, state: $state, country: $country)';
}


}

/// @nodoc
abstract mixin class $AddressCopyWith<$Res>  {
  factory $AddressCopyWith(Address value, $Res Function(Address) _then) = _$AddressCopyWithImpl;
@useResult
$Res call({
 String firstName, String lastName, String countryCode, String dialCode, String phoneNum, String line1, String? line2, String postcode, String city, MalaysiaState state, String country
});




}
/// @nodoc
class _$AddressCopyWithImpl<$Res>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._self, this._then);

  final Address _self;
  final $Res Function(Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firstName = null,Object? lastName = null,Object? countryCode = null,Object? dialCode = null,Object? phoneNum = null,Object? line1 = null,Object? line2 = freezed,Object? postcode = null,Object? city = null,Object? state = null,Object? country = null,}) {
  return _then(_self.copyWith(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,dialCode: null == dialCode ? _self.dialCode : dialCode // ignore: cast_nullable_to_non_nullable
as String,phoneNum: null == phoneNum ? _self.phoneNum : phoneNum // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,postcode: null == postcode ? _self.postcode : postcode // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as MalaysiaState,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Address].
extension AddressPatterns on Address {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Address value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Address value)  $default,){
final _that = this;
switch (_that) {
case _Address():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Address value)?  $default,){
final _that = this;
switch (_that) {
case _Address() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String countryCode,  String dialCode,  String phoneNum,  String line1,  String? line2,  String postcode,  String city,  MalaysiaState state,  String country)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.firstName,_that.lastName,_that.countryCode,_that.dialCode,_that.phoneNum,_that.line1,_that.line2,_that.postcode,_that.city,_that.state,_that.country);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firstName,  String lastName,  String countryCode,  String dialCode,  String phoneNum,  String line1,  String? line2,  String postcode,  String city,  MalaysiaState state,  String country)  $default,) {final _that = this;
switch (_that) {
case _Address():
return $default(_that.firstName,_that.lastName,_that.countryCode,_that.dialCode,_that.phoneNum,_that.line1,_that.line2,_that.postcode,_that.city,_that.state,_that.country);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firstName,  String lastName,  String countryCode,  String dialCode,  String phoneNum,  String line1,  String? line2,  String postcode,  String city,  MalaysiaState state,  String country)?  $default,) {final _that = this;
switch (_that) {
case _Address() when $default != null:
return $default(_that.firstName,_that.lastName,_that.countryCode,_that.dialCode,_that.phoneNum,_that.line1,_that.line2,_that.postcode,_that.city,_that.state,_that.country);case _:
  return null;

}
}

}

/// @nodoc


class _Address implements Address {
  const _Address({required this.firstName, required this.lastName, required this.countryCode, required this.dialCode, required this.phoneNum, required this.line1, required this.line2, required this.postcode, required this.city, required this.state, required this.country});
  

@override final  String firstName;
@override final  String lastName;
@override final  String countryCode;
@override final  String dialCode;
@override final  String phoneNum;
@override final  String line1;
@override final  String? line2;
@override final  String postcode;
@override final  String city;
@override final  MalaysiaState state;
@override final  String country;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressCopyWith<_Address> get copyWith => __$AddressCopyWithImpl<_Address>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Address&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.dialCode, dialCode) || other.dialCode == dialCode)&&(identical(other.phoneNum, phoneNum) || other.phoneNum == phoneNum)&&(identical(other.line1, line1) || other.line1 == line1)&&(identical(other.line2, line2) || other.line2 == line2)&&(identical(other.postcode, postcode) || other.postcode == postcode)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country));
}


@override
int get hashCode => Object.hash(runtimeType,firstName,lastName,countryCode,dialCode,phoneNum,line1,line2,postcode,city,state,country);

@override
String toString() {
  return 'Address(firstName: $firstName, lastName: $lastName, countryCode: $countryCode, dialCode: $dialCode, phoneNum: $phoneNum, line1: $line1, line2: $line2, postcode: $postcode, city: $city, state: $state, country: $country)';
}


}

/// @nodoc
abstract mixin class _$AddressCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$AddressCopyWith(_Address value, $Res Function(_Address) _then) = __$AddressCopyWithImpl;
@override @useResult
$Res call({
 String firstName, String lastName, String countryCode, String dialCode, String phoneNum, String line1, String? line2, String postcode, String city, MalaysiaState state, String country
});




}
/// @nodoc
class __$AddressCopyWithImpl<$Res>
    implements _$AddressCopyWith<$Res> {
  __$AddressCopyWithImpl(this._self, this._then);

  final _Address _self;
  final $Res Function(_Address) _then;

/// Create a copy of Address
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firstName = null,Object? lastName = null,Object? countryCode = null,Object? dialCode = null,Object? phoneNum = null,Object? line1 = null,Object? line2 = freezed,Object? postcode = null,Object? city = null,Object? state = null,Object? country = null,}) {
  return _then(_Address(
firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,dialCode: null == dialCode ? _self.dialCode : dialCode // ignore: cast_nullable_to_non_nullable
as String,phoneNum: null == phoneNum ? _self.phoneNum : phoneNum // ignore: cast_nullable_to_non_nullable
as String,line1: null == line1 ? _self.line1 : line1 // ignore: cast_nullable_to_non_nullable
as String,line2: freezed == line2 ? _self.line2 : line2 // ignore: cast_nullable_to_non_nullable
as String?,postcode: null == postcode ? _self.postcode : postcode // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as MalaysiaState,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Order {

 String get id; DateTime get createdAt; DateTime? get updatedAt; double get subtotal; double? get deliveryFee; double get total; int get points; String get username; String get userPhoneNum; String get userDialCode; String get userEmail; DeliveryMethod get deliveryMethod; String? get deliveryFirstName; String? get deliveryLastName; String? get deliveryDialCode; String? get deliveryPhoneNum; String? get deliveryAddressLine1; String? get deliveryAddressLine2; String? get deliveryPostcode; String? get deliveryCity; MalaysiaState? get deliveryState; String? get deliveryCountry; OrderStatus get status; String get userId;@JsonKey(name: 'order_items', includeToJson: false) List<OrderItem>? get items;
/// Create a copy of Order
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderCopyWith<Order> get copyWith => _$OrderCopyWithImpl<Order>(this as Order, _$identity);

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Order&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.total, total) || other.total == total)&&(identical(other.points, points) || other.points == points)&&(identical(other.username, username) || other.username == username)&&(identical(other.userPhoneNum, userPhoneNum) || other.userPhoneNum == userPhoneNum)&&(identical(other.userDialCode, userDialCode) || other.userDialCode == userDialCode)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.deliveryMethod, deliveryMethod) || other.deliveryMethod == deliveryMethod)&&(identical(other.deliveryFirstName, deliveryFirstName) || other.deliveryFirstName == deliveryFirstName)&&(identical(other.deliveryLastName, deliveryLastName) || other.deliveryLastName == deliveryLastName)&&(identical(other.deliveryDialCode, deliveryDialCode) || other.deliveryDialCode == deliveryDialCode)&&(identical(other.deliveryPhoneNum, deliveryPhoneNum) || other.deliveryPhoneNum == deliveryPhoneNum)&&(identical(other.deliveryAddressLine1, deliveryAddressLine1) || other.deliveryAddressLine1 == deliveryAddressLine1)&&(identical(other.deliveryAddressLine2, deliveryAddressLine2) || other.deliveryAddressLine2 == deliveryAddressLine2)&&(identical(other.deliveryPostcode, deliveryPostcode) || other.deliveryPostcode == deliveryPostcode)&&(identical(other.deliveryCity, deliveryCity) || other.deliveryCity == deliveryCity)&&(identical(other.deliveryState, deliveryState) || other.deliveryState == deliveryState)&&(identical(other.deliveryCountry, deliveryCountry) || other.deliveryCountry == deliveryCountry)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,createdAt,updatedAt,subtotal,deliveryFee,total,points,username,userPhoneNum,userDialCode,userEmail,deliveryMethod,deliveryFirstName,deliveryLastName,deliveryDialCode,deliveryPhoneNum,deliveryAddressLine1,deliveryAddressLine2,deliveryPostcode,deliveryCity,deliveryState,deliveryCountry,status,userId,const DeepCollectionEquality().hash(items)]);

@override
String toString() {
  return 'Order(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, subtotal: $subtotal, deliveryFee: $deliveryFee, total: $total, points: $points, username: $username, userPhoneNum: $userPhoneNum, userDialCode: $userDialCode, userEmail: $userEmail, deliveryMethod: $deliveryMethod, deliveryFirstName: $deliveryFirstName, deliveryLastName: $deliveryLastName, deliveryDialCode: $deliveryDialCode, deliveryPhoneNum: $deliveryPhoneNum, deliveryAddressLine1: $deliveryAddressLine1, deliveryAddressLine2: $deliveryAddressLine2, deliveryPostcode: $deliveryPostcode, deliveryCity: $deliveryCity, deliveryState: $deliveryState, deliveryCountry: $deliveryCountry, status: $status, userId: $userId, items: $items)';
}


}

/// @nodoc
abstract mixin class $OrderCopyWith<$Res>  {
  factory $OrderCopyWith(Order value, $Res Function(Order) _then) = _$OrderCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime? updatedAt, double subtotal, double? deliveryFee, double total, int points, String username, String userPhoneNum, String userDialCode, String userEmail, DeliveryMethod deliveryMethod, String? deliveryFirstName, String? deliveryLastName, String? deliveryDialCode, String? deliveryPhoneNum, String? deliveryAddressLine1, String? deliveryAddressLine2, String? deliveryPostcode, String? deliveryCity, MalaysiaState? deliveryState, String? deliveryCountry, OrderStatus status, String userId,@JsonKey(name: 'order_items', includeToJson: false) List<OrderItem>? items
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = freezed,Object? subtotal = null,Object? deliveryFee = freezed,Object? total = null,Object? points = null,Object? username = null,Object? userPhoneNum = null,Object? userDialCode = null,Object? userEmail = null,Object? deliveryMethod = null,Object? deliveryFirstName = freezed,Object? deliveryLastName = freezed,Object? deliveryDialCode = freezed,Object? deliveryPhoneNum = freezed,Object? deliveryAddressLine1 = freezed,Object? deliveryAddressLine2 = freezed,Object? deliveryPostcode = freezed,Object? deliveryCity = freezed,Object? deliveryState = freezed,Object? deliveryCountry = freezed,Object? status = null,Object? userId = null,Object? items = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userPhoneNum: null == userPhoneNum ? _self.userPhoneNum : userPhoneNum // ignore: cast_nullable_to_non_nullable
as String,userDialCode: null == userDialCode ? _self.userDialCode : userDialCode // ignore: cast_nullable_to_non_nullable
as String,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,deliveryMethod: null == deliveryMethod ? _self.deliveryMethod : deliveryMethod // ignore: cast_nullable_to_non_nullable
as DeliveryMethod,deliveryFirstName: freezed == deliveryFirstName ? _self.deliveryFirstName : deliveryFirstName // ignore: cast_nullable_to_non_nullable
as String?,deliveryLastName: freezed == deliveryLastName ? _self.deliveryLastName : deliveryLastName // ignore: cast_nullable_to_non_nullable
as String?,deliveryDialCode: freezed == deliveryDialCode ? _self.deliveryDialCode : deliveryDialCode // ignore: cast_nullable_to_non_nullable
as String?,deliveryPhoneNum: freezed == deliveryPhoneNum ? _self.deliveryPhoneNum : deliveryPhoneNum // ignore: cast_nullable_to_non_nullable
as String?,deliveryAddressLine1: freezed == deliveryAddressLine1 ? _self.deliveryAddressLine1 : deliveryAddressLine1 // ignore: cast_nullable_to_non_nullable
as String?,deliveryAddressLine2: freezed == deliveryAddressLine2 ? _self.deliveryAddressLine2 : deliveryAddressLine2 // ignore: cast_nullable_to_non_nullable
as String?,deliveryPostcode: freezed == deliveryPostcode ? _self.deliveryPostcode : deliveryPostcode // ignore: cast_nullable_to_non_nullable
as String?,deliveryCity: freezed == deliveryCity ? _self.deliveryCity : deliveryCity // ignore: cast_nullable_to_non_nullable
as String?,deliveryState: freezed == deliveryState ? _self.deliveryState : deliveryState // ignore: cast_nullable_to_non_nullable
as MalaysiaState?,deliveryCountry: freezed == deliveryCountry ? _self.deliveryCountry : deliveryCountry // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime? updatedAt,  double subtotal,  double? deliveryFee,  double total,  int points,  String username,  String userPhoneNum,  String userDialCode,  String userEmail,  DeliveryMethod deliveryMethod,  String? deliveryFirstName,  String? deliveryLastName,  String? deliveryDialCode,  String? deliveryPhoneNum,  String? deliveryAddressLine1,  String? deliveryAddressLine2,  String? deliveryPostcode,  String? deliveryCity,  MalaysiaState? deliveryState,  String? deliveryCountry,  OrderStatus status,  String userId, @JsonKey(name: 'order_items', includeToJson: false)  List<OrderItem>? items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.subtotal,_that.deliveryFee,_that.total,_that.points,_that.username,_that.userPhoneNum,_that.userDialCode,_that.userEmail,_that.deliveryMethod,_that.deliveryFirstName,_that.deliveryLastName,_that.deliveryDialCode,_that.deliveryPhoneNum,_that.deliveryAddressLine1,_that.deliveryAddressLine2,_that.deliveryPostcode,_that.deliveryCity,_that.deliveryState,_that.deliveryCountry,_that.status,_that.userId,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime? updatedAt,  double subtotal,  double? deliveryFee,  double total,  int points,  String username,  String userPhoneNum,  String userDialCode,  String userEmail,  DeliveryMethod deliveryMethod,  String? deliveryFirstName,  String? deliveryLastName,  String? deliveryDialCode,  String? deliveryPhoneNum,  String? deliveryAddressLine1,  String? deliveryAddressLine2,  String? deliveryPostcode,  String? deliveryCity,  MalaysiaState? deliveryState,  String? deliveryCountry,  OrderStatus status,  String userId, @JsonKey(name: 'order_items', includeToJson: false)  List<OrderItem>? items)  $default,) {final _that = this;
switch (_that) {
case _Order():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.subtotal,_that.deliveryFee,_that.total,_that.points,_that.username,_that.userPhoneNum,_that.userDialCode,_that.userEmail,_that.deliveryMethod,_that.deliveryFirstName,_that.deliveryLastName,_that.deliveryDialCode,_that.deliveryPhoneNum,_that.deliveryAddressLine1,_that.deliveryAddressLine2,_that.deliveryPostcode,_that.deliveryCity,_that.deliveryState,_that.deliveryCountry,_that.status,_that.userId,_that.items);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime? updatedAt,  double subtotal,  double? deliveryFee,  double total,  int points,  String username,  String userPhoneNum,  String userDialCode,  String userEmail,  DeliveryMethod deliveryMethod,  String? deliveryFirstName,  String? deliveryLastName,  String? deliveryDialCode,  String? deliveryPhoneNum,  String? deliveryAddressLine1,  String? deliveryAddressLine2,  String? deliveryPostcode,  String? deliveryCity,  MalaysiaState? deliveryState,  String? deliveryCountry,  OrderStatus status,  String userId, @JsonKey(name: 'order_items', includeToJson: false)  List<OrderItem>? items)?  $default,) {final _that = this;
switch (_that) {
case _Order() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.subtotal,_that.deliveryFee,_that.total,_that.points,_that.username,_that.userPhoneNum,_that.userDialCode,_that.userEmail,_that.deliveryMethod,_that.deliveryFirstName,_that.deliveryLastName,_that.deliveryDialCode,_that.deliveryPhoneNum,_that.deliveryAddressLine1,_that.deliveryAddressLine2,_that.deliveryPostcode,_that.deliveryCity,_that.deliveryState,_that.deliveryCountry,_that.status,_that.userId,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Order extends Order {
  const _Order({required this.id, required this.createdAt, required this.updatedAt, required this.subtotal, required this.deliveryFee, required this.total, required this.points, required this.username, required this.userPhoneNum, required this.userDialCode, required this.userEmail, required this.deliveryMethod, required this.deliveryFirstName, required this.deliveryLastName, required this.deliveryDialCode, required this.deliveryPhoneNum, required this.deliveryAddressLine1, required this.deliveryAddressLine2, required this.deliveryPostcode, required this.deliveryCity, required this.deliveryState, required this.deliveryCountry, required this.status, required this.userId, @JsonKey(name: 'order_items', includeToJson: false) final  List<OrderItem>? items}): _items = items,super._();
  factory _Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;
@override final  double subtotal;
@override final  double? deliveryFee;
@override final  double total;
@override final  int points;
@override final  String username;
@override final  String userPhoneNum;
@override final  String userDialCode;
@override final  String userEmail;
@override final  DeliveryMethod deliveryMethod;
@override final  String? deliveryFirstName;
@override final  String? deliveryLastName;
@override final  String? deliveryDialCode;
@override final  String? deliveryPhoneNum;
@override final  String? deliveryAddressLine1;
@override final  String? deliveryAddressLine2;
@override final  String? deliveryPostcode;
@override final  String? deliveryCity;
@override final  MalaysiaState? deliveryState;
@override final  String? deliveryCountry;
@override final  OrderStatus status;
@override final  String userId;
 final  List<OrderItem>? _items;
@override@JsonKey(name: 'order_items', includeToJson: false) List<OrderItem>? get items {
  final value = _items;
  if (value == null) return null;
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Order&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.deliveryFee, deliveryFee) || other.deliveryFee == deliveryFee)&&(identical(other.total, total) || other.total == total)&&(identical(other.points, points) || other.points == points)&&(identical(other.username, username) || other.username == username)&&(identical(other.userPhoneNum, userPhoneNum) || other.userPhoneNum == userPhoneNum)&&(identical(other.userDialCode, userDialCode) || other.userDialCode == userDialCode)&&(identical(other.userEmail, userEmail) || other.userEmail == userEmail)&&(identical(other.deliveryMethod, deliveryMethod) || other.deliveryMethod == deliveryMethod)&&(identical(other.deliveryFirstName, deliveryFirstName) || other.deliveryFirstName == deliveryFirstName)&&(identical(other.deliveryLastName, deliveryLastName) || other.deliveryLastName == deliveryLastName)&&(identical(other.deliveryDialCode, deliveryDialCode) || other.deliveryDialCode == deliveryDialCode)&&(identical(other.deliveryPhoneNum, deliveryPhoneNum) || other.deliveryPhoneNum == deliveryPhoneNum)&&(identical(other.deliveryAddressLine1, deliveryAddressLine1) || other.deliveryAddressLine1 == deliveryAddressLine1)&&(identical(other.deliveryAddressLine2, deliveryAddressLine2) || other.deliveryAddressLine2 == deliveryAddressLine2)&&(identical(other.deliveryPostcode, deliveryPostcode) || other.deliveryPostcode == deliveryPostcode)&&(identical(other.deliveryCity, deliveryCity) || other.deliveryCity == deliveryCity)&&(identical(other.deliveryState, deliveryState) || other.deliveryState == deliveryState)&&(identical(other.deliveryCountry, deliveryCountry) || other.deliveryCountry == deliveryCountry)&&(identical(other.status, status) || other.status == status)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,createdAt,updatedAt,subtotal,deliveryFee,total,points,username,userPhoneNum,userDialCode,userEmail,deliveryMethod,deliveryFirstName,deliveryLastName,deliveryDialCode,deliveryPhoneNum,deliveryAddressLine1,deliveryAddressLine2,deliveryPostcode,deliveryCity,deliveryState,deliveryCountry,status,userId,const DeepCollectionEquality().hash(_items)]);

@override
String toString() {
  return 'Order(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, subtotal: $subtotal, deliveryFee: $deliveryFee, total: $total, points: $points, username: $username, userPhoneNum: $userPhoneNum, userDialCode: $userDialCode, userEmail: $userEmail, deliveryMethod: $deliveryMethod, deliveryFirstName: $deliveryFirstName, deliveryLastName: $deliveryLastName, deliveryDialCode: $deliveryDialCode, deliveryPhoneNum: $deliveryPhoneNum, deliveryAddressLine1: $deliveryAddressLine1, deliveryAddressLine2: $deliveryAddressLine2, deliveryPostcode: $deliveryPostcode, deliveryCity: $deliveryCity, deliveryState: $deliveryState, deliveryCountry: $deliveryCountry, status: $status, userId: $userId, items: $items)';
}


}

/// @nodoc
abstract mixin class _$OrderCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$OrderCopyWith(_Order value, $Res Function(_Order) _then) = __$OrderCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime? updatedAt, double subtotal, double? deliveryFee, double total, int points, String username, String userPhoneNum, String userDialCode, String userEmail, DeliveryMethod deliveryMethod, String? deliveryFirstName, String? deliveryLastName, String? deliveryDialCode, String? deliveryPhoneNum, String? deliveryAddressLine1, String? deliveryAddressLine2, String? deliveryPostcode, String? deliveryCity, MalaysiaState? deliveryState, String? deliveryCountry, OrderStatus status, String userId,@JsonKey(name: 'order_items', includeToJson: false) List<OrderItem>? items
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = freezed,Object? subtotal = null,Object? deliveryFee = freezed,Object? total = null,Object? points = null,Object? username = null,Object? userPhoneNum = null,Object? userDialCode = null,Object? userEmail = null,Object? deliveryMethod = null,Object? deliveryFirstName = freezed,Object? deliveryLastName = freezed,Object? deliveryDialCode = freezed,Object? deliveryPhoneNum = freezed,Object? deliveryAddressLine1 = freezed,Object? deliveryAddressLine2 = freezed,Object? deliveryPostcode = freezed,Object? deliveryCity = freezed,Object? deliveryState = freezed,Object? deliveryCountry = freezed,Object? status = null,Object? userId = null,Object? items = freezed,}) {
  return _then(_Order(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,deliveryFee: freezed == deliveryFee ? _self.deliveryFee : deliveryFee // ignore: cast_nullable_to_non_nullable
as double?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,userPhoneNum: null == userPhoneNum ? _self.userPhoneNum : userPhoneNum // ignore: cast_nullable_to_non_nullable
as String,userDialCode: null == userDialCode ? _self.userDialCode : userDialCode // ignore: cast_nullable_to_non_nullable
as String,userEmail: null == userEmail ? _self.userEmail : userEmail // ignore: cast_nullable_to_non_nullable
as String,deliveryMethod: null == deliveryMethod ? _self.deliveryMethod : deliveryMethod // ignore: cast_nullable_to_non_nullable
as DeliveryMethod,deliveryFirstName: freezed == deliveryFirstName ? _self.deliveryFirstName : deliveryFirstName // ignore: cast_nullable_to_non_nullable
as String?,deliveryLastName: freezed == deliveryLastName ? _self.deliveryLastName : deliveryLastName // ignore: cast_nullable_to_non_nullable
as String?,deliveryDialCode: freezed == deliveryDialCode ? _self.deliveryDialCode : deliveryDialCode // ignore: cast_nullable_to_non_nullable
as String?,deliveryPhoneNum: freezed == deliveryPhoneNum ? _self.deliveryPhoneNum : deliveryPhoneNum // ignore: cast_nullable_to_non_nullable
as String?,deliveryAddressLine1: freezed == deliveryAddressLine1 ? _self.deliveryAddressLine1 : deliveryAddressLine1 // ignore: cast_nullable_to_non_nullable
as String?,deliveryAddressLine2: freezed == deliveryAddressLine2 ? _self.deliveryAddressLine2 : deliveryAddressLine2 // ignore: cast_nullable_to_non_nullable
as String?,deliveryPostcode: freezed == deliveryPostcode ? _self.deliveryPostcode : deliveryPostcode // ignore: cast_nullable_to_non_nullable
as String?,deliveryCity: freezed == deliveryCity ? _self.deliveryCity : deliveryCity // ignore: cast_nullable_to_non_nullable
as String?,deliveryState: freezed == deliveryState ? _self.deliveryState : deliveryState // ignore: cast_nullable_to_non_nullable
as MalaysiaState?,deliveryCountry: freezed == deliveryCountry ? _self.deliveryCountry : deliveryCountry // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrderStatus,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,items: freezed == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OrderItem>?,
  ));
}


}

// dart format on
