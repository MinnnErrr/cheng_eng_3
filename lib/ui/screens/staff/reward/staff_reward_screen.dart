import 'package:cheng_eng_3/core/controllers/reward/staff_rewards_notifier.dart';
import 'package:cheng_eng_3/ui/screens/staff/reward/staff_reward_create_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/reward/staff_reward_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/reward_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffRewardScreen extends ConsumerStatefulWidget {
  const StaffRewardScreen({super.key});

  @override
  ConsumerState<StaffRewardScreen> createState() => _StaffRewardScreenState();
}

class _StaffRewardScreenState extends ConsumerState<StaffRewardScreen> {
  String _search = "";
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rewardState = ref.watch(staffRewardsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Rewards')),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(staffRewardsProvider.future),
          child: rewardState.when(
            data: (rewards) {
              final searched = rewards.where((r) {
                final q = _search.toLowerCase();
                return r.code.toLowerCase().contains(q) ||
                    r.name.toLowerCase().contains(q);
              }).toList();

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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

                      // Reward List
                      Expanded(
                        child: searched.isEmpty
                            ? LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
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
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                itemCount: searched.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (_, i) {
                                  final r = searched[i];
                                  return RewardListitem(
                                    reward: r,
                                    isStaff: true,
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StaffRewardDetailsScreen(reward: r),
                                      ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const StaffRewardCreateScreen(),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
    );
  }
}
