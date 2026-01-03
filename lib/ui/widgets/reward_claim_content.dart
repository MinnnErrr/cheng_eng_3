import 'package:cheng_eng_3/core/controllers/profile/user_profile_provider.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/ui/widgets/profile_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/redeemed_reward_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RewardClaimContent extends ConsumerStatefulWidget {
  const RewardClaimContent({
    super.key,
    this.userId, // Nullable (if manual search)
    required this.redeemedId,
  });

  final String? userId;
  final String redeemedId;

  @override
  ConsumerState<RewardClaimContent> createState() =>
      __RewardClaimContentState();
}

class __RewardClaimContentState extends ConsumerState<RewardClaimContent> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(redeemedRewardRealTimeProvider);
    final theme = Theme.of(context);

    // --- STEP 1: Fetch Reward Data ---
    final redeemedAsync = ref.watch(
      redeeemdRewardByIdProvider(widget.redeemedId),
    );

    // Handle Reward Loading/Error BEFORE accessing .value
    if (redeemedAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (redeemedAsync.hasError || redeemedAsync.value == null) {
      return _buildErrorState(theme, "Reward ID not found.");
    }

    final redeemedData = redeemedAsync.value!;

    final isExpired =
        !redeemedData.isClaimed &&
        redeemedData.expiryDate != null &&
        redeemedData.expiryDate!.isBefore(DateTime.now());

    // --- STEP 2: Fetch Profile Data ---
    // Use the passed userId OR the one found in the reward data
    final targetUserId = widget.userId ?? redeemedData.userId;
    final profileAsync = ref.watch(userProfileByUserIdProvider(targetUserId));

    if (profileAsync.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (profileAsync.hasError || profileAsync.value == null) {
      return _buildErrorState(theme, "User profile not found.");
    }

    final profileData = profileAsync.value!;

    // --- STEP 3: Display Content ---
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: "Customer"),
        const SizedBox(height: 8),
        ProfileListitem(
          email: profileData.email,
          name: profileData.name,
          dialCode: profileData.dialCode,
          phoneNum: profileData.phoneNum,
          gender: profileData.gender,
        ),

        const SizedBox(height: 24),

        _SectionHeader(title: "Reward Item"),
        const SizedBox(height: 8),
        RedeemedRewardListitem(redeemedReward: redeemedData),

        const SizedBox(height: 40),

        // Action Button
        FilledButton(
          onPressed: _isLoading || redeemedData.isClaimed || isExpired
              ? null
              : () => _handleClaim(redeemedData.isClaimed, targetUserId),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  redeemedData.isClaimed
                      ? 'CLAIMED'
                      : isExpired
                      ? 'EXPIRED'
                      : 'CLAIM REWARD',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),

        if (redeemedData.isClaimed)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: Text(
                redeemedData.updatedAt != null
                    ? "Claimed on: ${DateFormat('dd/MM/yyyy h:mm a').format(redeemedData.updatedAt!)}"
                    : 'Unknown',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorState(ThemeData theme, String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleClaim(bool isAlreadyClaimed, String userId) async {
    if (isAlreadyClaimed) return;

    setState(() => _isLoading = true);

    final notifier = ref.read(
      redeemedRewardProvider(userId).notifier,
    );

    final message = await notifier.claimReward(
      redeemedId: widget.redeemedId,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      showAppSnackBar(
        context: context,
        content: message.message,
        isError: !message.isSuccess,
      );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
