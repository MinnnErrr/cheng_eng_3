
import 'package:cheng_eng_3/core/models/cart_state_model.dart';
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/core/models/profile_model.dart';

class CheckoutState {
  final CartState cart;

  // Mutable fields
  // Renamed to 'selectedState' to avoid confusion with class 'State'
  final MalaysiaState? selectedState;
  final DeliveryMethod method;
  final Profile? profile;

  const CheckoutState({
    required this.cart,
    this.selectedState,
    this.method = DeliveryMethod.selfPickup,
    required this.profile
  });

  // --- LOGIC ---

  /// 1. Check if ANY item needs installation
  bool get hasInstallation {
    return cart.entries.any(
      (entry) =>
          (entry.product?.installation == true) &&
          (entry.item.installation == true),
    );
  }

  /// 2. Calculate Delivery Fee
  double get deliveryFee {
    if (method == DeliveryMethod.selfPickup) return 0.00;

    // Default to 8.00 (West Malaysia) if nothing selected yet,
    // or return 0 if you want to force selection first.
    if (selectedState == null) return 0.00;

    switch (selectedState!) {
      case MalaysiaState.labuan:
      case MalaysiaState.sarawak:
      case MalaysiaState.sabah:
        return 10.00;
      default:
        return 8.00;
    }
  }

  /// 3. Grand Total
  double get total => cart.subtotal + deliveryFee;

  /// 4. Points
  int get points => total.floor();

  /// 5. Validation helper for the "Place Order" button
  /// This checks if the STATE logic is valid.
  /// (Form text validation happens in the UI key)
  bool get canPlaceOrder {
    // 1. Cart must be valid (Stock check)
    if (!cart.isValid) return false;

    // 2. If Delivery, must have selected a region for fee calculation
    if (method == DeliveryMethod.delivery && selectedState == null) {
      return false;
    }

    return true;
  }

  // --- COPY WITH ---
  CheckoutState copyWith({
    CartState? cart,
    MalaysiaState? selectedState,
    DeliveryMethod? method,
    Profile? profile
  }) {
    return CheckoutState(
      cart: cart ?? this.cart,
      selectedState: selectedState ?? this.selectedState,
      method: method ?? this.method,
      profile: profile ?? this.profile
    );
  }
}
