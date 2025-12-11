import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/customer_point_history_notifier.dart';
import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
import 'package:cheng_eng_3/core/controllers/reset_provider.dart';
import 'package:cheng_eng_3/core/models/profile_model.dart';
import 'package:cheng_eng_3/main.dart';
import 'package:cheng_eng_3/ui/screens/login_screen.dart';
import 'package:cheng_eng_3/ui/screens/profile_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).value;

    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Main(),
        ),
        (route) => false,
      );
    }

    final totalPoints = ref.watch(totalPointsProvider(user!.id));
    final profile = ref.watch(profileProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: profile.when(
        data: (profile) {
          return profile == null
              ? Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No profile found',
                      style:
                          Theme.of(
                            context,
                          ).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ProfileUpdateScreen(),
                          ),
                        );
                      },
                      child: Text('Create Profile'),
                    ),
                  ],
                )
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      spacing: 30,

                      children: [
                        //point field
                        if (profile.role.toLowerCase() == 'customer')
                          Container(
                            width: double.infinity,
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
                            padding: EdgeInsets.all(20),
                            child: totalPoints.when(
                              data: (total) {
                                return _pointsFiled(total, context);
                              },
                              error: (error, stackTrace) => Text("Error"),
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),

                        //profile field
                        _profileField(profile, context),

                        ElevatedButton(
                          onPressed: () {
                            final resetAll = ref.read(appStateResetProvider);

                            if (!context.mounted) return;
                            authNotifier.signOut();
                            resetAll();

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                              (route) => false,
                            );
                          },
                          child: Text('Sign Out'),
                        ),
                      ],
                    ),
                  ),
                );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _pointsFiled(int totalPoints, BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                '$totalPoints pts',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacer(),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              iconAlignment: IconAlignment.end,
            ),
            onPressed: () {},
            label: Text('Points History'),
            icon: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Widget _profileField(Profile profile, BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile Details',
              style:
                  Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ProfileUpdateScreen(),
                  ),
                );
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(profile.email),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(profile.name),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phone Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${profile.dialCode}${profile.phoneNum}'),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gender',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(profile.gender),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date of Birth',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              profile.birthday != null
                  ? dateFormatter.format(profile.birthday!)
                  : '-',
            ),
          ],
        ),
      ],
    );
  }
}
