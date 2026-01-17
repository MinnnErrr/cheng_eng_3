import 'package:cheng_eng_3/ui/maintenances/notifiers/maintenance_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cheng_eng_3/domain/models/maintenance_model.dart';

final maintenanceByIdProvider = FutureProvider.family<Maintenance, String>((ref, maintenanceId) async {
  
  final state = await ref.watch(maintenanceProvider.future);

  return state.maintenances.firstWhere(
    (m) => m.id == maintenanceId,
    orElse: () => throw Exception('Maintenance record not found'),
  );
});