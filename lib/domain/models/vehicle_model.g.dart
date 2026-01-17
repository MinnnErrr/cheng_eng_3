// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VehicleList _$VehicleListFromJson(Map<String, dynamic> json) => _VehicleList(
  vehicles: (json['vehicles'] as List<dynamic>)
      .map((e) => Vehicle.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$VehicleListToJson(_VehicleList instance) =>
    <String, dynamic>{'vehicles': instance.vehicles};

_Vehicle _$VehicleFromJson(Map<String, dynamic> json) => _Vehicle(
  id: json['id'] as String,
  description: json['description'] as String?,
  regNum: json['regNum'] as String,
  make: json['make'] as String,
  model: json['model'] as String,
  colour: json['colour'] as String,
  year: (json['year'] as num).toInt(),
  photoPath: json['photoPath'] as String?,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  userId: json['userId'] as String,
);

Map<String, dynamic> _$VehicleToJson(_Vehicle instance) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'regNum': instance.regNum,
  'make': instance.make,
  'model': instance.model,
  'colour': instance.colour,
  'year': instance.year,
  'photoPath': instance.photoPath,
  'deletedAt': instance.deletedAt?.toIso8601String(),
  'userId': instance.userId,
};
