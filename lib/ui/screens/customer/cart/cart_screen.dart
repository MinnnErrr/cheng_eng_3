
import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/controllers/cart/cart_total_provider.dart';
import 'package:cheng_eng_3/core/controllers/product/customer_product_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/cart/checkout_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/product/customer_product_screen.dart';
import 'package:cheng_eng_3/ui/widgets/cart_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  List<bool> _hasSoldOut = [];

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: cartState.when(
        data: (items) {
          final products = items.map((i) {
            return ref.watch(customerProductByIdProvider(i.productId)).value;
          }).toList();

          _hasSoldOut = products.map((p) {
            if (p == null) return false;
            return p.quantity != null && p.quantity! <= 0;
          }).toList();

          return items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Your cart is empty'),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CustomerProductScreen(),
                          ),
                        ),
                        child: Text('Shop Now'),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 40,
                        thickness: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final product = ref
                            .watch(
                              customerProductByIdProvider(item.productId),
                            )
                            .value;

                        if (product == null) {
                          return SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    'No product found or product is removed',
                                  ),
                                  Text('Please remove the item'),
                                  TextButton(
                                    onPressed: () =>
                                        cartNotifier.deleteItem(item.id),
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: () {},
                          child: CartListitem(
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
                              final message = await cartNotifier.deleteItem(
                                item.id,
                              );

                              if (!context.mounted) return;
                              showAppSnackBar(
                                context: context,
                                content: message.message,
                                isError: !message.isSuccess,
                              );
                            },
                          ),
                        );
                      },
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
      bottomNavigationBar: cartState.when(
        data: (cart) {
          final subtotal = ref.watch(cartTotalProvider);
          final point = ref.watch(cartPointProvider);

          return BottomAppBar(
            height: MediaQuery.of(context).size.height * 0.16,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Points earned",
                      ),
                      Text(
                        point.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal (RM)",
                      ),
                      Text(
                        subtotal.toStringAsFixed(2),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasSoldOut.contains(true)
                            ? Colors.grey.shade200
                            : Theme.of(context).colorScheme.primary,
                        foregroundColor: _hasSoldOut.contains(true)
                            ? Colors.grey
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: _hasSoldOut.contains(true)
                          ? null
                          : () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(),
                              ),
                            ),
                      child: Text('Checkout'),
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
            child: Text('Checkout'),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
