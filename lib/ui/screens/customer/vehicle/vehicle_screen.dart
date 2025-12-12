import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/vehicle/vehicle_details_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/vehicle/vehicle_update_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleScreen extends ConsumerWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleListState = ref.watch(customerVehicleProvider);
    final vehicleListNotifier = ref.read(customerVehicleProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Vehicles'),
      ),
      body: vehicleListState.when(
        data: (vehicleList) {
          final vehicles = vehicleList.vehicles;

         return vehicles.isEmpty
              ? const Center(
                  child: Text('No vehicles found'),
                )
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: vehicles.length,
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: VehicleListitem(
                            vehicle: vehicle,
                            descriptionRequired: true,
                            colourRequired: false,
                            yearRequired: false,
                            icon: IconButton(
                              onPressed: () async {
                                final success = await vehicleListNotifier
                                    .deleteVehicle(
                                      vehicle.id,
                                    );
                                if (!context.mounted) return;
                                showAppSnackBar(
                                  context: context,
                                  content: success
                                      ? 'Vehicle deleted'
                                      : 'Failed to delete vehicle',
                                );
                              },
                              icon: Icon(Icons.delete),
                            ),
                            tapAction: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VehicleDetailsScreen(
                                  vehicleId: vehicle.id,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VehicleUpdateScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
