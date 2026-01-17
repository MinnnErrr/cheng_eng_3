import 'package:cheng_eng_3/ui/vehicles/notifiers/customer_vehicle_notifier.dart';
import 'package:cheng_eng_3/ui/vehicles/screens/vehicle_create_screen.dart';
import 'package:cheng_eng_3/ui/vehicles/screens/vehicle_details_screen.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:cheng_eng_3/ui/vehicles/widgets/vehicle_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleScreen extends ConsumerWidget {
  const VehicleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleListState = ref.watch(customerVehicleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
      ),
      body: vehicleListState.when(
        data: (vehicleList) {
          final vehicles = vehicleList.vehicles;

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(customerVehicleProvider.future),
            child: vehicles.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const Center(child: Text('No vehicles found')),
                    ],
                  )
                : SafeArea(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: vehicles.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final vehicle = vehicles[index];

                        return VehicleListitem(
                          make: vehicle.make,
                          model: vehicle.model,
                          regNum: vehicle.regNum,
                          description: vehicle.description,
                          photoPath: vehicle.photoPath,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  VehicleDetailsScreen(vehicle: vehicle),
                            ),
                          ),
                          icon: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              _confirmDelete(context, ref, vehicle.id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
          );
        },
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.red),
              const SizedBox(height: 10),
              const Text('Error loading vehicles'),
              TextButton(
                onPressed: () => ref.refresh(customerVehicleProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const VehicleCreateScreen(),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String vehicleId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Vehicle"),
        content: const Text(
          "Are you sure you want to delete this vehicle? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final notifier = ref.read(customerVehicleProvider.notifier);
      final success = await notifier.deleteVehicle(vehicleId);

      if (context.mounted) {
        showAppSnackBar(
          context: context,
          content: success ? 'Vehicle deleted' : 'Failed to delete vehicle',
          isError: !success,
        );
      }
    }
  }
}
