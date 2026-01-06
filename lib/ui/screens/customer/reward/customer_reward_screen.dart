import 'package:cheng_eng_3/core/controllers/reward/customer_rewards_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/reward/customer_reward_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/reward_listitem.dart';
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
          final searched = rewards.where((r) {
            final q = _search.toLowerCase();
            return r.code.toLowerCase().contains(q) ||
                r.name.toLowerCase().contains(q);
          }).toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                // --- SEARCH BAR ---
                SearchBar(
                  controller: _searchCtrl,
                  hintText: "Search Reward Name or Code",

                  leading: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onChanged: (val) => setState(() => _search = val),
                  trailing: _search.isNotEmpty
                      ? [
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _search = "");
                            },
                          ),
                        ]
                      : null,
                ),
                const SizedBox(height: 20),

                // --- REWARD LIST ---
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        ref.refresh(customerRewardsProvider.future),
                    child: searched.isEmpty
                        ? LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  height: constraints.maxHeight,
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.redeem,
                                          size: 60,
                                          color: Colors.grey.shade300,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No rewards found',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
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
                                onTap:  () => Navigator.of(context).push(
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
