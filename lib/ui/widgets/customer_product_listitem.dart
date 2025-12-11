import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerProductListitem extends ConsumerWidget {
  const CustomerProductListitem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final String? url;

    url = product.photoPaths.isNotEmpty
        ? imageService.retrieveImageUrl(product.photoPaths.first)
        : null;

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageBuilder(
                  url: url,
                  containerWidth: double.infinity,
                  containerHeight: 130,
                  noImageContent: Container(
                    height: 130,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.store),
                  ),
                  context: context,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${product.brand} ${product.name} ${product.model}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (product.colour != null) Text(product.colour!),
                const Spacer(),
                Text(
                  'RM ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          if (product.quantity != null && product.quantity! <= 0)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(200, 117, 117, 117),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Out of Stock',
                    style: TextStyle(
                      color: Colors.grey.shade200,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
