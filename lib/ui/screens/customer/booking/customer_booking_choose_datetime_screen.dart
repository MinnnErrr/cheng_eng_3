import 'package:cheng_eng_3/core/controllers/booking/booking_by_date_provider.dart';
import 'package:cheng_eng_3/core/controllers/booking/booking_state_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_submit_screen.dart';
import 'package:cheng_eng_3/ui/widgets/datepicker.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
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
  final _dateCtrl = TextEditingController();
  final _dateFormatter = DateFormat('dd/MM/yyyy');
  final slots = generateTimeSlots();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // FIX 1: RESTORE STATE
    // Check if we already have data in the provider (e.g. user pressed Back)
    final currentBooking = ref.read(bookingStateProvider);
    if (currentBooking.date != null) {
      _selectedDate = currentBooking.date;
      _dateCtrl.text = _dateFormatter.format(_selectedDate!);
    }
    if (currentBooking.time != null) {
      _selectedTime = currentBooking.time;
      // Assuming timeSlot is stored as "HH:mm" String in provider, parse it back
      // If you stored it as TimeOfDay, just assign it directly.
      // _selectedTime = ...
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX 2: FETCH AVAILABILITY
    // Only fetch if a date is selected
    final availabilityAsync = _selectedDate == null
        ? const AsyncValue.data({}) // Empty map if no date
        : ref.watch(bookingPerSlotProvider(_selectedDate!));

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Date and Time')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- DATE PICKER ---
              textFormField(
                validationRequired: false,
                controller: _dateCtrl,
                label: 'Date',
                readOnly: true,
                suffix: IconButton(
                  onPressed: () async {
                    final date = await datePicker(DateTime.now(), context);
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                        _selectedTime = null; // Reset time if date changes
                        _dateCtrl.text = _dateFormatter.format(date);
                      });
                    }
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                'Choose a time slot',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // --- TIME SLOT GRID ---
              Expanded(
                child: _selectedDate == null
                    ? const Center(child: Text("Please select a date first"))
                    : availabilityAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            Center(child: Text('Error: $err')),
                        data: (slotCounts) {
                          return GridView.builder(
                            // Builder is more efficient
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      3, // FIX 3: 3 Columns looks better
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio:
                                      2.0, // Make them wider rectangles
                                ),
                            itemCount: slots.length,
                            itemBuilder: (context, index) {
                              final time = slots[index];
                              final isSelected = _selectedTime == time;

                              // LOGIC: Check if fully booked
                              // Change '>= 1' to whatever your max capacity is per slot
                              final currentBookings = slotCounts[time] ?? 0;
                              final isFull = currentBookings >= 5;

                              return InkWell(
                                onTap: isFull
                                    ? null // Disable tap if full
                                    : () =>
                                          setState(() => _selectedTime = time),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: isFull
                                        ? Colors
                                              .grey
                                              .shade300 // Grey out if full
                                        : (isSelected
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : Colors.white),
                                    border: Border.all(
                                      color: isFull
                                          ? Colors.transparent
                                          : Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isFull
                                            ? Colors.grey.shade500
                                            : (isSelected
                                                  ? Colors.white
                                                  : Theme.of(
                                                      context,
                                                    ).colorScheme.primary),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: (_selectedDate == null || _selectedTime == null)
              ? null
              : () {
                  // Save to Riverpod
                  ref
                      .read(bookingStateProvider.notifier)
                      .selectDate(
                        _selectedDate!,
                      ); // Assuming you updated your notifier signature

                  ref
                      .read(bookingStateProvider.notifier)
                      .selectTime(_selectedTime!);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerBookingSubmitScreen(),
                    ),
                  );
                },
          child: const Text("Next"),
        ),
      ),
    );
  }
}
