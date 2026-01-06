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
      // 1. Call Edge Function
      // FIX 1: Send the original double amount. Let the server handle the *100 logic.
      final response = await _supabase.functions.invoke(
        'payment-sheet',
        body: {
          'amount': amount, // Send 10.50, not 1050
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
          // FIX 2: Pass these to allow saving cards/recognizing the user
          customerId: data['customer'], 
          customerEphemeralKeySecret: data['ephemeralKey'], 
          
          paymentIntentClientSecret: data['paymentIntent'],
          merchantDisplayName: 'Cheng Eng Auto Accessories',
          style: ThemeMode.light, // Forces light mode to match your custom colors below
          appearance: const PaymentSheetAppearance(
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Colors.amberAccent, 
                  text: Colors.black, // White text on Amber is hard to read, Black is better
                ),
              ),
            ),
          ),
        ),
      );

      // 3. Present the Payment Sheet
      await Stripe.instance.presentPaymentSheet();
      
      return PaymentResult.success;

    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return PaymentResult.canceled; 
      }
      // Log the actual error for debugging
      return PaymentResult.failed;
    } catch (e) {
      return PaymentResult.failed;
    }
  }
}