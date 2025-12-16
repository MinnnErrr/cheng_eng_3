import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/total_points_provider.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/core/controllers/reward/reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/screens/customer/redeemed_reward/customer_redeemed_reward_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomerRewardDetailsScreen extends ConsumerStatefulWidget {
  const CustomerRewardDetailsScreen({super.key, required this.reward});
  final Reward reward;

  @override
  ConsumerState<CustomerRewardDetailsScreen> createState() {
    return _CustomerRewardDetailsScreenState();
  }
}

class _CustomerRewardDetailsScreenState
    extends ConsumerState<CustomerRewardDetailsScreen> {
  final PageController _pageController = PageController();
  final _dateFormatter = DateFormat('dd/MM/yyyy').add_jm();

  // Local loading state for button
  bool _isRedeeming = false;

  @override
  Widget build(BuildContext context) {
    // 1. Keep Realtime Alive
    ref.watch(rewardRealTimeProvider);

    // 2. Auth Safety
    final user = ref.watch(authProvider).value;
    if (user == null) {
      // Return simple loader, let your main Router handle the redirect logic
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    // 3. OPTIMISTIC UI PATTERN
    // Use the passed 'widget.reward' immediately.
    // If the provider updates (realtime), 'rewardAsync.value' will take over.
    final rewardAsync = ref.watch(rewardByIdProvider(widget.reward.id));
    final currentReward = rewardAsync.value ?? widget.reward;

    final totalPointsAsync = ref.watch(totalPointsProvider(user.id));

    ref.watch(redeemedRewardProvider(user.id));
    // We only read notifier for actions
    final redeemedRewardNotifier = ref.read(
      redeemedRewardProvider(user.id).notifier,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Details'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CustomerRedeemedRewardScreen(),
              ),
            ),
            child: const Icon(Icons.card_giftcard),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20, // Requires Flutter 3.27+
            children: [
              // PHOTO SECTION
              SizedBox(
                height: 250,
                width: double.infinity,
                child: currentReward.photoPaths.isEmpty
                    ? Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey,
                            ),
                            Text(
                              'No image found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: currentReward.photoPaths.length,
                              itemBuilder: (context, index) {
                                final imageService = ref.read(
                                  imageServiceProvider,
                                );
                                final imageUrl = imageService.retrieveImageUrl(
                                  currentReward.photoPaths[index],
                                );

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.broken_image),
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              progress.expectedTotalBytes !=
                                                  null
                                              ? progress.cumulativeBytesLoaded /
                                                    progress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          SmoothPageIndicator(
                            controller: _pageController,
                            count: currentReward.photoPaths.length,
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

              // AVAILABILITY BANNER
              if (currentReward.availableUntil != null)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Available until ${_dateFormatter.format(currentReward.availableUntil!)}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // DETAILS CARD
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${currentReward.code}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      currentReward.name,
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text('Points required: '),
                        Text(
                          '${currentReward.points} pts',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // DESCRIPTION
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(currentReward.description),
                  ],
                ),
              ),

              // REMARKS / CONDITIONS
              if (currentReward.conditions != null &&
                  currentReward.conditions!.isNotEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conditions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        currentReward.conditions!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        child: totalPointsAsync.when(
          data: (total) {
            final canAfford = total >= currentReward.points;

            return Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You have"),
                    Text(
                      '$total pts',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: canAfford ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (canAfford && !_isRedeeming)
                          ? () => _confirmRedemption(
                              context,
                              redeemedRewardNotifier,
                              currentReward,
                              user.id,
                            )
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canAfford
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        foregroundColor: canAfford
                            ? Theme.of(context).colorScheme.onPrimary
                            : Colors.grey.shade600,
                      ),
                      child: _isRedeeming
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              canAfford
                                  ? 'Redeem Reward'
                                  : 'Insufficient Points',
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => const Center(child: Text('Error loading points')),
        ),
      ),
    );
  }

  // Confirmation Dialog + Redemption Logic
  Future<void> _confirmRedemption(
    BuildContext context,
    RedeemedRewardNotifier notifier,
    Reward reward,
    String userId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Redemption"),
        content: Text(
          "Use ${reward.points} points to redeem '${reward.name}'?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Redeem"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isRedeeming = true);

      final message = await notifier.addRedeemedReward(
        rewardId: reward.id,
        userId: userId,
      );

      if (context.mounted) {
        setState(() => _isRedeeming = false);

        showAppSnackBar(
          context: context,
          content: message.message,
          isError: !message.isSuccess,
        );

        if (message.isSuccess) {
          Navigator.pop(context); // Optional: Go back after success
        }
      }
    }
  }
}
