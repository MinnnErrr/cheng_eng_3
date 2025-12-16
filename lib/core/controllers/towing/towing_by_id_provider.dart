

import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/core/services/towing_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final towingByIdProvider = FutureProvider.family<Towing, String>((
  ref,
  towingId,
) async {
  final towingService = ref.read(towingServiceProvider);
  return await towingService.getByTowingId(towingId);
});