import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:cheng_eng_3/core/services/maintenance_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'maintenance_notifier.g.dart';

@riverpod
class MaintenanceNotifier extends _$MaintenanceNotifier {
  MaintenanceService get _maintenanceService =>
      ref.read(maintenanceServiceProvider);

  @override
  FutureOr<MaintenanceList> build() async {
    final userState = ref.watch(authProvider);
    final user = userState.value;
    if (user == null) return MaintenanceList(maintenances: []);
    final data = await _maintenanceService.getByUser(user.id);
    return data;
  }

  Future<bool> addMaintenance({
    required String title,
    String? description,
    String? remarks,
    required DateTime currentServDate,
    required double currentServDistance,
    required DateTime nextServDate,
    required double nextServDistance,
    required String vehicleId,
  }) async {
    final previous = state.value ?? MaintenanceList(maintenances: []);

    final id = Uuid().v4();

    final maintenance = Maintenance(
      id: id,
      title: title,
      description: description,
      remarks: remarks,
      currentServDate: currentServDate,
      currentServDistance: currentServDistance,
      nextServDate: nextServDate,
      nextServDistance: nextServDistance,
      status: 'Incomplete',
      vehicleId: vehicleId,
    );

    try {
      state = const AsyncLoading();

      final newMaintenance = await _maintenanceService.create(maintenance);

      state = AsyncData(
        MaintenanceList(
          maintenances: [...previous.maintenances, newMaintenance],
        ),
      );

      return true;
    } catch (e) {
      state = AsyncData(previous);
      return false;
    }
  }

  Future<bool> updateMaintenance({
    required String id,
    required String title,
    String? description,
    String? remarks,
    required DateTime currentServDate,
    required double currentServDistance,
    required DateTime nextServDate,
    required double nextServDistance,
  }) async {
    final previous = state.value ?? MaintenanceList(maintenances: []);
    final currentMaintenance = previous.maintenances.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception('Maintenance not found'),
    );

    final maintenance = currentMaintenance.copyWith(
      title: title,
      description: description,
      remarks: remarks,
      currentServDate: currentServDate,
      currentServDistance: currentServDistance,
      nextServDate: nextServDate,
      nextServDistance: nextServDistance,
    );

    try {
      state = const AsyncLoading();

      final updated = await _maintenanceService.update(maintenance);

      final updatedList = previous.maintenances.map((m) {
        return m.id == id ? updated : m;
      }).toList();

      state = AsyncData(MaintenanceList(maintenances: updatedList));

      return true;
    } catch (e) {
      state = AsyncData(previous);
      return false;
    }
  }

  Future<bool> updateStatus({
    required String id,
    required String status,
  }) async {
    final previous = state.value ?? MaintenanceList(maintenances: []);

    try {
      state = const AsyncLoading();

      final updated = await _maintenanceService.updateStatus(status, id);

      final updatedList = previous.maintenances.map((m) {
        return m.id == id ? updated : m;
      }).toList();

      state = AsyncData(MaintenanceList(maintenances: updatedList));

      return true;
    } catch (e) {
      state = AsyncData(previous);
      return false;
    }
  }

  Future<bool> deleteMaintenance(String id) async {
    final previous = state.value ?? MaintenanceList(maintenances: []);

    try {
      state = const AsyncLoading();

      await _maintenanceService.delete(id);

      final updatedList = previous.maintenances
          .where((m) => m.id != id)
          .toList();

      state = AsyncData(MaintenanceList(maintenances: updatedList));

      return true;
    } catch (e) {
      state = AsyncData(previous);
      return false;
    }
  }
}

final maintenanceByVehicleProvider =
    FutureProvider.family<MaintenanceList, String>((ref, vehicleId) async {
  final list = await ref.watch(maintenanceProvider.future);

  final maintenances = list.maintenances
      .where((m) => m.vehicleId == vehicleId)
      .toList();

  return MaintenanceList(maintenances: maintenances);
});


final maintenanceByIdProvider =
    FutureProvider.family<Maintenance, String>((ref, maintenanceId) async {
  final maintenances = await ref.watch(maintenanceProvider.future);

  return maintenances.maintenances.firstWhere(
    (m) => m.id == maintenanceId,
    orElse: () => throw Exception("Maintenance not found"),
  );
});


final maintenanceCountDaysProvider =
    FutureProvider.family<int, String>((ref, maintenanceId) async {
  final maintenanceList = await ref.watch(maintenanceProvider.future);

  final maintenance = maintenanceList.maintenances.firstWhere(
    (m) => m.id == maintenanceId,
    orElse: () => throw Exception('Maintenance not found'),
  );

  return maintenance.nextServDate.difference(DateTime.now()).inDays;
});


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
          m.status.toLowerCase() == 'incomplete')
      .toList();

  if (upcoming.isEmpty) return MaintenanceList(maintenances: []);

  // Sort by nearest date
  upcoming.sort((a, b) => a.nextServDate.compareTo(b.nextServDate));

  final nearestDate = upcoming.first.nextServDate;

  // Select only maintenance tasks with the same nearest date
  final filtered = upcoming.where((m) {
    return m.nextServDate.year == nearestDate.year &&
        m.nextServDate.month == nearestDate.month &&
        m.nextServDate.day == nearestDate.day;
  }).toList();

  return MaintenanceList(maintenances: filtered);
});

