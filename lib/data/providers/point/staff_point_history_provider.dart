import 'package:cheng_eng_3/domain/models/point_history_model.dart';
import 'package:cheng_eng_3/data/services/point_history_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final staffPointHistoryProvider =
    FutureProvider<List<PointHistory>>((ref) async {
  final service = ref.read(pointHistoryServiceProvider);
  return await service.getStaffManagedPoints();
});


