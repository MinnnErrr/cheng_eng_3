import 'package:cheng_eng_3/domain/models/product_model.dart';
import 'package:cheng_eng_3/data/services/image_service.dart';
import 'package:cheng_eng_3/ui/products/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/core/widgets/imagebuilder.dart';
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

    final bool isOOS = product.quantity != null && product.quantity! <= 0;

    final bool isActive = product.status;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: ImageBuilder(
                url: product.photoPaths.isNotEmpty
                    ? imageService.retrieveImageUrl(product.photoPaths.first)
                    : null,
                width: 100,
                height: 100,
                noImageContent: Container(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                enableZoom: false,
                borderRadius: 0,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.brand} ${product.name} ${product.model ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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

                    Text(
                      'RM ${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? const Color(0xFF9E7C00) 
                            : Colors.grey, 
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: product.availability.getcolor(product.quantity).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                     product.availability.getlabel(product.quantity),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: product.availability.getcolor(product.quantity),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

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
