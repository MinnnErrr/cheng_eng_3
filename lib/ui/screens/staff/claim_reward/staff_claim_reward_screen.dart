import 'package:cheng_eng_3/core/controllers/profile/staff_user_profile_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/ui/screens/staff/claim_reward/staff_claim_reward_scanner_screen.dart';
import 'package:cheng_eng_3/ui/widgets/profile_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/redeemed_reward_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffClaimRewardScreen extends ConsumerStatefulWidget {
  const StaffClaimRewardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffClaimRewardScreenState();
}

class _StaffClaimRewardScreenState
    extends ConsumerState<StaffClaimRewardScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Claim Reward'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search ID...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StaffClaimRewardScannerScreen(),
                        ),
                      );

                      if (result != null && result is Map) {
                        setState(() {
                          _searchController.text =
                              result['redeemedRewardId'] ?? '';
                          _userId = result['userId'];
                        });
                      }
                    },
                    icon: Icon(Icons.qr_code_scanner),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              if (_searchController.text.trim().isNotEmpty && _userId != null)
                _details(_searchController.text.trim(), _userId!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _details(String redeemedId, String userId) {
    final redeemed = ref.watch(
      redeemedRewardByIdProvider((userId: userId, redeemedId: redeemedId)),
    );
    final profile = ref.watch(userProfileByUserIdProvider(userId));

    final hasError = profile.hasError || redeemed.hasError;

    if (hasError) {
      return Column(
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey),
          const SizedBox(height: 10),
          const Text(
            'No result found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.grey,
              ),
              onPressed: null,
              child: const Text('Claim Reward'),
            ),
          ),
        ],
      );
    }

    if (profile.isLoading || redeemed.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Both successful
    final profileData = profile.value!;
    final redeemedData = redeemed.value!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile Details'),
        ProfileListitem(profile: profileData),

        const SizedBox(height: 30),

        const Text('Reward Details'),
        RedeemedRewardListitem(redeemedReward: redeemedData),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final notifier = ref.read(
                redeemedRewardProvider(userId).notifier,
              );

              final message = await notifier.claimReward(
                userId: userId,
                redeemedId: redeemedId,
              );

              if (!mounted) return;
              showAppSnackBar(
                context: context,
                content: message.message,
                isError: !message.isSuccess,
              );
            },
            child: const Text('Claim Reward'),
          ),
        ),
      ],
    );
  }
}
