import 'dart:convert';

import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/redeemed_reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/utils/status_colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomerRedeemedRewardDetailsScreen extends ConsumerStatefulWidget {
  const CustomerRedeemedRewardDetailsScreen({
    super.key,
    required this.reward,
  });
  final RedeemedReward reward;

  @override
  ConsumerState<CustomerRedeemedRewardDetailsScreen> createState() {
    return _CustomerRedeemedRewardDetailsScreenState();
  }
}

class _CustomerRedeemedRewardDetailsScreenState
    extends ConsumerState<CustomerRedeemedRewardDetailsScreen> {
  final PageController _pageController = PageController();
  final _dateFormatter = DateFormat('dd MMM yyyy, h:mm a'); // More readable

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    ref.watch(redeemedRewardRealTimeProvider);

    final asyncReward = ref.watch(
      redeeemdRewardByIdProvider(widget.reward.id),
    );
    final displayReward = asyncReward.value ?? widget.reward;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Details'),
        actions: [
          IconButton(
            onPressed: () => _showQrDialog(context, user.id, displayReward.id),
            icon: const Icon(
              Icons.qr_code,
            ),
            style: IconButton.styleFrom(foregroundColor: Color(0xFF9E7C00)),
            tooltip: "Show QR Code",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HERO IMAGE SLIDER (Fixed Layout)
              _buildImageSlider(displayReward, theme),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. EXPIRY BANNER
                    if (displayReward.expiryDate != null)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: displayReward.isClaimed
                              ? Colors
                                    .grey
                                    .shade200 // Grey if used
                              : theme
                                    .colorScheme
                                    .errorContainer, // Red if active/expiring
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time_filled,
                              size: 18,
                              color: displayReward.isClaimed
                                  ? Colors.grey
                                  : theme.colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Expires: ${_dateFormatter.format(displayReward.expiryDate!)}',
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: displayReward.isClaimed
                                    ? Colors.grey.shade700
                                    : theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // 3. TITLE & STATUS
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${displayReward.code}',
                          style: theme.textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9E7C00),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayReward.name,
                          style: theme.textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 4. METADATA GRID
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        // Add subtle border to match app theme
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildMetaRow(
                            context,
                            'Status',
                            displayReward.isClaimed ? 'USED' : 'ACTIVE',
                            valueColor: getRedeemedRewardStatusColor(
                              displayReward.isClaimed,
                              context,
                            ),
                          ),
                          const Divider(height: 24),
                          _buildMetaRow(
                            context,
                            'Redeemed On',
                            _dateFormatter.format(displayReward.createdAt),
                          ),
                          const Divider(height: 24),
                          _buildMetaRow(
                            context,
                            'Points Used',
                            '${displayReward.points} pts',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 5. DESCRIPTION
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      displayReward.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 6. REMARKS (Friendly Style)
                    if (displayReward.conditions?.isNotEmpty == true)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              displayReward.conditions!,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Bottom Padding
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Fixed Image Slider (No Expanded issue)
  Widget _buildImageSlider(RedeemedReward reward, ThemeData theme) {
    if (reward.photoPaths.isEmpty) {
      return Container(
        height: 250,
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
              'No image found',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    final imageService = ref.read(imageServiceProvider);

    return SizedBox(
      height: 250,
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
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
                loadingBuilder: (_, child, loading) {
                  if (loading == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),

          // Gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 50,
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

          // Dots
          if (reward.photoPaths.length > 1)
            Positioned(
              bottom: 12,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: reward.photoPaths.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white54,
                  expansionFactor: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  void _showQrDialog(BuildContext context, String userId, String rewardId) {
    final qrData = jsonEncode({
      'userId': userId,
      'redeemedRewardId': rewardId,
    });

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scan to Claim',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Show this code to the staff',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // White container ensures high contrast for scanning
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
