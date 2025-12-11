// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  id: json['id'] as String,
  quantity: (json['quantity'] as num).toInt(),
  installation: json['installation'] as bool?,
  productId: json['productId'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'quantity': instance.quantity,
  'installation': instance.installation,
  'productId': instance.productId,
  'userId': instance.userId,
};
