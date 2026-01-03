import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
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
  ConsumerState<StaffRewardDetailsScreen> createState() =>
      _StaffRewardDetailsScreenState();
}

class _StaffRewardDetailsScreenState
    extends ConsumerState<StaffRewardDetailsScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Keep real-time listener active
    ref.watch(rewardRealTimeProvider);

    // Watch specific ID
    final rewardAsync = ref.watch(rewardByIdProvider(widget.reward.id));
    final Reward displayedReward = rewardAsync.value ?? widget.reward;
    final bool isActive = displayedReward.status;
    final notifier = ref.read(staffRewardsProvider.notifier);
    final theme = Theme.of(context);
    final dateFormmatter = DateFormat('dd MMM yyyy, h:mm a');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Reward Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      StaffRewardUpdateScreen(reward: displayedReward),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            tooltip: "Edit Reward",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- 1. STATUS CARD ---
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withValues(alpha: 0.1)
                      : theme.colorScheme.errorContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive ? Colors.green : theme.colorScheme.error,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isActive ? Icons.check_circle : Icons.unpublished,
                      color: isActive ? Colors.green : theme.colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CURRENT STATUS",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            isActive ? "ACTIVE (VISIBLE)" : "INACTIVE (HIDDEN)",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w900,
                              color: isActive
                                  ? Colors.green.shade800
                                  : theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isActive,
                      activeThumbColor: Colors.green,
                      onChanged: (value) async {
                        final message = await notifier.updateStatus(
                          id: displayedReward.id,
                          isActive: value,
                        );
                        if (!context.mounted) return;
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

              const SizedBox(height: 24),

              // --- 2. MAIN DETAILS CARD ---
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Image Carousel
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: displayedReward.photoPaths.isEmpty
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No images available',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  itemCount: displayedReward.photoPaths.length,
                                  itemBuilder: (context, index) {
                                    final imageService = ref.read(
                                      imageServiceProvider,
                                    );
                                    final imageUrl = imageService
                                        .retrieveImageUrl(
                                          displayedReward.photoPaths[index],
                                        );

                                    return ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        imageUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey.shade200,
                                          child: const Center(
                                            child: Icon(Icons.broken_image),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                if (displayedReward.photoPaths.length > 1)
                                  Positioned(
                                    bottom: 12,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: SmoothPageIndicator(
                                        controller: _pageController,
                                        count:
                                            displayedReward.photoPaths.length,
                                        effect: ExpandingDotsEffect(
                                          dotHeight: 8,
                                          dotWidth: 8,
                                          activeDotColor:
                                              theme.colorScheme.primary,
                                          dotColor: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ),

                    // B. Text Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#${displayedReward.code}',
                                      style: TextStyle(
                                        color: textYellow,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Monospace',
                                      ),
                                    ),
                                    Text(
                                      displayedReward.name,
                                      style: theme.textTheme.titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              // Points Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary, // Yellow
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "${displayedReward.points} PTS",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: theme.colorScheme.onPrimary, // Black
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Specs Grid
                          _buildDetailRow(
                            context,
                            'Quantity Available',
                            displayedReward.quantity.toString(),
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context,
                            'Available Until',
                            displayedReward.availableUntil != null
                                ? dateFormmatter.format(
                                    displayedReward.availableUntil!,
                                  )
                                : 'Permanent',
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context,
                            'Validity Period',
                            displayedReward.validityWeeks != null
                                ? '${displayedReward.validityWeeks} Weeks'
                                : 'Unlimited',
                          ),

                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),

                          // Metadata
                          _buildDetailRow(
                            context,
                            'Created On',
                            dateFormmatter.format(displayedReward.createdAt),
                            isMeta: true,
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow(
                            context,
                            'Last Updated',
                            displayedReward.updatedAt != null
                                ? dateFormmatter.format(
                                    displayedReward.updatedAt!,
                                  )
                                : '-',
                            isMeta: true,
                          ),

                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),

                          // Long Text
                          _buildLongTextSection(
                            context,
                            "Description",
                            displayedReward.description,
                          ),
                          const SizedBox(height: 20),
                          _buildLongTextSection(
                            context,
                            "Terms & Conditions",
                            displayedReward.conditions ?? '-',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- 3. DELETE BUTTON ---
              SizedBox(
                height: 54,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.error),
                    foregroundColor: theme.colorScheme.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Reward'),
                        content: const Text(
                          'Are you sure you want to delete this reward?\nThis action cannot be undone.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(
                              'Delete',
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    final message = await notifier.deleteReward(
                      displayedReward.id,
                    );

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
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('DELETE REWARD'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for single line details
  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isMeta = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isMeta ? FontWeight.normal : FontWeight.w600,
            fontSize: 14,
            color: isMeta
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  // Helper for long text blocks
  Widget _buildLongTextSection(
    BuildContext context,
    String title,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
