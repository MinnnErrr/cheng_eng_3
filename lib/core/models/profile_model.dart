import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.g.dart';
part 'profile_model.freezed.dart';

@freezed
sealed class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String name,
    required String email,
    required String phoneNum,
    required String countryCode,
    required String dialCode,
    required String gender,
    DateTime? birthday,
    required String role,
    required String userId,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
