import 'package:cheng_eng_3/domain/models/vehicle_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'vehicle_service.g.dart';

@Riverpod(keepAlive: true)
VehicleService vehicleService(Ref ref) {
  return VehicleService();
}

class VehicleService {
  final supabase = Supabase.instance.client;

  Future<VehicleList> getByUser(String userId) async {
    final data = await supabase
        .from('vehicles')
        .select()
        .eq('userId', userId)
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: true);
    final vehicles = (data as List)
        .map((vehicle) => Vehicle.fromJson(vehicle as Map<String, dynamic>))
        .toList();

    return VehicleList(vehicles: vehicles);
  }

  Future<Vehicle> getByVehicleId(String id) async {
    final data = await supabase.from('vehicles').select().eq('id', id).single();
    return Vehicle.fromJson(data);
  }

  Future<Vehicle> create(Vehicle vehicle) async {
    final data = await supabase
        .from('vehicles')
        .insert(vehicle.toJson())
        .select()
        .single();
    return Vehicle.fromJson(data);
  }

  Future<Vehicle> update(Vehicle vehicle) async {
    final data = await supabase
        .from('vehicles')
        .update(vehicle.toJson())
        .eq('id', vehicle.id)
        .select()
        .single();
    return Vehicle.fromJson(data);
  }

  Future<void> delete(String id) async {
    await supabase
        .from('vehicles')
        .update({'deletedAt': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
