// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderItem {

 String get id; int get quantity; List<String> get photoPaths; String get productBrand; String get productName; String get productModel; double get productPrice; double? get productInstallationFee; double get price; double? get installationFee; bool get isReady; String get productId; String get orderId;
/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderItemCopyWith<OrderItem> get copyWith => _$OrderItemCopyWithImpl<OrderItem>(this as OrderItem, _$identity);

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other.photoPaths, photoPaths)&&(identical(other.productBrand, productBrand) || other.productBrand == productBrand)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productModel, productModel) || other.productModel == productModel)&&(identical(other.productPrice, productPrice) || other.productPrice == productPrice)&&(identical(other.productInstallationFee, productInstallationFee) || other.productInstallationFee == productInstallationFee)&&(identical(other.price, price) || other.price == price)&&(identical(other.installationFee, installationFee) || other.installationFee == installationFee)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,quantity,const DeepCollectionEquality().hash(photoPaths),productBrand,productName,productModel,productPrice,productInstallationFee,price,installationFee,isReady,productId,orderId);

@override
String toString() {
  return 'OrderItem(id: $id, quantity: $quantity, photoPaths: $photoPaths, productBrand: $productBrand, productName: $productName, productModel: $productModel, productPrice: $productPrice, productInstallationFee: $productInstallationFee, price: $price, installationFee: $installationFee, isReady: $isReady, productId: $productId, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class $OrderItemCopyWith<$Res>  {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) _then) = _$OrderItemCopyWithImpl;
@useResult
$Res call({
 String id, int quantity, List<String> photoPaths, String productBrand, String productName, String productModel, double productPrice, double? productInstallationFee, double price, double? installationFee, bool isReady, String productId, String orderId
});




}
/// @nodoc
class _$OrderItemCopyWithImpl<$Res>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._self, this._then);

  final OrderItem _self;
  final $Res Function(OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? quantity = null,Object? photoPaths = null,Object? productBrand = null,Object? productName = null,Object? productModel = null,Object? productPrice = null,Object? productInstallationFee = freezed,Object? price = null,Object? installationFee = freezed,Object? isReady = null,Object? productId = null,Object? orderId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,productBrand: null == productBrand ? _self.productBrand : productBrand // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productModel: null == productModel ? _self.productModel : productModel // ignore: cast_nullable_to_non_nullable
as String,productPrice: null == productPrice ? _self.productPrice : productPrice // ignore: cast_nullable_to_non_nullable
as double,productInstallationFee: freezed == productInstallationFee ? _self.productInstallationFee : productInstallationFee // ignore: cast_nullable_to_non_nullable
as double?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,installationFee: freezed == installationFee ? _self.installationFee : installationFee // ignore: cast_nullable_to_non_nullable
as double?,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderItem].
extension OrderItemPatterns on OrderItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int quantity,  List<String> photoPaths,  String productBrand,  String productName,  String productModel,  double productPrice,  double? productInstallationFee,  double price,  double? installationFee,  bool isReady,  String productId,  String orderId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.id,_that.quantity,_that.photoPaths,_that.productBrand,_that.productName,_that.productModel,_that.productPrice,_that.productInstallationFee,_that.price,_that.installationFee,_that.isReady,_that.productId,_that.orderId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int quantity,  List<String> photoPaths,  String productBrand,  String productName,  String productModel,  double productPrice,  double? productInstallationFee,  double price,  double? installationFee,  bool isReady,  String productId,  String orderId)  $default,) {final _that = this;
switch (_that) {
case _OrderItem():
return $default(_that.id,_that.quantity,_that.photoPaths,_that.productBrand,_that.productName,_that.productModel,_that.productPrice,_that.productInstallationFee,_that.price,_that.installationFee,_that.isReady,_that.productId,_that.orderId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int quantity,  List<String> photoPaths,  String productBrand,  String productName,  String productModel,  double productPrice,  double? productInstallationFee,  double price,  double? installationFee,  bool isReady,  String productId,  String orderId)?  $default,) {final _that = this;
switch (_that) {
case _OrderItem() when $default != null:
return $default(_that.id,_that.quantity,_that.photoPaths,_that.productBrand,_that.productName,_that.productModel,_that.productPrice,_that.productInstallationFee,_that.price,_that.installationFee,_that.isReady,_that.productId,_that.orderId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderItem implements OrderItem {
  const _OrderItem({required this.id, required this.quantity, required final  List<String> photoPaths, required this.productBrand, required this.productName, required this.productModel, required this.productPrice, required this.productInstallationFee, required this.price, required this.installationFee, required this.isReady, required this.productId, required this.orderId}): _photoPaths = photoPaths;
  factory _OrderItem.fromJson(Map<String, dynamic> json) => _$OrderItemFromJson(json);

@override final  String id;
@override final  int quantity;
 final  List<String> _photoPaths;
@override List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}

@override final  String productBrand;
@override final  String productName;
@override final  String productModel;
@override final  double productPrice;
@override final  double? productInstallationFee;
@override final  double price;
@override final  double? installationFee;
@override final  bool isReady;
@override final  String productId;
@override final  String orderId;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderItemCopyWith<_OrderItem> get copyWith => __$OrderItemCopyWithImpl<_OrderItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderItem&&(identical(other.id, id) || other.id == id)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&const DeepCollectionEquality().equals(other._photoPaths, _photoPaths)&&(identical(other.productBrand, productBrand) || other.productBrand == productBrand)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productModel, productModel) || other.productModel == productModel)&&(identical(other.productPrice, productPrice) || other.productPrice == productPrice)&&(identical(other.productInstallationFee, productInstallationFee) || other.productInstallationFee == productInstallationFee)&&(identical(other.price, price) || other.price == price)&&(identical(other.installationFee, installationFee) || other.installationFee == installationFee)&&(identical(other.isReady, isReady) || other.isReady == isReady)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.orderId, orderId) || other.orderId == orderId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,quantity,const DeepCollectionEquality().hash(_photoPaths),productBrand,productName,productModel,productPrice,productInstallationFee,price,installationFee,isReady,productId,orderId);

