import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/extensions/booking_extension.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookingDetailsWidget extends ConsumerWidget {
  const BookingDetailsWidget({super.key, required this.booking});

  final Booking booking;

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
        _vehicle(context, booking, imageService, screenSize),

        const SizedBox(height: 30),

        // --- Towing Details Section ---
        Text(
          'Towing Details',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _bookingDetails(context, booking),
      ],
    );
  }

  Widget _bookingDetails(BuildContext context, Booking booking) {
    final dateTimeFormatter = DateFormat('dd/MM/yyyy').add_jm();
    final dateFormatter = DateFormat('dd/MM/yyyy');

    // 1. Generate the list of service names
    // Assumes booking.services is List<BookingServiceType>
    final servicesString = booking.services.isEmpty
        ? 'None'
        : booking.services.map((s) => s.serviceName).join(', ');

    Widget towingDetailsItem({required String title, required String value}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                softWrap: true,
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
            // FIX: Display the actual services string here
            towingDetailsItem(
              title: 'Services',
              value: servicesString, 
            ),
            towingDetailsItem(
              title: 'Date',
              value: dateFormatter.format(booking.date),
            ),
            towingDetailsItem(
              title: 'Time',
              value: booking.time.format(context), // formatting TimeOfDay
            ),
            towingDetailsItem(
              title: 'Created At',
              value: dateTimeFormatter.format(booking.createdAt),
            ),
            towingDetailsItem(
              title: 'Updated At',
              value: booking.updatedAt != null
                  ? dateTimeFormatter.format(booking.updatedAt!)
                  : '-',
            ),
            towingDetailsItem(
              title: 'Status',
              value: booking.status.name.toUpperCase(), // Clean status text
            ),

            const SizedBox(height: 20), // Spacing before remarks

            // Remarks Section
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.5), // Softer look
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
                    booking.remarks ?? '-',
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

  Widget _vehicle(
    BuildContext context,
    Booking booking,
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
                url: booking.vehiclePhoto != null
                    ? imageService.retrieveImageUrl(booking.vehiclePhoto!)
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
                    booking.vehicleRegNum,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${booking.vehicleMake}, ${booking.vehicleModel}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.vehicleColour,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.vehicleYear.toString(),
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
