// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  id: json['id'] as String,
  quantity: (json['quantity'] as num).toInt(),
  photoPaths: (json['photoPaths'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  productBrand: json['productBrand'] as String,
  productName: json['productName'] as String,
  productModel: json['productModel'] as String,
  productPrice: (json['productPrice'] as num).toDouble(),
  productInstallationFee: (json['productInstallationFee'] as num?)?.toDouble(),
  price: (json['price'] as num).toDouble(),
  installationFee: (json['installationFee'] as num?)?.toDouble(),
  isReady: json['isReady'] as bool,
  productId: json['productId'] as String,
  orderId: json['orderId'] as String,
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'photoPaths': instance.photoPaths,
      'productBrand': instance.productBrand,
      'productName': instance.productName,
      'productModel': instance.productModel,
      'productPrice': instance.productPrice,
      'productInstallationFee': instance.productInstallationFee,
      'price': instance.price,
      'installationFee': instance.installationFee,
      'isReady': instance.isReady,
      'productId': instance.productId,
      'orderId': instance.orderId,
    };
