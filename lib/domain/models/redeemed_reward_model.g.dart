// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeemed_reward_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RedeemedReward _$RedeemedRewardFromJson(Map<String, dynamic> json) =>
    _RedeemedReward(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      conditions: json['conditions'] as String?,
      points: (json['points'] as num).toInt(),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      photoPaths: (json['photoPaths'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isClaimed: json['isClaimed'] as bool,
      rewardId: json['rewardId'] as String,
      userId: json['userId'] as String,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RedeemedRewardToJson(_RedeemedReward instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'conditions': instance.conditions,
      'points': instance.points,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'photoPaths': instance.photoPaths,
      'isClaimed': instance.isClaimed,
      'rewardId': instance.rewardId,
      'userId': instance.userId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
