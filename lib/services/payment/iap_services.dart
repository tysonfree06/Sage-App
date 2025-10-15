import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/services/views/subscription_services.dart';

List<ProductDetails> iapSubscriptions = [];

class InAppPurchaseServices {
  ///
  ///IN-APP-PURCHASE (SUBSCRIPTION) SERVICES
  ///

//Define Subscription Product IDs
  static const Set<String> _subscriptionIds = {
    'sage_yearly_subscription',
    'sage_monthly_subscription',
    'sage_weekly_subscription',
  };

//Fetch Subscription Products

  // int selectedSubscription = 0;

//Load subscriptions
  Future<void> loadSubscriptions(
    // ignore: avoid_positional_boolean_parameters
    void Function(bool loadingStatus)? updateLoading,
    void Function(List<ProductDetails> subs)? updateSubscriptionsList,
  ) async {
    debugPrint('LOADING SUBSCRIPTIONS....');
    updateLoading?.call(false);
    try {
      final bool available = await InAppPurchase.instance.isAvailable();
      if (!available) {
        debugPrint('In App Purchase not available');
        updateLoading?.call(true);
        return;
      }

      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_subscriptionIds);
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
      }

      iapSubscriptions = response.productDetails;
      debugPrint('FOUND SUBSCRIPTIONS ARE: $iapSubscriptions....');
      updateSubscriptionsList?.call(iapSubscriptions);
    } catch (e) {
      debugPrint('Failed to load subscriptions Error: $e');
    }
    updateLoading?.call(true); //update UI (for localized pricing)
  }
//END: Load subscriptions

//Buy Subscription
  Future<void> buySubscription(
    ProductDetails product,
    BuildContext context,
  ) async {
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
    //this is also called on subscription.dart dispose
    purchaseSubscription?.cancel();

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

//Close Subscription Stream
//This will any stream which was already opened
  void closeSubscriptionStream() {
    purchaseSubscription?.cancel();
  }

  //END: IN-APP-PURCHASE (SUBSCRIPTION) SERVICES
}
