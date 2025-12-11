import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towing_notifier.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/towing_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerTowingDetailsScreen extends ConsumerWidget {
  const CustomerTowingDetailsScreen({super.key, required this.towingId});

  final String towingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    final towing = ref.watch(
      customerTowingByIdProvider((towingId: towingId, userId: user!.id)),
    );

    final towingNotifier = ref.read(customerTowingProvider(user.id).notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Towing Details'),
      ),
      body: towing.when(
        data: (towing) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  //details
                  TowingDetailsScreen(towing: towing),

                  const SizedBox(height: 20,),

                  //button
                  ElevatedButton(
                    onPressed: towing.status.toLowerCase() == 'pending'
                        ? () async {
                            final success = await towingNotifier.updateStatus(
                              id: towing.id,
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
                      towing.status.toLowerCase() == 'pending'
                          ? 'Cancel'
                          : 'Disabled',
                    ),
                  ),
                ],
              ),

              //details
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
