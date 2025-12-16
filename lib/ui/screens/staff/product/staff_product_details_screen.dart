import 'package:cheng_eng_3/core/controllers/product/product_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/product/staff_product_notifier.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
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
  const StaffProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<StaffProductDetailsScreen> createState() {
    return _StaffProductDetailsScreenState();
  }
}

class _StaffProductDetailsScreenState
    extends ConsumerState<StaffProductDetailsScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(productRealTimeProvider);
    final productState = ref.watch(productByIdProvider(widget.product.id));

    // Optimistic UI
    final Product displayedProduct = productState.value ?? widget.product;
    final bool isActive = displayedProduct.status;
    final notifier = ref.read(staffProductProvider.notifier);
    final DateFormat timeFormatter = DateFormat('dd/MM/yyyy').add_jm();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: productState.when(
        data: (product) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- Status Section ---
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Text(
                          'Status',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          isActive ? "Active" : "Inactive",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? Colors.green
                                : Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Switch(
                          value: isActive,
                          activeThumbColor: Colors.green,
                          onChanged: (value) async {
                            final message = await notifier.updateStatus(
                              id: displayedProduct.id,
                              isActive: value,
                            );

                            if (!context.mounted) return;

                            if (!message.isSuccess) {
                              showAppSnackBar(
                                context: context,
                                content: message.message,
                                isError: true,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- Product Details Section ---
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header + Edit Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Profile Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StaffProductUpdateScreen(
                                      product: product,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                        
                        // Picture Carousel
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: product.photoPaths.isEmpty
                              ? Container(
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.image_not_supported),
                                      Text('No image found'),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Expanded(
                                      child: PageView.builder(
                                        controller: _pageController,
                                        itemCount: product.photoPaths.length,
                                        itemBuilder: (context, index) {
                                          final imageService =
                                              ref.read(imageServiceProvider);
                                          final imageUrl =
                                              imageService.retrieveImageUrl(
                                            product.photoPaths[index],
                                          );

                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Image.network(
                                              imageUrl,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (context, child, progress) {
                                                if (progress == null) return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: progress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? progress
                                                                .cumulativeBytesLoaded /
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
                                    SmoothPageIndicator(
                                      controller: _pageController,
                                      count: product.photoPaths.length,
                                      effect: ExpandingDotsEffect(
                                        dotHeight: 8,
                                        dotWidth: 8,
                                        activeDotColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        dotColor: Colors.grey.shade400,
                                        expansionFactor: 3,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        
                        const SizedBox(height: 20),

                        // Text Details
                        Text(
                          '${product.brand} ${product.name} ${product.model ?? ''}',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _detail(title: 'Category', content: product.category),
                        _detail(
                            title: 'Colour', content: product.colour ?? '-'),
                        _detail(
                          title: 'Price',
                          content: 'RM ${product.price.toStringAsFixed(2)}',
                        ),
                        _detail(
                            title: 'Description', content: product.description),
                        _detail(
                            title: 'Remarks', content: product.remarks ?? '-'),
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

                        const SizedBox(height: 20),

                        // Availability Box
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLowest,
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Product Availability Info',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              _buildAvailabilityText(context, product),
                              const SizedBox(height: 5),
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
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Installation Box
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLowest,
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Product Installation Info',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  'Installation Provided: ${product.installation}'),
                              const SizedBox(height: 5),
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

                  const SizedBox(height: 20),

                  // Delete Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        final message = await notifier.deleteProduct(product.id);

                        if (!context.mounted) return;
                        
                        showAppSnackBar(
                          context: context,
                          content: message.isSuccess
                              ? 'Product deleted'
                              : 'Failed to delete product',
                          isError: !message.isSuccess,
                        );

                        if (message.isSuccess) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Delete Product'),
                    ),
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

  // Extracted Helper for the complex availability logic
  Widget _buildAvailabilityText(BuildContext context, Product product) {
    String label;
    Color color;

    if (product.availability == ProductAvailability.ready) {
      if ((product.quantity ?? 0) > 0) {
        label = product.availability.label; // e.g., "Ready Stock"
        color = product.availability.color; // e.g., Green
      } else {
        label = 'Out of Stock';
        color = Theme.of(context).colorScheme.error;
      }
    } else {
      label = ProductAvailability.preorder.label;
      color = ProductAvailability.preorder.color;
    }

    return Text.rich(
      TextSpan(
        text: 'Availability: ',
        children: <TextSpan>[
          TextSpan(
            text: label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            content,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}