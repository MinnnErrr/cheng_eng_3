import 'package:cheng_eng_3/core/controllers/booking/booking_state_notifier.dart';
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_choose_service_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/vehicle/vehicle_create_screen.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listitem.dart';
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
    final theme = Theme.of(context);
    final vehiclesAsync = ref.watch(customerVehicleProvider);
    final currentBooking = ref.watch(bookingStateProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Select Vehicle'),
      ),
      body: vehiclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              TextButton(
                onPressed: () => ref.refresh(customerVehicleProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
        data: (list) {
          if (list.vehicles.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: list.vehicles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final v = list.vehicles[index];
              final isSelected = currentBooking.vehicle?.id == v.id;

              return InkWell(
                onTap: () {
                  ref.read(bookingStateProvider.notifier).selectVehicle(v);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CustomerBookingChooseServiceScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
                        : theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // List Item
                      VehicleListitem(
                        make: v.make,
                        model: v.model,
                        regNum: v.regNum,
                        photoPath: v.photoPath,
                        description: v.description,
                      ),

                      // Selection Checkmark
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.check,
                              size: 16,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VehicleCreateScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("New Vehicle"),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_car_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No vehicles found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Add a vehicle to proceed with booking",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
