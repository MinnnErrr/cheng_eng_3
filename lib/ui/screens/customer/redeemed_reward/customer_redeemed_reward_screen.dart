import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/main.dart';
import 'package:cheng_eng_3/ui/screens/customer/redeemed_reward/customer_redeemed_reward_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/redeemed_reward_listitem.dart';
import 'package:cheng_eng_3/utils/search_sort_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerRedeemedRewardScreen extends ConsumerStatefulWidget {
  const CustomerRedeemedRewardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CustomerRedeemedRewardScreenState();
  }
}

class _CustomerRedeemedRewardScreenState
    extends ConsumerState<CustomerRedeemedRewardScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;

    if (user == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Main(),
        ),
      );
    }

    final redeemedRewards = ref.watch(redeemedRewardProvider(user!.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('My Rewards'),
      ),
      body: redeemedRewards.when(
        data: (rewards) {
          final searched = searchRedeemedReward(
            rewards: rewards,
            search: _search,
          );

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // search
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => _search = v),
                          decoration: InputDecoration(
                            hintText: "Search name...",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // reward list
                  Expanded(
                    child: searched.isEmpty
                        ? Center(
                            child: Text('No reward found'),
                          )
                        : ListView.separated(
                            itemCount: searched.length,
                            itemBuilder: (_, i) {
                              final r = searched[i];
                              return InkWell(
                                onTap:
                                    r.isClaimed == false &&
                                        r.expiryDate != null &&
                                        r.expiryDate!.isBefore(DateTime.now())
                                    ? null
                                    : () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerRedeemedRewardDetailsScreen(
                                                redeemedId: r.id,
                                              ),
                                        ),
                                      ),
                                child: RedeemedRewardListitem(
                                  redeemedReward: r,
                                ),
                              );
                            },
                            separatorBuilder: (context, i) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                          ),
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
}
