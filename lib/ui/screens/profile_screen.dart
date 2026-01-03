import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/nearest_expiry_point_provider.dart';
import 'package:cheng_eng_3/core/controllers/point/total_points_provider.dart';
import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
import 'package:cheng_eng_3/core/models/profile_model.dart';
import 'package:cheng_eng_3/ui/screens/customer/points_history/customer_points_history_screen.dart';
import 'package:cheng_eng_3/ui/screens/login_screen.dart';
import 'package:cheng_eng_3/ui/screens/profile_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);
    final user = userState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final totalPoints = ref.watch(totalPointsProvider(user.id));
    final expiryPoints = ref.watch(nearestExpiryProvider(user.id));
    final profileAsync = ref.watch(profileProvider);
    final authNotifier = ref.read(authProvider.notifier);

    final String? expiryText = expiryPoints.when(
      data: (info) => info != null
          ? '${info.points} pts expiring on ${DateFormat('dd/MM/yyyy').format(info.date)}'
          : null,
      loading: () => 'Loading...',
      error: (_, __) => null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) return _buildNoProfileView(context);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20), // Reduced padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Points Card (Customer Only) ---
                if (profile.role.toLowerCase() == 'customer') ...[
                  totalPoints.when(
                    data: (total) => _PointsCard(
                      totalPoints: total,
                      expiryText: expiryText,
                      onHistoryTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const CustomerPointsHistoryScreen(),
                          ),
                        );
                      },
                    ),
                    loading: () => const SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const SizedBox(),
                  ),
                  const SizedBox(height: 30),
                ],

                // --- Header & Edit ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Personal Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 32, // Smaller button area
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProfileUpdateScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // --- Profile Details ---
                _buildProfileInfoCard(context, profile),

                const SizedBox(height: 32),

                // --- Sign Out Button ---
                SizedBox(
                  height: 48, // Standard height, not too bulky
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async =>
                        _handleSignOut(context, authNotifier),
                    icon: const Icon(Icons.logout, size: 20),
                    label: const Text('SIGN OUT'),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _handleSignOut(
    BuildContext context,
    AuthNotifier authNotifier,
  ) async {
    await authNotifier.signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget _buildNoProfileView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No profile found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileUpdateScreen()),
              );
            },
            child: const Text('Create Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoCard(BuildContext context, Profile profile) {
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _ProfileRow(label: 'Name', value: profile.name),
          const Divider(height: 1),
          _ProfileRow(label: 'Email', value: profile.email),
          const Divider(height: 1),
          _ProfileRow(
            label: 'Phone',
            value: '${profile.dialCode} ${profile.phoneNum}',
          ),
          const Divider(height: 1),
          _ProfileRow(label: 'Gender', value: profile.gender),
          const Divider(height: 1),
          _ProfileRow(
            label: 'Birthday',
            value: profile.birthday != null
                ? dateFormatter.format(profile.birthday!)
                : '-',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

// --- Compact Helper Widgets ---

class _PointsCard extends StatelessWidget {
  final int totalPoints;
  final String? expiryText;
  final VoidCallback onHistoryTap;

  const _PointsCard({
    required this.totalPoints,
    required this.expiryText,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Points',
                style: TextStyle(
                  color: colorScheme.onPrimary.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                  fontSize: 13, // Smaller label
                ),
              ),
              InkWell(
                onTap: onHistoryTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                  child: Row(
                    children: [
                      Text(
                        'History',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Reduced font size for points
          Text(
            '$totalPoints pts',
            style: theme.textTheme.headlineMedium!.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          if (expiryText != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                expiryText!,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ), // Smaller text
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _ProfileRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Tighter padding for list items
      padding: EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14, // Standard body size
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
