import 'package:cheng_eng_3/core/models/reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RewardListitem extends ConsumerWidget {
  const RewardListitem({
    super.key,
    required this.reward,
    required this.isStaff,
    this.onTap, // ✅ Added onTap here
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
        onTap: onTap, // ✅ InkWell is now INSIDE the card
        child: Column(
          children: [
            // --- BANNER (Optional) ---
            if (reward.availableUntil != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                color: theme.colorScheme.primaryContainer,
                child: Text(
                  'Available until: ${dateFormatter.format(reward.availableUntil!)}',
                  style: theme.textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            // --- CONTENT ROW ---
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageBuilder(
                      url: reward.photoPaths.isNotEmpty
                          ? imageService.retrieveImageUrl(
                              reward.photoPaths.first,
                            )
                          : null,
                      containerWidth: 80,
                      containerHeight: 80,
                      noImageContent: Container(
                        width: 80,
                        height: 80,
                        color: theme.colorScheme.surfaceContainerHigh,
                        child: Icon(
                          Icons.redeem,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      context: context,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // 2. DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ✅ Removed MainAxisAlignment.spaceBetween (relied on IntrinsicHeight)
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
                          'Code: #${reward.code}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${reward.points} pts',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF9E7C00),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3. STAFF CONTROLS (Right Side)
                  if (isStaff)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Status Chip
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
                              border: Border.all(
                                color: reward.status
                                    ? Colors.green
                                    : theme.colorScheme.error,
                              ),
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

                          // ✅ Replaced Spacer with fixed SizedBox for performance
                          const SizedBox(height: 20),

                          // Qty Text
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
            ),
          ],
        ),
      ),
    );
  }
}
