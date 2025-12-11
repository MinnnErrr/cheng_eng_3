import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:cheng_eng_3/core/services/point_history_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final staffPointHistoryProvider =
    FutureProvider<List<PointHistory>>((ref) async {
  final service = ref.read(pointHistorytServiceProvider);
  return await service.getStaffManagedPoints();
});


