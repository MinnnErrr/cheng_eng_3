import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/ui/extensions/booking_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class BookingDetailsWidget extends ConsumerWidget {
  const BookingDetailsWidget({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('EEEE, dd MMM yyyy');
    final metaDateFormatter = DateFormat('dd/MM/yyyy h:mm a');

    // Combine services for display
    final servicesString = booking.services.isEmpty
        ? 'None'
        : booking.services.map((s) => s.serviceName).join(', ');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Services
          _buildSectionHeader(context, "Services"),
          const SizedBox(height: 8),
          Text(
            servicesString,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(),
          ),

          // Remarks
          if (booking.remarks != null) ...[
            _buildSectionHeader(context, "Customer Remarks"),
            const SizedBox(height: 8),
            Text(
              booking.remarks!,
              style: TextStyle(
                fontSize: 15,
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(),
            ),
          ],

          // --- 3. METADATA ---
          _buildMetaRow(
            context,
            "Created At",
            metaDateFormatter.format(booking.createdAt),
          ),

          if (booking.updatedAt != null) ...[
            const SizedBox(height: 12),
            _buildMetaRow(
              context,
              "Last Updated",
              metaDateFormatter.format(booking.updatedAt!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        letterSpacing: 1.0,
      ),
    );
  }

  // Updated to handle long text wrapping safely
  Widget _buildMetaRow(
    BuildContext context,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          CrossAxisAlignment.start, // Aligns label to top if value wraps
      children: [
        SizedBox(
          width: 120, // Ensures consistent label width
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.3, // Improved line height for wrapped text
            ),
          ),
        ),
      ],
    );
  }
}
