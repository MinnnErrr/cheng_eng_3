import 'package:cheng_eng_3/core/controllers/booking/booking_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/booking/staff_booking_notifier.dart';
import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/ui/extensions/booking_extension.dart';
import 'package:cheng_eng_3/ui/widgets/booking_details.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listitem.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StaffBookingDetailsScreen extends ConsumerStatefulWidget {
  const StaffBookingDetailsScreen({super.key, required this.booking});

  final Booking booking;

  @override
  ConsumerState<StaffBookingDetailsScreen> createState() =>
      _StaffBookingDetailsScreenState();
}

class _StaffBookingDetailsScreenState
    extends ConsumerState<StaffBookingDetailsScreen> {
  BookingStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    // Watch for live updates
    final bookingAsync = ref.watch(bookingByIdProvider(widget.booking.id));
    final currentBooking = bookingAsync.value ?? widget.booking;
    final notifier = ref.read(staffBookingProvider.notifier);

    // Status Logic
    final bool isCancelled = currentBooking.status == BookingStatus.cancelled;
    final bool isCompleted = currentBooking.status == BookingStatus.completed;
    final bool canUpdate = !isCancelled && !isCompleted;

    // Check for changes
    final bool isChanged =
        _selectedStatus != null && _selectedStatus != currentBooking.status;

    final theme = Theme.of(context);
    final dateFormatter = DateFormat('EEEE, dd MMM yyyy');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: Column(
        children: [
          // --- 1. FIXED STATUS ACTION BAR ---
          if (canUpdate)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ),
              child: Row(
                children: [
                  // A. STATUS SELECTOR BOX
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: theme.colorScheme.onSurface,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownMenu<BookingStatus>(
                              width: double.infinity,
                              initialSelection: currentBooking.status,
                              dropdownMenuEntries: BookingStatus.values.map((
                                e,
                              ) {
                                return DropdownMenuEntry(
                                  value: e,
                                  label: e.label,
                                  leadingIcon: Icon(
                                    Icons.circle,
                                    color: e.color,
                                    size: 10,
                                  ),
                                );
                              }).toList(),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              inputDecorationTheme: const InputDecorationTheme(
                                isDense: true,
                                filled: false,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                constraints: BoxConstraints(maxHeight: 48),
                              ),
                              onSelected: (value) =>
                                  setState(() => _selectedStatus = value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // B. CONFIRM BUTTON
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      disabledBackgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      disabledForegroundColor: theme
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fixedSize: const Size(50, 50),
                    ),
                    onPressed: isChanged
                        ? () => _updateStatus(
                            context,
                            notifier,
                            currentBooking.id,
                          )
                        : null,
                    icon: const Icon(Icons.check, size: 24),
                    tooltip: "Confirm Update",
                  ),
                ],
              ),
            ),

          // --- 2. SCROLLABLE DETAILS ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- HERO STATUS CARD (Without Vehicle Image) ---
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
                            // Use status color for text to make it pop
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
                        // Date & Time
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

                  // --- VEHICLE INFO (Using Reusable Widget) ---
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

                  // --- BOOKING DETAILS (Services, Remarks, etc.) ---
                  Text(
                    'Service Details',
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  BookingDetailsWidget(booking: currentBooking),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    StaffBookingNotifier notifier,
    String id,
  ) async {
    final message = await notifier.updateStatus(
      id: id,
      status: _selectedStatus!.name,
      message: null,
    );

    if (!context.mounted) return;

    showAppSnackBar(
      context: context,
      content: message.message,
      isError: !message.isSuccess,
    );

    if (message.isSuccess) {
      setState(() => _selectedStatus = null);
    }
  }
}
