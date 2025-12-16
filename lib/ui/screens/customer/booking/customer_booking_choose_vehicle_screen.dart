import 'package:cheng_eng_3/core/controllers/booking/booking_state_notifier.dart';
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_choose_service_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/vehicle/vehicle_create_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    // 1. Watch the list of vehicles
    final vehiclesAsync = ref.watch(customerVehicleProvider);

    // 2. Watch current booking state to highlight selection (State Restoration)
    final currentBooking = ref.watch(bookingStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Vehicle'),
      ),
      // 3. Body handles the states, AppBar stays stable
      body: vehiclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (list) {
          // 4. Handle Empty State
          if (list.vehicles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_car_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text("No vehicles found."),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleCreateScreen(),
                        ),
                      );
                    },
                    child: const Text("Add a Vehicle"),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: list.vehicles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final v = list.vehicles[index];

                // 5. Visual Feedback for Selection
                final isSelected =
                    currentBooking.vehicle?.id ==
                    v.id; // Assuming Vehicle object has 'id'

                return InkWell(
                  onTap: () {
                    // Update Provider
                    ref.read(bookingStateProvider.notifier).selectVehicle(v);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CustomerBookingChooseServiceScreen(),
                      ),
                    );
                  },
                  child: Container(
                    // Wrap item in a container to show border if selected
                    decoration: isSelected
                        ? BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // Match list item radius
                          )
                        : null,
                    child: VehicleListitem(
                      vehicle: v,
                      descriptionRequired: false,
                      colourRequired: false,
                      yearRequired: false,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
