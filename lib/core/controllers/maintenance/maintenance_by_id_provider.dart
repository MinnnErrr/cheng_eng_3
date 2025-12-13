import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final maintenanceByIdProvider =
    FutureProvider.family<Maintenance, String>((ref, maintenanceId) async {
  final maintenances = await ref.watch(maintenanceProvider.future);

  return maintenances.maintenances.firstWhere(
    (m) => m.id == maintenanceId,
    orElse: () => throw Exception("Maintenance not found"),
  );
});