import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/extensions/order_extension.dart'; // Ensure correct import
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _timeFormatter = DateFormat('dd MMM yyyy, h:mm a');

class OrderListitem extends ConsumerWidget {
  const OrderListitem({
    super.key,
    required this.order,
    required this.isStaff,
    required this.tapAction,
  });

  final Order order;
  final VoidCallback tapAction;
  final bool isStaff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final theme = Theme.of(context);

    // Get lead item for display
    final leadItem = (order.items != null && order.items!.isNotEmpty)
        ? order.items!.first
        : null;
    final otherItemCount = (order.items?.length ?? 0) - 1;

    // Helper to get image URL safely
    String? getLeadImageUrl() {
      if (leadItem != null && leadItem.photoPaths.isNotEmpty) {
        return imageService.retrieveImageUrl(leadItem.photoPaths.first);
      }
      return null;
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: tapAction,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- ROW 1: HEADER (Date & Status) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _timeFormatter.format(order.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  // Custom Status Chip (Cleaner than Material Chip)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order.status.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.status.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: order.status.color, // Darker text for contrast
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // --- ROW 2: CONTENT ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // THUMBNAIL
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageBuilder(
                      url: getLeadImageUrl(),
                      containerWidth: 64,
                      containerHeight: 64,
                      noImageContent: Container(
                        width: 64,
                        height: 64,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      context: context,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.id.substring(0, 8).toUpperCase()}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          leadItem?.productName ?? 'Unknown Items',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (otherItemCount > 0)
                          Text(
                            '+ $otherItemCount more items',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),

              // --- ROW 3: FOOTER (Delivery & Total) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Delivery Method
                  Row(
                    children: [
                      Icon(
                        order.deliveryMethod == DeliveryMethod.delivery
                            ? Icons.local_shipping_outlined
                            : Icons.store_mall_directory_outlined,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order.deliveryMethod.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Total Price
                  Text(
                    'RM ${order.total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textYellow,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
