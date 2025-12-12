import 'dart:io';

import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/core/services/vehicle_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'customer_vehicle_notifier.g.dart';

@riverpod
class CustomerVehicleNotifier extends _$CustomerVehicleNotifier {
  VehicleService get _vehicleService => ref.read(vehicleServiceProvider);
  ImageService get _imageService => ref.read(imageServiceProvider);

  @override
  FutureOr<VehicleList> build() async {
    final userState = ref.watch(authProvider);
    final user = userState.value;
    if (user == null) return VehicleList(vehicles: []);
    return await _vehicleService.getByUser(user.id);
  }

  Future<bool> addVehicle({
    String? description,
    required String regNum,
    required String make,
    required String model,
    required String colour,
    required int year,
    File? photo,
  }) async {
    final userState = ref.read(authProvider);
    final user = userState.value;
    if (user == null) {
      return false;
    }

    final previous = state.value ?? VehicleList(vehicles: []);

    final vehicleId = Uuid().v4();

    String? photoPath;
    if (photo != null) {
      try {
        photoPath = await _imageService.uploadImage(
          photoFile: photo,
          tableName: 'vehicle',
          id: vehicleId,
        );
      } catch (e) {
        return false;
      }
    }

    final vehicle = Vehicle(
      id: vehicleId,
      description: description,
      regNum: regNum,
      make: make,
      model: model,
      colour: colour,
      year: year,
      photoPath: photoPath,
      userId: user.id,
    );

    try {
      state = const AsyncLoading();

      final newVehicle = await _vehicleService.create(vehicle);

      state = AsyncData(
        VehicleList(vehicles: [...previous.vehicles, newVehicle]),
      );

      return true;
    } catch (e) {
      state = AsyncData(previous);
      return false;
    }
  }

  Future<bool> updateVehicle({
    required String id,
    String? description,
    required String regNum,
    required String make,
    required String model,
    required String colour,
    required int year,
    File? photo,
  }) async {
    final previous = state.value ?? VehicleList(vehicles: []);
    final currentVehicle = previous.vehicles.firstWhere((v) => v.id == id);

    String? photoPath = currentVehicle.photoPath;

    if (photo != null) {
      try {
        photoPath = await _imageService.uploadImage(
          photoFile: photo,
          tableName: 'vehicle',
          id: id,
        );
      } catch (e) {
        return false;
      }
    }

    final vehicle = currentVehicle.copyWith(
      description: description,
      regNum: regNum,
      make: make,
      model: model,
      colour: colour,
      year: year,
      photoPath: photoPath,
    );

    try {
      state = const AsyncLoading();

      final updated = await _vehicleService.update(vehicle);

      final updatedList = previous.vehicles.map((v) {
        return v.id == id ? updated : v;
      }).toList();

      state = AsyncData(VehicleList(vehicles: updatedList));

      return true;
    } catch (e) {
      state = AsyncData(previous);
      return false;
    }
  }

  Future<bool> deleteVehicle(String id) async {
    final previous = state.value ?? VehicleList(vehicles: []);

    try {
      state = const AsyncLoading();

      await _vehicleService.delete(id);

      final updatedList = previous.vehicles.where((v) => v.id != id).toList();

      state = AsyncData(VehicleList(vehicles: updatedList));

      return true;
    } catch (e) {
      state = AsyncData(previous);
      return false;
    }
  }
}

final customerVehicleByIdProvider =
    FutureProvider.family<Vehicle, String>((ref, vehicleId) async {
  final vehicles = await ref.watch(customerVehicleProvider.future);

  return vehicles.vehicles.firstWhere(
    (v) => v.id == vehicleId,
    orElse: () => throw Exception("Maintenance not found"),
  );
});