import 'package:cheng_eng_3/data/services/profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileByUserIdProvider = FutureProvider.family((ref, String userId) async {
  final service = ref.read(profileServiceProvider);
  return await service.get(userId);
});

final userProfileByEmailProvider = FutureProvider.family((ref, String email) async {
  final service = ref.read(profileServiceProvider);
  return await service.getProfileByEmail(email);
});