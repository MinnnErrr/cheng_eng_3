import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerVehicleByIdProvider =
    FutureProvider.family<Vehicle, String>((ref, vehicleId) async {
  final vehicles = await ref.watch(customerVehicleProvider.future);

  return vehicles.vehicles.firstWhere(
    (v) => v.id == vehicleId,
    orElse: () => throw Exception("Maintenance not found"),
  );
});