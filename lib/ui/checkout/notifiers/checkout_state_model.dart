
import 'package:cheng_eng_3/ui/cart/notifiers/cart_state_model.dart';
import 'package:cheng_eng_3/domain/models/order_model.dart';
import 'package:cheng_eng_3/domain/models/profile_model.dart';

class CheckoutState {
  final CartState cart;

  final MalaysiaState? selectedState;
  final DeliveryMethod method;
  final Profile? profile;

  const CheckoutState({
    required this.cart,
    this.selectedState,
    this.method = DeliveryMethod.selfPickup,
    required this.profile
  });

  bool get hasInstallation {
    return cart.entries.any(
      (entry) =>
          (entry.product?.installation == true) &&
          (entry.item.installation == true),
    );
  }

  double get deliveryFee {
    if (method == DeliveryMethod.selfPickup) return 0.00;

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

  double get total => cart.subtotal + deliveryFee;

  int get points => total.floor();

  bool get canPlaceOrder {
    if (!cart.isValid) return false;

    if (method == DeliveryMethod.delivery && selectedState == null) {
      return false;
    }

    return true;
  }

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
