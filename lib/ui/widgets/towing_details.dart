import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:cheng_eng_3/ui/widgets/vehicle_listitem.dart';
import 'package:cheng_eng_3/utils/status_colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TowingDetailsWidget extends ConsumerWidget {
  const TowingDetailsWidget({super.key, required this.towing});

  final Towing towing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.sizeOf(context);
    final imageService = ref.read(imageServiceProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Vehicle Section ---
        Text(
          'Vehicle Details',
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        VehicleListitem(
          make: towing.make,
          model: towing.model,
          regNum: towing.regNum,
          colour: towing.colour,
          photoPath: towing.vehiclePhoto,
        ),

        const SizedBox(height: 30),

        // --- Towing Details Section ---
        Text(
          'Towing Details',
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        _towingDetails(context, towing),

        const SizedBox(height: 30),

        // --- Image Section ---
        Text(
          'Surroundings',
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        _image(context, towing, imageService, screenSize),
      ],
    );
  }

  Widget _towingDetails(BuildContext context, Towing towing) {
    final dateFormatter = DateFormat('dd/MM/yyyy h:mm a');
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        // Add subtle border to match app theme
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _detailRow(
              context,
              'Status',
              towing.status,
              getTowingStatusColor(towing.status, context),
            ),
            const Divider(height: 20),
            _detailRow(context, 'Address', towing.address, null),
            const Divider(height: 20),
            _detailRow(
              context,
              'Coordinates',
              '${towing.latitude}, ${towing.longitude}',
              null,
            ),
            const Divider(height: 20),
            _detailRow(
              context,
              'Created At',
              dateFormatter.format(towing.createdAt),
              null,
            ),
            const Divider(height: 20),
            _detailRow(
              context,
              'Updated At',
              towing.updatedAt != null
                  ? dateFormatter.format(towing.updatedAt!)
                  : '-',
              null,
            ),

            // Remarks Section (Only show if exists)
            if (towing.remarks?.isNotEmpty == true) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 16,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Remarks',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      towing.remarks!,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Refactored helper for clean rows
  Widget _detailRow(
    BuildContext context,
    String title,
    String value,
    Color? valueColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
          ),
        ),
      ],
    );
  }

  Widget _image(
    BuildContext context,
    Towing towing,
    ImageService imageService,
    Size screenSize,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageBuilder(
        url: towing.photoPath != null
            ? imageService.retrieveImageUrl(towing.photoPath!)
            : null,
        containerWidth: double.infinity,
        containerHeight: screenSize.height * 0.25,
        noImageContent: Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'No image provided',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        context: context,
      ),
    );
  }
}
