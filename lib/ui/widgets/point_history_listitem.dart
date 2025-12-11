import 'package:cheng_eng_3/core/controllers/profile/staff_user_profile_provider.dart';
import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PointHistoryListitem extends ConsumerWidget {
  const PointHistoryListitem({
    super.key,
    required this.record,
    required this.isStaff,
  });

  final PointHistory record;
  final bool isStaff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = DateFormat('dd/MM/yyyy').add_jm();
    final userProfile = ref.watch(userProfileByIdProvider(record.userId));

    return Row(
      children: [
        Column(
          children: [
            Text(
              dateFormatter.format(record.createdAt),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              record.reason,
              softWrap: true,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isStaff)
              userProfile.when(
                data: (profile) => Text(
                  'Issued to: ${profile?.email ?? "User email not found"}',
                  softWrap: true,
                ),
                loading: () => const Text("Loading email..."),
                error: (_, __) => Text("Email error", style: TextStyle(color: Theme.of(context).colorScheme.error),),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            record.points.isNegative
                ? record.points.toString()
                : '+${record.points}',
            style: TextStyle(
              color: record.points.isNegative
                  ? Theme.of(context).colorScheme.error
                  : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
