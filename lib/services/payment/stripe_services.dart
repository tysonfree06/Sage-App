import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/services/views/subscription_services.dart';

class StripeServices {
  //
//
//
  ///
  ///
  ///STRIPE (WITH APPLE PAY) SERVICES
  ///
  ///
//
//
//

//Step 3: Create subscription
  Future<void> createSubscription(
    BuildContext context,
    Map<dynamic, dynamic> intent,
    String priceId, {
    bool isSignupFlow = true,
  }) async {
    await SubscriptionService().createSubscription(
      context,
      priceId: priceId,
      customerId: intent['customerId'] as String,
      setupIntentId: intent['setupIntentId'] as String,
      isSignupFlow: isSignupFlow,
    );
  }

//Step 2: Pay
  Future<void> pay(
    BuildContext context,
    Map<dynamic, dynamic> intent,
    String priceId, {
    bool isSignupFlow = true,
    VoidCallback? updateLoading,
  }) async {
    // setState(() {
    //   isLoading = true;
    // });
    updateLoading?.call(); //call setstate in subscription.dart
    final clientSecret = intent['clientSecret'] as String?;

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // paymentIntentClientSecret: clientSecret as String, //this line is commented and replaced by "setupItnent Client Secret" for testing... #muttas
        setupIntentClientSecret: clientSecret,
        merchantDisplayName: 'Sage',
        style: ThemeMode.light,
        //add Apple Pay
        applePay: const PaymentSheetApplePay(
          buttonType: PlatformButtonType.subscribe,
          merchantCountryCode: 'US',
        ),
      ),
    );

    try {
      await Stripe.instance.presentPaymentSheet();
      //Create Subscripion here

      await createSubscription(
        // ignore: use_build_context_synchronously
        context,
        intent,
        priceId,
        isSignupFlow: isSignupFlow,
      );
      //END: Create Subscription here
      // if (context.mounted) {
      //   context.flushBarSuccessMessage(message: 'Payment Successful!!');
      // }
    } on Exception catch (e) {
      debugPrint('❌ PAYMENT FAILED WITH ERROR: $e');
      if (context.mounted) {
        context.flushBarErrorMessage(message: 'Payment Failed...');
      }
    }
    // if (context.mounted) {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
    updateLoading?.call(); //call setstate in subscription.dart
  }
//END: Pay

//Step 1: getPaymentIntent
  Future<void> getPaymentIntent(
    BuildContext context,
    String priceId, {
    bool isSignupFlow = true,
    VoidCallback? updateLoading,
  }) async {
    try {
      final Map<dynamic, dynamic> intent =
          await SubscriptionService().createPaymentIntent(
        context,
        priceId,
      );
      if (context.mounted) {
        await pay(
          context,
          intent,
          priceId,
          isSignupFlow: isSignupFlow,
          updateLoading: () {
            updateLoading?.call(); //call setstate in subscription.dart
          },
        );
      }
      debugPrint('✅ INTENT CREATED SUCCESSFULLY');
      debugPrint('INTENT: $intent');
    } on Exception catch (e) {
      debugPrint('❌ Error Creating Intent: $e');
      if (context.mounted) {
        context.flushBarErrorMessage(message: 'Something went wrong');
      }
    }
  }

  ///
  ///
  ///END: STRIPE (WITH APPLE PAY) SERVICES
  ///
  ///
}
