import 'package:cheng_eng_3/data/services/booking_service.dart';
import 'package:cheng_eng_3/utils/booking_time_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookingPerSlotProvider =
    FutureProvider.family<Map<TimeOfDay, int>, DateTime>((ref, date) async {
      final bookingService = ref.read(bookingServiceProvider);
      print("DEBUG: Fetching bookings for Date: $date");
      final bookings = await bookingService.getBookingByDate(date);
      print("DEBUG: Found ${bookings.length} bookings from DB");

      final slots = generateTimeSlots();

      final Map<TimeOfDay, int> slotCounts = {for (var slot in slots) slot: 0};

      for (var booking in bookings) {
        print("DEBUG: Processing booking time: ${booking.time}");
        final slot = TimeOfDay(
          hour: booking.time.hour,
          minute: booking.time.minute,
        );
        if (slotCounts.containsKey(slot)) {
          slotCounts[slot] = slotCounts[slot]! + 1;
        } else {
          // 4. If it prints this, your booking time doesn't match your generated slots
          print(
            "WARNING: Booking time $slot does not match any generated slot!",
          );
        }
      }

      return slotCounts;
    });
