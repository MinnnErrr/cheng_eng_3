import 'package:cheng_eng_3/core/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  AuthService get _authService => ref.read(authServiceProvider);

  @override
  FutureOr<User?> build() {
    final supabase = Supabase.instance.client;

    supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      state = AsyncData(session?.user);
    });

    return supabase.auth.currentUser;
  }

  Future<String?> signUp(String email, String password) async {
    try {
      // state = const AsyncLoading();
      final user = await _authService.signUp(email, password);

      // if (user == null) {
      //   return 'Sign up failed. Please try again.';
      // }

      final identities = user?.identities ?? [];
      if (identities.isEmpty) {
        return "User already exists. Please log in.";
      }

      // state = AsyncData(user);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      // state = const AsyncLoading();
      final user = await _authService.signIn(email, password);

      if (user == null) {
        return 'Sign in failed. Please try again. ';
      }

      // final emailConfirmed = user.emailConfirmedAt;
      // if (emailConfirmed == null || emailConfirmed.isEmpty) {
      //   return "Email not verified. Please verify your email.";
      // }

      // state = AsyncData(user);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> verifyWithOtp(String email, String otp) async {
    try {
      // state = const AsyncLoading();
      final user = await _authService.verifyWithOtp(email, otp);

      if (user == null) {
        return 'Email verification failed. Please try again. ';
      }
      // state = AsyncData(user);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> resendOtp(String email) async {
    try {
      // state = const AsyncLoading();
      await _authService.resendOtp(email);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    // state = AsyncData(null);
  }
}
