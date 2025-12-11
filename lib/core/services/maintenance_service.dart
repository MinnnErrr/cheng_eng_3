import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'maintenance_service.g.dart';

@Riverpod(keepAlive: true)
MaintenanceService maintenanceService(Ref ref) {
  return MaintenanceService();
}

class MaintenanceService {
  final supabase = Supabase.instance.client;

  Future<MaintenanceList> getByUser(String userId) async {
    final data = await supabase
        .from('maintenances')
        .select('*, vehicles!inner(userId)')
        .eq('vehicles.userId', userId)
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: true);
    final maintenances = (data as List)
        .map(
          (maintenance) =>
              Maintenance.fromJson(maintenance as Map<String, dynamic>),
        )
        .toList();

    return MaintenanceList(maintenances: maintenances);
  }

  Future<MaintenanceList> getByVehicleId(String vehicleId) async {
    final data = await supabase
        .from('maintenances')
        .select()
        .eq('vehicleId', vehicleId)
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: true);
    final maintenances = (data as List)
        .map(
          (maintenance) =>
              Maintenance.fromJson(maintenance as Map<String, dynamic>),
        )
        .toList();

    return MaintenanceList(maintenances: maintenances);
  }

  Future<Maintenance> getByMaintenanceId(String id) async {
    final data = await supabase
        .from('maintenances')
        .select()
        .eq('id', id)
        .single();
    return Maintenance.fromJson(data);
  }

  Future<Maintenance> create(Maintenance maintenance) async {
    final data = await supabase
        .from('maintenances')
        .insert(maintenance.toJson())
        .select()
        .single();
    return Maintenance.fromJson(data);
  }

  Future<Maintenance> update(Maintenance maintenance) async {
    final data = await supabase
        .from('maintenances')
        .update(maintenance.toJson())
        .eq('id', maintenance.id)
        .select()
        .single();
    return Maintenance.fromJson(data);
  }

  Future<Maintenance> updateStatus(String status, String maintenanceId) async {
    final data = await supabase
        .from('maintenances')
        .update({'status': status})
        .eq('id', maintenanceId)
        .select()
        .single();
    return Maintenance.fromJson(data);
  }

  Future<void> delete(String id) async {
    await supabase
        .from('maintenances')
        .update({'deletedAt': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
