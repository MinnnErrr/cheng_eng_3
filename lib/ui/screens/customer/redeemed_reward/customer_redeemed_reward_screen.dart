import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/redeemed_reward/customer_redeemed_reward_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/redeemed_reward_listitem.dart';
import 'package:cheng_eng_3/utils/search_sort_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ... imports ...

class CustomerRedeemedRewardScreen extends ConsumerStatefulWidget {
  const CustomerRedeemedRewardScreen({super.key});

  @override
  ConsumerState<CustomerRedeemedRewardScreen> createState() =>
      _CustomerRedeemedRewardScreenState();
}

class _CustomerRedeemedRewardScreenState
    extends ConsumerState<CustomerRedeemedRewardScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    final redeemedRewards = ref.watch(redeemedRewardProvider(user.id));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('My Rewards')),
      body: redeemedRewards.when(
        data: (rewards) {
          final searched = searchRedeemedReward(
            rewards: rewards,
            search: _search,
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                // --- SEARCH BAR (Improved) ---
                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: "Search my rewards...",
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
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

                // --- LIST ---
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async =>
                        ref.refresh(redeemedRewardProvider(user.id).future),
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
                                      Icons.confirmation_number_outlined,
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

                              return RedeemedRewardListitem(
                                redeemedReward: r,
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerRedeemedRewardDetailsScreen(
                                          reward: r,
                                        ),
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
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
