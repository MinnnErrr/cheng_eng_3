import 'package:cheng_eng_3/core/controllers/reward/customer_reward_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/reward/customer_reward_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/reward_listitem.dart';
import 'package:cheng_eng_3/utils/search_sort_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerRewardScreen extends ConsumerStatefulWidget {
  const CustomerRewardScreen({super.key});

  @override
  ConsumerState<CustomerRewardScreen> createState() =>
      _CustomerRewardScreenState();
}

class _CustomerRewardScreenState extends ConsumerState<CustomerRewardScreen> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final rewardState = ref.watch(customerRewardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: rewardState.when(
        data: (rewards) {
          final searched = searchReward(
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
                                child: RewardListitem(
                                  reward: r,
                                  isStaff: false,
                                ),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerRewardDetailsScreen(
                                          rewardId: r.id,
                                        ),
                                  ),
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
