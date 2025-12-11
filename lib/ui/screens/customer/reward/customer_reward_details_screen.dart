import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/customer_point_history_notifier.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/core/controllers/reward/customer_reward_notifier.dart';
import 'package:cheng_eng_3/core/models/reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/main.dart';
import 'package:cheng_eng_3/ui/screens/customer/redeemed_reward/customer_redeemed_reward_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomerRewardDetailsScreen extends ConsumerStatefulWidget {
  const CustomerRewardDetailsScreen({super.key, required this.rewardId});
  final String rewardId;

  @override
  ConsumerState<CustomerRewardDetailsScreen> createState() {
    return _CustomerRewardDetailsScreenState();
  }
}

class _CustomerRewardDetailsScreenState
    extends ConsumerState<CustomerRewardDetailsScreen> {
  final PageController _pageController = PageController();
  final _dateFormatter = DateFormat('dd/MM/yyyy').add_jm();
  Reward? _reward;

  @override
  Widget build(BuildContext context) {
    final rewardState = ref.watch(
      customerRewardByIdProvider(widget.rewardId),
    );

    final user = ref.watch(authProvider).value;
    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Main(),
        ),
        (route) => false,
      );
    }
    final totalPoints = ref.watch(totalPointsProvider(user!.id));
    final redeemedRewardNotifier = ref.read(
      redeemedRewardProvider(user.id).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Reward Details'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CustomerRedeemedRewardScreen(),
              ),
            ),
            child: Icon(Icons.card_giftcard),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 20),
      ),
      body: rewardState.when(
        data: (reward) {
          setState(() {
            _reward = reward;
          });
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  //photo
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: reward.photoPaths.isEmpty
                        ? Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported),
                                Text('No image found'),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              //image
                              Expanded(
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: reward.photoPaths.length,
                                  itemBuilder: (context, index) {
                                    final imageService = ref.read(
                                      imageServiceProvider,
                                    );
                                    final imageUrl = imageService
                                        .retrieveImageUrl(
                                          reward.photoPaths[index],
                                        );

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                      child: Image.network(
                                        imageUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  progress.expectedTotalBytes !=
                                                      null
                                                  ? progress.cumulativeBytesLoaded /
                                                        progress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),

                              //dots
                              SmoothPageIndicator(
                                controller: _pageController,
                                count: reward.photoPaths.length,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  dotColor: Colors.grey.shade400,
                                  expansionFactor: 3,
                                ),
                              ),
                            ],
                          ),
                  ),

                  if (reward.availableUntil != null)
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'This reward is available until ${_dateFormatter.format(reward.availableUntil!)}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),

                  //details
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${reward.code}',
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),

                        Text(
                          reward.name,
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Text('Points required: '),
                        Text(
                          '${reward.points.toString()} pts',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),

                  //description
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          reward.description,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),

                  //remarks
                  if (reward.conditions != null)
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.errorContainer,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remarks',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            reward.conditions!,
                            softWrap: true,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
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
      bottomNavigationBar: BottomAppBar(
        height: MediaQuery.of(context).size.height * 0.11,
        child: totalPoints.when(
          data: (total) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //quantity
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You have",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '$total pts',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  width: 20,
                ),

                _reward == null
                    ? Expanded(
                        child: ElevatedButton(
                          onPressed: null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.grey,
                          ),
                          child: Text('Unavailable'),
                        ),
                      )
                    : Expanded(
                        child: ElevatedButton(
                          onPressed: total >= _reward!.points
                              ? () async {
                                  final message = await redeemedRewardNotifier
                                      .addRedeemedReward(
                                        rewardId: _reward!.id,
                                        userId: user.id,
                                      );

                                  if (!context.mounted) return;
                                  showAppSnackBar(
                                    context: context,
                                    content: message.message,
                                    isError: !message.isSuccess,
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: total >= _reward!.points
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade200,
                            foregroundColor: total >= _reward!.points
                                ? Theme.of(context).colorScheme.onPrimary
                                : Colors.grey,
                          ),
                          child: Text('Redeem Reward'),
                        ),
                      ),
              ],
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(
              'Error retrieving user points',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
