import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/services/notification_service.dart';
import 'package:cheng_eng_3/ui/screens/customer/customer_main_wrapper.dart';
import 'package:cheng_eng_3/ui/screens/initial_profile_screen.dart';
import 'package:cheng_eng_3/ui/screens/login_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/staff_main_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String stripe_publishable =
    "pk_test_51ShA7kLXdt9JqGlW7kQoPSUoejcUht31ulHygbPOuJpFjBVBnsXQ1hfkzCaoPtGOsaA5sBIlfjGTHjMbfQa6IaH100WCSfc1tH";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iquemainudabsfrfzypl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlxdWVtYWludWRhYnNmcmZ6eXBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4MTgyMzIsImV4cCI6MjA3OTM5NDIzMn0.7hCB-cZ5KUm08rt_UNIQolhgkhwGL2hjLHNPoM0XMe8',
  );

  Stripe.publishableKey = stripe_publishable;
  Stripe.instance.applySettings();

  final container = ProviderContainer();
  await container.read(notificationServiceProvider).init();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Cheng Eng Auto Accessories',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: chengEngCustomScheme,
        scaffoldBackgroundColor: chengEngCustomScheme.surface,
        appBarTheme: AppBarTheme(
          backgroundColor: chengEngCustomScheme.surface,
          foregroundColor: chengEngCustomScheme.onSurface,
          elevation: 0,
          centerTitle: true,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            foregroundColor: chengEngCustomScheme.onPrimary,
            backgroundColor: chengEngCustomScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ), // Modern rounded
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ), // Taller modern buttons
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
          cursorColor: chengEngCustomScheme.onSurface, // Black
          // 2. The Color of the "Teardrop" handles when you select text
          selectionHandleColor: chengEngCustomScheme.onSurface, // Black
          // 3. The Highlight color when you drag-select text
          // We use your Primary Yellow but with low opacity so you can read the text through it
          selectionColor: chengEngCustomScheme.primary.withValues(alpha: 0.4),
        ),

        cardTheme: CardThemeData(
          color: chengEngCustomScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: chengEngCustomScheme.outlineVariant.withValues(alpha: 0.6),
            ), // Subtle border
          ),
          elevation: 0,
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
      ),
      home: const GlobalListenerWrapper(child: Main()),
    );
  }
}

class GlobalListenerWrapper extends ConsumerWidget {
  final Widget child;
  const GlobalListenerWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep these providers alive!
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
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(profileProvider);

    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (authState.value == null) return const LoginScreen();

    return profileState.when(
      data: (profile) {
        if (profile == null) {
          return InitialProfileScreen();
        }

        if (profile.role.toLowerCase() == 'staff') {
          return const StaffMainWrapper(); // 👈 Separate File
        } else {
          return const CustomerMainWrapper(); // 👈 Separate File
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) =>
          const Scaffold(body: Center(child: Text("Error detect user role"))),
    );
  }
}
