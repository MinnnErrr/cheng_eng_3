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
  complete('Complete', 'Completed');

  const TowingStatus(this.label, this.value);
  final String label;
  final String value;

  static final List<TowingEntry> entries = UnmodifiableListView<TowingEntry>(
    values.map<TowingEntry>(
      (TowingStatus status) => TowingEntry(
        label: status.label,
        value: status.value,
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
    ref.watch(towingRealtimeProvider);

    final towingAsync = ref.watch(towingByIdProvider(widget.towing.id));
    final Towing currentTowing = towingAsync.value ?? widget.towing;
    final towingNotifier = ref.read(staffTowingsProvider.notifier);

    final bool isCancelled = currentTowing.status.toLowerCase() == 'cancelled';
    final bool isCompleted = currentTowing.status.toLowerCase() == 'completed';
    final bool canUpdate = !isCancelled && !isCompleted;

    // Check if user has selected a DIFFERENT status
    final bool isChanged =
        _selectedStatus != null && _selectedStatus != currentTowing.status;

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Towing Details'),
      ),
      body: Column(
        children: [
          // --- 1. FIXED STATUS SECTION (Separated) ---
          if (canUpdate)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
              ),
              child: Row(
                children: [
                  // A. STATUS SELECTOR BOX (Expanded)
                  Expanded(
                    child: Container(
                      height: 50, // Fixed height for alignment
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_note,
                            color: theme.colorScheme.onSurface,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          // Dropdown
                          Expanded(
                            child: DropdownMenu<String>(
                              width: double.infinity,
                              initialSelection: currentTowing.status,
                              dropdownMenuEntries: TowingStatus.entries,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              // Invisible border inside the container
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: false,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                constraints: BoxConstraints(maxHeight: 48),
                              ),
                              onSelected: (value) =>
                                  setState(() => _selectedStatus = value),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // B. CONFIRM BUTTON (Separate)
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      // Grey out when disabled
                      disabledBackgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      disabledForegroundColor: theme
                          .colorScheme
                          .onSurfaceVariant
                          .withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      fixedSize: const Size(50, 50), // Matches input height
                    ),
                    onPressed: isChanged
                        ? () => _updateStatus(
                            context,
                            towingNotifier,
                            currentTowing.id,
                          )
                        : null, // Disabled if no change
                    icon: const Icon(Icons.check, size: 24),
                    tooltip: "Confirm Update",
                  ),
                ],
              ),
            ),

          // --- 2. SCROLLABLE DETAILS ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                children: [
                  TowingDetailsWidget(towing: currentTowing),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
