import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/controllers/cart/cart_prices_provider.dart';
import 'package:cheng_eng_3/core/controllers/cart/cart_valid_provider.dart';
import 'package:cheng_eng_3/core/controllers/product/product_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/cart_item_model.dart';
import 'package:cheng_eng_3/ui/screens/customer/cart/checkout_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/product/customer_product_screen.dart';
import 'package:cheng_eng_3/ui/widgets/cart_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: cartState.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your cart is empty'),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CustomerProductScreen(),
                      ),
                    ),
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            );
          }

          // Use Safe Area + ListView
          return SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 40),
              itemBuilder: (context, index) {
                final item = items[index];

                // This is a Widget, so it's safe to use a separate consumer
                // or just wrap the item in a dedicated widget that watches the product
                return _CartItemRow(item: item);
              },
            ),
          );
        },
        error: (e, s) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),

      // Bottom Bar needs to know if ANY product is sold out
      // We need a smart way to calculate this without ref.watch in a loop.
      bottomNavigationBar: cartState.hasValue && cartState.value!.isNotEmpty
          ? _CartBottomBar(items: cartState.value!)
          : null,
    );
  }
}

// Extract Row to handle individual product fetching cleanly
class _CartItemRow extends ConsumerWidget {
  final CartItem item;
  const _CartItemRow({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(item.productId));
    final cartNotifier = ref.read(cartProvider.notifier);

    return productAsync.when(
      data: (product) {
        return CartListitem(
          item: item,
          product: product,
          incrementAction: () => cartNotifier.updateQuantity(
            quantity: item.quantity + 1,
            itemId: item.id,
          ),
          decrementAction: () => cartNotifier.updateQuantity(
            quantity: item.quantity - 1,
            itemId: item.id,
          ),
          deleteAction: () async {
            final message = await cartNotifier.deleteItem(item.id);
            if (context.mounted) {
              showAppSnackBar(
                context: context,
                content: message.message,
                isError: !message.isSuccess,
              );
            }
          },
        );
      },
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => ListTile(
        title: const Text("Product Unavailable"),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => cartNotifier.deleteItem(item.id),
        ),
      ),
    );
  }
}

// Extract Bottom Bar to calculate "Sold Out" state efficiently
class _CartBottomBar extends ConsumerWidget {
  final List<CartItem> items;
  const _CartBottomBar({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotalAsync = ref.watch(cartTotalProvider);
    final pointsAsync = ref.watch(cartPointProvider);
    final isValidAsync = ref.watch(isCartValidProvider);

    return BottomAppBar(
      height: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- POINTS ROW ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Points earned"),
              pointsAsync.when(
                data: (points) => Text(
                  points.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Show small spinner or placeholder while calculating
                loading: () => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                // Default to 0 on error
                error: (e, s) => const Text(
                  '0',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // --- SUBTOTAL ROW ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal (RM)"),
              subtotalAsync.when(
                data: (total) => Text(
                  total.toStringAsFixed(2),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                loading: () => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (e, s) => const Text(
                  '0.00',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --- CHECKOUT BUTTON ---
          Expanded(
            child: ElevatedButton(
              onPressed: (!isValidAsync.isLoading && isValidAsync.value == true)
                  ? () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CheckoutScreen(),
                      ),
                    )
                  : null,
              child: isValidAsync.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Checkout'),
            ),
          ),
        ],
      ),
    );
  }
}
