import 'package:cheng_eng_3/domain/models/reward_model.dart';
import 'package:cheng_eng_3/data/services/image_service.dart';
import 'package:cheng_eng_3/ui/core/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RewardListitem extends ConsumerWidget {
  const RewardListitem({
    super.key,
    required this.reward,
    required this.isStaff,
    this.onTap,
  });

  final Reward reward;
  final bool isStaff;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. EXPIRY DATE BADGE ---
              if (reward.availableUntil != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        size: 14,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Valid until ${dateFormatter.format(reward.availableUntil!)}',
                        style: theme.textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12), 
              ],

              // --- 2. MAIN CONTENT ROW ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A. Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageBuilder(
                      url: reward.photoPaths.isNotEmpty
                          ? imageService.retrieveImageUrl(
                              reward.photoPaths.first,
                            )
                          : null,
                      width: 80,
                      height: 80,
                      noImageContent: Container(
                        width: 80,
                        height: 80,
                        color: theme.colorScheme.surfaceContainerHigh,
                        child: Icon(
                          Icons.redeem,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      enableZoom: false,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // B. Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#${reward.code}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily:
                                'monospace', 
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${reward.points} pts',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF9E7C00),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // C. Staff Controls
                  if (isStaff)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: reward.status
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              reward.status ? 'Active' : 'Inactive',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: reward.status
                                    ? Colors.green.shade700
                                    : theme.colorScheme.error,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Qty: ${reward.quantity}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: reward.quantity > 0
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
