import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_by_vehicle_provider.dart';
import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/screens/customer/cart/cart_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_create_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_details_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/vehicle/vehicle_update_screen.dart';
import 'package:cheng_eng_3/ui/widgets/cart_icon.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:cheng_eng_3/ui/widgets/maintenance_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleDetailsScreen extends ConsumerWidget {
  const VehicleDetailsScreen({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Optimistic UI Logic
    final vehicleAsync = ref.watch(customerVehicleByIdProvider(vehicle.id));
    final displayVehicle = vehicleAsync.value ?? vehicle;

    final imageService = ref.read(imageServiceProvider);
    final screenSize = MediaQuery.of(context).size;
    final maintenanceListAsync = ref.watch(
      maintenanceByVehicleProvider(vehicle.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ),
            child: cartIcon(ref, context),
          ),
        ],
      ),
      // 1. CHANGE: Use SingleChildScrollView to make the whole page scroll
      body: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works if added later
        child: Column(
          children: [
            // --- VEHICLE DETAILS ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: _vehicleDetails(
                vehicle: displayVehicle,
                context: context,
                imageService: imageService,
                screenSize: screenSize,
              ),
            ),

            // --- HEADER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  Text(
                    'Maintenance Records',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MaintenanceCreateScreen(vehicleId: vehicle.id),
                      ),
                    ),
                    label: const Text('Add'),
                    icon: const Icon(Icons.add, size: 18),
                    style: ElevatedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),

            // --- MAINTENANCE LIST ---
            // 2. CHANGE: Removed Expanded.
            maintenanceListAsync.when(
              data: (list) {
                if (list.maintenances.isEmpty) {
                  return Container(
                    height: 200, // Give some height to the empty state
                    alignment: Alignment.center,
                    child: const Text("No maintenance records found"),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  // 3. CRITICAL CHANGE: Disable internal scrolling
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.maintenances.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final maintenance = list.maintenances[index];
                    return MaintenanceListItem(
                      maintenance: maintenance,
                      tapAction: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MaintenanceDetailsScreen(
                            maintenance: maintenance,
                          ),
                        ),
                      ),
                      icon: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () =>
                            _confirmDelete(context, ref, maintenance.id),
                      ),
                    );
                  },
                );
              },
              loading: () => const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => SizedBox(
                height: 100,
                child: Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... (Keep _confirmDelete and _vehicleDetails exactly the same as before) ...
  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String maintenanceId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Record"),
        content: const Text("Are you sure? This cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final notifier = ref.read(maintenanceProvider.notifier);
      final success = await notifier.deleteMaintenance(maintenanceId);

      if (context.mounted) {
        showAppSnackBar(
          context: context,
          content: success ? 'Record deleted' : 'Failed to delete',
          isError: !success,
        );
      }
    }
  }

  Widget _vehicleDetails({
    required Vehicle vehicle,
    required BuildContext context,
    required ImageService imageService,
    required Size screenSize,
  }) {
    Widget detailRow(String title, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(child: Text(value, textAlign: TextAlign.end)),
        ],
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    vehicle.description ?? 'Vehicle Details',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VehicleUpdateScreen(vehicle: vehicle),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          Column(
            children: [
              imageBuilder(
                url: vehicle.photoPath != null
                    ? imageService.retrieveImageUrl(vehicle.photoPath!)
                    : null,
                containerWidth: double.infinity,
                containerHeight: screenSize.height * 0.25,
                noImageContent: Container(
                  height: screenSize.height * 0.25,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.directions_car, size: 40, color: Colors.grey),
                      Text('No image', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                context: context,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 12,
                  children: [
                    detailRow('Registration', vehicle.regNum),
                    detailRow('Make', vehicle.make),
                    detailRow('Model', vehicle.model),
                    detailRow('Year', vehicle.year.toString()),
                    detailRow('Colour', vehicle.colour),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
