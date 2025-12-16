import 'package:cheng_eng_3/core/controllers/cart/cart_prices_provider.dart';
import 'package:cheng_eng_3/core/models/cart_item_model.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartListitem extends ConsumerWidget {
  const CartListitem({
    super.key,
    required this.item,
    required this.product,
    required this.incrementAction,
    required this.decrementAction,
    required this.deleteAction,
  });

  final CartItem item;
  final Product product;

  final VoidCallback incrementAction;
  final VoidCallback decrementAction;
  final VoidCallback deleteAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);

    // FIX 1: Watch the AsyncValue, not the double directly
    final itemPriceAsync = ref.watch(cartItemPriceProvider(item.id));
    final installationFeeAsync = ref.watch(cartItemInstallationFeeProvider(item.id));

    String? getUrl(Product product) {
      final url = product.photoPaths.isNotEmpty
          ? imageService.retrieveImageUrl(product.photoPaths.first)
          : null;
      return url;
    }

    return Column(
      children: [
        if (product.quantity != null && product.quantity! <= 0)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
            ),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            child: Text(
              'The product is sold out. Please remove it from the cart',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        
        const SizedBox(height: 10), // Add spacing after warning
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Picture
            imageBuilder(
              url: getUrl(product),
              containerWidth: 120,
              containerHeight: 120,
              noImageContent: Container(
                height: 120,
                width: 120,
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
                  if (product.colour != null) Text(product.colour!),
                  const SizedBox(height: 15),

                  const Text('Quantity'),
                  Row(
                    children: [
                      // Quantity Box
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surfaceContainerLowest,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              iconSize: 20,
                              visualDensity: VisualDensity.compact,
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
                              iconSize: 20,
                              visualDensity: VisualDensity.compact,
                              onPressed: incrementAction,
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(), // Pushes delete button to the right? Or keep close?
                      
                      // Delete
                      IconButton(
                        onPressed: deleteAction,
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // FIX 2: Handle Price Display with .when()
                  itemPriceAsync.when(
                    data: (price) => Text(
                      'RM ${price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    loading: () => const Text('RM ...'), // Or a small spinner
                    error: (e, s) => const Text('Error calculating price'),
                  ),

                  // FIX 3: Handle Installation Fee Display
                  installationFeeAsync.when(
                    data: (fee) {
                      // Only show if there is actually a fee
                      if (fee <= 0) return const SizedBox.shrink();
                      return Text(
                        'Installation Fee: RM ${fee.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      );
                    },
                    loading: () => const SizedBox.shrink(), // Hide while loading to prevent jump
                    error: (e, s) => const SizedBox.shrink(),
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