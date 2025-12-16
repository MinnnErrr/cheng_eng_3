import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';

// Input is now a "Record" (Tuple) containing both IDs
final maintenanceByIdProvider = FutureProvider.family<Maintenance, String>((ref, maintenanceId) async {
  
  // 1. Watch the list for this specific vehicle
  final state = await ref.watch(maintenanceProvider.future);

  // 2. Find the specific maintenance record in that list
  return state.maintenances.firstWhere(
    (m) => m.id == maintenanceId,
    orElse: () => throw Exception('Maintenance record not found'),
  );
});