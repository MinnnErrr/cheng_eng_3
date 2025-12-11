import 'package:cheng_eng_3/core/controllers/cart/cart_total_provider.dart';
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
    final itemPrice = ref.watch(cartItemPriceProvider(item.id));
    final installationFee = ref.watch(cartItemInstallationFeeProvider(item.id));

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
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Text(
                    'The product is sold out. Please remove it from the cart',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //picture
                  imageBuilder(
                    url: getUrl(product),
                    containerWidth: 120,
                    containerHeight: 120,
                    noImageContent: Container(
                      height: 130,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.store),
                    ),
                    context: context,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.brand} ${product.name} ${product.model ?? ''}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (product.colour != null) Text(product.colour!),

                        const SizedBox(
                          height: 15,
                        ),

                        Text('Quantity'),

                        Row(
                          children: [
                            // Quantity Box
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerLowest,
                              ),
                              child: Row(
                                spacing: 10,
                                children: [
                                  IconButton(
                                    iconSize: 20,
                                    visualDensity: VisualDensity.compact,
                                    onPressed: decrementAction,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: TextStyle(
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

                            //delete
                            IconButton(
                              onPressed: deleteAction,
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        Text(
                          'RM ${itemPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Installation Fee: RM ${installationFee.toStringAsFixed(2)}',
                          style:
                              Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
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
