import 'package:cheng_eng_3/ui/core/theme/colorscheme.dart';
import 'package:cheng_eng_3/ui/auth/notifiers/auth_notifier.dart';
import 'package:cheng_eng_3/data/providers/auth/auth_stream_provider.dart';
import 'package:cheng_eng_3/ui/profile/notifiers/profile_notifier.dart';
import 'package:cheng_eng_3/data/providers/realtime_provider.dart';
import 'package:cheng_eng_3/data/services/notification_service.dart';
import 'package:cheng_eng_3/ui/home/screens/customer_main_wrapper.dart';
import 'package:cheng_eng_3/ui/profile/screens/initial_profile_screen.dart';
import 'package:cheng_eng_3/ui/auth/screens/login_screen.dart';
import 'package:cheng_eng_3/ui/auth/screens/reset_password_screen.dart';
import 'package:cheng_eng_3/ui/home/screens/staff_main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String stripePublishable =
    "pk_test_51ShA7kLXdt9JqGlW7kQoPSUoejcUht31ulHygbPOuJpFjBVBnsXQ1hfkzCaoPtGOsaA5sBIlfjGTHjMbfQa6IaH100WCSfc1tH";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iquemainudabsfrfzypl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlxdWVtYWludWRhYnNmcmZ6eXBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4MTgyMzIsImV4cCI6MjA3OTM5NDIzMn0.7hCB-cZ5KUm08rt_UNIQolhgkhwGL2hjLHNPoM0XMe8',
  );

  Stripe.publishableKey = stripePublishable;
  Stripe.instance.applySettings();

  final container = ProviderContainer();
  await container.read(notificationServiceProvider).init();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Cheng Eng Auto Accessories',
      theme: ThemeData(
        colorScheme: chengEngCustomScheme,
        scaffoldBackgroundColor: chengEngCustomScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: chengEngCustomScheme.surface,
          foregroundColor: chengEngCustomScheme.onSurface,
          surfaceTintColor: chengEngCustomScheme.surface,
          elevation: 0,
          centerTitle: true,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: chengEngCustomScheme.surfaceContainerHigh,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: chengEngCustomScheme.onSurfaceVariant),
          labelStyle: TextStyle(color: chengEngCustomScheme.onSurfaceVariant),
          floatingLabelStyle: TextStyle(
            color: chengEngCustomScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),

        textSelectionTheme: TextSelectionThemeData(
          cursorColor: chengEngCustomScheme.onSurface, 
          selectionHandleColor: chengEngCustomScheme.onSurface,
          selectionColor: chengEngCustomScheme.primary.withValues(alpha: 0.4),
        ),

        cardTheme: CardThemeData(
          color: chengEngCustomScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0.3,
          margin: EdgeInsets.zero,
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: chengEngCustomScheme.onSurface,
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
            overlayColor: chengEngCustomScheme.primary.withValues(alpha: 0.2),
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: chengEngCustomScheme.primary,
          foregroundColor: chengEngCustomScheme.onPrimary,
        ),

        searchBarTheme: SearchBarThemeData(
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStatePropertyAll(
            chengEngCustomScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          ),
          side: WidgetStatePropertyAll(BorderSide.none),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const GlobalListenerWrapper(
        child: Main(),
      ),
    );
  }
}

class GlobalListenerWrapper extends ConsumerWidget {
  final Widget child;
  const GlobalListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(towingRealtimeProvider);
    ref.watch(productRealTimeProvider);
    ref.watch(rewardRealTimeProvider);
    ref.watch(pointHistoryRealTimeProvider);
    ref.watch(redeemedRewardRealTimeProvider);
    ref.watch(bookingRealTimeProvider);
    ref.watch(orderRealTimeProvider);

    return child;
  }
}

class Main extends ConsumerWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateStreamProvider, (previous, next) {
      next.whenData((authState) {
        if (authState.event == AuthChangeEvent.passwordRecovery) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ResetPasswordScreen(),
            ),
          );
        }
      });
    });

    final userAsync = ref.watch(authProvider);

    return userAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => const Scaffold(body: Center(child: Text("Auth Error"))),
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        final profileAsync = ref.watch(profileProvider);
        return profileAsync.when(
          loading: () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (e, _) =>
              Scaffold(body: Center(child: Text("Profile Error: $e"))),
          data: (profile) {
            if (profile == null) {
              return const InitialProfileScreen();
            }

            if (profile.role.toLowerCase() == 'staff') {
              return const StaffMainWrapper();
            } else {
              return const CustomerMainWrapper();
            }
          },
        );
      },
    );
  }
}
