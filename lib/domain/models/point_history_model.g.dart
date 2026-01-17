// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PointHistory _$PointHistoryFromJson(Map<String, dynamic> json) =>
    _PointHistory(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiredAt: json['expiredAt'] == null
          ? null
          : DateTime.parse(json['expiredAt'] as String),
      reason: json['reason'] as String,
      points: (json['points'] as num).toInt(),
      isIssuedByStaff: json['isIssuedByStaff'] as bool,
      type: $enumDecode(_$PointTypeEnumMap, json['type']),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$PointHistoryToJson(_PointHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiredAt': instance.expiredAt?.toIso8601String(),
      'reason': instance.reason,
      'points': instance.points,
      'isIssuedByStaff': instance.isIssuedByStaff,
      'type': _$PointTypeEnumMap[instance.type]!,
      'userId': instance.userId,
    };

const _$PointTypeEnumMap = {
  PointType.earn: 'earn',
  PointType.use: 'use',
  PointType.expire: 'expire',
  PointType.earnExpired: 'earnExpired',
};
