// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Reward _$RewardFromJson(Map<String, dynamic> json) => _Reward(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  code: json['code'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  conditions: json['conditions'] as String?,
  points: (json['points'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
  availableUntil: json['availableUntil'] == null
      ? null
      : DateTime.parse(json['availableUntil'] as String),
  hasExpiry: json['hasExpiry'] as bool,
  photoPaths: (json['photoPaths'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  status: json['status'] as bool,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$RewardToJson(_Reward instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'code': instance.code,
  'name': instance.name,
  'description': instance.description,
  'conditions': instance.conditions,
  'points': instance.points,
  'quantity': instance.quantity,
  'availableUntil': instance.availableUntil?.toIso8601String(),
  'hasExpiry': instance.hasExpiry,
  'photoPaths': instance.photoPaths,
  'status': instance.status,
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
