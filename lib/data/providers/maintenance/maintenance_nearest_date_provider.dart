import 'package:cheng_eng_3/ui/maintenances/notifiers/maintenance_notifier.dart';
import 'package:cheng_eng_3/domain/models/maintenance_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final maintenanceByNearestDateProvider =
    FutureProvider<MaintenanceList>((ref) async {
  final maintenanceList = await ref.watch(maintenanceProvider.future);

  if (maintenanceList.maintenances.isEmpty) {
    return MaintenanceList(maintenances: []);
  }

  final now = DateTime.now();

  final upcoming = maintenanceList.maintenances
      .where((m) =>
          !m.nextServDate.isBefore(now) &&
          m.isComplete == false)
      .toList();

  if (upcoming.isEmpty) return MaintenanceList(maintenances: []);

  upcoming.sort((a, b) => a.nextServDate.compareTo(b.nextServDate));

  final nearestDate = upcoming.first.nextServDate;

  final filtered = upcoming.where((m) {
    return m.nextServDate.year == nearestDate.year &&
        m.nextServDate.month == nearestDate.month &&
        m.nextServDate.day == nearestDate.day;
  }).toList();

  return MaintenanceList(maintenances: filtered);
});