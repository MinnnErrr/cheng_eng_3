import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/booking/booking_state_notifier.dart';
import 'package:cheng_eng_3/core/controllers/booking/customer_booking_notifier.dart';
import 'package:cheng_eng_3/ui/extensions/booking_extension.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomerBookingSubmitScreen extends ConsumerStatefulWidget {
  const CustomerBookingSubmitScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerBookingSubmitScreenState();
}

class _CustomerBookingSubmitScreenState
    extends ConsumerState<CustomerBookingSubmitScreen> {
  final _remarksCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final dateFormatter = DateFormat('dd/MM/yyyy');

    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    // 1. PREPARE SERVICE LIST STRING
    final servicesList = bookingState.services ?? [];
    final servicesString = servicesList.isEmpty
        ? 'None'
        : servicesList.map((s) => s.serviceName).join(', ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECTION 1: VEHICLE ---
            Text(
              'Vehicle Details',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            bookingState.vehicle != null
                ? VehicleListitem(
                    vehicle: bookingState.vehicle!,
                    descriptionRequired: false,
                    colourRequired: true,
                    yearRequired: true,
                  )
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'No vehicle selected',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),

            const SizedBox(height: 30),

            // --- SECTION 2: BOOKING INFO ---
            Text(
              'Booking Details',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  // FIX 2: Pass the generated string here
                  _buildSummaryRow(
                    'Services',
                    servicesString,
                  ),
                  const Divider(),
                  _buildSummaryRow(
                    'Date',
                    bookingState.date != null
                        ? dateFormatter.format(bookingState.date!)
                        : 'None',
                  ),
                  const Divider(),
                  _buildSummaryRow(
                    'Time',
                    bookingState.time != null
                        ? bookingState.time!.format(context)
                        : 'None',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- SECTION 3: REMARKS ---
            textFormField(
              controller: _remarksCtrl,
              label: 'Remarks (Optional)',
              minLines: 3,
              maxLines: null,
              validationRequired: false,
            ),

            const SizedBox(height: 30),

            // --- SUBMIT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  // Guard Clause
                  if (bookingState.vehicle == null ||
                      bookingState.services == null ||
                      bookingState.services!.isEmpty ||
                      bookingState.date == null ||
                      bookingState.time == null) {
                    showAppSnackBar(
                      context: context,
                      content: 'Please complete all booking details.',
                      isError: true,
                    );
                    return;
                  }

                  final notifier = ref.read(
                    customerBookingProvider(user.id).notifier,
                  );

                  final message = await notifier.addBooking(
                    services: bookingState.services!,
                    date: bookingState.date!,
                    time: bookingState.time!,
                    remarks: _remarksCtrl.text.trim().isNotEmpty
                        ? _remarksCtrl.text.trim()
                        : null,
                    vehicle: bookingState.vehicle!,
                  );

                  if (!context.mounted) return;

                  showAppSnackBar(
                    context: context,
                    content: message.message,
                    isError: !message.isSuccess,
                  );

                  if (message.isSuccess) {
                    ref.read(bookingStateProvider.notifier).reset();

                    // 1. Clear the history stack down to the Home Screen
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    // 2. Open the Booking Screen on top of Home
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CustomerBookingScreen(),
                      ),
                    );
                  }
                },
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIX 3: Updated Helper Widget to handle Long Text (Wrapping)
  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(width: 15), // Spacing between label and value
          Expanded(
            // Allows text to wrap if list is long
            child: Text(
              value,
              textAlign: TextAlign.end, // Align value to the right
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
