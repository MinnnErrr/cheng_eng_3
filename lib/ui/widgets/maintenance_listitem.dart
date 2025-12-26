import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_count_days_provider.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:cheng_eng_3/utils/status_colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MaintenanceListItem extends ConsumerWidget {
  const MaintenanceListItem({
    super.key,
    required this.maintenance,
    this.icon,
    this.tapAction,
  });

  final Maintenance maintenance;
  final Widget? icon;
  final GestureTapCallback? tapAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final maintenanceDays = ref.watch(
      maintenanceCountDaysProvider(maintenance.id),
    );

    return InkWell(
      onTap: tapAction,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            maintenance.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Chip(
                            side: BorderSide.none,
                            label: Text(
                              maintenance.status,
                              style: TextStyle(color: Colors.white),
                            ),
                            labelStyle: Theme.of(context).textTheme.labelSmall,
                            padding: EdgeInsets.all(0),
                            backgroundColor: getMaintenanceStatusColor(
                              maintenance.status,
                              context,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next Service Date: ${dateFormatter.format(maintenance.nextServDate)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Next Service Distance: ${maintenance.nextServDistance} KM',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                Column(
                  children: [
                    if (icon != null) icon!,
                    const Spacer(),
                    if (maintenance.nextServDate.isAfter(DateTime.now()))
                      maintenanceDays.when(
                        data: (days) => Text('$days days'),
                        loading: () => Text('Loading...'),
                        error: (error, stackTrace) => Text('Error'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
