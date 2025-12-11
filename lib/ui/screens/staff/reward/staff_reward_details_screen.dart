import 'package:cheng_eng_3/core/controllers/reward/staff_reward_notifier.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/screens/staff/reward/staff_reward_update_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StaffRewardDetailsScreen extends ConsumerStatefulWidget {
  const StaffRewardDetailsScreen({super.key, required this.rewardId});

  final String rewardId;

  @override
  ConsumerState<StaffRewardDetailsScreen> createState() {
    return _StaffRewardDetailsScreenState();
  }
}

class _StaffRewardDetailsScreenState
    extends ConsumerState<StaffRewardDetailsScreen> {
  late bool _isActive;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final rewardState = ref.watch(staffRewardByIdProvider(widget.rewardId));
    final notifier = ref.read(
      staffRewardProvider.notifier,
    );
    DateFormat dateFormmatter = DateFormat('dd/MM/yyyy').add_jm();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reward Details'),
      ),
      body: rewardState.when(
        data: (reward) {
          _isActive = reward.status;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  //product status
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(
                          'Status',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          _isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _isActive
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Switch(
                          value: _isActive,
                          activeThumbColor: Colors.green,
                          onChanged: (value) async {
                            setState(() {
                              _isActive = value;
                            });

                            final message = await notifier.updateStatus(
                              id: widget.rewardId,
                              isActive: value,
                            );
                            if (!context.mounted) return;
                            showAppSnackBar(
                              context: context,
                              content: message.message,
                              isError: !message.isSuccess,
                            );
                            if (!message.isSuccess) {
                              setState(() {
                                _isActive = !value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  //product details
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      spacing: 30,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reward Details',
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StaffRewardUpdateScreen(
                                      rewardId: reward.id,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        ),
                        //picture section
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
                                                if (progress == null)
                                                  return child;
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
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
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

                        //details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${reward.code}',
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            Text(
                              reward.name,
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Quantity'),
                                Text(reward.quantity.toString()),
                              ],
                            ),
                            Divider(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Available Until'),
                                Text(
                                  reward.availableUntil != null
                                      ? dateFormmatter.format(
                                          reward.availableUntil!,
                                        )
                                      : '-',
                                ),
                              ],
                            ),
                            Divider(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Has Expiry Date'),
                                Text(reward.hasExpiry == true ? 'Yes' : 'No'),
                              ],
                            ),
                            Divider(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Created at'),
                                Text(dateFormmatter.format(reward.createdAt)),
                              ],
                            ),
                            Divider(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Updated at'),
                                Text(
                                  reward.updatedAt != null
                                      ? dateFormmatter.format(reward.updatedAt!)
                                      : '-',
                                ),
                              ],
                            ),
                          ],
                        ),

                        _detail(
                          title: 'Description',
                          content: reward.description,
                        ),
                        _detail(
                          title: 'Terms & Conditions',
                          content: reward.conditions ?? '-',
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      final message = await notifier.deleteReward(reward.id);

                      if (!context.mounted) return;
                      showAppSnackBar(
                        context: context,
                        content: message.message,
                        isError: !message.isSuccess,
                      );

                      if (message.isSuccess) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Delete Reward'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _detail({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          content,
          softWrap: true,
        ),
      ],
    );
  }
}
