// lib/core/controllers/booking/booking_notifier.dart
import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/core/models/booking_state_model.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_state_notifier.g.dart';

@Riverpod(keepAlive: true)
class BookingStateNotifier extends _$BookingStateNotifier {
  @override
  BookingState build() {
    return const BookingState();
  }

  void selectVehicle(Vehicle vehicle) {
    state = state.copyWith(vehicle: vehicle);
  }

  void selectService(BookingServiceType service) {
    final currentList = state.services ?? []; 
  
  if (currentList.contains(service)) {
    state = state.copyWith(
      services: currentList.where((s) => s != service).toList(),
    );
  } else {
    state = state.copyWith(
      services: [...currentList, service],
    );
  }
  }

  void selectDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void selectTime(TimeOfDay time) {
    state = state.copyWith(time: time);
  }

  void inputRemarks(String remarks) {
    state = state.copyWith(remarks: remarks);
  }

  void reset() {
    state = const BookingState();
  }
}
