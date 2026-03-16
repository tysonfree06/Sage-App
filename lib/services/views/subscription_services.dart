import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/components/my_dialog.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/provider/home/navigation_provider.dart';
import 'package:sage/repository/iap_repo.dart';
import 'package:sage/repository/subscription_repo.dart';
import 'package:sage/services/points_services.dart';
import 'package:sage/services/views/splash_services.dart';

class SubscriptionService {
  final String tag = 'SubscriptionService';
  final _subscriptionRepo = SubscriptionRepository();
  final _iapRepo = InAppPurchaseRepository();
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
    int pointsEarned,
  ) async {
    await Navigator.pushReplacementNamed(
      context,
      RoutesName.activeSubscription,
      arguments: {
        'pointsEarned': pointsEarned,
      },
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
    String? purchaseStatus,
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
    debugPrint('PURCHASE STATUS: $purchaseStatus');
    try {
      debugPrint('NOW TYRING TO CREATE SUBSCRIPTION');
      final response = isAndroid
          ? await _subscriptionRepo.createStripeSubscription(
              priceId!,
              customerId!,
              setupIntentId!,
            )
          : await _iapRepo.createAppleSubscription(
              receiptData!, //receiptData
              productId!, //productId
              transactionId!, //transactionId
              purchaseStatus ?? '',
            );
      debugPrint('[$tag] ✅ Subscription Created Sucessfully');
      debugPrint('[$tag] SUBSCRIPTION CREATED RESPONSE: $response');

      if (context.mounted) {
        await SplashServices().fetchProfile(context);
      }
      final int pointsEarned = response['points_earned'] as int;
      if (context.mounted) {
        // if (context.mounted) {
        //   if (pointEarned > 0) {
        //     PointsServices.showPointsEarnedDialog(
        //       context,
        //       'Subscribing to Sage!',
        //       points: pointEarned,
        //     );
        //   }
        // }
        if (isSignupFlow) {
          debugPrint('NOW NAVIGATING TO HOME');
          context.read<NavigationProvider>().setIndex(0);
          await Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.navigation,
            (route) => false,
          );
        } else {
          if (context.mounted) {
            context.flushBarSuccessMessage(
              message: 'You have subscribed successfully!',
            );
          }
          //show points earned dialog if it's not signup flow
          if (pointsEarned > 0) {
            PointsServices.showPointsEarnedDialog(
              context,
              'Subscribing to Sage!',
              points: pointsEarned,
            );
          }
          // else {
          //   if (context.mounted) {
          //     Navigator.of(context).pop();
          //   }
          // }

          // await goToActiveSubscription(context, pointEarned);
        }
      }

      // if (context.mounted) {
      //   context.flushBarSuccessMessage(
      //     message: 'Subscription Successful!!',
      //   );
      // }
    } catch (e) {
      debugPrint('[$tag] ❌ Error creating subscription: $e');
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
      debugPrint('[$tag] ❌ Error getting susbcription details: $e');
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
  static Future<void> goToChangeSubscription(BuildContext context) async {
    await Navigator.pushReplacementNamed(
      context,
      RoutesName.subscription,
    );
  }

  static void goToSubscriptionScreen(
    BuildContext context,
  ) {}
}

///
///Show Info dialog when user press skip
///
Future<void> showInfoDialog(
  BuildContext context,
) async {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (_) => MyDialog(
          titleFirst: 'Subscribe ', //'Get ' //don't remove extra space
          titleSecond: 'to Get Free Points!',
          subtitle: "Don't miss out on free points to be used on prizes!",
          confirmLabel: 'Subscribe',
          cancelLabel: 'Skip Anyway',
          onConfirm: () {
            Navigator.pop(context);
          },
          onCancel: () {
            context.read<NavigationProvider>().setIndex(0);
            Navigator.pushNamedAndRemoveUntil(
              arguments: true,
              context,
              RoutesName.navigation,
              (route) => false,
            );
          },
        ),
      );
    }
  });
}

// class StoreKitHelper {
//   static const MethodChannel _channel = MethodChannel('storekit_helper');

//   static Future<List<String>> getJWSTokens() async {
//     final List<dynamic> tokens =
//         await _channel.invokeMethod('getJWSTokens') as List<dynamic>;
//     return tokens.cast<String>();
//   }
// }
