import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/towing_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/towing_details.dart';
import 'package:cheng_eng_3/utils/status_colour.dart'; // Ensure imported
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerTowingDetailsScreen extends ConsumerStatefulWidget {
  const CustomerTowingDetailsScreen({super.key, required this.towing});

  final Towing towing;

  @override
  ConsumerState<CustomerTowingDetailsScreen> createState() =>
      _CustomerTowingDetailsScreenState();
}

class _CustomerTowingDetailsScreenState
    extends ConsumerState<CustomerTowingDetailsScreen> {
  bool _isCancelling = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(towingRealtimeProvider);

    final towingAsync = ref.watch(towingByIdProvider(widget.towing.id));
    final currentTowing = towingAsync.value ?? widget.towing;

    final towingNotifier = ref.read(
      customerTowingsProvider(currentTowing.userId).notifier,
    );

    final isPending = currentTowing.status.toLowerCase() == 'pending';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Towing Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TowingDetailsWidget(towing: currentTowing),

              const SizedBox(height: 30),

              // 3. ACTION SECTION
              if (isPending)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isCancelling
                        ? null
                        : () => _confirmCancel(
                            context,
                            towingNotifier,
                            currentTowing.id,
                          ),
                    icon: _isCancelling
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                        : const Icon(Icons.cancel_outlined),
                    label: _isCancelling
                        ? const Text("Cancelling...")
                        : const Text("Cancel Request"),
                  ),
                )
              else
                // ✅ UX FIX: Show Status Banner if not actionable
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: getTowingStatusColor(
                      currentTowing.status,
                      context,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: getTowingStatusColor(
                        currentTowing.status,
                        context,
                      ).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getStatusIcon(currentTowing.status),
                        color: getTowingStatusColor(
                          currentTowing.status,
                          context,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getStatusMessage(currentTowing.status),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: getTowingStatusColor(
                            currentTowing.status,
                            context,
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'cancelled':
        return Icons.cancel_presentation;
      case 'accepted':
        return Icons.near_me;
      case 'completed':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  String _getStatusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'cancelled':
        return 'Request Cancelled';
      case 'accepted':
        return 'Help is on the way';
      case 'completed':
        return 'Thanks for choosing us';
      default:
        return 'Status: $status'; // Safe fallback
    }
  }

  Future<void> _confirmCancel(
    BuildContext context,
    CustomerTowingsNotifier notifier,
    String towingId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Request"),
        content: const Text(
          "Are you sure you want to cancel? This will remove your request from the queue.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Keep Request"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isCancelling = true);

      final success = await notifier.updateStatus(
        id: towingId,
        status: 'Cancelled',
      );

      if (context.mounted) {
        setState(() => _isCancelling = false);

        showAppSnackBar(
          context: context,
          content: success
              ? 'Request cancelled successfully'
              : 'Failed to cancel',
          isError: !success,
        );
      }
    }
  }
}
