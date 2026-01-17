// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; DateTime get createdAt; String get name; String get category; String get brand; String? get model; String? get colour; String get description; bool get status; ProductAvailability get availability; int? get quantity; bool get installation; double? get installationFee; List<String> get photoPaths; DateTime? get deletedAt; DateTime? get updatedAt; String? get remarks; double get price;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.colour, colour) || other.colour == colour)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.availability, availability) || other.availability == availability)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.installation, installation) || other.installation == installation)&&(identical(other.installationFee, installationFee) || other.installationFee == installationFee)&&const DeepCollectionEquality().equals(other.photoPaths, photoPaths)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,name,category,brand,model,colour,description,status,availability,quantity,installation,installationFee,const DeepCollectionEquality().hash(photoPaths),deletedAt,updatedAt,remarks,price);

@override
String toString() {
  return 'Product(id: $id, createdAt: $createdAt, name: $name, category: $category, brand: $brand, model: $model, colour: $colour, description: $description, status: $status, availability: $availability, quantity: $quantity, installation: $installation, installationFee: $installationFee, photoPaths: $photoPaths, deletedAt: $deletedAt, updatedAt: $updatedAt, remarks: $remarks, price: $price)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String name, String category, String brand, String? model, String? colour, String description, bool status, ProductAvailability availability, int? quantity, bool installation, double? installationFee, List<String> photoPaths, DateTime? deletedAt, DateTime? updatedAt, String? remarks, double price
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? name = null,Object? category = null,Object? brand = null,Object? model = freezed,Object? colour = freezed,Object? description = null,Object? status = null,Object? availability = null,Object? quantity = freezed,Object? installation = null,Object? installationFee = freezed,Object? photoPaths = null,Object? deletedAt = freezed,Object? updatedAt = freezed,Object? remarks = freezed,Object? price = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,colour: freezed == colour ? _self.colour : colour // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as ProductAvailability,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,installation: null == installation ? _self.installation : installation // ignore: cast_nullable_to_non_nullable
as bool,installationFee: freezed == installationFee ? _self.installationFee : installationFee // ignore: cast_nullable_to_non_nullable
as double?,photoPaths: null == photoPaths ? _self.photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  String name,  String category,  String brand,  String? model,  String? colour,  String description,  bool status,  ProductAvailability availability,  int? quantity,  bool installation,  double? installationFee,  List<String> photoPaths,  DateTime? deletedAt,  DateTime? updatedAt,  String? remarks,  double price)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.createdAt,_that.name,_that.category,_that.brand,_that.model,_that.colour,_that.description,_that.status,_that.availability,_that.quantity,_that.installation,_that.installationFee,_that.photoPaths,_that.deletedAt,_that.updatedAt,_that.remarks,_that.price);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  String name,  String category,  String brand,  String? model,  String? colour,  String description,  bool status,  ProductAvailability availability,  int? quantity,  bool installation,  double? installationFee,  List<String> photoPaths,  DateTime? deletedAt,  DateTime? updatedAt,  String? remarks,  double price)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.createdAt,_that.name,_that.category,_that.brand,_that.model,_that.colour,_that.description,_that.status,_that.availability,_that.quantity,_that.installation,_that.installationFee,_that.photoPaths,_that.deletedAt,_that.updatedAt,_that.remarks,_that.price);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  String name,  String category,  String brand,  String? model,  String? colour,  String description,  bool status,  ProductAvailability availability,  int? quantity,  bool installation,  double? installationFee,  List<String> photoPaths,  DateTime? deletedAt,  DateTime? updatedAt,  String? remarks,  double price)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.createdAt,_that.name,_that.category,_that.brand,_that.model,_that.colour,_that.description,_that.status,_that.availability,_that.quantity,_that.installation,_that.installationFee,_that.photoPaths,_that.deletedAt,_that.updatedAt,_that.remarks,_that.price);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product implements Product {
  const _Product({required this.id, required this.createdAt, required this.name, required this.category, required this.brand, this.model, this.colour, required this.description, required this.status, required this.availability, this.quantity, required this.installation, this.installationFee, required final  List<String> photoPaths, this.deletedAt, this.updatedAt, this.remarks, required this.price}): _photoPaths = photoPaths;
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  String name;
@override final  String category;
@override final  String brand;
@override final  String? model;
@override final  String? colour;
@override final  String description;
@override final  bool status;
@override final  ProductAvailability availability;
@override final  int? quantity;
@override final  bool installation;
@override final  double? installationFee;
 final  List<String> _photoPaths;
@override List<String> get photoPaths {
  if (_photoPaths is EqualUnmodifiableListView) return _photoPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photoPaths);
}

@override final  DateTime? deletedAt;
@override final  DateTime? updatedAt;
@override final  String? remarks;
@override final  double price;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.colour, colour) || other.colour == colour)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.availability, availability) || other.availability == availability)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.installation, installation) || other.installation == installation)&&(identical(other.installationFee, installationFee) || other.installationFee == installationFee)&&const DeepCollectionEquality().equals(other._photoPaths, _photoPaths)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.price, price) || other.price == price));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,name,category,brand,model,colour,description,status,availability,quantity,installation,installationFee,const DeepCollectionEquality().hash(_photoPaths),deletedAt,updatedAt,remarks,price);

@override
String toString() {
  return 'Product(id: $id, createdAt: $createdAt, name: $name, category: $category, brand: $brand, model: $model, colour: $colour, description: $description, status: $status, availability: $availability, quantity: $quantity, installation: $installation, installationFee: $installationFee, photoPaths: $photoPaths, deletedAt: $deletedAt, updatedAt: $updatedAt, remarks: $remarks, price: $price)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, String name, String category, String brand, String? model, String? colour, String description, bool status, ProductAvailability availability, int? quantity, bool installation, double? installationFee, List<String> photoPaths, DateTime? deletedAt, DateTime? updatedAt, String? remarks, double price
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? name = null,Object? category = null,Object? brand = null,Object? model = freezed,Object? colour = freezed,Object? description = null,Object? status = null,Object? availability = null,Object? quantity = freezed,Object? installation = null,Object? installationFee = freezed,Object? photoPaths = null,Object? deletedAt = freezed,Object? updatedAt = freezed,Object? remarks = freezed,Object? price = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,colour: freezed == colour ? _self.colour : colour // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as bool,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as ProductAvailability,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int?,installation: null == installation ? _self.installation : installation // ignore: cast_nullable_to_non_nullable
as bool,installationFee: freezed == installationFee ? _self.installationFee : installationFee // ignore: cast_nullable_to_non_nullable
as double?,photoPaths: null == photoPaths ? _self._photoPaths : photoPaths // ignore: cast_nullable_to_non_nullable
as List<String>,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
