import 'package:cheng_eng_3/core/controllers/profile/user_profile_provider.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/ui/widgets/profile_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/redeemed_reward_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardClaimContent extends ConsumerStatefulWidget {
  const RewardClaimContent({
    super.key,
    required this.userId,
    required this.redeemedId,
  });

  final String userId;
  final String redeemedId;

  @override
  ConsumerState<RewardClaimContent> createState() =>
      __RewardClaimContentState();
}

class __RewardClaimContentState extends ConsumerState<RewardClaimContent> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // 1. Keep data fresh
    ref.watch(redeemedRewardRealTimeProvider);

    // 2. Watch Providers
    final redeemedAsync = ref.watch(
      redeeemdRewardByIdProvider(widget.redeemedId),
    );
    final profileAsync = ref.watch(userProfileByUserIdProvider(widget.userId));

    // 3. Handle Loading/Error States elegantly
    if (redeemedAsync.isLoading || profileAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (redeemedAsync.hasError || profileAsync.hasError) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 10),
            const Expanded(child: Text("Record not found or invalid ID.")),
          ],
        ),
      );
    }

    // 4. Data is ready
    final redeemedData = redeemedAsync.value!;
    final profileData = profileAsync.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        ProfileListitem(profile: profileData),

        const SizedBox(height: 30),

        Text(
          'Reward Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        RedeemedRewardListitem(redeemedReward: redeemedData),

        const SizedBox(height: 40),

        // 5. Action Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            // Disable if loading OR if already claimed
            onPressed: _isLoading || redeemedData.isClaimed
                ? null
                : () async {
                    setState(() => _isLoading = true);

                    final notifier = ref.read(
                      redeemedRewardProvider(widget.userId).notifier,
                    );

                    final message = await notifier.claimReward(
                      redeemedId: widget.redeemedId,
                    );

                    if (context.mounted) {
                      setState(() => _isLoading = false);
                      showAppSnackBar(
                        context: context,
                        content: message.message,
                        isError: !message.isSuccess,
                      );

                      // Optional: Navigate back on success
                      if (message.isSuccess) {
                        Navigator.pop(context);
                      }
                    }
                  },
            child: _isLoading
                ? const CircularProgressIndicator.adaptive()
                : Text(
                    redeemedData.isClaimed ? 'Already Claimed' : 'Claim Reward',
                  ),
          ),
        ),
      ],
    );
  }
}
