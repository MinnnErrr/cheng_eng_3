import 'package:cheng_eng_3/core/controllers/booking/booking_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/booking/customer_booking_notifier.dart';
import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/ui/extensions/booking_extension.dart';
import 'package:cheng_eng_3/ui/widgets/booking_details.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomerBookingDetailsScreen extends ConsumerStatefulWidget {
  const CustomerBookingDetailsScreen({super.key, required this.booking});

  final Booking booking;

  @override
  ConsumerState<CustomerBookingDetailsScreen> createState() =>
      _CustomerBookingDetailsScreenState();
}

class _CustomerBookingDetailsScreenState
    extends ConsumerState<CustomerBookingDetailsScreen> {
  bool _isCancelling = false;

  @override
  Widget build(BuildContext context) {
    final bookingAsync = ref.watch(bookingByIdProvider(widget.booking.id));
    final currentBooking = bookingAsync.value ?? widget.booking;

    final theme = Theme.of(context);
    final dateFormatter = DateFormat('EEEE, dd MMM yyyy');

    final bool canCancel =
        currentBooking.status == BookingStatus.pending ||
        currentBooking.status == BookingStatus.accepted;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Booking Details'),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- HERO STATUS CARD ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: currentBooking.status.color.withValues(
                  alpha: 0.05,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: currentBooking.status.color.withValues(
                    alpha: 0.5,
                  ),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'CURRENT STATUS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: currentBooking.status.color,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentBooking.status.label.toUpperCase(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: currentBooking.status.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${dateFormatter.format(currentBooking.date)} | ${currentBooking.time.format(context)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 2. VEHICLE INFO ---
            Text(
              'Vehicle Information',
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            VehicleListitem(
              make: currentBooking.vehicleMake,
              model: currentBooking.vehicleModel,
              regNum: currentBooking.vehicleRegNum,
              colour: currentBooking.vehicleColour,
              year: currentBooking.vehicleYear,
            ),

            const SizedBox(height: 30),

            // --- 3. SERVICE DETAILS ---
            Text(
              'Service Details',
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            BookingDetailsWidget(booking: currentBooking),

            const SizedBox(height: 40),

            // --- 4. CANCEL BUTTON ---
            if (canCancel)
              SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isCancelling
                      ? null
                      : () => _confirmCancel(
                          context,
                          ref,
                          currentBooking.id,
                          currentBooking.userId,
                        ),
                  icon: _isCancelling
                      ? const SizedBox.shrink()
                      : const Icon(Icons.cancel_outlined),
                  label: _isCancelling
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.error,
                          ),
                        )
                      : const Text("CANCEL BOOKING"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(
    BuildContext context,
    WidgetRef ref,
    String bookingId,
    String userId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Booking?"),
        content: const Text(
          "Are you sure you want to cancel this booking?\nThis action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Back"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text("Confirm Cancel"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isCancelling = true);

      final notifier = ref.read(customerBookingProvider(userId).notifier);
      final message = await notifier.cancelBooking(id: bookingId);

      if (context.mounted) {
        setState(() => _isCancelling = false);

        showAppSnackBar(
          context: context,
          content: message.message,
          isError: !message.isSuccess,
        );

        if (message.isSuccess) {
          Navigator.pop(context);
        }
      }
    }
  }
}
