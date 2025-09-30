import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/services/payment/iap_services.dart';
import 'package:sage/services/payment/stripe_services.dart';

class SubscriptionScreenService {
  final _stripeServices = StripeServices();
  final _iapServices = InAppPurchaseServices();

  Future<void> handleSubscribeButton(
    BuildContext context,
    String stripePriceId, {
    bool isSignupFlow = true,
    VoidCallback? updateLoading,
  }) async {
    if (Platform.isIOS) {
      await _handleIAPSubscription(
        context,
      );
    } else {
      //for android (the stripe way)
      await _stripeServices.getPaymentIntent(
        context,
        stripePriceId,
        isSignupFlow: isSignupFlow,
        updateLoading: () {
          updateLoading?.call();
        },
      );
    }
  }

  Future<void> _handleIAPSubscription(BuildContext context) async {
    debugPrint('IN HANDLE IAP SUBSCRIPTION,');
    debugPrint('SUBSCRIPTIONS LIST IS: $iapSubscriptions');
    if (iapSubscriptions.isEmpty) {
      debugPrint('No Subscription loaded from Apple');
      debugPrint(
        '''\n\nHey, In App Purchase only works on real ios device in "Release mode!"\n\n''',
      );
      context.flushBarErrorMessage(
        message: 'Something went wrong, please try again...',
      );
      return;
    }
    if (context.mounted) {
      context.flushBarSuccessMessage(
        message: 'Initializing payment sheet...',
      );
    }
    //for precise package / subscription selection

    final Map<int, String> keywords = {
      0: 'Year',
      1: 'Month',
      2: 'Week',
    };

    ProductDetails product = iapSubscriptions.firstWhere(
      (product) => product.title.contains('Year'),
      orElse: () => throw Exception(
        'Yearly Subscription not found',
      ),
    );

    final keyword = keywords[_iapServices.selectedSubscription];
    debugPrint(
      'SELECTED SUBSCRIPTION INDEX (FROM SUBSCRIPTION SERVICES.DART): ${_iapServices.selectedSubscription}',
    );
    product = iapSubscriptions.firstWhere(
      (product) => product.title.contains(keyword ?? 'Year'),
      orElse: () => throw Exception(
        '$keyword Subscription not found',
      ),
    );
    // buySubscription(product);
    await _iapServices.buySubscription(
      product,
      context,
    );
  }
}
