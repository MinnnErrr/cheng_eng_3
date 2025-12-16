import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_state_model.freezed.dart';

@freezed
sealed class BookingState with _$BookingState {
  const factory BookingState({
    Vehicle? vehicle,
    List<BookingServiceType>? services,
    DateTime? date,
    TimeOfDay? time,
    String? remarks
  }) = _BookingState;
}
