import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.g.dart';
part 'booking_model.freezed.dart';

//converter for timeofday
class TimeOfDayConverter implements JsonConverter<TimeOfDay, String> {
  const TimeOfDayConverter();

  @override
  TimeOfDay fromJson(String json) {
    final parts = json.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  @override
  String toJson(TimeOfDay object) {
    // Converts to format "HH:mm"
    final hour = object.hour.toString().padLeft(2, '0');
    final minute = object.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

enum BookingServiceType {
  service1,
  service2,
  service3,
  service4
}

enum BookingStatus {
  pending,
  accepted,
  cancelled,
  completed
}

@freezed
sealed class Booking with _$Booking {
  const factory Booking({
    required String id,
    required List<BookingServiceType> services,
    required DateTime date,
    
    @TimeOfDayConverter() 
    required TimeOfDay time,
    
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