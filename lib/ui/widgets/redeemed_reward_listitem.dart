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
                        // Name & Code
                        Text(
                          redeemedReward.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#${redeemedReward.code}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Footer Row (Expiry & Status)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Expiry Text
                            if (redeemedReward.expiryDate != null)
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    dateFormatter.format(
                                      redeemedReward.expiryDate!,
                                    ),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                            // Status Chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: getRedeemedRewardStatusColor(
                                  redeemedReward.isClaimed,
                                  context,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),

                              child: Text(
                                redeemedReward.isClaimed ? 'Used' : 'Active',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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

            // 3. EXPIRED OVERLAY
            if (isExpired)
              Positioned.fill(
                child: Container(
                  color: theme.colorScheme.surface.withValues(alpha: 0.7),
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'EXPIRED',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
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
