import 'package:cheng_eng_3/ui/auth/notifiers/auth_notifier.dart';
import 'package:cheng_eng_3/data/providers/vehicle/customer_vehicle_by_id_provider.dart';
import 'package:cheng_eng_3/domain/models/maintenance_model.dart';
import 'package:cheng_eng_3/data/services/maintenance_service.dart';
import 'package:cheng_eng_3/data/services/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'maintenance_notifier.g.dart';

@riverpod
class MaintenanceNotifier extends _$MaintenanceNotifier {
  MaintenanceService get _maintenanceService =>
      ref.read(maintenanceServiceProvider);
  NotificationService get _notificationService =>
      ref.read(notificationServiceProvider);

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
    required double? currentServDistance,
    required DateTime nextServDate,
    required double? nextServDistance,
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
      isComplete: false,
      vehicleId: vehicleId,
    );

    try {
      state = const AsyncLoading();

      final newMaintenance = await _maintenanceService.create(maintenance);

      final vehicle = await ref.read(
        customerVehicleByIdProvider(vehicleId).future,
      );

      await _notificationService.scheduleMaintenanceReminder(
        id: id,
        vehicleName: vehicle.regNum,
        serviceDate: nextServDate,
      );

      await _notificationService.showNotification(
        vehicleName: vehicle.regNum,
        serviceDate: nextServDate,
      );

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
    required double? currentServDistance,
    required DateTime nextServDate,
    required double? nextServDistance,
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

      if (updated.isComplete == false) {
        final vehicle = await ref.read(
          customerVehicleByIdProvider(maintenance.vehicleId).future,
        );

        // This effectively overwrites the previous alarm because we use the same ID hash logic
        await _notificationService.cancelReminder(id);
        await _notificationService.scheduleMaintenanceReminder(
          id: id,
          vehicleName: vehicle.regNum,
          serviceDate: nextServDate,
        );
        await _notificationService.showNotification(
        vehicleName: vehicle.regNum,
        serviceDate: nextServDate,
      );
      }

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
    required bool isComplete,
  }) async {
    final previous = state.value ?? MaintenanceList(maintenances: []);
    final currentMaintenance = previous.maintenances.firstWhere(
      (m) => m.id == id,
      orElse: () => throw Exception('Maintenance not found'),
    );

    try {
      state = const AsyncLoading();

      final updated = await _maintenanceService.updateStatus(isComplete, id);

      if (isComplete == true) {
        await _notificationService.cancelReminder(id);
      } else {
        // Optimization: Only fetch vehicle info if we actually need to schedule
        final vehicle = await ref.read(
          customerVehicleByIdProvider(currentMaintenance.vehicleId).future,
        );

        await _notificationService.scheduleMaintenanceReminder(
          id: id, // Ensure parameter name matches your service
          vehicleName: vehicle.regNum,
          serviceDate: currentMaintenance.nextServDate,
        );
      }

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

      await _notificationService.cancelReminder(id);

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
