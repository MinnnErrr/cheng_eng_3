import 'package:cheng_eng_3/core/controllers/reward/staff_reward_notifier.dart';
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
    final rewardState = ref.watch(staffRewardProvider);

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
                                  isStaff: true,
                                ),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StaffRewardDetailsScreen(
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
