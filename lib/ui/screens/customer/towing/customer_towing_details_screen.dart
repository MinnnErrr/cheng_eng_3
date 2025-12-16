import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/towing_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/towing_details.dart';
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
  
  // Local state only for the button loading
  bool _isCancelling = false;

  @override
  Widget build(BuildContext context) {
    // 1. Keep Realtime Connection Alive
    ref.watch(towingRealtimeProvider);

    // 2. Safe Optimistic UI Pattern
    // If we have fresh data (.value), use it. 
    // If we are loading or error, fall back to the passed widget.towing.
    final towingAsync = ref.watch(towingByIdProvider(widget.towing.id));
    final currentTowing = towingAsync.value ?? widget.towing;

    // Notifier for actions
    final towingNotifier =
        ref.read(customerTowingsProvider(currentTowing.userId).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Towing Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TowingDetailsWidget(towing: currentTowing),
              const SizedBox(height: 20),

              // 3. UX Logic: Only show Cancel button if status is Pending
              if (currentTowing.status.toLowerCase() == 'pending')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50, // Light red background
                      foregroundColor: Colors.red, // Red text
                    ),
                    // Disable button if currently loading/cancelling
                    onPressed: _isCancelling
                        ? null
                        : () {
                            _confirmCancel(context, towingNotifier, currentTowing.id);
                          },
                    child: _isCancelling
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Cancel Request'),
                  ),
                ),
                
              // Optional: Show status text if not pending
              if (currentTowing.status.toLowerCase() != 'pending')
                Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Request is ${currentTowing.status}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for Confirmation Dialog
  Future<void> _confirmCancel(
    BuildContext context, 
    dynamic notifier, // Using dynamic to match your notifier type easily
    String towingId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cancel Request"),
        content: const Text("Are you sure you want to cancel this towing request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes, Cancel", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isCancelling = true); // Start Loading

      final success = await notifier.updateStatus(
        id: towingId,
        status: 'Cancelled',
      );

      if (context.mounted) {
        setState(() => _isCancelling = false); // Stop Loading
        
        showAppSnackBar(
          context: context,
          content: success ? 'Request cancelled' : 'Failed to cancel request',
          isError: !success,
        );
        
        // Optional: Pop back to list if successful?
        // if (success) Navigator.pop(context); 
      }
    }
  }
}