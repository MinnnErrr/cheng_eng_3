import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'payment_service.g.dart';

enum PaymentResult { success, canceled, failed }

@Riverpod(keepAlive: true)
PaymentService paymentService(Ref ref) {
  return PaymentService();
}

class PaymentService {
  final _supabase = Supabase.instance.client;

  Future<PaymentResult> makePayment({
    required double amount, 
    required String currency,
    required String orderId,
  }) async {
    try {
      // 1. Call Edge Function to get client_secret
      // Stripe expects integer amounts (e.g. 10.50 -> 1050)
      final intAmount = (amount * 100).toInt(); 
      
      final response = await _supabase.functions.invoke(
        'payment-sheet',
        body: {
          'amount': intAmount,
          'currency': currency,
          'orderId': orderId,
        },
      );

      final data = response.data;
      if (data == null || data['paymentIntent'] == null) {
        return PaymentResult.failed;
      }

      // 2. Initialize the Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: data['paymentIntent'],
          merchantDisplayName: 'Cheng Eng Auto Accessories',
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Colors.amberAccent, // Match your app theme
                  text: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

      // 3. Present the Payment Sheet
      await Stripe.instance.presentPaymentSheet();
      
      // If we reach here, payment was successful!
      return PaymentResult.success;

    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // User cancelled, do nothing
        return PaymentResult.canceled; 
      }
      throw PaymentResult.failed;
    } catch (e) {
      throw PaymentResult.failed;
    }
  }
}