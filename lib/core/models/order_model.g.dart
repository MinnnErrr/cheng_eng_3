// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
  total: (json['total'] as num).toDouble(),
  points: (json['points'] as num).toInt(),
  username: json['username'] as String,
  userPhoneNum: json['userPhoneNum'] as String,
  userDialCode: json['userDialCode'] as String,
  userEmail: json['userEmail'] as String,
  deliveryMethod: $enumDecode(_$DeliveryMethodEnumMap, json['deliveryMethod']),
  deliveryFirstName: json['deliveryFirstName'] as String?,
  deliveryLastName: json['deliveryLastName'] as String?,
  deliveryDialCode: json['deliveryDialCode'] as String?,
  deliveryPhoneNum: json['deliveryPhoneNum'] as String?,
  deliveryAddressLine1: json['deliveryAddressLine1'] as String?,
  deliveryAddressLine2: json['deliveryAddressLine2'] as String?,
  deliveryPostcode: json['deliveryPostcode'] as String?,
  deliveryCity: json['deliveryCity'] as String?,
  deliveryState: $enumDecodeNullable(
    _$MalaysiaStateEnumMap,
    json['deliveryState'],
  ),
  deliveryCountry: json['deliveryCountry'] as String?,
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  userId: json['userId'] as String,
  items: (json['order_items'] as List<dynamic>?)
      ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'subtotal': instance.subtotal,
  'deliveryFee': instance.deliveryFee,
  'total': instance.total,
  'points': instance.points,
  'username': instance.username,
  'userPhoneNum': instance.userPhoneNum,
  'userDialCode': instance.userDialCode,
  'userEmail': instance.userEmail,
  'deliveryMethod': _$DeliveryMethodEnumMap[instance.deliveryMethod]!,
  'deliveryFirstName': instance.deliveryFirstName,
  'deliveryLastName': instance.deliveryLastName,
  'deliveryDialCode': instance.deliveryDialCode,
  'deliveryPhoneNum': instance.deliveryPhoneNum,
  'deliveryAddressLine1': instance.deliveryAddressLine1,
  'deliveryAddressLine2': instance.deliveryAddressLine2,
  'deliveryPostcode': instance.deliveryPostcode,
  'deliveryCity': instance.deliveryCity,
  'deliveryState': _$MalaysiaStateEnumMap[instance.deliveryState],
  'deliveryCountry': instance.deliveryCountry,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'userId': instance.userId,
};

const _$DeliveryMethodEnumMap = {
  DeliveryMethod.selfPickup: 'selfPickup',
  DeliveryMethod.delivery: 'delivery',
};

const _$MalaysiaStateEnumMap = {
  MalaysiaState.johor: 'johor',
  MalaysiaState.kedah: 'kedah',
  MalaysiaState.kelantan: 'kelantan',
  MalaysiaState.melaka: 'melaka',
  MalaysiaState.negeriSembilan: 'negeriSembilan',
  MalaysiaState.pahang: 'pahang',
  MalaysiaState.pulauPinang: 'pulauPinang',
  MalaysiaState.perak: 'perak',
  MalaysiaState.perlis: 'perlis',
  MalaysiaState.selangor: 'selangor',
  MalaysiaState.terengganu: 'terengganu',
  MalaysiaState.sabah: 'sabah',
  MalaysiaState.sarawak: 'sarawak',
  MalaysiaState.kualaLumpur: 'kualaLumpur',
  MalaysiaState.labuan: 'labuan',
  MalaysiaState.putrajaya: 'putrajaya',
};

const _$OrderStatusEnumMap = {
  OrderStatus.unpaid: 'unpaid',
  OrderStatus.pending: 'pending',
  OrderStatus.processing: 'processing',
  OrderStatus.ready: 'ready',
  OrderStatus.delivered: 'delivered',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};
