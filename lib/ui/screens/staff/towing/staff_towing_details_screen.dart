import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/towing/staff_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/towing_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/ui/extensions/towing_extension.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/towing_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffTowingDetailsScreen extends ConsumerStatefulWidget {
  const StaffTowingDetailsScreen({super.key, required this.towing});

  final Towing towing;

  @override
  ConsumerState<StaffTowingDetailsScreen> createState() =>
      _StaffTowingDetailsScreenState();
}

class _StaffTowingDetailsScreenState
    extends ConsumerState<StaffTowingDetailsScreen> {
  TowingStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    ref.watch(towingRealtimeProvider);

    final towingAsync = ref.watch(towingByIdProvider(widget.towing.id));
    final Towing currentTowing = towingAsync.value ?? widget.towing;
    final towingNotifier = ref.read(staffTowingsProvider.notifier);

    final bool isCancelled = currentTowing.status == TowingStatus.cancelled;
    final bool canUpdate = !isCancelled;
    final bool isChanged =
        _selectedStatus != null && _selectedStatus != currentTowing.status;

    final theme = Theme.of(context);

    final towingEntries = TowingStatus.values
        .where((status) => status != TowingStatus.cancelled)
        .map((status) {
      return DropdownMenuEntry<TowingStatus>(
        value: status,
        label: status.label,
        leadingIcon: Icon(Icons.circle, color: status.color, size: 10),
      );
    }).toList();

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
                            child: DropdownMenu<TowingStatus>(
                              key: ValueKey(currentTowing.status),
                              width: double.infinity,
                              initialSelection: currentTowing.status,
                              dropdownMenuEntries: towingEntries,
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
                              onSelected: (value) {
                                  if (value != null) {
                                  setState(() => _selectedStatus = value);
                                }
                              },
                            )
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
                          .withValues(alpha: 0.4),
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
    if (_selectedStatus == null) return;

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
