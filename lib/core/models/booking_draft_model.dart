import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_draft_model.freezed.dart';

@freezed
sealed class BookingDraft with _$BookingDraft {
  const factory BookingDraft({
    Vehicle? vehicle,
    BookingServiceType? serviceType,
    DateTime? date,
    TimeOfDay? time,
  }) = _BookingDraft;
}
