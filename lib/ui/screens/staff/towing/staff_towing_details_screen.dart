import 'dart:collection';

import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/towing/staff_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/towing_notifier.dart';
import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/towing_details.dart';
import 'package:flutter/material.dart';
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
  late Towing displayedTowing;
  String? _status;

  @override
  void initState() {
    displayedTowing = widget.towing;
    super.initState();
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
        ref.read(staffTowingsProvider.notifier);

    return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                toolbarHeight: 70,
                title: Text(
                  'Towing Details',
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                bottom: displayedTowing.status.toLowerCase() == 'cancelled'
                    ? null
                    : PreferredSize(
                        preferredSize: const Size.fromHeight(70),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownMenu<String>(
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  label: const Text('Status'),
                                  dropdownMenuEntries: TowingStatus.entries,
                                  onSelected: (value) {
                                    setState(() {
                                      _status = value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: _status != null
                                    ? () async {
                                        final success = await towingNotifier
                                            .updateStatus(
                                              id: displayedTowing.id,
                                              status: _status!,
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
                                child: const Icon(Icons.check),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Column(
                    children: [
                      //details
                      TowingDetailsScreen(towing: displayedTowing),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
  }

