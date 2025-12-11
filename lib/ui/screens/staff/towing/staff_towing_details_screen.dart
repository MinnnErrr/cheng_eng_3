import 'dart:collection';

import 'package:cheng_eng_3/core/controllers/towing/staff_towing_notifier.dart';
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
  const StaffTowingDetailsScreen({super.key, required this.towingId});

  final String towingId;

  @override
  ConsumerState<StaffTowingDetailsScreen> createState() =>
      _StaffTowingDetailsScreenState();
}

class _StaffTowingDetailsScreenState
    extends ConsumerState<StaffTowingDetailsScreen> {
  String? _status;

  @override
  Widget build(BuildContext context) {
    final towing = ref.watch(staffTowingByIdProvider(widget.towingId));
    final towingNotifier = ref.read(staffTowingProvider.notifier);

    return Scaffold(
      body: towing.when(
        data: (towing) {
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

                bottom: towing.status.toLowerCase() == 'cancelled'
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
                                              id: widget.towingId,
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
                      TowingDetailsScreen(towing: towing),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
