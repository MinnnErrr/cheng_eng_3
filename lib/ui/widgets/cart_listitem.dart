import 'package:cheng_eng_3/core/models/cart_entry_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartListitem extends ConsumerWidget {
  const CartListitem({
    super.key,
    required this.entry,
    required this.incrementAction,
    required this.decrementAction,
    required this.deleteAction,
  });

  final CartEntry entry;
  final VoidCallback incrementAction;
  final VoidCallback decrementAction;
  final VoidCallback deleteAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final product = entry.product;
    final item = entry.item;

    // SCENARIO 1: Product was deleted from Database
    if (product == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.red.shade50,
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Item unavailable',
                style: TextStyle(color: Colors.red),
              ),
            ),
            // FIX: Added the actual delete button here
            IconButton(
              onPressed: deleteAction,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      );
    }

    // SCENARIO 2: Normal Product
    String? getUrl() {
      return product.photoPaths.isNotEmpty
          ? imageService.retrieveImageUrl(product.photoPaths.first)
          : null;
    }

    // Check if max stock reached (for disabling button)
    final isSoldOut = entry.isSoldOut;
    final isMaxStock = entry.isMaxStock;

    return Column(
      children: [
        // Sold Out Warning
        if (isSoldOut)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            width: double.infinity,
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sold Out',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Picture
            imageBuilder(
              url: getUrl(),
              containerWidth: 100, // Adjusted size
              containerHeight: 100,
              noImageContent: Container(
                height: 100,
                width: 100,
                color: Colors.grey.shade200,
                child: const Icon(Icons.store),
              ),
              context: context,
            ),
            const SizedBox(width: 15),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${product.brand} ${product.name} ${product.model ?? ''}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.colour != null)
                    Text(
                      product.colour!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Box
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                              .withValues(alpha: 0.5),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              iconSize: 18,
                              onPressed: decrementAction,
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              item.quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              iconSize: 18,
                              // FIX: Disable button if sold out or max stock reached
                              onPressed: (isSoldOut || isMaxStock)
                                  ? null
                                  : incrementAction,
                              icon: Icon(
                                Icons.add,
                                color: (isSoldOut || isMaxStock)
                                    ? Colors.grey
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: deleteAction,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Pricing
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'RM ${entry.priceTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (entry.installationTotal > 0)
                          Text(
                            '+ Install: RM ${entry.installationTotal.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
