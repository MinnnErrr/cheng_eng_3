import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'towing_service.g.dart';

@Riverpod(keepAlive: true)
TowingService towingService(Ref ref) {
  return TowingService();
}

class TowingService {
  final supabase = Supabase.instance.client;

  Future<List<Towing>> getAllTowing() async {
    final data = await supabase
        .from('tows')
        .select()
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Towing>((t) => Towing.fromJson(t)).toList();
  }

  Future<List<Towing>> getByUser(String userId) async {
    final data = await supabase
        .from('tows')
        .select()
        .eq('userId', userId)
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Towing>((t) => Towing.fromJson(t)).toList();
  }

  Future<Towing> getByTowingId(String id) async {
    final data = await supabase.from('tows').select().eq('id', id).single();
    return Towing.fromJson(data);
  }

  Future<void> create(Towing towing) async {
    await supabase.from('tows').insert(towing.toJson());
  }

  Future<void> update(Towing towing) async {
    await supabase.from('tows').update(towing.toJson()).eq('id', towing.id);
  }

  Future<void> updateStatus(String status, String towingId) async {
    await supabase
        .from('tows')
        .update({'status': status, 'updatedAt': DateTime.now()})
        .eq('id', towingId);
  }

  Future<void> delete(String id) async {
    await supabase
        .from('tows')
        .update({'deletedAt': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
