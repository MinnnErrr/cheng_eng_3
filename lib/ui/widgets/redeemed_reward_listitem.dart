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
    final screenSize = MediaQuery.of(context).size;
    final dateformatter = DateFormat('dd/MM/yyyy').add_jm();
    final now = DateTime.now();

    return Card(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Column(
            children: [
              if (redeemedReward.expiryDate != null)
                Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    'Expiry Date: ${dateformatter.format(redeemedReward.expiryDate!)}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //picture
                    imageBuilder(
                      url: redeemedReward.photoPaths.isNotEmpty
                          ? imageService.retrieveImageUrl(
                              redeemedReward.photoPaths.first,
                            )
                          : null,
                      containerWidth: screenSize.width * 0.22,
                      containerHeight: screenSize.height * 0.3,
                      noImageContent: Container(
                        color: Colors.white,
                        child: Icon(Icons.redeem),
                      ),
                      context: context,
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    //details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '#${redeemedReward.code}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                redeemedReward.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),

                              const SizedBox(
                                height: 20,
                              ),

                              Text(
                                '${redeemedReward.points.toString()} pts',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      width: 20,
                    ),

                    Chip(
                      side: BorderSide.none,
                      label: Text(
                        redeemedReward.isClaimed == true
                            ? 'Claimed'
                            : 'Unclaimed',
                        style: TextStyle(color: Colors.white),
                      ),
                      labelStyle: Theme.of(context).textTheme.labelSmall,
                      padding: EdgeInsets.all(0),
                      backgroundColor: redeemedReward.isClaimed != true
                          ? Colors.green
                          : Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (redeemedReward.isClaimed == false && redeemedReward.expiryDate != null && redeemedReward.expiryDate!.isBefore(now))
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(200, 117, 117, 117),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Expired',
                    style: TextStyle(
                      color: Colors.grey.shade200,
                      fontWeight: FontWeight.bold,
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
