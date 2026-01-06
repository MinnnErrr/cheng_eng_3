import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/models/profile_model.dart';
import 'package:cheng_eng_3/core/services/profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'profile_notifier.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  ProfileService get _profileService => ref.read(profileServiceProvider);

  @override
  FutureOr<Profile?> build() async {
    final userState = ref.watch(authProvider);
    final user = userState.value;
    if (user == null) return null;
    return await _profileService.get(user.id);
  }

  Future<bool> createProfile({
    required String name,
    required String email,
    required String phoneNum,
    required String countryCode,
    required String dialCode,
    required String gender,
    DateTime? birthday,
  }) async {
    final userState = ref.read(authProvider);

    final user = userState.value;
    if (user == null) {
      return false;
    }

    final profile = Profile(
      id: Uuid().v4(),
      name: name,
      email: email,
      phoneNum: phoneNum,
      countryCode: countryCode,
      dialCode: dialCode,
      gender: gender,
      birthday: birthday,
      role: 'customer',
      userId: user.id,
    );
    try {
      state = const AsyncLoading();
      final newProfile = await _profileService.create(profile);
      state = AsyncData(newProfile);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phoneNum,
    required String countryCode,
    required String dialCode,
    required String gender,
    DateTime? birthday,
  }) async {
    final current = state.value;
    if (current == null) return false;

    final profile = current.copyWith(
      name: name,
      phoneNum: phoneNum,
      countryCode: countryCode,
      dialCode: dialCode,
      gender: gender,
      birthday: birthday,
    );
    try {
      state = const AsyncLoading();
      final updated = await _profileService.update(profile);
      state = AsyncData(updated);
      return true;
    } catch (e) {
      return false;
    }
  }
}
