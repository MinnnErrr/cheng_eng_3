import 'package:cheng_eng_3/core/models/redeemed_reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:cheng_eng_3/utils/status_colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RedeemedRewardListitem extends ConsumerWidget {
  const RedeemedRewardListitem({
    super.key,
    required this.redeemedReward,
    this.onTap,
  });

  final RedeemedReward redeemedReward;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final dateFormatter = DateFormat('dd MMM yyyy');
    final now = DateTime.now();

    final isExpired =
        !redeemedReward.isClaimed &&
        redeemedReward.expiryDate != null &&
        redeemedReward.expiryDate!.isBefore(now);

    final theme = Theme.of(context);

    // Get Status Color Helper
    final statusColor = getRedeemedRewardStatusColor(
      redeemedReward.isClaimed,
      context,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isExpired ? null : onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageBuilder(
                      url: redeemedReward.photoPaths.isNotEmpty
                          ? imageService.retrieveImageUrl(
                              redeemedReward.photoPaths.first,
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
                      children: [
                        // Name (with padding to avoid chip overlap)
                        Padding(
                          padding: const EdgeInsets.only(right: 70), //
                          child: Text(
                            redeemedReward.name,
                            maxLines: 2, // Allow 2 lines
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          '#${redeemedReward.code}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontFamily:
                                'monospace', // Makes code look technical
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Expiry Date (Now alone at bottom)
                        if (redeemedReward.expiryDate != null)
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: theme.colorScheme.error,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Expires: ${dateFormatter.format(redeemedReward.expiryDate!)}",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 3. STATUS CHIP (Top Right)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  redeemedReward.isClaimed ? 'Used' : 'Active',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ),

            // 4. EXPIRED OVERLAY
            if (isExpired)
              Positioned.fill(
                child: Container(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.8,
                  ),
                   alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'EXPIRED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
