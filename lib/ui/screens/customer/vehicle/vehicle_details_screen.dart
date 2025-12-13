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
  const VehicleDetailsScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleState = ref.watch(customerVehicleByIdProvider(vehicleId));
    final imageService = ref.read(imageServiceProvider);
    final screenSize = MediaQuery.of(context).size;
    final maintenanceList = ref.watch(
      maintenanceByVehicleProvider(vehicleId),
    );
    final maintenanceListNotifier = ref.watch(maintenanceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CartScreen(),
              ),
            ),
            child: cartIcon(ref, context),
          ),
        ],
      ),
      body: vehicleState.when(
        data: (vehicle) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _vehicleDetails(
                    vehicle: vehicle,
                    context: context,
                    imageService: imageService,
                    screenSize: screenSize,
                  ),
                ),
              ),

              // Header row
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Text(
                        'Maintenance Records',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MaintenanceCreateScreen(vehicleId: vehicle.id),
                          ),
                        ),
                        label: Text('Add'),
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),

              // Maintenance list
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: Consumer(
                  builder: (context, ref, _) {
                    return maintenanceList.when(
                      data: (list) {
                        if (list.maintenances.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: Center(child: Text("No maintenance found")),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final maintenance = list.maintenances[index];
                              return MaintenanceListItem(
                                maintenance: maintenance,
                                icon: IconButton(
                                  onPressed: () async {
                                    final success =
                                        await maintenanceListNotifier
                                            .deleteMaintenance(
                                              maintenance.id,
                                            );
                                    if (!context.mounted) return;
                                    showAppSnackBar(
                                      context: context,
                                      content: success
                                          ? 'Maintenance record deleted'
                                          : 'Failed to delete maintenance record',
                                    );
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                                tapAction: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MaintenanceDetailsScreen(
                                          maintenanceId: maintenance.id,
                                        ),
                                  ),
                                ),
                              );
                            },
                            childCount: list.maintenances.length,
                          ),
                        );
                      },
                      error: (e, st) => const SliverToBoxAdapter(
                        child: Text("Error loading data"),
                      ),
                      loading: () => const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _vehicleDetails({
    Vehicle? vehicle,
    required BuildContext context,
    required ImageService imageService,
    required Size screenSize,
  }) {
    Widget vehicleDetailsItem({required String title, required String value}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            softWrap: true,
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: vehicle == null
          ? const Center(child: Text("Vehicle not found"))
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        vehicle.description ?? '-',
                        style:
                            Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                VehicleUpdateScreen(vehicle: vehicle),
                          ),
                        ),
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      spacing: 20,
                      children: [
                        //image
                        imageBuilder(
                          url: vehicle.photoPath != null
                              ? imageService.retrieveImageUrl(
                                  vehicle.photoPath!,
                                )
                              : null,
                          containerWidth: double.infinity,
                          containerHeight: screenSize.height * 0.3,
                          noImageContent: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.directions_car),
                                Text('No image found'),
                              ],
                            ),
                          ),
                          context: context,
                        ),

                        //details
                        vehicleDetailsItem(
                          title: 'Registration Number',
                          value: vehicle.regNum,
                        ),
                        vehicleDetailsItem(title: 'Make', value: vehicle.make),
                        vehicleDetailsItem(
                          title: 'Model',
                          value: vehicle.model,
                        ),
                        vehicleDetailsItem(
                          title: 'Year',
                          value: vehicle.year.toString(),
                        ),
                        vehicleDetailsItem(
                          title: 'Colour',
                          value: vehicle.colour,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
