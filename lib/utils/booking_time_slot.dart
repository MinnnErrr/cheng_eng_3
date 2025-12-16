import 'package:flutter/material.dart';

List<TimeOfDay> generateTimeSlots() {
  final slots = <TimeOfDay>[];
  final int startHour = 9;
  final int endHour = 19; // 7 PM

  for (int hour = startHour; hour <= endHour; hour++) {
    // Always add the :00 slot
    slots.add(TimeOfDay(hour: hour, minute: 0));

    // Only add the :30 slot if it's NOT the very last hour
    // (Or remove this check if you close at 8 PM)
    if (hour != endHour) { 
      slots.add(TimeOfDay(hour: hour, minute: 30));
    }
  }

  return slots;
}