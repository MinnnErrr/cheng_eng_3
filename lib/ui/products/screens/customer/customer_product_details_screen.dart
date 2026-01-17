import 'package:cheng_eng_3/ui/core/theme/colorscheme.dart';
import 'package:cheng_eng_3/ui/cart/notifiers/cart_notifier.dart';
import 'package:cheng_eng_3/data/providers/product/product_by_id_provider.dart';
import 'package:cheng_eng_3/data/providers/realtime_provider.dart';
import 'package:cheng_eng_3/domain/models/product_model.dart';
import 'package:cheng_eng_3/data/services/image_service.dart';
import 'package:cheng_eng_3/ui/products/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/cart/screens/cart_screen.dart';
import 'package:cheng_eng_3/ui/core/widgets/cart_icon.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
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
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    ref.watch(productRealTimeProvider);

    final productAsync = ref.watch(productByIdProvider(widget.product.id));
    final product = productAsync.value ?? widget.product;
    final cartNotifier = ref.read(cartProvider.notifier);
    final theme = Theme.of(context);
    final isSoldOut = product.quantity != null && product.quantity! <= 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CartScreen()),
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: CartIconBadge(
                icon: Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HERO IMAGE CAROUSEL ---
              _buildImageSlider(product, theme),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 2. HEADER INFO ---
                    // Availability Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: product.availability
                            .getcolor(product.quantity)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.availability.getlabel(product.quantity),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: product.availability.getcolor(
                            product.quantity,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Title (Name + Model)
                    Text(
                      '${product.brand} ${product.name} ${product.model ?? ''}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 4),
                    if (product.colour != null)
                      Text(
                        '${product.colour}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Price
                    Text(
                      'RM ${product.price.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textYellow,
                      ),
                    ),

                    // --- 3. INSTALLATION OPTION ---
                    if (product.installation == true) ...[
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.build_circle_outlined,
                                      color: Color(0xFF9E7C00),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Add Installation?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '+ RM ${product.installationFee?.toStringAsFixed(2) ?? '0.00'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF9E7C00),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ChoiceChip(
                                  label: const Text("No, thanks"),
                                  selected: !_installSelected,
                                  onSelected: (val) =>
                                      setState(() => _installSelected = false),
                                  selectedColor:
                                      theme.colorScheme.primaryContainer,
                                  checkmarkColor: theme.colorScheme.onPrimary,
                                ),
                                const SizedBox(width: 12),
                                ChoiceChip(
                                  label: const Text("Yes, please"),
                                  selected: _installSelected,
                                  onSelected: (val) =>
                                      setState(() => _installSelected = true),
                                  selectedColor:
                                      theme.colorScheme.primaryContainer,
                                  checkmarkColor: theme.colorScheme.onPrimary,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Divider(height: 1),
                    ),

                    // --- 4. DESCRIPTION ---
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- 5. REMARKS ---
                    if (product.remarks != null && product.remarks!.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Additional Notes',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(product.remarks!),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // --- BOTTOM BAR ---
      bottomNavigationBar: BottomAppBar(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: theme.colorScheme.surface,
        child: isSoldOut
            ? Center(
                child: FilledButton.tonal(
                  onPressed: null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('SOLD OUT'),
                ),
              )
            : Row(
                children: [
                  // Quantity Selector
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_selectedQuantity > 1) {
                              setState(() => _selectedQuantity--);
                            }
                          },
                          icon: const Icon(Icons.remove, size: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Text(
                          '$_selectedQuantity',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() => _selectedQuantity++);
                          },
                          icon: const Icon(Icons.add, size: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Add to Cart Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: _isAddingToCart
                            ? null
                            : () async {
                                setState(() => _isAddingToCart = true);

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
                        icon: _isAddingToCart
                            ? const SizedBox.shrink()
                            : const Icon(Icons.shopping_cart_outlined),
                        label: _isAddingToCart
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "ADD TO CART",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildImageSlider(Product product, ThemeData theme) {
    if (product.photoPaths.isEmpty) {
      return Container(
        height: 300,
        width: double.infinity,
        color: theme.colorScheme.surfaceContainerHighest,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              'No image found',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    final imageService = ref.read(imageServiceProvider);

    return SizedBox(
      height: 300,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: product.photoPaths.length,
            itemBuilder: (context, index) {
              final imageUrl = imageService.retrieveImageUrl(
                product.photoPaths[index],
              );
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) =>
                    Container(color: Colors.grey.shade200),
                loadingBuilder: (_, child, loading) {
                  if (loading == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),

          // Gradient Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),

          // Dots
          if (product.photoPaths.length > 1)
            Positioned(
              bottom: 16,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: product.photoPaths.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white54,
                  expansionFactor: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
