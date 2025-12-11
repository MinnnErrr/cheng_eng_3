import 'package:freezed_annotation/freezed_annotation.dart';

part 'maintenance_model.g.dart';
part 'maintenance_model.freezed.dart';

@freezed
sealed class MaintenanceList with _$MaintenanceList{
  const factory MaintenanceList({required List<Maintenance> maintenances}) = _MaintenanceList;

  factory MaintenanceList.fromJson(Map<String, dynamic> json) =>
    _$MaintenanceListFromJson(json);

}

@freezed
sealed class Maintenance with _$Maintenance {
  const factory Maintenance({
    required String id,
    required String title,
    String? description,
    String? remarks,
    required DateTime currentServDate,
    required double currentServDistance,
    required DateTime nextServDate,
    required double nextServDistance,
    required String status,
    DateTime? deletedAt,
    required String vehicleId
  }) = _Maintenance;

  factory Maintenance.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceFromJson(json);

}
