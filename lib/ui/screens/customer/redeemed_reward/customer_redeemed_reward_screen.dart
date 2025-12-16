import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
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
  final TextEditingController _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Safe User Check
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    final redeemedRewards = ref.watch(redeemedRewardProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rewards'),
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
                  // --- SEARCH BAR ---
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _search = v),
                    decoration: InputDecoration(
                      hintText: "Search name...",
                      prefixIcon: const Icon(Icons.search),
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

                  // --- LIST ---
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async =>
                          ref.refresh(redeemedRewardProvider(user.id).future),
                      child: searched.isEmpty
                          // FIX: Scrollable Empty State
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

                                // Helper logic for readability
                                final isExpired = r.expiryDate != null &&
                                    r.expiryDate!.isBefore(DateTime.now());
                                final isDisabled = !r.isClaimed && isExpired;

                                return InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  // Disable tap if expired and not claimed
                                  onTap: isDisabled
                                      ? null
                                      : () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomerRedeemedRewardDetailsScreen(
                                                reward: r,
                                              ),
                                            ),
                                          ),
                                  child: Opacity(
                                    // Visual cue that it is disabled
                                    opacity: isDisabled ? 0.5 : 1.0,
                                    child: RedeemedRewardListitem(
                                      redeemedReward: r,
                                    ),
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
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $e'),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(redeemedRewardProvider(user.id)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}