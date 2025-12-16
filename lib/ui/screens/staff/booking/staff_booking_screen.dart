import 'package:cheng_eng_3/core/controllers/booking/staff_booking_notifier.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart'; // Import this
import 'package:cheng_eng_3/ui/screens/staff/booking/staff_booking_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/booking_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffBookingScreen extends ConsumerWidget {
  const StaffBookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. WATCH REALTIME
    // This ensures the list refreshes automatically when the database changes
    ref.watch(bookingRealTimeProvider);
    
    final bookingList = ref.watch(staffBookingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(staffBookingProvider.future);
        },
        child: bookingList.when(
          data: (bookings) {
            if (bookings.isEmpty) {
              // Using LayoutBuilder ensures the "No record" text is truly centered
              // while still allowing the Pull-to-Refresh to work.
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: constraints.maxHeight,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No booking record found', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SafeArea(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: bookings.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  
                  // 2. VISUAL FIX: 
                  // If BookingListitem is a Card, we shouldn't wrap it in InkWell here.
                  // Instead, wrapping it in a GestureDetector is safer for navigation,
                  // OR modify BookingListitem to accept an onTap.
                  // For now, GestureDetector works perfectly for navigation.
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StaffBookingDetailsScreen(
                          booking: booking,
                        ),
                      ),
                    ),
                    child: BookingListitem(booking: booking),
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}