@override
String toString() {
  return 'OrderItem(id: $id, quantity: $quantity, photoPaths: $photoPaths, productBrand: $productBrand, productName: $productName, productModel: $productModel, productPrice: $productPrice, productInstallationFee: $productInstallationFee, price: $price, installationFee: $installationFee, isReady: $isReady, productId: $productId, orderId: $orderId)';
}


}

/// @nodoc
abstract mixin class _$OrderItemCopyWith<$Res> implements $OrderItemCopyWith<$Res> {
  factory _$OrderItemCopyWith(_OrderItem value, $Res Function(_OrderItem) _then) = __$OrderItemCopyWithImpl;
@override @useResult
$Res call({
 String id, int quantity, List<String> photoPaths, String productBrand, String productName, String productModel, double productPrice, double? productInstallationFee, double price, double? installationFee, bool isReady, String productId, String orderId
});




}
/// @nodoc
class __$OrderItemCopyWithImpl<$Res>
    implements _$OrderItemCopyWith<$Res> {
  __$OrderItemCopyWithImpl(this._self, this._then);

  final _OrderItem _self;
  final $Res Function(_OrderItem) _then;

/// Create a copy of OrderItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? quantity = null,Object? photoPaths = null,Object? productBrand = null,Object? productName = null,Object? productModel = null,Object? productPrice = null,Object? productInstallationFee = freezed,Object? price = null,Object? installationFee = freezed,Object? isReady = null,Object? productId = null,Object? orderId = null,}) {
  return _then(_OrderItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,productBrand: null == productBrand ? _self.productBrand : productBrand // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,productModel: null == productModel ? _self.productModel : productModel // ignore: cast_nullable_to_non_nullable
as String,productPrice: null == productPrice ? _self.productPrice : productPrice // ignore: cast_nullable_to_non_nullable
as double,productInstallationFee: freezed == productInstallationFee ? _self.productInstallationFee : productInstallationFee // ignore: cast_nullable_to_non_nullable
as double?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,installationFee: freezed == installationFee ? _self.installationFee : installationFee // ignore: cast_nullable_to_non_nullable
as double?,isReady: null == isReady ? _self.isReady : isReady // ignore: cast_nullable_to_non_nullable
as bool,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,orderId: null == orderId ? _self.orderId : orderId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
