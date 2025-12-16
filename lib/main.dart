import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/ui/screens/customer/customer_home.dart';
import 'package:cheng_eng_3/ui/screens/initial_profile_screen.dart';
import 'package:cheng_eng_3/ui/screens/login_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/staff_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://iquemainudabsfrfzypl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlxdWVtYWludWRhYnNmcmZ6eXBsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4MTgyMzIsImV4cCI6MjA3OTM5NDIzMn0.7hCB-cZ5KUm08rt_UNIQolhgkhwGL2hjLHNPoM0XMe8',
  );

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(towingRealtimeProvider);
    ref.watch(productRealTimeProvider);
    ref.watch(rewardRealTimeProvider);
    ref.watch(pointHistoryRealTimeProvider);
    ref.watch(redeemedRewardRealTimeProvider);
    ref.watch(bookingRealTimeProvider);

    return MaterialApp(
      title: 'Flutter Demo',
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Main(),
    );
  }
}

class Main extends ConsumerWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(profileProvider);

    return authState.when(
      data: (user) {
        if (user == null) return LoginScreen();

        return profileState.when(
          data: (profile) {
            if (profile == null) {
              return InitialProfileScreen();
            }

            final role = profile.role.toLowerCase();

            return role == 'customer' ? CustomerHome() : StaffHome();
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (_, __) => Center(child: Text("Error detect user role")),
        );
      },
      error: (error, stackTrace) => LoginScreen(),
      loading: () => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
