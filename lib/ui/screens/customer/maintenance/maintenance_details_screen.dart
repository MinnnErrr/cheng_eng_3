import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_update_screen.dart';
import 'package:cheng_eng_3/utils/status_colour.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MaintenanceDetailsScreen extends ConsumerWidget {
  const MaintenanceDetailsScreen({super.key, required this.maintenanceId});

  final String maintenanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenance = ref.watch(maintenanceByIdProvider(maintenanceId));
    final maintenanceNotifier = ref.read(maintenanceProvider.notifier);

    Widget maintenanceDetailsItem({
      required String title,
      required String value,
      Color? textcolor,
    }) {
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
            style: TextStyle(color: textcolor),
          ),
        ],
      );
    }

    Widget vehicleDetails(String vehicleId) {
      final vehicleAsync = ref.watch(customerVehicleByIdProvider(vehicleId));

      return vehicleAsync.when(
        data: (vehicle) {
          return VehicleListitem(
            vehicle: vehicle,
            descriptionRequired: false,
            colourRequired: false,
            yearRequired: false,
          );
        },
        loading: () => const SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, st) => Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Center(child: Text('Failed to load vehicle')),
        ),
      );
    }

    Widget details({
      required BuildContext context,
      required Maintenance maintenance,
    }) {
      final dateFormatter = DateFormat('dd//MM/yyyy');
      final timeFormatter = DateFormat('dd/MM/yyyy').add_jm();

      return Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    maintenance.title,
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
                        builder: (_) => MaintenanceUpdateScreen(
                          maintenance: maintenance,
                        ),
                      ),
                    ),
                    icon: Icon(Icons.edit),
                  ),
                ],
              ),
            ),

            //details
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  spacing: 20,
                  children: [
                    vehicleDetails(maintenance.vehicleId),
                    maintenanceDetailsItem(
                      title: 'Description',
                      value: maintenance.description ?? '-',
                    ),
                    maintenanceDetailsItem(
                      title: 'Last Service Date',
                      value: dateFormatter.format(maintenance.currentServDate),
                    ),
                    maintenanceDetailsItem(
                      title: 'Last Service Distance',
                      value: '${maintenance.currentServDistance} KM',
                    ),
                    maintenanceDetailsItem(
                      title: 'Next Service Date',
                      value: dateFormatter.format(maintenance.nextServDate),
                    ),
                    maintenanceDetailsItem(
                      title: 'Next Service Distance',
                      value: '${maintenance.nextServDistance} KM',
                    ),
                    maintenanceDetailsItem(
                      title: 'Status',
                      value: maintenance.status,
                      textcolor: getMaintenanceStatusColor(
                        maintenance.status,
                        context,
                      ),
                    ),
                    maintenanceDetailsItem(
                      title: 'Updated At',
                      value: maintenance.updatedAt != null
                          ? timeFormatter.format(maintenance.updatedAt!)
                          : '-',
                    ),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.errorContainer,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remarks',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                          Text(
                            maintenance.remarks ?? '-',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Maintenance Details'),
      ),
      body: maintenance.when(
        data: (maintenance) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 30,
                children: [
                  //details
                  details(context: context, maintenance: maintenance),

                  //status
                  ElevatedButton(
                    onPressed: () async {
                      String status =
                          maintenance.status.toLowerCase() == 'incomplete'
                          ? 'Complete'
                          : 'Incomplete';

                      final success = await maintenanceNotifier.updateStatus(
                        id: maintenance.id,
                        status: status,
                      );

                      if (!context.mounted) return;
                      showAppSnackBar(
                        context: context,
                        content: success
                            ? 'Status updated'
                            : 'Failed to update status',
                        isError: !success,
                      );
                    },
                    child: Text(
                      maintenance.status.toLowerCase() == 'incomplete'
                          ? 'Complete'
                          : 'Incomplete',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
