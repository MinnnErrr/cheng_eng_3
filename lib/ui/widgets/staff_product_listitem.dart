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
  });

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final screenSize = MediaQuery.of(context).size;

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //picture
              imageBuilder(
                url: product.photoPaths.isNotEmpty
                    ? imageService.retrieveImageUrl(product.photoPaths.first)
                    : null,
                containerWidth: screenSize.width * 0.22,
                containerHeight: double.infinity,
                noImageContent: Container(
                  color: Colors.white,
                  child: Icon(Icons.store),
                ),
                context: context,
              ),

              const SizedBox(
                width: 10,
              ),

              //details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.brand} ${product.name} ${product.model ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (product.colour != null) Text(product.colour!),

                        const SizedBox(
                          height: 20,
                        ),

                        Text('RM${product.price.toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                width: 20,
              ),

              Column(
                children: [
                  Chip(
                    side: BorderSide.none,
                    label: Text(
                      product.availability.label,
                      style: TextStyle(color: Colors.white),
                    ),
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    padding: EdgeInsets.all(0),
                    backgroundColor:
                        product.availability == ProductAvailability.ready
                        ? product.quantity != null && product.quantity! <= 0
                              ? Theme.of(context).colorScheme.error
                              : product.availability.color
                        : product.availability.color,
                  ),

                  const Spacer(),

                  if (product.quantity != null)
                    Text(
                      'Stock: ${product.quantity}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: product.quantity! > 0
                            ? Colors.grey
                            : Theme.of(context).colorScheme.error,
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
