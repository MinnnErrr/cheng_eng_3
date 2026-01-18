import 'package:cheng_eng_3/ui/core/theme/colorscheme.dart';
import 'package:cheng_eng_3/data/providers/product/product_by_id_provider.dart';
import 'package:cheng_eng_3/ui/core/widgets/full_screen_image.dart';
import 'package:cheng_eng_3/ui/products/notifiers/staff_product_notifier.dart';
import 'package:cheng_eng_3/data/providers/realtime_provider.dart';
import 'package:cheng_eng_3/domain/models/product_model.dart';
import 'package:cheng_eng_3/data/services/image_service.dart';
import 'package:cheng_eng_3/ui/products/extensions/product_extension.dart';
import 'package:cheng_eng_3/ui/products/screens/staff/staff_product_update_screen.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
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
    final Product displayedProduct = productState.value ?? widget.product;
    final bool isActive = displayedProduct.status;
    final notifier = ref.read(staffProductProvider.notifier);

    final theme = Theme.of(context);
    final DateFormat timeFormatter = DateFormat('dd MMM yyyy, h:mm a');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Product Details'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => StaffProductUpdateScreen(
                    product: displayedProduct,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            tooltip: "Edit Product",
          ),
        ],
      ),
      body: productState.when(
        data: (product) {
          if (product == null) {
            return const Center(child: Text('No product found'));
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 1. STATUS CARD ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.green.withValues(alpha: 0.1)
                          : theme.colorScheme.errorContainer.withValues(
                              alpha: 0.5,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isActive
                            ? Colors.green
                            : theme.colorScheme.error,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.check_circle : Icons.unpublished,
                          color: isActive
                              ? Colors.green
                              : theme.colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CURRENT STATUS",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                isActive
                                    ? "ACTIVE (VISIBLE)"
                                    : "INACTIVE (HIDDEN)",
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: isActive
                                      ? Colors.green.shade800
                                      : theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
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

                  const SizedBox(height: 24),

                  // --- 2. MAIN DETAILS CARD ---
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // A. Image Carousel
                        SizedBox(
                          height: 250,
                          width: double.infinity,
                          child: displayedProduct.photoPaths.isEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No images available',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Stack(
                                  children: [
                                    PageView.builder(
                                      controller: _pageController,
                                      itemCount:
                                          displayedProduct.photoPaths.length,
                                      itemBuilder: (context, index) {
                                        final imageService = ref.read(
                                          imageServiceProvider,
                                        );
                                        final imageUrl = imageService
                                            .retrieveImageUrl(
                                              displayedProduct
                                                  .photoPaths[index],
                                            );

                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullScreenImageView(
                                                      imageUrl: imageUrl,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: imageUrl,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(16),
                                                  ),
                                              child: Image.network(
                                                imageUrl,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                        ),
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (displayedProduct.photoPaths.length > 1)
                                      Positioned(
                                        bottom: 12,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: SmoothPageIndicator(
                                            controller: _pageController,
                                            count: displayedProduct
                                                .photoPaths
                                                .length,
                                            effect: ExpandingDotsEffect(
                                              dotHeight: 8,
                                              dotWidth: 8,
                                              activeDotColor:
                                                  theme.colorScheme.primary,
                                              dotColor: Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                        ),

                        // B. Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${displayedProduct.brand} ${displayedProduct.name} ${displayedProduct.model ?? ''}',
                                style: theme.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (displayedProduct.colour != null)
                                    Text(
                                      displayedProduct.colour!,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),

                                  const Spacer(),

                                  Text(
                                    'RM ${displayedProduct.price.toStringAsFixed(2)}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: textYellow,
                                          fontSize: 22,
                                        ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              _buildDetailRow(
                                context,
                                'Category',
                                displayedProduct.category,
                              ),
                              const SizedBox(height: 12),

                              _buildAvailabilityRow(context, displayedProduct),

                              const SizedBox(height: 12),

                              _buildInstallationRow(context, displayedProduct),

                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 16),

                              _buildDetailRow(
                                context,
                                'Created On',
                                timeFormatter.format(
                                  displayedProduct.createdAt,
                                ),
                                isMeta: true,
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow(
                                context,
                                'Last Updated',
                                displayedProduct.updatedAt != null
                                    ? timeFormatter.format(
                                        displayedProduct.updatedAt!,
                                      )
                                    : '-',
                                isMeta: true,
                              ),

                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 16),

                              _buildLongTextSection(
                                context,
                                "Description",
                                displayedProduct.description,
                              ),
                              const SizedBox(height: 20),
                              _buildLongTextSection(
                                context,
                                "Remarks",
                                displayedProduct.remarks ?? '-',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- 3. DELETE BUTTON ---
                  SizedBox(
                    height: 54,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.colorScheme.error),
                        foregroundColor: theme.colorScheme.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Product'),
                            content: const Text(
                              'Are you sure you want to delete this product?\nThis action cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm != true) return;

                        final message = await notifier.deleteProduct(
                          displayedProduct.id,
                        );

                        if (!context.mounted) return;

                        showAppSnackBar(
                          context: context,
                          content: message.message,
                          isError: !message.isSuccess,
                        );

                        if (message.isSuccess) {
                          Navigator.of(context).pop();
                        }
                      },
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('DELETE PRODUCT'),
                    ),
                  ),
                  const SizedBox(height: 40),
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

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isMeta = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isMeta ? FontWeight.normal : FontWeight.w600,
            fontSize: 14,
            color: isMeta
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityRow(BuildContext context, Product product) {
    String label;
    Color color;

    label = product.availability.getlabel(product.quantity);
    color = product.availability.getcolor(product.quantity);

    if (product.availability == ProductAvailability.ready) {
      label = "$label (${product.quantity})";
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Availability",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstallationRow(BuildContext context, Product product) {
    final hasInstallation = product.installation;
    final fee = product.installationFee ?? 0.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Installation",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        Text(
          hasInstallation ? "Yes (+RM ${fee.toStringAsFixed(2)})" : "No",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildLongTextSection(
    BuildContext context,
    String title,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
