// features/payment/payment_notifier.dart
import 'package:cheng_eng_3/core/services/payment_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_notifier.g.dart';

@riverpod
class PaymentNotifier extends _$PaymentNotifier {
  PaymentService get _paymentService => ref.read(paymentServiceProvider);

  @override
  AsyncValue<PaymentResult> build() {
    return const AsyncValue.data(PaymentResult.canceled); // Default state
  }

  Future<PaymentResult> payForOrder({
    required String orderId,
    required double amount,
    required String userId,
    required int pointsToEarn,
    // New parameters required by the updated PaymentService
    required String email,
  }) async {
    state = const AsyncValue.loading();

    try {
      // 1. Process Payment
      // We pass the data to the service, which calls the Edge Function.
      // The Edge Function creates the PaymentIntent with metadata.
      final result = await _paymentService.makePayment(
        amount: amount,
        orderId: orderId,
        userId: userId,
        pointsToEarn: pointsToEarn,
        email: email,
      );

      // 2. Update State
      // We do NOT update the DB here. The Stripe Webhook will do it.
      state = AsyncValue.data(result);
      return result;

    } catch (e, st) {
      // Handle standard networking/stripe initialization errors
      state = AsyncValue.error("Payment failed to initialize: $e", st);
      return PaymentResult.failed;
    }
  }
}
