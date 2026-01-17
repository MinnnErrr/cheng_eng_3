import 'package:cheng_eng_3/ui/points/notifiers/point_history_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final totalPointsProvider = FutureProvider.family<int, String>((ref, userId) async {

  final records = await ref.watch(pointHistoryProvider(userId).future);

  return records.fold<int>(0, (sum, r) => sum + r.points);
});