import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
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
  final _dateFormatter = DateFormat('dd MMM yyyy');

  bool _isRedeeming = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(rewardRealTimeProvider);

    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    final rewardAsync = ref.watch(rewardByIdProvider(widget.reward.id));
    final currentReward = rewardAsync.value ?? widget.reward;

    final totalPointsAsync = ref.watch(totalPointsProvider(user.id));

    final redeemedRewardNotifier = ref.watch(
      redeemedRewardProvider(user.id).notifier,
    );

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Details'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CustomerRedeemedRewardScreen(),
              ),
            ),
            icon: const Icon(Icons.history),
            tooltip: "My Redemptions",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HERO IMAGE SLIDER ---
              _buildImageSlider(currentReward, theme),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 2. HEADER INFO ---
                    if (currentReward.availableUntil != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Valid until: ${_dateFormatter.format(currentReward.availableUntil!)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    Text(
                      currentReward.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Text(
                        '#${currentReward.code}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace', 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- 3. POINTS & STOCK ROW ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Points Required",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '${currentReward.points}',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: textYellow,
                                      ),
                                ),
                                const SizedBox(width: 4  ),
                                Text(
                                  'PTS',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: textYellow,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: currentReward.quantity > 0
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                currentReward.quantity > 0
                                    ? '${currentReward.quantity} In Stock'
                                    : 'Out of Stock',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: currentReward.quantity > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const Divider(),
                    const SizedBox(height: 15),

                    // --- 4. DESCRIPTION ---
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentReward.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- 5. CONDITIONS ---
                    if (currentReward.conditions != null &&
                        currentReward.conditions!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Terms & Conditions',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentReward.conditions!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
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
      ),

      // --- BOTTOM BAR ---
      bottomNavigationBar: BottomAppBar(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: theme.colorScheme.surface,
        child: totalPointsAsync.when(
          data: (total) {
            final canAfford = total >= currentReward.points;
            final hasStock = currentReward.quantity > 0;
            final isEligible = canAfford && hasStock;

            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "My Balance",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$total pts',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: canAfford
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: (isEligible && !_isRedeeming)
                          ? () => _confirmRedemption(
                              context,
                              redeemedRewardNotifier,
                              currentReward,
                              user.id,
                              total,
                            )
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: _isRedeeming
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              !hasStock
                                  ? 'OUT OF STOCK'
                                  : !canAfford
                                  ? 'NOT ENOUGH POINTS'
                                  : 'REDEEM NOW',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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

  Widget _buildImageSlider(Reward reward, ThemeData theme) {
    if (reward.photoPaths.isEmpty) {
      return Container(
        height: 300,
        width: double.infinity,
        color: theme.colorScheme.surfaceContainerHigh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'No image provided',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    final imageService = ref.read(imageServiceProvider);

    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: reward.photoPaths.length,
            itemBuilder: (context, index) {
              final imageUrl = imageService.retrieveImageUrl(
                reward.photoPaths[index],
              );
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: theme.colorScheme.surfaceContainer,
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
                loadingBuilder: (_, child, loading) {
                  if (loading == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
          if (reward.photoPaths.length > 1)
            Positioned(
              bottom: 16,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: reward.photoPaths.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white.withValues(alpha: 0.5),
                  expansionFactor: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _confirmRedemption(
    BuildContext context,
    RedeemedRewardNotifier notifier,
    Reward reward,
    String userId,
    int currentPoints,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Redeem Reward"),
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
            child: const Text("Confirm"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isRedeeming = true);

      final message = await notifier.addRedeemedReward(
        reward: reward,
        userId: userId,
        currentPoints: currentPoints,
      );

      if (context.mounted) {
        setState(() => _isRedeeming = false);

        showAppSnackBar(
          context: context,
          content: message.message,
          isError: !message.isSuccess,
        );
      }
    }
  }
}
