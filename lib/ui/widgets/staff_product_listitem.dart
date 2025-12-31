import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffProductListitem extends ConsumerWidget {
  const StaffProductListitem({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final theme = Theme.of(context);

    // --- 1. Stock Logic ---
    final bool isLowStock =
        product.quantity != null &&
        product.quantity! <= 10 &&
        product.quantity! > 0;
    final bool isOOS = product.quantity != null && product.quantity! <= 0;

    // --- 2. Availability Chip Logic ---
    Color chipColor;
    Color chipTextColor;
    String chipLabel = product.availability.label;

    if (product.availability == ProductAvailability.ready) {
      if (isOOS) {
        chipColor = theme.colorScheme.error.withValues(alpha: 0.1);
        chipTextColor = theme.colorScheme.error;
        chipLabel = "No Stock";
      } else if (isLowStock) {
        chipColor = Colors.orange.withValues(alpha: 0.1);
        chipTextColor = Colors.orange;
        chipLabel = "Low Stock";
      } else {
        chipColor = Colors.green.withValues(alpha: 0.1);
        chipTextColor = Colors.green;
      }
    } else {
      // Preorder
      chipColor = Colors.blue.withValues(alpha: 0.1);
      chipTextColor = Colors.blue;
    }

    final bool isActive = product.status;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 4. IMAGE ---
            SizedBox(
              width: 100,
              height: 100,
              child: imageBuilder(
                url: product.photoPaths.isNotEmpty
                    ? imageService.retrieveImageUrl(product.photoPaths.first)
                    : null,
                containerWidth: 100,
                containerHeight: 100,
                noImageContent: Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                context: context,
                borderRadius: 0,
              ),
            ),

            // --- 5. DETAILS (Left Side) ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand & Name
                    Text(
                      '${product.brand} ${product.name} ${product.model ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        // Grey out title if inactive
                        color: isActive
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                      ),
                    ),
                    if (product.colour != null)
                      Text(
                        product.colour!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),

                    const SizedBox(height: 10),

                    // Price
                    Text(
                      'RM ${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? const Color(0xFF9E7C00) // Gold/Yellow
                            : Colors.grey, // Grey if inactive
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 6. STATUS & CHIPS (Right Side) ---
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // B. Availability Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: chipColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      chipLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: chipTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // C. Stock Count
                  if (product.quantity != null)
                    Text(
                      'Qty: ${product.quantity}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOOS
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurface,
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
}
