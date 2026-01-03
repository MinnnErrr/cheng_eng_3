import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileListitem extends ConsumerWidget {
  const ProfileListitem({
    super.key,
    required this.email,
    required this.name,
    required this.dialCode,
    required this.phoneNum,
    required this.gender,
  });

  final String? email;
  final String? name;
  final String? dialCode;
  final String? phoneNum;
  final String? gender;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Fallback if critical data is missing
    if (email == null || name == null) {
      return Card(
        color: theme.colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Incomplete Profile Data',
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. NAME SECTION ---
            Text(
              "Full Name",
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1),
            ),

            // --- 2. DETAILS SECTION ---
            _buildDetailRow(context, icon: Icons.email_outlined, value: email!),

            if (dialCode != null && phoneNum != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.phone_outlined,
                value: "$dialCode $phoneNum",
              ),
            ],

            if (gender != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.person_outline,
                value: gender!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
