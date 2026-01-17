import 'package:cheng_eng_3/ui/auth/notifiers/auth_notifier.dart';
import 'package:cheng_eng_3/ui/bookings/notifiers/customer_booking_notifier.dart';
import 'package:cheng_eng_3/ui/bookings/screens/customer/customer_booking_choose_vehicle_screen.dart';
import 'package:cheng_eng_3/ui/bookings/screens/customer/customer_booking_details_screen.dart';
import 'package:cheng_eng_3/ui/bookings/widgets/booking_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerBookingScreen extends ConsumerWidget {
  const CustomerBookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userState = ref.watch(authProvider);
    final user = userState.value;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user found')),
      );
    }

    final bookingList = ref.watch(customerBookingProvider(user.id));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookingList.when(
        data: (bookings) {
          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(customerBookingProvider(user.id).future),
            child: bookings.isEmpty
                ? _buildEmptyState(context)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: bookings.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return BookingListitem(
                        booking: booking,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                CustomerBookingDetailsScreen(booking: booking),
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading bookings:\n$error',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () =>
                    ref.refresh(customerBookingProvider(user.id).future),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CustomerBookingChooseVehicleScreen(),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text("Book"),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "No Bookings Found",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Schedule a service for your vehicle\neasily from here.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
