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
  });

  final Reward reward;
  final bool isStaff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final screenSize = MediaQuery.of(context).size;
    final dateformatter = DateFormat('dd/MM/yyyy').add_jm();

    return Card(
      clipBehavior: Clip.hardEdge,
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          if (reward.availableUntil != null)
            Container(
              padding: EdgeInsets.all(5),
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                'Available until: ${dateformatter.format(reward.availableUntil!)}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //picture
                  imageBuilder(
                    url: reward.photoPaths.isNotEmpty
                        ? imageService.retrieveImageUrl(reward.photoPaths.first)
                        : null,
                    containerWidth: screenSize.width * 0.22,
                    containerHeight: double.infinity,
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
                              '#${reward.code}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              reward.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            Text(
                              '${reward.points.toString()} pts',
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

                  if (isStaff == true)
                    Column(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Chip(
                          side: BorderSide.none,
                          label: Text(
                            reward.status == true ? 'Active' : 'Inactive',
                            style: TextStyle(color: Colors.white),
                          ),
                          labelStyle: Theme.of(context).textTheme.labelSmall,
                          padding: EdgeInsets.all(0),
                          backgroundColor: reward.status == true
                              ? Colors.green
                              : Theme.of(context).colorScheme.error,
                        ),

                        const Spacer(),

                        Text(
                          'Qty: ${reward.quantity}',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: reward.quantity > 0
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
