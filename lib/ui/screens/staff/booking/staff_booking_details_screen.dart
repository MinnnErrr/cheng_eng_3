import 'package:cheng_eng_3/core/controllers/booking/booking_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/booking/staff_booking_notifier.dart';
import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/ui/extensions/booking_extension.dart';
import 'package:cheng_eng_3/ui/widgets/booking_details.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffBookingDetailsScreen extends ConsumerWidget {
  const StaffBookingDetailsScreen({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the booking ID for live updates
    final bookingAsync = ref.watch(bookingByIdProvider(booking.id));
    final currentBooking = bookingAsync.value ?? booking;
    final isCancelled = currentBooking.status == BookingStatus.cancelled;

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),

      // 1. Clean Body (Just the details)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            BookingDetailsWidget(booking: currentBooking),
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),

      // 2. Floating Action Button to trigger the update
      floatingActionButton: isCancelled
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                _showUpdateSheet(context, ref, currentBooking);
              },
              icon: const Icon(Icons.edit_note),
              label: const Text("Update Status"),
            ),
    );
  }

  // 3. The Bottom Sheet Logic
  void _showUpdateSheet(BuildContext context, WidgetRef ref, Booking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // IMPORTANT: Allows sheet to grow with keyboard
      useSafeArea: true,
      builder: (context) => _UpdateStatusSheet(booking: booking),
    );
  }
}

// 4. The Form Widget (Separate for cleanliness)
class _UpdateStatusSheet extends ConsumerStatefulWidget {
  const _UpdateStatusSheet({required this.booking});
  final Booking booking;

  @override
  ConsumerState<_UpdateStatusSheet> createState() => _UpdateStatusSheetState();
}

class _UpdateStatusSheetState extends ConsumerState<_UpdateStatusSheet> {
  late BookingStatus _selectedStatus;
  final _messageCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.booking.status; // Init with current status
  }

  @override
  void dispose() {
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This padding ensures the sheet moves up when keyboard opens
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, keyboardPadding + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content height
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Update Status",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- Status Dropdown ---
          DropdownMenu<BookingStatus>(
            width: double.infinity, // Full width
            label: const Text('New Status'),
            initialSelection: _selectedStatus,
            dropdownMenuEntries: BookingStatus.values
                .map(
                  (e) => DropdownMenuEntry(value: e, label: e.label),
                )
                .toList(),
            onSelected: (value) {
              if (value != null) setState(() => _selectedStatus = value);
            },
          ),

          const SizedBox(height: 20),

          // --- Message Field ---
          TextField(
            controller: _messageCtrl,
            decoration: const InputDecoration(
              labelText: 'Message to Customer',
              hintText: 'e.g. "We are not available"',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),

          const SizedBox(height: 20),

          // --- Update Button ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      // Logic to update
                      setState(() => _isLoading = true);

                      final notifier = ref.read(staffBookingProvider.notifier);
                      final message = await notifier.updateStatus(
                        id: widget.booking.id,
                        status: _selectedStatus.name,
                        message: _messageCtrl.text.trim().isNotEmpty
                            ? _messageCtrl.text.trim()
                            : null,
                      );

                      if (!context.mounted) return;
                      setState(() => _isLoading = false);

                      showAppSnackBar(
                        context: context,
                        content: message.message,
                        isError: !message.isSuccess,
                      );

                      // Close sheet on success
                      if (message.isSuccess) {
                        Navigator.pop(context);
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text("Confirm Update"),
            ),
          ),
        ],
      ),
    );
  }
}
