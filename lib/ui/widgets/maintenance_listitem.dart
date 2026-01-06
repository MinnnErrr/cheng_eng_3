import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_count_days_provider.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MaintenanceListItem extends ConsumerWidget {
  const MaintenanceListItem({
    super.key,
    required this.maintenance,
    this.tapAction,
  });

  final Maintenance maintenance;
  final GestureTapCallback? tapAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = DateFormat('dd MMM yyyy'); // Cleaner Date Format
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final maintenanceDays = ref.watch(
      maintenanceCountDaysProvider(maintenance.id),
    );

    final bool isOverdue =
        !maintenance.isComplete &&
        maintenance.nextServDate.isBefore(DateTime.now());

    String statusLabel;
    Color statusColor;

    if (maintenance.isComplete) {
      statusLabel = 'Completed';
      statusColor = Colors.green;
    } else if (isOverdue) {
      statusLabel = 'Overdue';
      statusColor = Colors.red;
    } else {
      statusLabel = 'Upcoming';
      statusColor = Colors.orange;
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: tapAction,
        child: SizedBox(
          height: 140,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- LEFT SIDE: Main Info ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header: Title + Status
                      Row(
                        children: [
                          // ✅ FIX 1: Expanded prevents Title from pushing Chip off-screen
                          Expanded(
                            child: Text(
                              maintenance.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // 2. Data Rows (Icons instead of Labels)
                      // Date
                      _iconTextRow(
                        context,
                        Icons.calendar_month,
                        dateFormatter.format(maintenance.nextServDate),
                      ),

                      // Distance
                      if (maintenance.nextServDistance != null) ...[
                        const SizedBox(height: 6),
                        _iconTextRow(
                          context,
                          Icons
                              .add_road_outlined, // "Road" icon implies distance
                          '${maintenance.nextServDistance} KM',
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // --- RIGHT SIDE: Actions & Days Counter ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (!maintenance.isComplete && !isOverdue) ...[
                      maintenanceDays.when(
                        data: (days) => Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "$days",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textYellow,
                              ),
                            ),
                            Text(
                              "days left",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                        loading: () => const SizedBox(width: 10, height: 10),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for clean Icon + Text rows
  Widget _iconTextRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.tertiary, // Use your Industrial Grey
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
