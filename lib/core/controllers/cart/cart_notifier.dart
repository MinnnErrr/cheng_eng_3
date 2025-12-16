import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/product_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/cart_item_model.dart';
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/cart_item_service.dart';
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
    
    // Note: If you want the cart to update securely, consider passing the userId 
    // to the provider family instead of reading it inside, but this works for now.
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

    try {
      // FIX: Use .future to ensure we wait for the product to load if it's not cached
      final product = await ref.read(productByIdProvider(productId).future);

      // Verify product is not out of stock
      if (product.availability == ProductAvailability.ready &&
          product.quantity != null) {
        if (product.quantity! <= 0) {
          return Message(isSuccess: false, message: 'Product is sold out');
        }
      }

      // Verify installation selection
      if (product.installation == true && requiredInstallation == null) {
        return Message(
          isSuccess: false,
          message: 'Please choose if you want installation service',
        );
      }

      final cartItemId = const Uuid().v4();

      final item = CartItem(
        id: cartItemId,
        quantity: quantity,
        installation: requiredInstallation,
        productId: productId,
        userId: user.id,
      );

      // Optimistic Update Preparation
      final previous = state.value ?? [];
      state = const AsyncLoading();

      final newItem = await _cartItemService.create(item);

      state = AsyncData([...previous, newItem]);

      return Message(isSuccess: true, message: 'Product added to cart');
    } catch (e) {
      // Handle product fetch errors or service errors
      return Message(
        isSuccess: false,
        message: 'Failed to add product: ${e.toString()}',
      );
    }
  }

  Future<Message> updateQuantity({
    required int quantity,
    required String itemId,
  }) async {
    final previous = state.value ?? [];
    
    try {
      final cartItem = previous.firstWhere((item) => item.id == itemId);
      
      // FIX: Await the future. If user went straight to cart, product might not be loaded.
      final product = await ref.read(productByIdProvider(cartItem.productId).future);

      // Check stock limit
      if (product.quantity != null && quantity > product.quantity!) {
        return Message(
          isSuccess: false,
          message: 'Quantity exceeded product stock',
        );
      }

      if (quantity <= 0) {
        return deleteItem(itemId);
      }

      state = const AsyncLoading();

      final updated = await _cartItemService.updateQuantity(quantity, itemId);

      final updatedList = previous.map((item) {
        return item.id == itemId ? updated : item;
      }).toList();

      state = AsyncData(updatedList);

      return Message(isSuccess: true, message: 'Item quantity updated');
    } catch (e) {
      // Restore state on error if needed, or just return error message
      state = AsyncData(previous); 
      return Message(
        isSuccess: false,
        message: 'Failed to update: ${e.toString()}',
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