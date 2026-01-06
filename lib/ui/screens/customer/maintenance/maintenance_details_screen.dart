import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_update_screen.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MaintenanceDetailsScreen extends ConsumerStatefulWidget {
  const MaintenanceDetailsScreen({super.key, required this.maintenance});

  final Maintenance maintenance;

  @override
  ConsumerState<MaintenanceDetailsScreen> createState() =>
      _MaintenanceDetailsScreenState();
}

class _MaintenanceDetailsScreenState
    extends ConsumerState<MaintenanceDetailsScreen> {
  bool _isUpdatingStatus = false;

  @override
  Widget build(BuildContext context) {
    // Optimistic UI
    final maintenanceAsync = ref.watch(
      maintenanceByIdProvider(widget.maintenance.id),
    );
    final maintenance = maintenanceAsync.value ?? widget.maintenance;

    final bool isOverdue =
        !maintenance.isComplete &&
        maintenance.nextServDate.isBefore(DateTime.now());

    String statusLabel;
    Color statusColor;

    if (maintenance.isComplete) {
      statusLabel = 'Completed';
      statusColor = Colors.green;
    } else if (isOverdue) {
      statusLabel = 'Overdue';
      statusColor = Colors.red;
    } else {
      statusLabel = 'Upcoming';
      statusColor = Colors.orange;
    }

    final maintenanceNotifier = ref.read(maintenanceProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Details'),
        actions: [
          // Moved Edit to AppBar for consistency
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MaintenanceUpdateScreen(
                  maintenance: maintenance,
                ),
              ),
            ),
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Record',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION 1: VEHICLE ---
              Text(
                "Vehicle",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              _VehicleInfoSection(vehicleId: maintenance.vehicleId),

              const SizedBox(height: 25),

              // --- SECTION 2: MAINTENANCE INFO CARD ---
              Text(
                "Service Record",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Status Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              maintenance.title,
                              style: theme.textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Details List
                      _buildDetailsList(context, maintenance),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- ACTIONS ---
              FilledButton(
                onPressed: _isUpdatingStatus
                    ? null
                    : () async {
                        setState(() => _isUpdatingStatus = true);

                        final isComplete = maintenance.isComplete;
                        final newStatus = isComplete ? false : true;

                        final success = await maintenanceNotifier.updateStatus(
                          id: maintenance.id,
                          isComplete: newStatus,
                        );

                        if (context.mounted) {
                          setState(() => _isUpdatingStatus = false);
                          showAppSnackBar(
                            context: context,
                            content: success
                                ? 'Status updated to $newStatus'
                                : 'Failed to update status',
                            isError: !success,
                          );
                        }
                      },

                child: _isUpdatingStatus
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        maintenance.isComplete == false
                            ? 'MARK AS COMPLETE'
                            : 'MARK AS INCOMPLETE',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,

                    // ✅ 2. Define Border Color here
                    side: const BorderSide(color: Colors.red),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _confirmDelete(
                    context,
                    maintenanceNotifier,
                    maintenance.id,
                  ),
                  child: const Text(
                    'DELETE RECORD',
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context, Maintenance maintenance) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final timeFormatter = DateFormat('dd/MM/yyyy h:mm a'); // 12hr format

    return Column(
      children: [
        _detailRow(context, 'Description', maintenance.description ?? '-'),
        const SizedBox(height: 15),
        _detailRow(
          context,
          'Last Service',
          '${dateFormatter.format(maintenance.currentServDate)}${maintenance.currentServDistance != null ? '\n${maintenance.currentServDistance} km' : ''}',
        ),
        const SizedBox(height: 15),
        _detailRow(
          context,
          'Next Service',
          '${dateFormatter.format(maintenance.nextServDate)}${maintenance.nextServDistance != null ? '\n${maintenance.nextServDistance} km' : ''}',
        ),
        const SizedBox(height: 15),
        _detailRow(
          context,
          'Last Updated',
          maintenance.updatedAt != null
              ? timeFormatter.format(maintenance.updatedAt!)
              : '-',
        ),

        const SizedBox(height: 20),

        // ✅ IMPROVED REMARKS BOX
        if (maintenance.remarks?.isNotEmpty == true)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Remarks',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  maintenance.remarks!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ✅ ALIGNED ROW HELPER
  Widget _detailRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120, // Fixed width ensures alignment
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
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
        if (success) Navigator.pop(context); // Go back after delete
        showAppSnackBar(
          context: context,
          content: success ? 'Record deleted' : 'Failed to delete record',
          isError: !success,
        );
      }
    }
  }
}

// Extracted Vehicle Widget to keep build method clean
class _VehicleInfoSection extends ConsumerWidget {
  final String vehicleId;
  const _VehicleInfoSection({required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(customerVehicleByIdProvider(vehicleId));

    return vehicleAsync.when(
      data: (vehicle) => VehicleListitem(
        model: vehicle.model,
        make: vehicle.make,
        regNum: vehicle.regNum,
        photoPath: vehicle.photoPath,
        onTap: null,
      ),
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, st) => Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        alignment: Alignment.center,
        child: const Text('Vehicle info unavailable'),
      ),
    );
  }
}
