import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_choose_service_screen.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerBookingChooseVehicleScreen extends ConsumerStatefulWidget {
  const CustomerBookingChooseVehicleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerBookingChooseVehicleScreenState();
}

class _CustomerBookingChooseVehicleScreenState
    extends ConsumerState<CustomerBookingChooseVehicleScreen> {
  Vehicle? _selected;
  @override
  Widget build(BuildContext context) {
    final vehicles = ref.watch(customerVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Vehicle'),
      ),
      body: vehicles.when(
        data: (list) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final v = list.vehicles[index];
                  final isSelected = _selected?.id == v.id;

                  return InkWell(
                    onTap: () => setState(() {
                      _selected = v;
                    }),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: VehicleListitem(
                        vehicle: v,
                        descriptionRequired: false,
                        colourRequired: false,
                        yearRequired: false,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemCount: list.vehicles.length,
              ),
            ),
          );
        },
        error: (error, stackTrace) => Scaffold(
          body: Center(
            child: Text(error.toString()),
          ),
        ),
        loading: () => Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(20),
        child: Expanded(
          child: ElevatedButton(
            onPressed: () => _selected == null
                ? null
                : Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CustomerBookingChooseServiceScreen(),
                    ),
                  ),
            child: Text('Next'),
          ),
        ),
      ),
    );
  }
}
