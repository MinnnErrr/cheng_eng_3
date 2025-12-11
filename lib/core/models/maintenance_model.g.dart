// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MaintenanceList _$MaintenanceListFromJson(Map<String, dynamic> json) =>
    _MaintenanceList(
      maintenances: (json['maintenances'] as List<dynamic>)
          .map((e) => Maintenance.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MaintenanceListToJson(_MaintenanceList instance) =>
    <String, dynamic>{'maintenances': instance.maintenances};

_Maintenance _$MaintenanceFromJson(Map<String, dynamic> json) => _Maintenance(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  remarks: json['remarks'] as String?,
  currentServDate: DateTime.parse(json['currentServDate'] as String),
  currentServDistance: (json['currentServDistance'] as num).toDouble(),
  nextServDate: DateTime.parse(json['nextServDate'] as String),
  nextServDistance: (json['nextServDistance'] as num).toDouble(),
  status: json['status'] as String,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  vehicleId: json['vehicleId'] as String,
);

Map<String, dynamic> _$MaintenanceToJson(_Maintenance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'remarks': instance.remarks,
      'currentServDate': instance.currentServDate.toIso8601String(),
      'currentServDistance': instance.currentServDistance,
      'nextServDate': instance.nextServDate.toIso8601String(),
      'nextServDistance': instance.nextServDistance,
      'status': instance.status,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'vehicleId': instance.vehicleId,
    };
