import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
// Import your list provider
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart'; 

final customerVehicleByIdProvider = FutureProvider.family<Vehicle, String>((ref, vehicleId) async {
  // 1. Watch the list provider. 
  // Using .future ensures we wait if the list is currently loading.
  final vehicleState = await ref.watch(customerVehicleProvider.future);

  // 2. Find the specific vehicle in the memory list
  return vehicleState.vehicles.firstWhere(
    (vehicle) => vehicle.id == vehicleId,
    orElse: () => throw Exception('Vehicle not found'),
  );
});