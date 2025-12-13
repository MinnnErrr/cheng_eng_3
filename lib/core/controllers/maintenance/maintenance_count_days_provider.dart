import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final maintenanceCountDaysProvider =
    FutureProvider.family<int, String>((ref, maintenanceId) async {
  final maintenanceList = await ref.watch(maintenanceProvider.future);

  final maintenance = maintenanceList.maintenances.firstWhere(
    (m) => m.id == maintenanceId,
    orElse: () => throw Exception('Maintenance not found'),
  );

  return maintenance.nextServDate.difference(DateTime.now()).inDays;
});