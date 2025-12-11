import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/maintenance_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaintenanceScreen extends ConsumerWidget {
  const MaintenanceScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintenanceList = ref.watch(maintenanceByVehicleProvider(vehicleId));
    final maintenanceListNotifier = ref.watch(maintenanceProvider.notifier);

    return Container(
      child: maintenanceList.when(
        data: (list) {
          final maintenances = list.maintenances;

          if (maintenances.isEmpty) {
            return const Center(
              child: Text('No maintenance records found.'),
            );
          }

          return ListView(
            padding: EdgeInsets.all(10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final maintenance in maintenances)
                MaintenanceListItem(
                  maintenance: maintenance,
                  icon: IconButton(
                    onPressed: () async {
                      final success = await maintenanceListNotifier
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
                      builder: (context) => MaintenanceDetailsScreen(
                        maintenanceId: maintenance.id,
                      ),
                    ),
                  ),
                ),
            ],
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
    );
  }
}
