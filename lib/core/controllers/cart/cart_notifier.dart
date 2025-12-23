import 'package:cheng_eng_3/core/controllers/product/product_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/cart_item_model.dart';
import 'package:cheng_eng_3/core/models/cart_state_model.dart'; // Ensure this matches your file
import 'package:cheng_eng_3/core/models/cart_entry_model.dart'; // Ensure this matches your file
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/cart_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'cart_notifier.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  CartService get _cartItemService => ref.read(cartServiceProvider);

  @override
  FutureOr<CartState> build() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return const CartState(entries: []);

    final data = await _cartItemService.getCartItems(user.id);
    
    final entries = await Future.wait(
      data.map((item) async {
         final product = await ref.watch(productByIdProvider(item.productId).future);
         return CartEntry(item: item, product: product);
      })
    );

    return CartState(entries: entries);
  }

  // --- ACTIONS ---

  Future<Message> addItem({
    required String productId,
    required int quantity,
    bool? requiredInstallation,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return const Message(isSuccess: false, message: 'User not authenticated');

    // 1. Get Current State Safely
    final currentState = state.value;
    if (currentState == null) return const Message(isSuccess: false, message: 'Cart loading...');

    try {
      final product = await ref.read(productByIdProvider(productId).future);

      // --- Validation ---
      if (product == null) return const Message(isSuccess: false, message: 'Product not found');
      
      if (product.availability == ProductAvailability.ready && (product.quantity ?? 0) < quantity) {
        return const Message(isSuccess: false, message: 'Sold Out');
      }

      if (product.installation == true && requiredInstallation == null) {
        return const Message(isSuccess: false, message: 'Please select installation preference');
      }

      // --- Create Objects ---
      final newItem = CartItem(
        id: const Uuid().v4(),
        quantity: quantity,
        installation: requiredInstallation,
        productId: productId,
        userId: user.id,
      );

      // Create the Entry (Wrapper) for UI
      final newEntry = CartEntry(item: newItem, product: product);

      // --- Optimistic Update ---
      // We append the new ENTRY to the list inside CartState
      final updatedEntries = [...currentState.entries, newEntry];
      state = AsyncData(currentState.copyWith(entries: updatedEntries));

      // --- API Call ---
      await _cartItemService.create(newItem);
      
      return const Message(isSuccess: true, message: 'Product added to cart');

    } catch (e) {
      // Revert on failure
      state = AsyncData(currentState); 
      return const Message(isSuccess: false, message: 'Failed to add to cart');
    }
  }

  Future<Message> increaseQty({required String itemId}) async {
    final currentState = state.value;
    if (currentState == null) return const Message(isSuccess: false, message: 'Error');

    try {
      // Find the ENTRY (not just the item)
      final entryIndex = currentState.entries.indexWhere((e) => e.item.id == itemId);
      if (entryIndex == -1) return const Message(isSuccess: false, message: 'Item not found');

      final entry = currentState.entries[entryIndex];
      final newQty = entry.item.quantity + 1;
      
      // Check Stock
      if (entry.product?.quantity != null && newQty > entry.product!.quantity!) {
        return const Message(isSuccess: false, message: 'Max stock reached');
      }

      // --- Optimistic Update ---
      // 1. Create new Item with updated quantity
      final updatedItem = entry.item.copyWith(quantity: newQty);
      // 2. Create new Entry with updated item
      final updatedEntry = CartEntry(item: updatedItem, product: entry.product);
      
      // 3. Replace in List
      final newEntries = [...currentState.entries];
      newEntries[entryIndex] = updatedEntry;

      state = AsyncData(currentState.copyWith(entries: newEntries));

      // --- API Call ---
      await _cartItemService.updateQuantity(newQty, itemId);

      return const Message(isSuccess: true, message: 'Quantity updated');

    } catch (e) {
      state = AsyncData(currentState);
      return const Message(isSuccess: false, message: 'Failed to update');
    }
  }

  Future<Message> decreaseQty({required String itemId}) async {
    final currentState = state.value;
    if (currentState == null) return const Message(isSuccess: false, message: 'Error');

    try {
      final entryIndex = currentState.entries.indexWhere((e) => e.item.id == itemId);
      if (entryIndex == -1) return const Message(isSuccess: false, message: 'Item not found');

      final entry = currentState.entries[entryIndex];
      final newQty = entry.item.quantity - 1;

      // Logic: If 0, Delete
      if (newQty <= 0) {
        return deleteItem(itemId);
      }

      // --- Optimistic Update ---
      final updatedItem = entry.item.copyWith(quantity: newQty);
      final updatedEntry = CartEntry(item: updatedItem, product: entry.product);
      
      final newEntries = [...currentState.entries];
      newEntries[entryIndex] = updatedEntry;

      state = AsyncData(currentState.copyWith(entries: newEntries));

      await _cartItemService.updateQuantity(newQty, itemId);

      return const Message(isSuccess: true, message: 'Quantity updated');

    } catch (e) {
      state = AsyncData(currentState);
      return const Message(isSuccess: false, message: 'Failed to update');
    }
  }

  Future<Message> deleteItem(String id) async {
    final currentState = state.value;
    if (currentState == null) return const Message(isSuccess: false, message: 'Error');

    try {
      // --- Optimistic Update ---
      // Filter out the entry with the matching Item ID
      final updatedEntries = currentState.entries.where((e) => e.item.id != id).toList();

      state = AsyncData(currentState.copyWith(entries: updatedEntries));

      await _cartItemService.delete(id);

      return const Message(isSuccess: true, message: 'Item deleted');
    } catch (e) {
      state = AsyncData(currentState);
      return const Message(isSuccess: false, message: 'Failed to delete item');
    }
  }
}