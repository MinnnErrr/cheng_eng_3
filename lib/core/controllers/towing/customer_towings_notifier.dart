import 'dart:io';

import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/core/services/towing_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'customer_towings_notifier.g.dart';

@riverpod
class CustomerTowingsNotifier extends _$CustomerTowingsNotifier {
  TowingService get _towingService => ref.read(towingServiceProvider);
  ImageService get _imageService => ref.read(imageServiceProvider);

  @override
  FutureOr<List<Towing>> build(String userId) async {
    return await _towingService.getByUser(userId);
  }

  void refresh() => ref.invalidateSelf();

  Future<bool> addTowing({
    required double latitude,
    required double longitude,
    required String address,
    required String phoneNum,
    required String dialCode,
    required String countryCode,
    String? remarks,
    required String vehicleId,
    File? photo,
  }) async {
    final userState = ref.read(authProvider);
    final user = userState.value;
    if (user == null) {
      return false;
    }

    final towingId = Uuid().v4();

    String? photoPath;
    if (photo != null) {
      try {
        photoPath = await _imageService.uploadImage(
          photoFile: photo,
          tableName: 'towing',
          id: towingId,
        );
      } catch (e) {
        return false;
      }
    }

    final vehicle = ref.read(customerVehicleByIdProvider(vehicleId)).value;

    if (vehicle == null) return false;

    final towing = Towing(
      id: towingId,
      latitude: latitude,
      longitude: longitude,
      address: address,
      phoneNum: phoneNum,
      countryCode: countryCode,
      dialCode: dialCode,
      status: 'Pending',
      regNum: vehicle.regNum,
      make: vehicle.make,
      model: vehicle.model,
      colour: vehicle.colour,
      vehiclePhoto: vehicle.photoPath,
      remarks: remarks,
      photoPath: photoPath,
      createdAt: DateTime.now(),
      vehicleId: vehicleId,
      userId: user.id,
    );

    try {
      await _towingService.create(towing);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStatus({
    required String id,
    required String status,
  }) async {
    try {
      await _towingService.updateStatus(status, id);

      return true;
    } catch (e) {
      return false;
    }
  }
}

// final customerTowingByIdProvider = FutureProvider.family<Towing, ({String userId, String towingId})>(
//   (ref, params) async {
//     final towingList = await ref.watch(customerTowingProvider(params.userId).future);

//     final towing = towingList.firstWhere(
//       (t) => t.id == params.towingId,
//       orElse: () => throw Exception('Towing not found'),
//     );

//     return towing;
//   },
// );
