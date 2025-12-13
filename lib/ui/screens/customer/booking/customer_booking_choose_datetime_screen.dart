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

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final _dateFormatter = DateFormat('dd/MM/yyyy');

  final slots = generateTimeSlots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a Date and Time'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
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
                        _dateCtrl.text = _dateFormatter.format(
                          date,
                        );
                      });
                    }
                  },
                  icon: Icon(Icons.calendar_month),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text('Choose a time slot'),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: slots.map((time) {
                    final isSelected = _selectedTime == time;

                    return InkWell(
                      onTap: () {
                        setState(() => _selectedTime = time);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: !isSelected
                              ? BorderRadius.circular(10)
                              : null,
                          border: !isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : null,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NextScreen(),
                    ),
                  );
                },
          child: Text("Next"),
        ),
      ),
    );
  }
}
