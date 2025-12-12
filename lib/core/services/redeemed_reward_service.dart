import 'package:cheng_eng_3/core/models/redeemed_reward_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'redeemed_reward_service.g.dart';

@Riverpod(keepAlive: true)
RedeemedRewardService redeemedRewardService(Ref ref) {
  return RedeemedRewardService();
}

class RedeemedRewardService {
  final supabase = Supabase.instance.client;

  Future<List<RedeemedReward>> getbyUser(String userId) async {
    final data = await supabase
        .from('redeemed_rewards')
        .select()
        .eq('userId', userId)
        .order('createdAt', ascending: false);
    return data.map<RedeemedReward>((r) => RedeemedReward.fromJson(r)).toList();
  }

  Future<RedeemedReward> getById(String id) async {
    final data = await supabase
        .from('redeemed_rewards')
        .select()
        .eq('id', id)
        .single();
    return RedeemedReward.fromJson(data);
  }

  Future<void> create(RedeemedReward redeemed) async {
    await supabase
        .from('redeemed_rewards')
        .insert(redeemed.toJson());
  }

  Future<void> updateStatus(bool isClaimed, String id) async {
    await supabase
        .from('redeemed_rewards')
        .update({'isClaimed': isClaimed, 'updatedAt': DateTime.now()})
        .eq('id', id);
  }
}
