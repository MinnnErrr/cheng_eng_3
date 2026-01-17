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
    required String orderId,
    required String userId,     
    required int pointsToEarn,  
    required String email,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'payment-sheet',
        body: {
          'amount': amount, 
          'email': email,
          'description': 'Order #$orderId',
          'orderId': orderId,
          'userId': userId,
          'points': pointsToEarn,
        },
      );

      final data = response.data;
      if (data == null || data['paymentIntent'] == null) {
        return PaymentResult.failed;
      }

      // 2. Initialize the Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customerId: data['customer'], 
          customerEphemeralKeySecret: data['ephemeralKey'], 
          
          paymentIntentClientSecret: data['paymentIntent'],
          merchantDisplayName: 'Cheng Eng Auto Accessories',
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Colors.amberAccent, 
                  text: Colors.black, 
                ),
              ),
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      
      return PaymentResult.success;

    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return PaymentResult.canceled; 
      }
      return PaymentResult.failed;
    } catch (e) {
      return PaymentResult.failed;
    }
  }
}