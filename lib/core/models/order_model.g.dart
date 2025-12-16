// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  createAt: DateTime.parse(json['createAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
  total: (json['total'] as num).toDouble(),
  points: (json['points'] as num).toInt(),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  phoneNum: json['phoneNum'] as String?,
  addressLine1: json['addressLine1'] as String?,
  addressLine2: json['addressLine2'] as String?,
  poscode: json['poscode'] as String?,
  city: json['city'] as String?,
  state: $enumDecode(_$StateEnumMap, json['state']),
  country: json['country'] as String?,
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  userId: json['userId'] as String,
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'createAt': instance.createAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'subtotal': instance.subtotal,
  'deliveryFee': instance.deliveryFee,
  'total': instance.total,
  'points': instance.points,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phoneNum': instance.phoneNum,
  'addressLine1': instance.addressLine1,
  'addressLine2': instance.addressLine2,
  'poscode': instance.poscode,
  'city': instance.city,
  'state': _$StateEnumMap[instance.state]!,
  'country': instance.country,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'userId': instance.userId,
};

const _$StateEnumMap = {
  State.johor: 'johor',
  State.kedah: 'kedah',
  State.kelantan: 'kelantan',
  State.melaka: 'melaka',
  State.negeriSembilan: 'negeriSembilan',
  State.pahang: 'pahang',
  State.pulauPinanag: 'pulauPinanag',
  State.perak: 'perak',
  State.perlis: 'perlis',
  State.selangor: 'selangor',
  State.terengganu: 'terengganu',
  State.sabah: 'sabah',
  State.sarawak: 'sarawak',
  State.kualaLumpur: 'kualaLumpur',
  State.labuah: 'labuah',
  State.putrajaya: 'putrajaya',
};

const _$OrderStatusEnumMap = {
  OrderStatus.unpaid: 'unpaid',
  OrderStatus.pending: 'pending',
  OrderStatus.processing: 'processing',
  OrderStatus.ready: 'ready',
  OrderStatus.delivered: 'delivered',
  OrderStatus.completed: 'completed',
};
