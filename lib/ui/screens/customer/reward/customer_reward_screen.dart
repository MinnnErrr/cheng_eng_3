import 'package:cheng_eng_3/core/controllers/reward/customer_rewards_notifier.dart';
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
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = "";

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rewardState = ref.watch(customerRewardsProvider);

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
                  // --- SEARCH BAR ---
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: "Search name...",
                      prefixIcon: const Icon(Icons.search),
                      // Added Clear Button
                      suffixIcon: _search.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _search = "");
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- REWARD LIST ---
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async =>
                          ref.refresh(customerRewardsProvider.future),
                      child: searched.isEmpty
                          // FIX: Scrollable Empty State allows refreshing
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3),
                                const Center(child: Text('No reward found')),
                              ],
                            )
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: searched.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, i) {
                                final r = searched[i];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerRewardDetailsScreen(
                                        reward: r,
                                      ),
                                    ),
                                  ),
                                  child: RewardListitem(
                                    reward: r,
                                    isStaff: false,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        // Error State with Retry
         error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}