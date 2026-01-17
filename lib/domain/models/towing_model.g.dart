// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'towing_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Towing _$TowingFromJson(Map<String, dynamic> json) => _Towing(
  id: json['id'] as String,
  remarks: json['remarks'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String,
  phoneNum: json['phoneNum'] as String,
  countryCode: json['countryCode'] as String,
  dialCode: json['dialCode'] as String,
  photoPath: json['photoPath'] as String?,
  status: $enumDecode(_$TowingStatusEnumMap, json['status']),
  regNum: json['regNum'] as String,
  make: json['make'] as String,
  model: json['model'] as String,
  colour: json['colour'] as String,
  vehiclePhoto: json['vehiclePhoto'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  vehicleId: json['vehicleId'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$TowingToJson(_Towing instance) => <String, dynamic>{
  'id': instance.id,
  'remarks': instance.remarks,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'phoneNum': instance.phoneNum,
  'countryCode': instance.countryCode,
  'dialCode': instance.dialCode,
  'photoPath': instance.photoPath,
  'status': _$TowingStatusEnumMap[instance.status]!,
  'regNum': instance.regNum,
  'make': instance.make,
  'model': instance.model,
  'colour': instance.colour,
  'vehiclePhoto': instance.vehiclePhoto,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'vehicleId': instance.vehicleId,
  'userId': instance.userId,
};

const _$TowingStatusEnumMap = {
  TowingStatus.completed: 'completed',
  TowingStatus.pending: 'pending',
  TowingStatus.accepted: 'accepted',
  TowingStatus.cancelled: 'cancelled',
  TowingStatus.declined: 'declined',
};
