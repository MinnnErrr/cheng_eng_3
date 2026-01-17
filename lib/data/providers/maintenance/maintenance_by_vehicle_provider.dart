import 'package:cheng_eng_3/ui/maintenances/notifiers/maintenance_notifier.dart';
import 'package:cheng_eng_3/domain/models/maintenance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final maintenanceByVehicleProvider =
    FutureProvider.family<MaintenanceList, String>((ref, vehicleId) async {
  final list = await ref.watch(maintenanceProvider.future);

  final maintenances = list.maintenances
      .where((m) => m.vehicleId == vehicleId)
      .toList();

  return MaintenanceList(maintenances: maintenances);
});