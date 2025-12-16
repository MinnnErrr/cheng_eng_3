import 'package:cheng_eng_3/core/controllers/point/point_history_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final totalPointsProvider = FutureProvider.family<int, String>((ref, userId) async {
  // 1. WATCH the history provider. 
  // If the history list updates (via Realtime or manual refresh), 
  // this line re-runs automatically.
  final records = await ref.watch(pointHistoryProvider(userId).future);

  // 2. Calculate in memory (fast and free)
  return records.fold<int>(0, (sum, r) => sum + r.points);
});