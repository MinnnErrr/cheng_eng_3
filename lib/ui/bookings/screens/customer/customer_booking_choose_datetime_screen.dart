import 'package:cheng_eng_3/data/providers/booking/booking_by_date_provider.dart';
import 'package:cheng_eng_3/ui/bookings/notifiers/booking_state_notifier.dart';
import 'package:cheng_eng_3/ui/bookings/screens/customer/customer_booking_submit_screen.dart';
import 'package:cheng_eng_3/utils/datepicker.dart';
import 'package:cheng_eng_3/utils/booking_time_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomerBookingChooseDatetimeScreen extends ConsumerStatefulWidget {
  const CustomerBookingChooseDatetimeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerBookingChooseDatetimeScreenState();
}

class _CustomerBookingChooseDatetimeScreenState
    extends ConsumerState<CustomerBookingChooseDatetimeScreen> {
  final _dateFormatter = DateFormat(
    'dd MMM yyyy, EEEE',
  );
  final slots = generateTimeSlots();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    final currentBooking = ref.read(bookingStateProvider);
    if (currentBooking.date != null) {
      _selectedDate = currentBooking.date;
    }
    if (currentBooking.time != null) {
      _selectedTime = currentBooking.time;
    }
  }

  Future<void> _pickDate() async {
    final date = await datePicker(
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      context,
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final availabilityAsync = _selectedDate == null
        ? const AsyncValue.data({})
        : ref.watch(bookingPerSlotProvider(_selectedDate!));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Select Date & Time'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- DATE SELECTION ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate == null
                                ? "Select a date"
                                : _dateFormatter.format(_selectedDate!),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _selectedDate == null
                                  ? theme.colorScheme.onSurfaceVariant
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_drop_down,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- TIME SLOT GRID ---
            Expanded(
              child: _selectedDate == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 48,
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Please select a date to view slots",
                            style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : availabilityAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                      data: (slotCounts) {
                        return ListView(
                          padding: const EdgeInsets.all(20),
                          children: [
                            Text(
                              "Available Slots",
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: slots.map((time) {
                                final isSelected = _selectedTime == time;
                                final currentBookings = slotCounts[time] ?? 0;
                                final isFull = currentBookings >= 5;

                                return InkWell(
                                  onTap: isFull
                                      ? null
                                      : () => setState(
                                          () => _selectedTime = time,
                                        ),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width:
                                        (MediaQuery.of(context).size.width -
                                            64) /
                                        3,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isFull
                                          ? theme
                                                .colorScheme
                                                .surfaceContainerHigh
                                          : isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.surfaceContainer,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.outlineVariant,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isFull
                                                ? theme
                                                      .colorScheme
                                                      .onSurfaceVariant
                                                : isSelected
                                                ? theme.colorScheme.onPrimary
                                                : theme.colorScheme.onSurface,
                                          ),
                                        ),
                                        if (isFull)
                                          Text(
                                            "FULL",
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: theme.colorScheme.error,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // --- BOTTOM BAR ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: FilledButton(
            onPressed: (_selectedDate == null || _selectedTime == null)
                ? null
                : () {
                    ref
                        .read(bookingStateProvider.notifier)
                        .selectDate(_selectedDate!);
                    ref
                        .read(bookingStateProvider.notifier)
                        .selectTime(_selectedTime!);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CustomerBookingSubmitScreen(),
                      ),
                    );
                  },

            child: const Text(
              "REVIEW BOOKING",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
