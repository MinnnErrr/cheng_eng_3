import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/customer_product_notifier.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/screens/customer/cart/cart_screen.dart';
import 'package:cheng_eng_3/ui/widgets/cart_icon.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomerProductDetailsScreen extends ConsumerStatefulWidget {
  const CustomerProductDetailsScreen({super.key, required this.productId});
  final String productId;

  @override
  ConsumerState<CustomerProductDetailsScreen> createState() {
    return _CustomerProductDetailsScreenState();
  }
}

class _CustomerProductDetailsScreenState
    extends ConsumerState<CustomerProductDetailsScreen> {
  final PageController _pageController = PageController();
  int _selectedQuantity = 1;
  bool _installSelected = false;

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(
      customerProductByIdProvider(widget.productId),
    );
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CartScreen(),
              ),
            ),
            child: cartIcon(ref, context),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 20),
      ),
      body: productState.when(
        data: (product) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  //photo
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: product.photoPaths.isEmpty
                        ? Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported),
                                Text('No image found'),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              //image
                              Expanded(
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: product.photoPaths.length,
                                  itemBuilder: (context, index) {
                                    final imageService = ref.read(
                                      imageServiceProvider,
                                    );
                                    final imageUrl = imageService
                                        .retrieveImageUrl(
                                          product.photoPaths[index],
                                        );

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                      child: Image.network(
                                        imageUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  progress.expectedTotalBytes !=
                                                      null
                                                  ? progress.cumulativeBytesLoaded /
                                                        progress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),

                              //dots
                              SmoothPageIndicator(
                                controller: _pageController,
                                count: product.photoPaths.length,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  dotColor: Colors.grey.shade400,
                                  expansionFactor: 3,
                                ),
                              ),
                            ],
                          ),
                  ),

                  //details
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.brand} ${product.name} ${product.model} | ${product.colour}',
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),

                        Text(
                          product.availability == ProductAvailability.ready
                              ? product.quantity! > 0
                                    ? product.availability.label
                                    : 'Out of Stock'
                              : ProductAvailability.preorder.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                product.availability ==
                                    ProductAvailability.ready
                                ? product.quantity! > 0
                                      ? product.availability.color
                                      : Theme.of(
                                          context,
                                        ).colorScheme.error
                                : ProductAvailability.preorder.color,
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        Text(
                          'RM ${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),

                        //selection
                        if (product.installation == true)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),

                              Text(
                                "Installation Service",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Row(
                                children: [
                                  Text('Installation Fee: '),
                                  Text(
                                    'RM ${product.installationFee!.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                spacing: 20,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: _installSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.grey.shade200,
                                      foregroundColor: _installSelected
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : Colors.grey.shade700,
                                    ),
                                    onPressed: () => setState(() {
                                      _installSelected = true;
                                    }),
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () => setState(() {
                                      _installSelected = false;
                                    }),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: _installSelected == false
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.grey.shade200,
                                      foregroundColor: _installSelected == false
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.onPrimary
                                          : Colors.grey.shade700,
                                    ),
                                    child: Text('No'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  //description
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          product.description,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),

                  //remarks
                  if (product.remarks != null)
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.errorContainer,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remarks',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            product.remarks ?? '-',
                            softWrap: true,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: productState.when(
        data: (product) {
          return BottomAppBar(
            height: MediaQuery.of(context).size.height * 0.11,
            child: Expanded(
              child: product.quantity != null && product.quantity! <= 0
                  ? ElevatedButton(
                      onPressed: null,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.grey,
                      ),
                      child: Text('Sold Out'),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //quantity
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Quantity",
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
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
                                        onPressed: () {
                                          if (_selectedQuantity > 1) {
                                            setState(() => _selectedQuantity--);
                                          }
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(
                                        _selectedQuantity.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        iconSize: 20,
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          setState(() => _selectedQuantity++);
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final message = await cartNotifier.addItem(
                                productId: product.id,
                                quantity: _selectedQuantity,
                              );

                              if (!context.mounted) return;
                              showAppSnackBar(
                                context: context,
                                content: message.message,
                                isError: !message.isSuccess,
                              );
                            },
                            child: Text('Add to Cart'),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
        error: (error, stackTrace) => Expanded(
          child: ElevatedButton(
            onPressed: null,

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.grey,
            ),
            child: Text('Add to Cart'),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
