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

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                // --- SEARCH BAR ---
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide.none, // Removes the underline/outline
                    ),
                    hintText: "Search rewards...",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),

                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _search = "");
                            },
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                // --- REWARD LIST ---
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        ref.refresh(customerRewardsProvider.future),
                    child: searched.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                              Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.redeem,
                                      size: 60,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'No rewards found',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: searched.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) {
                              final r = searched[i];
                              return RewardListitem(
                                reward: r,
                                isStaff: false,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerRewardDetailsScreen(reward: r),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              Text('Error: $error'),
              TextButton(
                onPressed: () => ref.refresh(customerRewardsProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
