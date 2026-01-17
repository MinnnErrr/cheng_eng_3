import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_model.g.dart';
part 'vehicle_model.freezed.dart';

@freezed
sealed class VehicleList with _$VehicleList{
  const factory VehicleList({required List<Vehicle> vehicles}) = _VehicleList;

  factory VehicleList.fromJson(Map<String, dynamic> json) =>
    _$VehicleListFromJson(json);

}

@freezed
sealed class Vehicle with _$Vehicle {
  const factory Vehicle({
    required String id,
    String? description,
    required String regNum,
    required String make,
    required String model,
    required String colour,
    required int year,
    String? photoPath,
    DateTime? deletedAt,
    required String userId
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

}
