import 'package:cheng_eng_3/core/models/redeemed_reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RedeemedRewardListitem extends ConsumerWidget {
  const RedeemedRewardListitem({
    super.key,
    required this.redeemedReward,
  });

  final RedeemedReward redeemedReward;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final dateformatter = DateFormat('dd/MM/yyyy').add_jm();
    final now = DateTime.now();

    // Check expired status
    final isExpired =
        redeemedReward.isClaimed == false &&
        redeemedReward.expiryDate != null &&
        redeemedReward.expiryDate!.isBefore(now);

    return Card(
      clipBehavior: Clip.antiAlias, // Clean rounded corners
      elevation: 2,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            children: [
              // 1. EXPIRY HEADER (Full Width)
              if (redeemedReward.expiryDate != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  width: double.infinity,
                  color: isExpired
                      ? Colors
                            .grey // Grey header if expired
                      : Theme.of(context).colorScheme.primaryContainer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Expires: ${dateformatter.format(redeemedReward.expiryDate!)}',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),

              // 2. MAIN CONTENT (Ticket Layout)
              IntrinsicHeight(
                // <--- KEY: Matches Image height to Text height
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // LEFT: IMAGE
                    SizedBox(
                      width: 110, // Fixed width, simpler than screen %
                      child: imageBuilder(
                        url: redeemedReward.photoPaths.isNotEmpty
                            ? imageService.retrieveImageUrl(
                                redeemedReward.photoPaths.first,
                              )
                            : null,
                        // We don't need containerWidth/Height here because
                        // IntrinsicHeight + stretch handles it.
                        containerWidth: 110,
                        containerHeight: double.infinity,
                        noImageContent: Container(
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.confirmation_number_outlined,
                            color: Colors.grey,
                          ),
                        ),
                        context: context,
                      ),
                    ),

                    // RIGHT: DETAILS
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Spreads content out
                              children: [
                                // Top: Code & Name
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#${redeemedReward.code}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      redeemedReward.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      '${redeemedReward.points} pts',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Spacer(),

                            // Status Chip
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: redeemedReward.isClaimed == true
                                    ? Colors.red.shade50
                                    : Colors.green.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: redeemedReward.isClaimed == true
                                      ? Colors.red.shade200
                                      : Colors.green.shade200,
                                ),
                              ),
                              child: Text(
                                redeemedReward.isClaimed == true
                                    ? 'Used'
                                    : 'Active',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: redeemedReward.isClaimed == true
                                      ? Colors.red.shade700
                                      : Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 3. EXPIRED OVERLAY (Full Card)
          if (isExpired)
            Positioned.fill(
              child: Container(
                color: Colors.white.withValues(alpha: 0.7), // Whitewash effect
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
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
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
