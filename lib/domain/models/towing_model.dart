import 'package:freezed_annotation/freezed_annotation.dart';

part 'towing_model.g.dart';
part 'towing_model.freezed.dart';

enum TowingStatus{
  completed,
  pending,
  accepted,
  cancelled,
  declined
}

@freezed
sealed class Towing with _$Towing {
  const factory Towing({
    required String id,
    String? remarks,
    required double latitude,
    required double longitude,
    required String address,
    required String phoneNum,
    required String countryCode,
    required String dialCode,
    String? photoPath,
    required TowingStatus status,
    required String regNum,
    required String make,
    required String model,
    required String colour,
    String? vehiclePhoto,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    required String vehicleId,
    required String userId
  }) = _Towing;

  factory Towing.fromJson(Map<String, dynamic> json) =>
      _$TowingFromJson(json);

}