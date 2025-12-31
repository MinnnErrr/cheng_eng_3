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
      (TowingStatus status) => TowingEntry(
        label: status.label,
        value: status.value,
        // Optional: Add icons for a better look
        leadingIcon: Icon(
          status == TowingStatus.decline
              ? Icons.close
              : status == TowingStatus.accept
              ? Icons.check
              : Icons.flag,
          color: status == TowingStatus.decline ? Colors.red : null,
        ),
      ),
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
    final Towing currentTowing = towingAsync.value ?? widget.towing;
    final towingNotifier = ref.read(staffTowingsProvider.notifier);
    final bool isCancelled = currentTowing.status.toLowerCase() == 'cancelled';
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Towing Details'),
        systemOverlayStyle: SystemUiOverlayStyle.dark,

        // Sticky Status Bar
        bottom: isCancelled
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(90),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // --- DROPDOWN ---
                      Expanded(
                        child: DropdownMenu<String>(
                          width: double.infinity, // Fills the Expanded
                          initialSelection: currentTowing.status,
                          dropdownMenuEntries: TowingStatus.entries,
                          label: const Text('Update Status'),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainer,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outlineVariant,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onSelected: (value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      // --- CONFIRM BUTTON ---
                      // Styled to match the Yellow/Black theme
                      IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary, // Yellow
                          foregroundColor: theme.colorScheme.onPrimary, // Black
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(
                            56,
                            56,
                          ), // Matches Dropdown height
                          elevation: 0,
                        ),
                        onPressed:
                            _selectedStatus != null &&
                                _selectedStatus != currentTowing.status
                            ? () => _updateStatus(
                                context,
                                towingNotifier,
                                currentTowing.id,
                              )
                            : null, // Disabled state handles grey out auto
                        icon: const Icon(Icons.check, size: 28),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Details Card
            TowingDetailsWidget(towing: currentTowing),

            // Bottom Padding for scrolling
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- LOGIC HELPER ---
  Future<void> _updateStatus(
    BuildContext context,
    StaffTowingsNotifier notifier,
    String id,
  ) async {
    final success = await notifier.updateStatus(
      id: id,
      status: _selectedStatus!,
    );

    if (!context.mounted) return;

    showAppSnackBar(
      context: context,
      content: success
          ? 'Status updated successfully'
          : 'Failed to update status',
      isError: !success,
    );

    if (success) {
      setState(() => _selectedStatus = null);
    }
  }
}
