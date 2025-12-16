import 'package:cheng_eng_3/core/controllers/reward/staff_rewards_notifier.dart';
import 'package:cheng_eng_3/ui/screens/staff/reward/staff_reward_create_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/reward/staff_reward_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/reward_listitem.dart';
import 'package:cheng_eng_3/utils/search_sort_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffRewardScreen extends ConsumerStatefulWidget {
  const StaffRewardScreen({super.key});

  @override
  ConsumerState<StaffRewardScreen> createState() => _StaffRewardScreenState();
}

class _StaffRewardScreenState extends ConsumerState<StaffRewardScreen> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final rewardState = ref.watch(staffRewardsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      // 1. Allow tapping background to dismiss keyboard
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: RefreshIndicator(
          // 2. Add Pull-to-Refresh capability
          onRefresh: () => ref.refresh(staffRewardsProvider.future),
          child: rewardState.when(
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
                      // Search Bar
                      // Removed redundant Row/Expanded
                      TextField(
                        onChanged: (v) => setState(() => _search = v),
                        decoration: InputDecoration(
                          hintText: "Search name...",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
    
                      const SizedBox(height: 20),
    
                      // Reward List
                      Expanded(
                        child: searched.isEmpty
                            ? SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: const Center(
                                    child: Text('No reward found'),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                // Allow dismissing keyboard on scroll
                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: searched.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 10),
                                itemBuilder: (_, i) {
                                  final r = searched[i];
                                  
                                  // Better to pass tap action into the widget if possible
                                  // to ensure ripples respect card border radius
                                  return GestureDetector(
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StaffRewardDetailsScreen(reward: r),
                                      ),
                                    ),
                                    child: RewardListitem(
                                      reward: r,
                                      isStaff: true,
                                    ),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const StaffRewardCreateScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}