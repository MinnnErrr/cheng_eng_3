import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/customer_product_notifier.dart';
import 'package:cheng_eng_3/core/models/cart_item_model.dart';
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/cart_item_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'cart_notifier.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  CartItemService get _cartItemService => ref.read(cartItemServiceProvider);

  @override
  FutureOr<List<CartItem>> build() async {
    final userState = ref.watch(authProvider);
    final user = userState.value;
    if (user == null) return [];
    final data = await _cartItemService.getCartItems(user.id);
    return data;
  }

  Future<Message> addItem({
    required String productId,
    required int quantity,
    bool? requiredInstallation,
  }) async {
    final user = ref.read(authProvider).value;
    if (user == null) {
      return Message(isSuccess: false, message: 'User not authenticated');
    }

    final productAsync = ref.read(customerProductByIdProvider(productId));
    if (productAsync is! AsyncData) {
      return Message(isSuccess: false, message: 'Product is loading or failed');
    }
    final product = productAsync.value;

    if (product == null) {
      return Message(isSuccess: false, message: 'Invalid product');
    }

    //verify product is not out of stock
    if (product.availability == ProductAvailability.ready &&
        product.quantity != null) {
      if (product.quantity! <= 0) {
        return Message(isSuccess: false, message: 'Product is sold out');
      }
    }

    //verify installation selected for product with installation service
    if (product.installation == true && requiredInstallation == null) {
      return Message(
        isSuccess: false,
        message: 'Please choose do you want installation service',
      );
    }

    final cartItemId = Uuid().v4();

    final item = CartItem(
      id: cartItemId,
      quantity: quantity,
      installation: requiredInstallation,
      productId: productId,
      userId: user.id,
    );

    final previous = state.value ?? [];

    try {
      state = const AsyncLoading();

      final newItem = await _cartItemService.create(item);

      state = AsyncData([...previous, newItem]);

      return Message(isSuccess: true, message: 'Product added to cart');
    } catch (e) {
      return Message(
        isSuccess: false,
        message: 'Failed to add product to cart',
      );
    }
  }

  Future<Message> updateQuantity({
    required int quantity,
    required String itemId,
  }) async {
    final previous = state.value ?? [];

    // Find the current cart item
    final cartItem = previous.firstWhere((item) => item.id == itemId);

    // Get product
    final productId = cartItem.productId;

    final productAsync = ref.read(customerProductByIdProvider(productId));
    final product = productAsync.value;

    if (product == null) {
      return Message(isSuccess: false, message: 'Product not found');
    }

    // Check stock
    if (product.quantity != null && quantity > product.quantity!) {
      return Message(
        isSuccess: false,
        message:
            'Quantity exceeded product stock, please decrease the quantity',
      );
    }

    if (quantity <= 0) {
      return deleteItem(itemId);
    }

    try {
      state = const AsyncLoading();

      final updated = await _cartItemService.updateQuantity(quantity, itemId);

      final updatedList = previous.map((item) {
        return item.id == itemId ? updated : item;
      }).toList();

      state = AsyncData(updatedList);

      return Message(
        isSuccess: true,
        message: 'Item quantity updated',
      );
    } catch (e) {
      return Message(
        isSuccess: false,
        message: 'Failed to update item quantity',
      );
    }
  }

  Future<Message> deleteItem(String id) async {
    final previous = state.value ?? [];

    try {
      state = const AsyncLoading();

      await _cartItemService.delete(id);

      final updatedList = previous.where((item) => item.id != id).toList();

      state = AsyncData(updatedList);

      return Message(isSuccess: true, message: 'Item deleted');
    } catch (e) {
      state = AsyncData(previous);
      return Message(isSuccess: false, message: 'Failed to delete item');
    }
  }
}

final cartItemByIdProvider = Provider.family<AsyncValue<CartItem>, String>((
  ref,
  itemId,
) {
  final cartItems = ref.watch(cartProvider);

  return cartItems.when(
    data: (items) {
      final item = items.firstWhere(
        (item) => item.id == itemId,
        orElse: () => throw Exception('Cart item not found'),
      );
      return AsyncValue.data(item);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, st) => AsyncValue.error(err, st),
  );
});
