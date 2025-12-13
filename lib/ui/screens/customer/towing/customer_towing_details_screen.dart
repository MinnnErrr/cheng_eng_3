
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/towing_notifier.dart';
import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/towing_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerTowingDetailsScreen extends ConsumerStatefulWidget {
  const CustomerTowingDetailsScreen({super.key, required this.towing});

  final Towing towing;

  @override
  ConsumerState<CustomerTowingDetailsScreen> createState() {
    return _CustomerTowingDetailsScreenState();
  }
}

class _CustomerTowingDetailsScreenState
    extends ConsumerState<CustomerTowingDetailsScreen> {
  late Towing displayedTowing;

  @override
  void initState() {
    super.initState();
    displayedTowing = widget.towing;
  }

  @override
  Widget build(BuildContext context) {
    // Subscribe to real-time updates
    ref.watch(towingRealtimeProvider);

    // Watch the towing provider for updates
    final towingAsync = ref.watch(towingProvider(widget.towing.id));

    towingAsync.whenData((updatedTowing) {
      displayedTowing = updatedTowing;
    });

    final towingNotifier =
        ref.read(customerTowingsProvider(displayedTowing.userId).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Towing Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TowingDetailsScreen(towing: displayedTowing),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: displayedTowing.status.toLowerCase() == 'pending'
                    ? () async {
                        final success = await towingNotifier.updateStatus(
                          id: displayedTowing.id,
                          status: 'Cancelled',
                        );
                        if (!context.mounted) return;
                        showAppSnackBar(
                          context: context,
                          content: success
                              ? 'Status updated'
                              : 'Failed to update status',
                        );
                      }
                    : null,
                child: Text(
                  displayedTowing.status.toLowerCase() == 'pending'
                      ? 'Cancel'
                      : 'Disabled',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
