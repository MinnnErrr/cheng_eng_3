import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.g.dart';
part 'booking_model.freezed.dart';

enum BookingServiceType{
  service1,
  service2,
  service3,
  service4
}

enum BookingStatus{
  pending,
  accepted,
  cancelled,
  completed
}

@freezed
sealed class Booking with _$Booking {
  const factory Booking({
    required String id,
    required BookingServiceType service,
    required DateTime date,
    required DateTime time,
    required String? remarks,
    required String? staffMessage,
    required BookingStatus status,
    required String? vehiclePhoto,
    required String vehicleRegNum,
    required String vehicleMake,
    required String vehicleModel,
    required String vehicleColour,
    required int vehicleYear,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required String vehicleId,
    required String userId
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

}