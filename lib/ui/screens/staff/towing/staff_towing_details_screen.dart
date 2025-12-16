import 'dart:collection';

import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/towing/staff_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/towing_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/towing_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef TowingEntry = DropdownMenuEntry<String>;

enum TowingStatus {
  decline('Decline', 'Declined'),
  accept('Accept', 'Accepted'),
  complete('Complete', 'Complete');

  const TowingStatus(this.label, this.value);
  final String label;
  final String value;

  static final List<TowingEntry> entries = UnmodifiableListView<TowingEntry>(
    values.map<TowingEntry>(
      (TowingStatus status) =>
          TowingEntry(label: status.label, value: status.value),
    ),
  );
}

class StaffTowingDetailsScreen extends ConsumerStatefulWidget {
  const StaffTowingDetailsScreen({super.key, required this.towing});

  final Towing towing;

  @override
  ConsumerState<StaffTowingDetailsScreen> createState() =>
      _StaffTowingDetailsScreenState();
}

class _StaffTowingDetailsScreenState
    extends ConsumerState<StaffTowingDetailsScreen> {
  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    // Subscribe to real-time updates
    ref.watch(towingRealtimeProvider);

    // Watch the towing provider for updates
    final towingAsync = ref.watch(towingByIdProvider(widget.towing.id));

    // Optimistic UI Pattern
    final Towing currentTowing = towingAsync.value ?? widget.towing;
    final towingNotifier = ref.read(staffTowingsProvider.notifier);
    final bool isCancelled = currentTowing.status.toLowerCase() == 'cancelled';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Towing Details'),
        centerTitle: true, // Optional: Center title looks better in this layout
        // 1. Make Status Bar Transparent so the AppBar color shows through it
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // Use .light for dark mode
        ),

        // 2. This controls the "tint" intensity when you scroll.
        // Default is usually 3.0. You can increase it for a darker scroll color.
        scrolledUnderElevation: 3.0,

        // 3. Ensure the base background matches your page before scrolling
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        // The bottom widget
        bottom: isCancelled
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Padding(
                  // REMOVED THE CONTAINER WITH 'color:' PROPERTY
                  // Now this section is transparent and shows the AppBar's
                  // scrolled color underneath.
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownMenu<String>(
                          width: MediaQuery.sizeOf(context).width * 0.70,
                          label: const Text('Status'),
                          initialSelection: currentTowing.status,
                          dropdownMenuEntries: TowingStatus.entries,
                          onSelected: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(50, 50),
                        ),
                        onPressed:
                            _selectedStatus != null &&
                                _selectedStatus != currentTowing.status
                            ? () async {
                                final success = await towingNotifier
                                    .updateStatus(
                                      id: currentTowing.id,
                                      status: _selectedStatus!,
                                    );

                                if (!context.mounted) return;
                                showAppSnackBar(
                                  context: context,
                                  content: success
                                      ? 'Status updated'
                                      : 'Failed to update status',
                                  isError: !success,
                                );

                                if (success) {
                                  setState(() => _selectedStatus = null);
                                }
                              }
                            : null,
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      // Standard SingleChildScrollView for the content
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          children: [
            TowingDetailsWidget(towing: currentTowing),
          ],
        ),
      ),
    );
  }
}
