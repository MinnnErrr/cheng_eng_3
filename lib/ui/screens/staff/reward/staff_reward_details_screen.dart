import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/reward/reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/reward/staff_rewards_notifier.dart';
import 'package:cheng_eng_3/core/models/reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/screens/staff/reward/staff_reward_update_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StaffRewardDetailsScreen extends ConsumerStatefulWidget {
  const StaffRewardDetailsScreen({super.key, required this.reward});

  final Reward reward;

  @override
  ConsumerState<StaffRewardDetailsScreen> createState() {
    return _StaffRewardDetailsScreenState();
  }
}

class _StaffRewardDetailsScreenState
    extends ConsumerState<StaffRewardDetailsScreen> {
  // 1. Removed 'late Reward _displayedReward'
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 2. Removed 'initState' entirely. It is not needed for this pattern.

  @override
  Widget build(BuildContext context) {
    // Keep the realtime listener alive
    ref.watch(rewardRealTimeProvider);

    // 3. THE KEY LOGIC FIX:
    // Listen to the specific reward ID.
    final rewardAsync = ref.watch(rewardByIdProvider(widget.reward.id));

    // "Optimistic UI":
    // Use the latest data from the provider (rewardAsync.valueOrNull).
    // If that is null (loading/error), fallback to the data passed 
    // from the previous screen (widget.reward).
    final Reward displayedReward = rewardAsync.value ?? widget.reward;
    
    // Status Logic
    bool isActive = displayedReward.status;
    
    final notifier = ref.read(staffRewardsProvider.notifier);
    DateFormat dateFormmatter = DateFormat('dd/MM/yyyy').add_jm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              // --- Status Section ---
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? Colors.green
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Switch(
                      value: isActive,
                      activeThumbColor: Colors.green,
                      onChanged: (value) async {
                        // 4. Cleaned up Switch Logic
                        // Don't set local state manually. Let the backend update,
                        // which triggers the stream, which updates 'displayedReward'.
                        final message = await notifier.updateStatus(
                          id: displayedReward.id,
                          isActive: value,
                        );

                        if (!context.mounted) return;
                        
                        // Only show snackbar if it fails or if you specifically want confirmation
                        if (!message.isSuccess) {
                           showAppSnackBar(
                            context: context,
                            content: message.message,
                            isError: true,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              // --- Product Details Section ---
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  spacing: 30,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Reward Details',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => StaffRewardUpdateScreen(
                                  reward: displayedReward,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                    
                    // Image Section (Logic unchanged, just using displayedReward)
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: displayedReward.photoPaths.isEmpty
                          ? Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.image_not_supported),
                                  Text('No image found'),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Expanded(
                                  child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: displayedReward.photoPaths.length,
                                    itemBuilder: (context, index) {
                                      final imageService = ref.read(imageServiceProvider);
                                      final imageUrl = imageService.retrieveImageUrl(
                                          displayedReward.photoPaths[index]);

                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          imageUrl,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (context, child, progress) {
                                            if (progress == null) return child;
                                            return Center(
                                                child: CircularProgressIndicator(
                                              value: progress.expectedTotalBytes != null
                                                  ? progress.cumulativeBytesLoaded /
                                                      progress.expectedTotalBytes!
                                                  : null,
                                            ));
                                          },
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image, size: 40),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SmoothPageIndicator(
                                  controller: _pageController,
                                  count: displayedReward.photoPaths.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    activeDotColor: Theme.of(context).colorScheme.primary,
                                    dotColor: Colors.grey.shade400,
                                    expansionFactor: 3,
                                  ),
                                ),
                              ],
                            ),
                    ),

                    // ... The Rest of Text Details ... 
                    // (Ensure you use 'displayedReward' instead of '_displayedReward' here)
                    Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('#${displayedReward.code}', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                         Text(displayedReward.name, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold)),
                       ]
                    ),
                    
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantity'),
                            Text(displayedReward.quantity.toString()),
                          ],
                        ),
                        Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Available Until'),
                            Text(
                              displayedReward.availableUntil != null
                                  ? dateFormmatter.format(
                                      displayedReward.availableUntil!,
                                    )
                                  : '-',
                            ),
                          ],
                        ),
                        Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Validity Period'),
                            Text(
                              displayedReward.validityWeeks != null
                                  ? '${displayedReward.validityWeeks} weeks'
                                  : '-',
                            ),
                          ],
                        ),
                        Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Created at'),
                            Text(
                              dateFormmatter.format(displayedReward.createdAt),
                            ),
                          ],
                        ),
                        Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Updated at'),
                            Text(
                              displayedReward.updatedAt != null
                                  ? dateFormmatter.format(
                                      displayedReward.updatedAt!,
                                    )
                                  : '-',
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    _detail(
                      title: 'Description',
                      content: displayedReward.description,
                    ),
                    _detail(
                      title: 'Terms & Conditions',
                      content: displayedReward.conditions ?? '-',
                    ),
                  ],
                ),
              ),

              // --- Delete Button with Confirmation ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () async {
                  // 5. Added Confirmation Dialog
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Reward'),
                      content: const Text('Are you sure? This cannot be undone.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  );

                  if (confirm != true) return;

                  final message = await notifier.deleteReward(displayedReward.id);

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
                child: const Text('Delete Reward'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          content,
          softWrap: true,
        ),
      ],
    );
  }
}
