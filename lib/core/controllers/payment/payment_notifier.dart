// features/payment/payment_notifier.dart
import 'package:cheng_eng_3/core/services/payment_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_notifier.g.dart';

@riverpod
class PaymentNotifier extends _$PaymentNotifier {
  PaymentService get _paymentService => ref.read(paymentServiceProvider);

  @override
  AsyncValue<PaymentResult> build() {
    return const AsyncValue.data(PaymentResult.canceled); 
  }

  Future<PaymentResult> payForOrder({
    required String orderId,
    required double amount,
    required String userId,
    required int pointsToEarn,
    required String email,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await _paymentService.makePayment(
        amount: amount,
        orderId: orderId,
        userId: userId,
        pointsToEarn: pointsToEarn,
        email: email,
      );

      state = AsyncValue.data(result);
      return result;

    } catch (e, st) {
      state = AsyncValue.error("Payment failed to initialize: $e", st);
      return PaymentResult.failed;
    }
  }
}
