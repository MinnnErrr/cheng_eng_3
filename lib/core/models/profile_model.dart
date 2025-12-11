import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.g.dart';
part 'profile_model.freezed.dart';

// @JsonSerializable()
// @freezed
// sealed class ProfileList with _$ProfileList{
//   const factory ProfileList({required List<Profile> profiles}) = _ProfileList;
// }

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
    DateTime? deletedAt
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  // Map<String, dynamic> toJson() => _$ProfileToJson(this);
}
