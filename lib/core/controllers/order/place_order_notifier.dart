import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/controllers/checkout/checkout_notifier.dart';
import 'package:cheng_eng_3/core/controllers/profile/user_profile_provider.dart';
import 'package:cheng_eng_3/core/models/cart_state_model.dart';
import 'package:cheng_eng_3/core/models/order_item_model.dart';
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/core/services/cart_service.dart';
import 'package:cheng_eng_3/core/services/order_service.dart';
import 'package:cheng_eng_3/core/services/product_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'place_order_notifier.g.dart';

@riverpod
class PlaceOrderNotifier extends _$PlaceOrderNotifier {
  OrderService get _orderService => ref.read(orderServiceProvider);
  ProductService get _productService => ref.read(productServiceProvider);
  CartService get _cartService => ref.read(cartServiceProvider);

  @override
  FutureOr<void> build() {}

  Future<String?> placeOrder({
    required CartState cartState,
    required DeliveryMethod method,
    required Address? address,
    required String userId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final profile = await ref.read(
        userProfileByUserIdProvider(user.id).future,
      );
      if (profile == null) {
        throw Exception('Profile not found. Please create a profile first');
      }

      final checkout = await ref.read(checkoutProvider.future);
      final subtotal = cartState.subtotal;
      final deliveryFee = checkout.deliveryFee;
      final total = checkout.total;
      final points = checkout.points;

      final newOrderId = const Uuid().v4();

      // --- STEP 3: CREATE ORDER OBJECT ---
      final newOrder = Order(
        id: newOrderId,
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: null,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        total: total,
        points: points,
        username: profile.name,
        userEmail: profile.email,
        userPhoneNum: profile.phoneNum,
        userDialCode: profile.dialCode,
        status: OrderStatus.unpaid,
        deliveryMethod: method,
        deliveryFirstName: address?.firstName,
        deliveryLastName: address?.lastName,
        deliveryPhoneNum: address?.phoneNum,
        deliveryDialCode: address?.dialCode,
        deliveryAddressLine1: address?.line1,
        deliveryAddressLine2: address?.line2,
        deliveryPostcode: address?.postcode,
        deliveryCity: address?.city,
        deliveryState: address?.state,
        deliveryCountry: address?.country,
      );

      // --- STEP 4: MAP CART TO ORDER ITEM ---
      final List<OrderItem> orderItems = [];

      for (final cartEntry in cartState.entries) {
        final product = cartEntry.product;
        final item = cartEntry.item;

        if (product == null) {
          throw Exception(
            "Product unavaliable",
          );
        }

        orderItems.add(
          OrderItem(
            id: const Uuid().v4(),
            orderId: newOrderId,
            productId: product.id,
            quantity: item.quantity,
            productBrand: product.brand,
            productName: product.name,
            productModel: product.model,
            productColour: product.colour,
            productPrice: product.price,
            productInstallationFee: product.installationFee,
            photoPaths: product.photoPaths,
            totalPrice: cartEntry.priceTotal,
            totalInstallationFee: cartEntry.installationTotal,
            isReady: false,
            updatedAt: null,
          ),
        );
      }

      // --- STEP 5: SAVE TO DB ---
      await _orderService.createOrder(newOrder, orderItems);

      //reduce each of the product quantity
      await Future.wait(
        cartState.entries.map((cartEntry) async {
          final product = cartEntry.product!;
          final quantityToReduce = cartEntry.item.quantity; // <--- The Fix

          if (product.quantity != null) {
            await _productService.decreaseQuantity(
              product.id,
              quantityToReduce,
            );
          }
        }),
      );

      //clear cart
      await _cartService.clearCart(userId);
      ref.invalidate(cartProvider);

      state = AsyncValue.data(null);
      return newOrderId;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}
