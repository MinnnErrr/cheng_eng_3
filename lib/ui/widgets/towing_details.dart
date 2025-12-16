import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Vehicle Section ---
        Text(
          'Vehicle Details',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _vehicle(context, towing, imageService, screenSize),

        const SizedBox(height: 30),

        // --- Towing Details Section ---
        Text(
          'Towing Details',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _towingDetails(context, towing),

        const SizedBox(height: 30),

        // --- Image Section ---
        Text(
          'Picture of Surrounding',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _image(context, towing, imageService, screenSize),
      ],
    );
  }

  Widget _towingDetails(BuildContext context, Towing towing) {
    final dateFormatter = DateFormat('dd/MM/yyyy').add_jm();

    // inside lib/ui/widgets/towing_details.dart

  Widget towingDetailsItem({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top in case of wrapping
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20), 
          
          // FIX D: Use Expanded instead of Flexible to force wrapping
          Expanded( 
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: true, // Ensure wrapping is enabled
            ),
          ),
        ],
      ),
    );
  }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            towingDetailsItem(
              title: 'Address',
              value: towing.address,
            ),
            towingDetailsItem(
              title: 'Coordinates',
              value: '${towing.longitude}, ${towing.latitude}',
            ),
            towingDetailsItem(
              title: 'Created At',
              value: dateFormatter.format(towing.createdAt),
            ),
            towingDetailsItem(
              title: 'Updated At',
              value: towing.updatedAt != null
                  ? dateFormatter.format(towing.updatedAt!)
                  : '-',
            ),
            towingDetailsItem(
              title: 'Status',
              value: towing.status,
            ),

            // Remarks
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Remarks',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    towing.remarks ?? '-',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        containerHeight: screenSize.height * 0.3,
        noImageContent: Container(
          width: double.infinity,
          color: Colors.grey.shade200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.image_not_supported, color: Colors.grey),
              SizedBox(height: 8),
              Text('No image found', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        context: context,
      ),
    );
  }

  Widget _vehicle(
    BuildContext context,
    Towing towing,
    ImageService imageService,
    Size screenSize,
  ) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageBuilder(
                url: towing.photoPath != null
                    ? imageService.retrieveImageUrl(towing.photoPath!)
                    : null,
                containerWidth: screenSize.width * 0.2, // Slightly larger
                containerHeight: screenSize.width * 0.2,
                noImageContent: Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.directions_car),
                ),
                context: context,
              ),
            ),

            const SizedBox(width: 16),

            // Vehicle Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    towing.regNum,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${towing.make}, ${towing.model}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    towing.colour,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
