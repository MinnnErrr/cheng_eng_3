import 'package:flutter/material.dart';

List<TimeOfDay> generateTimeSlots() {
  final slots = <TimeOfDay>[];
  final int startHour = 9;
  final int endHour = 19; // 7 PM

  for (int hour = startHour; hour <= endHour; hour++) {
    slots.add(TimeOfDay(hour: hour, minute: 0));
    if (hour != endHour) { 
      slots.add(TimeOfDay(hour: hour, minute: 30));
    }
  }

  return slots;
}