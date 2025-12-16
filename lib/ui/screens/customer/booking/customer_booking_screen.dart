import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/booking/customer_booking_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_choose_vehicle_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/booking_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerBookingScreen extends ConsumerWidget {
  const CustomerBookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);
    final user = userState.value;

    // FIX 1: Safety check to prevent crash on 'user!.id'
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user found')),
      );
    }

    final bookingList = ref.watch(customerBookingProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking'),
      ),
      body: bookingList.when(
        data: (bookings) {
          // FIX 2: Add RefreshIndicator
          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(customerBookingProvider(user.id).future),
            child: bookings.isEmpty
                // FIX 3: Empty state must be scrollable to allow Refresh
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      const Center(child: Text('No booking record found')),
                    ],
                  )
                : SafeArea(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerBookingDetailsScreen(
                                    booking: booking,
                                  ),
                            ),
                          ),
                          child: BookingListitem(
                            booking: booking,
                          ),
                        );
                      },
                    ),
                  ),
          );
        },
        // Error handling with Retry button
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CustomerBookingChooseVehicleScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
