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

class MaintenanceDetailsScreen extends ConsumerStatefulWidget {
  const MaintenanceDetailsScreen({super.key, required this.maintenance});

  final Maintenance maintenance;

  @override
  ConsumerState<MaintenanceDetailsScreen> createState() =>
      _MaintenanceDetailsScreenState();
}

class _MaintenanceDetailsScreenState
    extends ConsumerState<MaintenanceDetailsScreen> {
  // To handle button loading state locally
  bool _isUpdatingStatus = false;

  @override
  Widget build(BuildContext context) {
    // 1. OPTIMISTIC UI: Use widget data first, update with provider data if available
    final maintenanceAsync = ref.watch(maintenanceByIdProvider(widget.maintenance.id));
    final maintenance = maintenanceAsync.value ?? widget.maintenance;

    final maintenanceNotifier = ref.read(maintenanceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- HEADER SECTION ---
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        maintenance.title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
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
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),

              // --- BODY SECTION ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  spacing: 20, // Requires Flutter 3.27+
                  children: [
                    // Vehicle Card
                    _VehicleInfoSection(vehicleId: maintenance.vehicleId),

                    // Details
                    _buildDetailsList(context, maintenance),

                    // Status Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isUpdatingStatus
                            ? null
                            : () async {
                                setState(() => _isUpdatingStatus = true);

                                final isComplete =
                                    maintenance.status.toLowerCase() ==
                                        'complete';
                                final newStatus =
                                    isComplete ? 'Incomplete' : 'Complete';

                                final success =
                                    await maintenanceNotifier.updateStatus(
                                  id: maintenance.id,
                                  status: newStatus,
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
                                maintenance.status.toLowerCase() == 'incomplete'
                                    ? 'Mark as Complete'
                                    : 'Mark as Incomplete',
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context, Maintenance maintenance) {
    // Fixed Typo: removed double slash
    final dateFormatter = DateFormat('dd/MM/yyyy'); 
    final timeFormatter = DateFormat('dd/MM/yyyy').add_jm();

    return Column(
      spacing: 15,
      children: [
        _buildRow('Description', maintenance.description ?? '-'),
        _buildRow('Last Service Date',
            dateFormatter.format(maintenance.currentServDate)),
        _buildRow(
            'Last Service Distance', '${maintenance.currentServDistance} KM'),
        _buildRow('Next Service Date',
            dateFormatter.format(maintenance.nextServDate)),
        _buildRow(
            'Next Service Distance', '${maintenance.nextServDistance} KM'),
        _buildRow(
          'Status',
          maintenance.status,
          textColor: getMaintenanceStatusColor(maintenance.status, context),
        ),
        _buildRow(
          'Updated At',
          maintenance.updatedAt != null
              ? timeFormatter.format(maintenance.updatedAt!)
              : '-',
        ),
        
        // Remarks Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
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
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                maintenance.remarks ?? '-',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String title, String value, {Color? textColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
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
        vehicle: vehicle,
        descriptionRequired: false,
        colourRequired: false,
        yearRequired: false,
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