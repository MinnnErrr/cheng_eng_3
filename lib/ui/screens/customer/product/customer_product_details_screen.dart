import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/product_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
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
  const CustomerProductDetailsScreen({super.key, required this.product});
  final Product product;

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
  bool _isAddingToCart = false; // Local loading state for button

  @override
  Widget build(BuildContext context) {
    ref.watch(productRealTimeProvider);

    // 1. Optimistic UI Pattern
    // Watch for updates, but use the passed widget.product immediately
    final productAsync = ref.watch(productByIdProvider(widget.product.id));
    final product = productAsync.value ?? widget.product;

    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ),
            child: cartIcon(ref, context),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 20, // Flutter 3.27+
            children: [
              // --- PHOTO SECTION ---
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
                                final imageService = ref.read(imageServiceProvider);
                                final imageUrl = imageService.retrieveImageUrl(
                                  product.photoPaths[index],
                                );

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: progress.expectedTotalBytes != null
                                              ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.broken_image, size: 50),
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
                              activeDotColor: Theme.of(context).colorScheme.primary,
                              dotColor: Colors.grey.shade400,
                              expansionFactor: 3,
                            ),
                          ),
                        ],
                      ),
              ),

              // --- DETAILS SECTION ---
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.brand} ${product.name} ${product.model ?? ''} | ${product.colour ?? ''}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    
                    // Availability Badge
                    Text(
                      product.availability == ProductAvailability.ready
                          ? product.quantity! > 0
                              ? product.availability.label
                              : 'Out of Stock'
                          : ProductAvailability.preorder.label,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: product.availability == ProductAvailability.ready
                            ? product.quantity! > 0
                                ? product.availability.color
                                : Theme.of(context).colorScheme.error
                            : ProductAvailability.preorder.color,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      'RM ${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),

                    // --- INSTALLATION SELECTION ---
                    if (product.installation == true) ...[
                      const SizedBox(height: 30),
                      const Text(
                        "Installation Service",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text('Fee: '),
                          Text(
                            'RM ${product.installationFee?.toStringAsFixed(2) ?? '0.00'}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildOptionButton(
                            label: 'Yes',
                            isSelected: _installSelected,
                            onTap: () => setState(() => _installSelected = true),
                          ),
                          const SizedBox(width: 20),
                          _buildOptionButton(
                            label: 'No',
                            isSelected: !_installSelected,
                            onTap: () => setState(() => _installSelected = false),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // --- DESCRIPTION ---
              Container(
                width: double.infinity,
                color: Theme.of(context).colorScheme.surfaceContainer,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(product.description),
                  ],
                ),
              ),

              // --- REMARKS ---
              if (product.remarks != null && product.remarks!.isNotEmpty)
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.errorContainer,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Remarks',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        product.remarks!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
      
      // --- BOTTOM BAR ---
      bottomNavigationBar: BottomAppBar(
        height: MediaQuery.of(context).size.height * 0.12,
        child: (product.quantity != null && product.quantity! <= 0)
            ? SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                  ),
                  child: const Text('Sold Out'),
                ),
              )
            : Row(
                children: [
                  // Quantity Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.surfaceContainerLowest,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              iconSize: 20,
                              onPressed: () {
                                if (_selectedQuantity > 1) {
                                  setState(() => _selectedQuantity--);
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              '$_selectedQuantity',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              iconSize: 20,
                              onPressed: () {
                                // Optional: Check against product.quantity limit here
                                setState(() => _selectedQuantity++);
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  
                  // Add to Cart Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isAddingToCart 
                          ? null 
                          : () async {
                            setState(() => _isAddingToCart = true);

                            // 2. CRITICAL FIX: Pass _installSelected to the provider
                            final message = await cartNotifier.addItem(
                              productId: product.id,
                              quantity: _selectedQuantity,
                              requiredInstallation: _installSelected, 
                            );

                            if (!context.mounted) return;
                            
                            setState(() => _isAddingToCart = false);

                            showAppSnackBar(
                              context: context,
                              content: message.message,
                              isError: !message.isSuccess,
                            );
                          },
                        child: _isAddingToCart 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                          : const Text('Add to Cart'),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Helper widget for Yes/No buttons
  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade200,
          foregroundColor: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Colors.grey.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}