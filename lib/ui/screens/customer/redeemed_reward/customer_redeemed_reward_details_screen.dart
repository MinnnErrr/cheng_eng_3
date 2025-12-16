import 'dart:convert';

import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/redeemed_reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
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
  final _dateFormatter = DateFormat('dd/MM/yyyy').add_jm();

  @override
  Widget build(BuildContext context) {
    // 1. Safe Auth Check
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    // 2. Realtime Updates
    ref.watch(redeemedRewardRealTimeProvider);

    // 3. Optimistic UI Pattern
    // Watch for updates, but default to the widget.reward passed from the list.
    final asyncReward = ref.watch(
      redeeemdRewardByIdProvider(widget.reward.id),
    );
    final displayReward = asyncReward.value ?? widget.reward;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Details'),
        actions: [
          IconButton(
            // Pass data directly, no need for local state variables
            onPressed: () => _showQrDialog(context, user.id, displayReward.id),
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20, // Requires Flutter 3.27+, else use SizedBox
            children: [
              // PHOTO CAROUSEL
              SizedBox(
                height: 250,
                width: double.infinity,
                child: displayReward.photoPaths.isEmpty
                    ? Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                            Text('No image found', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: displayReward.photoPaths.length,
                              itemBuilder: (context, index) {
                                final imageService = ref.read(imageServiceProvider);
                                final imageUrl = imageService.retrieveImageUrl(
                                  displayReward.photoPaths[index],
                                );

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.expectedTotalBytes != null
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
                            count: displayReward.photoPaths.length,
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

              // EXPIRY BANNER
              if (displayReward.expiryDate != null)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Expiry Date: ${_dateFormatter.format(displayReward.expiryDate!)}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),

              // DETAILS
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '#${displayReward.code}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      displayReward.name,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Metadata Rows
                    _buildMetaRow(
                      context, 
                      'Status', 
                      displayReward.isClaimed ? 'Claimed' : 'Unclaimed',
                      valueColor: displayReward.isClaimed ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    _buildMetaRow(
                      context, 
                      'Redeemed at', 
                      _dateFormatter.format(displayReward.createdAt)
                    ),
                    const SizedBox(height: 10),
                    _buildMetaRow(
                      context, 
                      'Updated at', 
                      displayReward.updatedAt != null 
                        ? _dateFormatter.format(displayReward.updatedAt!) 
                        : '-'
                    ),
                    const SizedBox(height: 10),
                    _buildMetaRow(
                      context, 
                      'Points used', 
                      '${displayReward.points} pts',
                      valueColor: Theme.of(context).colorScheme.primary
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
                    Text(displayReward.description),
                  ],
                ),
              ),

              // REMARKS
              if (displayReward.conditions != null && displayReward.conditions!.isNotEmpty)
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
                        'Remarks',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        displayReward.conditions!,
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
    );
  }

  Widget _buildMetaRow(BuildContext context, String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // FIX: correct method
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // FIX: Don't take full height
            children: [
              const Text(
                'Show this QR to the staff for claiming the reward',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.white, // Ensure high contrast for scanner
                padding: const EdgeInsets.all(10),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              )
            ],
          ),
        ),
      ),
    );
  }
}