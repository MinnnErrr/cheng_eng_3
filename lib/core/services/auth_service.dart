import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_service.g.dart';

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService();
}

class AuthService {
  final supabase = Supabase.instance.client;

  Future<User?> signUp(String email, String password) async {
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<User?> signIn(String email, String password) async {
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  Future<User?> verifyWithOtp(String email, String token) async {
    final AuthResponse res = await supabase.auth.verifyOTP(
      type: OtpType.signup,
      token: token,
      email: email,
    );
    return res.user;
  }

  Future<void> resendOtp(String email) async {
    await supabase.auth.resend(type: OtpType.signup, email: email);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    const redirectUrl = 'com.example.chengeng3://login-callback/';

    await supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: redirectUrl,
    );
  }

  Future<User?> resetPassword(String newPassword) async {
    final UserResponse res = await supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
    return res.user;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
