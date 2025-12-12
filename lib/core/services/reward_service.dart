
import 'package:cheng_eng_3/core/models/reward_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'reward_service.g.dart';

@Riverpod(keepAlive: true)
RewardService rewardService(Ref ref) {
  return RewardService();
}

class RewardService {
  final supabase = Supabase.instance.client;

  Future<List<Reward>> getAllRewards() async {
    final data = await supabase
        .from('rewards')
        .select()
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Reward>((p) => Reward.fromJson(p)).toList();
  }

  Future<List<Reward>> getActiveRewards() async {
    final data = await supabase
        .from('rewards')
        .select()
        .isFilter('deletedAt', null)
        .eq('status', true)
        .order('createdAt', ascending: false);
    return data.map<Reward>((p) => Reward.fromJson(p)).toList();
  }

  Future<Reward> getByRewardId(String id) async {
    final data = await supabase.from('rewards').select().eq('id', id).single();
    return Reward.fromJson(data);
  }

  Future<void> create(Reward reward) async {
    await supabase.from('rewards').insert(reward.toJson());
  }

  Future<void> update(Reward reward) async {
    await supabase.from('rewards').update(reward.toJson()).eq('id', reward.id);
  }

  Future<void> updateQuantity(int quantity, String rewardId) async {
    await supabase
        .from('rewards')
        .update({'quantity': quantity, 'updatedAt': DateTime.now()})
        .eq('id', rewardId);
  }

  Future<void> updateStatus(bool isActive, String rewardId) async {
    await supabase
        .from('rewards')
        .update({'status': isActive, 'updatedAt': DateTime.now()})
        .eq('id', rewardId);
  }

  Future<void> delete(String id) async {
    await supabase
        .from('rewards')
        .update({'deletedAt': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
