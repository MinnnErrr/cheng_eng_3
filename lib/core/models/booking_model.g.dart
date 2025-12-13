// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: json['id'] as String,
  service: $enumDecode(_$BookingServiceTypeEnumMap, json['service']),
  date: DateTime.parse(json['date'] as String),
  time: DateTime.parse(json['time'] as String),
  remarks: json['remarks'] as String?,
  staffMessage: json['staffMessage'] as String?,
  status: $enumDecode(_$BookingStatusEnumMap, json['status']),
  vehiclePhoto: json['vehiclePhoto'] as String?,
  vehicleRegNum: json['vehicleRegNum'] as String,
  vehicleMake: json['vehicleMake'] as String,
  vehicleModel: json['vehicleModel'] as String,
  vehicleColour: json['vehicleColour'] as String,
  vehicleYear: (json['vehicleYear'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  vehicleId: json['vehicleId'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'id': instance.id,
  'service': _$BookingServiceTypeEnumMap[instance.service]!,
  'date': instance.date.toIso8601String(),
  'time': instance.time.toIso8601String(),
  'remarks': instance.remarks,
  'staffMessage': instance.staffMessage,
  'status': _$BookingStatusEnumMap[instance.status]!,
  'vehiclePhoto': instance.vehiclePhoto,
  'vehicleRegNum': instance.vehicleRegNum,
  'vehicleMake': instance.vehicleMake,
  'vehicleModel': instance.vehicleModel,
  'vehicleColour': instance.vehicleColour,
  'vehicleYear': instance.vehicleYear,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'vehicleId': instance.vehicleId,
  'userId': instance.userId,
};

const _$BookingServiceTypeEnumMap = {
  BookingServiceType.service1: 'service1',
  BookingServiceType.service2: 'service2',
  BookingServiceType.service3: 'service3',
  BookingServiceType.service4: 'service4',
};

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.accepted: 'accepted',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.completed: 'completed',
};
