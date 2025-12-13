import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/ui/extensions/product_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerBookingChooseServiceScreen extends ConsumerStatefulWidget {
  const CustomerBookingChooseServiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerBookingChooseServiceScreenState();
}

class _CustomerBookingChooseServiceScreenState
    extends ConsumerState<CustomerBookingChooseServiceScreen> {
  BookingServiceType? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Service'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: BookingServiceType.values.map((type) {
              final isSelected = _selected == type;

              return InkWell(
                onTap: () {
                  setState(() => _selected = type);
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
  type.picture,
  width: 80,
  height: 80,
  fit: BoxFit.contain,
),
                      SizedBox(height: 10),
                      Text(
                        type.name,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: _selected == null
              ? null
              : () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ,
                  ),
                ),
          child: Text("Next"),
        ),
      ),
    );
  }
}
