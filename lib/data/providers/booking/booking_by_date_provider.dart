import 'package:cheng_eng_3/data/services/booking_service.dart';
import 'package:cheng_eng_3/utils/booking_time_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookingPerSlotProvider =
    FutureProvider.family<Map<TimeOfDay, int>, DateTime>((ref, date) async {
      final bookingService = ref.read(bookingServiceProvider);
      final bookings = await bookingService.getBookingByDate(date);

      final slots = generateTimeSlots();

      final Map<TimeOfDay, int> slotCounts = {for (var slot in slots) slot: 0};

      for (var booking in bookings) {
        final slot = TimeOfDay(
          hour: booking.time.hour,
          minute: booking.time.minute,
        );
        if (slotCounts.containsKey(slot)) {
          slotCounts[slot] = slotCounts[slot]! + 1;
        } 
      }

      return slotCounts;
    });
