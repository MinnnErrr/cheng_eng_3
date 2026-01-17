import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/controllers/profile/user_profile_provider.dart';
import 'package:cheng_eng_3/core/models/checkout_state_model.dart';
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'checkout_notifier.g.dart';

@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  @override
  FutureOr<CheckoutState> build() async {
    final cartState = await ref.watch(cartProvider.future);

    final user = Supabase.instance.client.auth.currentUser;

    final profile = user == null ? null : await ref.watch(userProfileByUserIdProvider(user.id).future);

    return CheckoutState(
      cart: cartState,
      method: DeliveryMethod.selfPickup,
      selectedState: null,
      profile: profile
    );
  }

  void setDeliveryMethod(DeliveryMethod method) {
    if (!state.hasValue) return;

    if (state.value!.hasInstallation && method == DeliveryMethod.delivery) {
      return;
    }

    state = AsyncData(state.value!.copyWith(method: method));
  }

  void setStateSelection(MalaysiaState? newState) {
    if (!state.hasValue) return;
    state = AsyncData(state.value!.copyWith(selectedState: newState));
  }
}
