import 'package:cheng_eng_3/ui/auth/notifiers/auth_notifier.dart';
import 'package:cheng_eng_3/ui/bookings/notifiers/booking_state_notifier.dart';
import 'package:cheng_eng_3/ui/bookings/notifiers/customer_booking_notifier.dart';
import 'package:cheng_eng_3/ui/bookings/extensions/booking_extension.dart';
import 'package:cheng_eng_3/ui/bookings/screens/customer/customer_booking_screen.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:cheng_eng_3/ui/core/widgets/custom_text_field.dart';
import 'package:cheng_eng_3/ui/vehicles/widgets/vehicle_listitem.dart';
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
  bool _isLoading = false; // 1. Added Loading State

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookingState = ref.watch(bookingStateProvider);
    final dateFormatter = DateFormat('dd MMM yyyy'); 

    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    final servicesList = bookingState.services ?? [];
    final servicesString = servicesList.isEmpty
        ? 'None'
        : servicesList.map((s) => s.serviceName).join(', ');

    final vehicle = bookingState.vehicle;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Review Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- VEHICLE ---
            _SectionHeader(title: "Vehicle"),
            const SizedBox(height: 12),
            vehicle != null
                ? VehicleListitem(
                    model: vehicle.model,
                    make: vehicle.make,
                    regNum: vehicle.regNum,
                    colour: vehicle.colour,
                    year: vehicle.year,
                    photoPath: vehicle.photoPath,
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: theme.colorScheme.error),
                          const SizedBox(width: 10),
                          Text(
                            'No vehicle selected',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ),

            const SizedBox(height: 30),

            // --- BOOKING INFO ---
            _SectionHeader(title: "Appointment Details"),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    context,
                    "Date",
                    bookingState.date != null
                        ? dateFormatter.format(bookingState.date!)
                        : "-",
                    icon: Icons.calendar_today,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  _buildSummaryRow(
                    context,
                    "Time",
                    bookingState.time != null
                        ? bookingState.time!.format(context)
                        : "-",
                    icon: Icons.access_time,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  _buildSummaryRow(
                    context,
                    "Services",
                    servicesString,
                    icon: Icons.build_circle_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- REMARKS ---
            _SectionHeader(title: "Additional Notes"),
            const SizedBox(height: 12),
            Customtextfield(
              controller: _remarksCtrl,
              label: 'Remarks (Optional)',
              hint: "Any specific issues or requests...",
              minLines: 3,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              isRequired: false,
            ),

            const SizedBox(height: 40),

            // --- SUBMIT BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: _isLoading ? null : () => _submitBooking(user.id),

                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black, 
                        ),
                      )
                    : const Text(
                        "CONFIRM BOOKING",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _submitBooking(String userId) async {
    final bookingState = ref.read(bookingStateProvider);

    if (bookingState.vehicle == null ||
        bookingState.services == null ||
        bookingState.services!.isEmpty ||
        bookingState.date == null ||
        bookingState.time == null) {
      showAppSnackBar(
        context: context,
        content: 'Missing details. Please restart booking.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    final notifier = ref.read(customerBookingProvider(userId).notifier);

    final message = await notifier.addBooking(
      services: bookingState.services!,
      date: bookingState.date!,
      time: bookingState.time!,
      remarks: _remarksCtrl.text.trim().isNotEmpty
          ? _remarksCtrl.text.trim()
          : null,
      vehicle: bookingState.vehicle!,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    showAppSnackBar(
      context: context,
      content: message.message,
      isError: !message.isSuccess,
    );

    if (message.isSuccess) {
      ref.read(bookingStateProvider.notifier).reset();

      Navigator.of(context).popUntil((route) => route.isFirst);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const CustomerBookingScreen(),
        ),
      );
    }
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
