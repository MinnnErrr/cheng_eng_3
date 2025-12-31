import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
import 'package:cheng_eng_3/core/controllers/profile/user_profile_provider.dart';
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
    final dateFormatter = DateFormat('dd MMM yyyy, h:mm a');
    final userProfile = ref.watch(userProfileByUserIdProvider(record.userId));
    final theme = Theme.of(context);

    final isNegative = record.points.isNegative;
    final localTime = record.createdAt.toLocal();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
        children: [
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.reason,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormatter.format(localTime),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isStaff) ...[
                  const SizedBox(height: 2),
                  userProfile.when(
                    data: (p) => Text(
                      'User: ${p?.email ?? "Unknown"}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: textYellow,
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),

          // Points Value
          Text(
            isNegative ? '${record.points}' : '+${record.points}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isNegative ? theme.colorScheme.error : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
