import 'package:cheng_eng_3/core/controllers/product/staff_product_notifier.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/screens/staff/product/staff_product_update_screen.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StaffProductDetailsScreen extends ConsumerStatefulWidget {
  const StaffProductDetailsScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<StaffProductDetailsScreen> createState() {
    return _StaffProductDetailsScreenState();
  }
}

class _StaffProductDetailsScreenState
    extends ConsumerState<StaffProductDetailsScreen> {
  late bool _isActive;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(staffProductByIdProvider(widget.productId));
    final notifier = ref.read(
      staffProductProvider.notifier,
    );
    DateFormat timeFormatter = DateFormat('dd/MM/yyyy').add_jm();

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: productState.when(
        data: (product) {
          _isActive = product.status;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  //product status
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(
                          'Status',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          _isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _isActive
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Switch(
                          value: _isActive,
                          activeThumbColor: Colors.green,
                          onChanged: (value) async {
                            setState(() {
                              _isActive = value;
                            });

                            final success = await notifier.updateStatus(
                              id: widget.productId,
                              isActive: value,
                            );
                            if (!context.mounted) return;
                            showAppSnackBar(
                              context: context,
                              content: success
                                  ? "Product status updated"
                                  : "Failed to update status",
                              isError: !success,
                            );
                            if (!success) {
                              setState(() {
                                _isActive = !value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  //product details
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profile Details',
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StaffProductUpdateScreen(
                                      productId: product.id,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                            ),
                          ],
                        ),
                        //picture section
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
                                                if (progress == null)
                                                  return child;
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
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
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
                        Text(
                          '${product.brand} ${product.name} ${product.model ?? ''}',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        _detail(title: 'Category', content: product.category),
                        _detail(
                          title: 'Colour',
                          content: product.colour ?? '-',
                        ),
                        _detail(
                          title: 'Price',
                          content: 'RM ${product.price.toStringAsFixed(2)}',
                        ),
                        _detail(
                          title: 'Description',
                          content: product.description,
                        ),
                        _detail(
                          title: 'Remarks',
                          content: product.remarks ?? '-',
                        ),
                        _detail(
                          title: 'Created At',
                          content: timeFormatter.format(product.createdAt),
                        ),
                        _detail(
                          title: 'Updated At',
                          content: product.updatedAt != null
                              ? timeFormatter.format(product.updatedAt!)
                              : '-',
                        ),

                        //availability
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLowest,
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Availability Info',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Availability: ',
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          product.availability ==
                                              ProductAvailability.ready
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
                                            : ProductAvailability
                                                  .preorder
                                                  .color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (product.availability ==
                                  ProductAvailability.ready)
                                Text.rich(
                                  TextSpan(
                                    text: 'Stock Number: ',
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: product.quantity.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: product.quantity! > 0
                                              ? product.availability.color
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        //installation
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerLowest,
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product Installation Info',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Installation Provided: ${product.installation}',
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (product.installation == true)
                                Text(
                                  'Installation Price: RM${product.installationFee!.toStringAsFixed(2)}',
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      final success = await notifier.deleteProduct(product.id);

                      if (!context.mounted) return;
                      showAppSnackBar(
                        context: context,
                        content: success
                            ? 'Product deleted'
                            : 'Failed to delete product0',
                        isError: !success,
                      );

                      if (success) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Delete Product'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _detail({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          content,
          softWrap: true,
        ),
      ],
    );
  }
}
