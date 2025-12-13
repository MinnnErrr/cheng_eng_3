import 'package:flutter/material.dart';

List<TimeOfDay> generateTimeSlots() {
  final slots = <TimeOfDay>[];

  for (int hour = 9; hour <= 19; hour++) {
    slots.add(TimeOfDay(hour: hour, minute: 0));
    slots.add(TimeOfDay(hour: hour, minute: 30));
  }

  return slots;
}
