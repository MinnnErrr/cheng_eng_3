// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  name: json['name'] as String,
  category: json['category'] as String,
  brand: json['brand'] as String,
  model: json['model'] as String?,
  colour: json['colour'] as String?,
  description: json['description'] as String,
  status: json['status'] as bool,
  availability: $enumDecode(_$ProductAvailabilityEnumMap, json['availability']),
  quantity: (json['quantity'] as num?)?.toInt(),
  installation: json['installation'] as bool,
  installationFee: (json['installationFee'] as num?)?.toDouble(),
  photoPaths: (json['photoPaths'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  remarks: json['remarks'] as String?,
  price: (json['price'] as num).toDouble(),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'name': instance.name,
  'category': instance.category,
  'brand': instance.brand,
  'model': instance.model,
  'colour': instance.colour,
  'description': instance.description,
  'status': instance.status,
  'availability': _$ProductAvailabilityEnumMap[instance.availability]!,
  'quantity': instance.quantity,
  'installation': instance.installation,
  'installationFee': instance.installationFee,
  'photoPaths': instance.photoPaths,
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'remarks': instance.remarks,
  'price': instance.price,
};

const _$ProductAvailabilityEnumMap = {
  ProductAvailability.ready: 'ready',
  ProductAvailability.preorder: 'preorder',
};
