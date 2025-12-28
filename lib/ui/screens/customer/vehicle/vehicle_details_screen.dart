import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_create_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/vehicle/vehicle_update_screen.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleDetailsScreen extends ConsumerWidget {
  const VehicleDetailsScreen({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(customerVehicleByIdProvider(vehicle.id));
    final displayVehicle = vehicleAsync.value ?? vehicle;

    final imageService = ref.read(imageServiceProvider);
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => VehicleUpdateScreen(vehicle: displayVehicle),
              ),
            ),
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Vehicle',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- VEHICLE CARD ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: _vehicleDetailsCard(
                vehicle: displayVehicle,
                context: context,
                imageService: imageService,
                screenSize: screenSize,
              ),
            ),

            // --- MAINTENANCE HEADER ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: Row(
                children: [
                  // ✅ FIX 1: Wrap Text in Expanded to stabilize constraints
                  Expanded(
                    child: Text(
                      'Maintenance Records',
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            MaintenanceCreateScreen(vehicleId: vehicle.id),
                      ),
                    ),
                    label: const Text('Add Record'),
                    icon: const Icon(Icons.add, size: 18),
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      // Removed visualDensity to prevent "hasSize" errors
                    ),
                  ),
                ],
              ),
            ),

            // --- LIST ---
            MaintenanceScreen(vehicleId: vehicle.id),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _vehicleDetailsCard({
    required Vehicle vehicle,
    required BuildContext context,
    required ImageService imageService,
    required Size screenSize,
  }) {
    final theme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageBuilder(
              url: vehicle.photoPath != null
                  ? imageService.retrieveImageUrl(vehicle.photoPath!)
                  : null,
              containerWidth: double.infinity,
              containerHeight: screenSize.height * 0.25,
              context: context,
              noImageContent: Container(
                height: screenSize.height * 0.25,
                color: theme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_car,
                      size: 50,
                      color: theme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No image uploaded',
                      style: TextStyle(color: theme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.description?.isNotEmpty == true
                      ? vehicle.description!
                      : '${vehicle.make} ${vehicle.model}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _detailRow(
                  context,
                  'Registration Number',
                  vehicle.regNum.toUpperCase(),
                ),
                _detailRow(context, 'Make', vehicle.make),
                _detailRow(context, 'Model', vehicle.model),
                _detailRow(context, 'Year', vehicle.year.toString()),
                _detailRow(context, 'Colour', vehicle.colour),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
