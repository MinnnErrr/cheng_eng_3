import 'package:cheng_eng_3/domain/models/profile_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'profile_service.g.dart';

@Riverpod(keepAlive: true)
ProfileService profileService(Ref ref) {
  return ProfileService();
}

class ProfileService {
  final supabase = Supabase.instance.client;

  Future<Profile?> get(String userId) async {
    final result = await supabase
        .from('profiles')
        .select()
        .eq('userId', userId)
        .maybeSingle();
    if (result == null) return null;
    return Profile.fromJson(result);
  }

  Future<Profile> create(Profile profile) async {
    final result = await supabase
        .from('profiles')
        .insert(profile.toJson())
        .select()
        .single();
    return Profile.fromJson(result);
  }

  Future<Profile> update(Profile profile) async {
    final result = await supabase
        .from('profiles')
        .update(profile.toJson())
        .eq('id', profile.id)
        .select()
        .single();
    return Profile.fromJson(result);
  }

  Future<Profile?> getProfileByEmail(String email) async {
    final result = await supabase
        .from('profiles')
        .select()
        .eq('email', email)
        .maybeSingle();
    if (result == null) {
      return null;
    }
    return Profile.fromJson(result);
  }
}
