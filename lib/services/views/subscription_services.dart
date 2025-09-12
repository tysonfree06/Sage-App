import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/components/my_dialog.dart';
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
          ? await _subscriptionRepo.createSubscription(
              priceId!,
              customerId!,
              setupIntentId!,
            )
          : await _subscriptionRepo.createAppleSubscription(
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
      if (context.mounted) {
        // final int pointEarned = response['points_earned'] as int;
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
          await goToActiveSubscription(context);
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
  static void goToChangeSubscription(BuildContext context) {
    Navigator.pushReplacementNamed(
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

//
//
//
///
///IN-APP-PURCHASE (SUBSCRIPTION) SERVICES
///
//
//
//

//Define Subscription Product IDs
const Set<String> _subscriptionIds = {
  'sage_yearly_subscription',
  'sage_monthly_subscription',
  'sage_weekly_subscription',
};

//Fetch Subscription Products

int selectedSubscription = 2; //Yearly
List<ProductDetails> subscriptions = [];

//Load subscriptions
Future<void> loadSubscriptions() async {
  try {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      debugPrint('In App Purchase not available');
      return;
    }

    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_subscriptionIds);
    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('Products not found: ${response.notFoundIDs}');
    }

    subscriptions = response.productDetails;
  } catch (e) {
    debugPrint('Failed to load subscriptions Error: $e');
  }
}
//END: Load subscriptions

//Buy Subscription
Future<void> buySubscription(ProductDetails product) async {
  final purchaseParam = PurchaseParam(productDetails: product);
  await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
}
//END: Buy Subscription

//Open Stream
//This will continuesly listen to events (when opened and when and
// event happens)
StreamSubscription<List<PurchaseDetails>>? purchaseSubscription;

void startListeningToPurchaseUpdates(
  BuildContext context, {
  bool isSignupFlow = true,
}) {
  // cancel old subscription if already listening
  purchaseSubscription?.cancel(); //TODO: #muttas review this line..

  // purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
  //   handlePurchaseUpdates(context, purchaseSubscription,
  //       isSignupFlow: isSignupFlow),
  //   onError: (err) => debugPrint('purchaseStream error: $err'),
  // );

  purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
    (purchaseDetailsList) {
      handlePurchaseUpdates(
        // ignore: use_build_context_synchronously
        context,
        purchaseDetailsList,
        isSignupFlow: isSignupFlow,
      );
    },
    onError: (dynamic err) {
      debugPrint(
        'purchaseStream error: $err',
      );
      if (context.mounted) {
        context.flushBarErrorMessage(
          message: 'Purchase Stream Error...',
        );
      }
    },
  );
}
//END: Open Stream

//Hanlde Purchase
Future<void> handlePurchaseUpdates(
  BuildContext context,
  List<PurchaseDetails> purchaseDetailsList, {
  bool isSignupFlow = true,
}) async {
  for (final purchase in purchaseDetailsList) {
    await _processPurchase(context, purchase, isSignupFlow: isSignupFlow);
  }
}
//END: Hanlde Purchase

//Process Purchase
Future<void> _processPurchase(
  BuildContext context,
  PurchaseDetails purchase, {
  bool isSignupFlow = true,
}) async {
  //Status is purchased when a new subscription is
  //created or subscription is updated. Otherwise
  //status will be 'restored'.
  //Sandbox is "Notoriously Buggy for Subscriptions" : ChatGpt
  //That's why it returns false status in sandbox
  if (purchase.status == PurchaseStatus.purchased
      // || purchase.status == PurchaseStatus.restored
      ) {
    try {
      await _verifyAndUnlock(context, purchase, isSignupFlow: isSignupFlow);

      if (purchase.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchase);
      }
    } catch (e, st) {
      debugPrint('❌ Error verifying purchase: $e\n$st');
      if (context.mounted) {
        context.flushBarErrorMessage(message: 'Error verifying purchase...');
      }
    }
  } else if (purchase.status == PurchaseStatus.restored) {
    debugPrint(' Purchase Restored');
  }
}
//END: Process Purchase

//Verify and Unlock
Future<void> _verifyAndUnlock(
  BuildContext context,
  PurchaseDetails purchase, {
  bool isSignupFlow = true,
}) async {
  ///
  // String? jwsToken;
  // if (Platform.isIOS) {
  //   try {
  //     final tokens = await StoreKitHelper.getJWSTokens();
  //     if (tokens.isNotEmpty) {
  //       jwsToken = tokens.first; // pick the latest transaction
  //       debugPrint('✅ Got JWS Token: $jwsToken');
  //     }
  //   } catch (e) {
  //     debugPrint('❌ Failed to get JWS token: $e');
  //   }
  // }

  ///

  debugPrint('-----------------------------------------------');
  debugPrint('VERIFY AND UNLOCK CALLED');
  debugPrint('PURCHASE STATUS ${purchase.status}');
  debugPrint(
    'RECEIPT DATA: ${purchase.verificationData.serverVerificationData}',
  );
  debugPrint('PRODUCT ID: ${purchase.productID}');
  debugPrint('TRANSACTION ID: ${purchase.purchaseID}');
  // debugPrint('JWS Token: $jwsToken');
  debugPrint('-----------------------------------------------');
  // Best practice: verify with your server and Apple’s receipt system
  // create here
  // if (purchase.status == PurchaseStatus.purchased) {
  //only call when subscription is created/updated
  if (context.mounted) {
    await SubscriptionService().createSubscription(
      context,
      isAndroid: false,
      receiptData: purchase.verificationData.serverVerificationData, //old
      // receiptData: jwsToken ?? purchase.verificationData.serverVerificationData,
      productId: purchase.productID,
      transactionId: purchase.purchaseID,
      purchaseStatus: purchase.status.toString(),
      isSignupFlow: isSignupFlow,
    );
  }
  // }
}
//END: Verify and Unlock

///
///END: IN-APP-PURCHASE (SUBSCRIPTION) SERVICES
///

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

class StoreKitHelper {
  static const MethodChannel _channel = MethodChannel('storekit_helper');

  static Future<List<String>> getJWSTokens() async {
    final List<dynamic> tokens =
        await _channel.invokeMethod('getJWSTokens') as List<dynamic>;
    return tokens.cast<String>();
  }
}
