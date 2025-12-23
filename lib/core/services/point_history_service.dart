
import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'point_history_service.g.dart';

@Riverpod(keepAlive: true)
PointHistoryService pointHistorytService(Ref ref) {
  return PointHistoryService();
}

class PointHistoryService {
  final supabase = Supabase.instance.client;

  Future<List<PointHistory>> getStaffManagedPoints() async {
    final data = await supabase
        .from('point_history')
        .select()
        .eq('isIssuedByStaff', true)
        .order('createdAt', ascending: false);
    
    return data.map<PointHistory>((p) => PointHistory.fromJson(p)).toList();
  }

  Future<List<PointHistory>> getAllUserPoints(String userId) async {
    final data = await supabase
        .from('point_history')
        .select()
        .eq('userId', userId)
        .order('createdAt', ascending: false);
    
    return data.map<PointHistory>((p) => PointHistory.fromJson(p)).toList();
  }

  // Future<void> create(PointHistory record) async {
  //   await supabase.from('point_history').insert(record.toJson());
  // }

  Future<void> deductPoints(String userId, int points, String reason, bool isIssuedByStaff) async {
    await supabase.rpc(
      'deduct_points',
      params: {
        'p_user_id': userId,
        'p_points': points,
        'p_reason': reason,
        'p_is_issued_by_staff': isIssuedByStaff
      },
    );
  }

  Future<void> addPoints(String userId, int points, String reason, bool isIssuedByStaff) async {
    await supabase.rpc(
      'add_points',
      params: {
        'p_user_id': userId,
        'p_points': points,
        'p_reason': reason,
        'p_is_issued_by_staff': isIssuedByStaff
      },
    );
  }
}
