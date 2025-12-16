import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_by_vehicle_provider.dart';
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
    final maintenanceListNotifier = ref.read(maintenanceProvider.notifier);

    return maintenanceList.when(
      data: (list) {
        if (list.maintenances.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('No maintenance records found.')),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(10),
          shrinkWrap: true, // Correct for nested lists
          physics: const NeverScrollableScrollPhysics(), // Let parent handle scrolling
          itemCount: list.maintenances.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final maintenance = list.maintenances[index];
            return MaintenanceListItem(
              maintenance: maintenance,
              icon: IconButton(
                // FIX 1: Add Confirmation Dialog
                onPressed: () => _confirmDelete(
                  context,
                  maintenanceListNotifier,
                  maintenance.id,
                ),
                icon: const Icon(Icons.delete, color: Colors.grey),
              ),
              // FIX 2: Pass Object for Optimistic UI
              tapAction: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MaintenanceDetailsScreen(
                    maintenance: maintenance, // Ensure your Details screen accepts this
                  ),
                ),
              ),
            );
          },
        );
      },
      // FIX 3: Remove Scaffold from these states (caused visual bugs)
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(20),
        child: Center(child: Text('Error: $error')),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    dynamic notifier, // Using dynamic to match your specific notifier type
    String id,
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
      final success = await notifier.deleteMaintenance(id);

      if (context.mounted) {
        showAppSnackBar(
          context: context,
          content: success ? 'Record deleted' : 'Failed to delete record',
          isError: !success,
        );
      }
    }
  }
}