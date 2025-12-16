import 'package:cheng_eng_3/core/controllers/booking/booking_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/booking/customer_booking_notifier.dart';
import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/ui/widgets/booking_details.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerBookingDetailsScreen extends ConsumerStatefulWidget {
  const CustomerBookingDetailsScreen({super.key, required this.booking});

  final Booking booking;

  @override
  ConsumerState<CustomerBookingDetailsScreen> createState() =>
      _CustomerBookingDetailsScreenState(); // FIX: Corrected Name
}

class _CustomerBookingDetailsScreenState
    extends ConsumerState<CustomerBookingDetailsScreen> {
  bool _isCancelling = false;

  @override
  Widget build(BuildContext context) {
    // 1. Live Data Pattern
    // Listen to the specific booking ID.
    // If the backend updates (e.g., status changes to 'Cancelled'),
    // this screen updates automatically.
    final bookingAsync = ref.watch(bookingByIdProvider(widget.booking.id));

    // Fallback to the passed 'widget.booking' while loading or if stream is initializing
    final currentBooking = bookingAsync.value ?? widget.booking;

    final bookingNotifier = ref.read(
      customerBookingProvider(currentBooking.userId).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ), // FIX: Corrected Title
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 2. Styled Staff Message
              if (currentBooking.staffMessage != null &&
                  currentBooking.staffMessage!.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50, // Gentle info color
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Staff Message',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentBooking.staffMessage!,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // 3. Booking Details Widget (from previous step)
              BookingDetailsWidget(booking: currentBooking),

              const SizedBox(height: 30),

              // 4. Cancel Button
              // Only show if status allows cancellation
              if (currentBooking.status == BookingStatus.pending ||
                  currentBooking.status == BookingStatus.accepted)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.red.shade200),
                      ),
                    ),
                    onPressed: _isCancelling
                        ? null
                        : () {
                            _confirmCancel(
                              context,
                              bookingNotifier,
                              currentBooking.id,
                            );
                          },
                    child: _isCancelling
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                        : const Text('Cancel Booking'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    CustomerBookingNotifier notifier,
    String bookingId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Booking"),
        content: const Text(
          "Are you sure you want to cancel this booking? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Keep Booking"), // Better UX text
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isCancelling = true);

      // Call Notifier
      final message = await notifier.cancelBooking(id: bookingId);

      if (context.mounted) {
        setState(() => _isCancelling = false);

        showAppSnackBar(
          context: context,
          content: message.message,
          isError: !message.isSuccess,
        );

        // Optional: If you want to close the screen on success
        // if (message.isSuccess) Navigator.pop(context);
      }
    }
  }
}
