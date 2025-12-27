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
    final theme = Theme.of(context);

    return maintenanceList.when(
      data: (list) {
        if (list.maintenances.isEmpty) {
          // ✅ FIX: Use SizedBox instead of Padding/Center to prevent layout crashes
          return SizedBox(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.build_circle_outlined,
                    size: 40,
                    color: theme.colorScheme.outlineVariant,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No maintenance records found.',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.maintenances.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
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
            );
          },
        );
      },
      // ✅ FIX: Fixed heights prevent "RenderBox not laid out" errors
      error: (error, stackTrace) => SizedBox(
        height: 100,
        child: Center(child: Text('Error: $error')),
      ),
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    dynamic notifier,
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
