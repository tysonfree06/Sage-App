import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/provider/home/navigation_provider.dart';
import 'package:sage/repository/subscription_repo.dart';
import 'package:sage/services/points_services.dart';
import 'package:sage/services/views/splash_services.dart';

class SubscriptionService {
  final String tag = 'SubscriptionService';
  final _subscriptionRepo = SubscriptionRepository();
  // ignore: strict_raw_type
  Future<Map> createPaymentIntent(
    BuildContext context,
    String priceId,
  ) async {
    try {
      final response = await _subscriptionRepo.createPaymentIntent(priceId);
      debugPrint('[$tag] ✅ Intent Created');
      return response;
    } catch (e) {
      debugPrint('[$tag] ❌ Error creating intent: $e');
    }
    return {};
  }

  static Future<void> goToActiveSubscription(
    BuildContext context,
  ) async {
    await Navigator.pushReplacementNamed(
      context,
      RoutesName.activeSubscription,
      arguments: false, //show skip button
    );
  }

  // ignore: strict_raw_type
  Future<void> createSubscription(
    //Create subscription on server
    BuildContext context,
    //for ios
    {
    String? receiptData,
    String? productId,
    String? transactionId,
    //for android and others
    String? priceId,
    String? customerId,
    String? setupIntentId,
    bool isSignupFlow = true,
    bool isAndroid = true,
  }) async {
    debugPrint('[NOW CREATING SUBSCRIPTION] with isSignupFlow: $isSignupFlow');
    debugPrint('IsAndroid: $isAndroid');
    debugPrint('In createSubscription FUNCTION:');
    debugPrint('RECEIPT DATA: $receiptData');
    debugPrint('PRODUCT ID: $productId');
    debugPrint('TRANSACTION ID: $transactionId');
    try {
      debugPrint('NOW TYRING TO CREATE SUBSCRIPTION');
      final response = isAndroid
          ? await _subscriptionRepo.createSubscription(
              priceId!,
              customerId!,
              setupIntentId!,
            )
          : await _subscriptionRepo.createAppleSubscription(
              receiptData!, //receiptData
              productId!, //productId
              transactionId!, //transactionId
            );
      debugPrint('[$tag] ✅ Subscription Created Created');

      if (context.mounted) {
        await SplashServices().fetchProfile(context);
      }
      if (context.mounted) {
        final int pointEarned = response['points_earned'] as int;
        if (context.mounted) {
          if (pointEarned > 0) {
            PointsServices.showPointsEarnedDialog(
              context,
              'Subscribing to Sage!',
              points: pointEarned,
            );
          }
        }

        if (isSignupFlow) {
          debugPrint('NOW NAVIGATING TO HOME');
          context.read<NavigationProvider>().setIndex(0);
          await Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.navigation,
            (route) => false,
          ).then((_) {});
        } else {
          await goToActiveSubscription(context);
        }
      }

      // if (context.mounted) {
      //   context.flushBarSuccessMessage(
      //     message: 'Subscription Successful!!',
      //   );
      // }
    } catch (e) {
      debugPrint('[$tag] ❌ Error creating intent: $e');
      debugPrint('❌ SUBSCRIPTION CREATION FAILED WITH ERROR: $e');
      if (context.mounted) {
        context.flushBarErrorMessage(
          message: 'Failed to Create Subscription',
        );
      }
    }
  }

  //Get Subscription Details
  // ignore: strict_raw_type
  Future<Map<String, dynamic>> getSubscriptionDetails() async {
    try {
      final response = await _subscriptionRepo.fetchSubscriptionDetails();
      debugPrint('[$tag] ✅ Subscription Details Fetched');
      return response;
    } catch (e) {
      debugPrint('[$tag] ❌ Error creating intent: $e');
    }
    return {};
  }

  Future<void> cancelSubcription(BuildContext context) async {
    try {
      await _subscriptionRepo.cancelSubscription();
      debugPrint('[$tag] ✅ Subscription Canceled Successfuly');
      if (context.mounted) {
        await SplashServices().fetchProfile(context);
      }
      if (context.mounted) {
        Navigator.pop(context);
        context.flushBarSuccessMessage(message: 'Subscription Canceled!');
      }
    } catch (e) {
      debugPrint('[$tag] ❌ Error canceling subscription: $e');
      if (context.mounted) {
        context.flushBarErrorMessage(message: 'Something went wrong...');
      }
    }
  }

  //Go to subscription screen to change membership
  static void goToChangeSubscription(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      RoutesName.subscription,
    );
  }

  static void goToSubscriptionScreen(BuildContext context, bool bool) {}
}
