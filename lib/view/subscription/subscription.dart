import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_dialog.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/env.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/subscription.dart';
import 'package:sage/provider/home/navigation_provider.dart';
import 'package:sage/services/views/subscription_services.dart';
import 'package:sage/view/subscription/widget/my_scaffold.dart';
import 'package:sage/view/subscription/widget/subscription_tile.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({
    super.key,
    this.showSkip = false,
  });
  final bool showSkip;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  //APPLE IN APP PURCHASE / SUBSCRIPTIONS
  //Define Subscription Product IDs
  static const Set<String> _subscriptionIds = {
    'sage_yearly_subscription',
    'sage_monthly_subscription',
    'sage_weekly_subscription',
  };

  //Fetch Subscription Products

  int selectedSubscription = 2; //Yearly
  List<ProductDetails> _subscriptions = [];

  Future<void> _loadSubscriptions() async {
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

      _subscriptions = response.productDetails;
    } catch (e) {
      debugPrint('Failed to load subscriptions Error: $e');
    }
  }

  void _buySubscription(ProductDetails product) {
    final purchaseParam = PurchaseParam(productDetails: product);
    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  //old
  // StreamSubscription<List<PurchaseDetails>>? _subscription;
  // void _startListeningToPurchaseUpdates() {
  //   _subscription = InAppPurchase.instance.purchaseStream.listen(
  //     (purchaseDetailsList) async {
  //       for (final purchase in purchaseDetailsList) {
  //         debugPrint('IAP update: id=${purchase.productID} '
  //             'status=${purchase.status} '
  //             'pendingComplete=${purchase.pendingCompletePurchase} '
  //             'error=${purchase.error}');

  //         try {
  //           if (purchase.status == PurchaseStatus.pending) {
  //             // Show pending UI (spinner / message)
  //             if (mounted) {
  //               context.flushBarSuccessMessage(message: 'Purchase pending...');
  //             }
  //           } else if (purchase.status == PurchaseStatus.error) {
  //             // Handle the error
  //             debugPrint('In-app purchase error: ${purchase.error}');
  //             if (mounted) {
  //               context.flushBarErrorMessage(
  //                 message: 'Purchase error occurred.',
  //               );
  //             }
  //           } else if (purchase.status == PurchaseStatus.purchased ||
  //               purchase.status == PurchaseStatus.restored) {
  //             // Treat restored same as purchased for subscriptions:
  //             // 1) Verify receipt on your server (recommended)
  //             // 2) Unlock content / update backend
  //             // 3) Complete the purchase so the store finalizes the transaction

  //             // Example: verify and unlock (your existing method)
  //             await _verifyAndUnlock(purchase);

  //             // After successful verification/delivery, mark as complete:
  //             if (purchase.pendingCompletePurchase) {
  //               await InAppPurchase.instance.completePurchase(purchase);
  //             }

  //             if (mounted) {
  //               context.flushBarSuccessMessage(
  //                 message: 'Subscription successful: ${purchase.productID}',
  //               );
  //             }
  //           } else {
  //             // Unexpected status -- log it
  //             debugPrint('Unhandled purchase status: ${purchase.status}');
  //             if (mounted) {
  //               context.flushBarErrorMessage(
  //                 message: 'Something went wrong...',
  //               );
  //             }
  //           }
  //         } catch (e, st) {
  //           debugPrint('Error handling purchase: $e\n$st');
  //           // If verification failed, you might want to NOT call
  //           // completePurchase,
  //           // so store/the store can retry sending the transaction.
  //           if (mounted) {
  //             context.flushBarErrorMessage(
  //               message: 'Purchase verification failed.',
  //             );
  //           }
  //         }
  //       }
  //     },
  //     onError: (err) => debugPrint('purchaseStream error: $err'),
  //   );
  // }
  //END: old

  //new
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  void _startListeningToPurchaseUpdates() {
    // cancel old subscription if already listening
    _purchaseSubscription?.cancel();

    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (err) => debugPrint('purchaseStream error: $err'),
    );
  }

  Future<void> _handlePurchaseUpdates(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      await _processPurchase(purchase);
    }
  }

  Future<void> _processPurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      try {
        await _verifyAndUnlock(purchase);

        if (purchase.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchase);
        }
      } catch (e, st) {
        debugPrint('❌ Error verifying purchase: $e\n$st');
      }
    }
  }
  //END: new

  Future<void> _verifyAndUnlock(PurchaseDetails purchase) async {
    debugPrint('-----------------------------------------------');
    debugPrint('VERIFY AND UNLOCK CALLED');
    debugPrint('PURCHASE STATUS ${purchase.status}');
    debugPrint('RECEIPT DATA: ${purchase.productID}');
    debugPrint('PRODUCT ID: ${purchase.productID}');
    debugPrint('TRANSACTION ID: ${purchase.purchaseID}');
    debugPrint('-----------------------------------------------');
    // Best practice: verify with your server and Apple’s receipt system
    // create here
    await _subscriptionService.createSubscription(
      context,
      isAndroid: false,
      receiptData: purchase.verificationData.serverVerificationData,
      productId: purchase.productID,
      transactionId: purchase.purchaseID,
      purchaseStatus: purchase.status.toString(),
      isSignupFlow: widget.showSkip,
    );
  }

//   {
//   "userId": "user123", (original user id)
//   "receiptData": "base64EncodedReceiptData...",
//   "productId": "com.yourapp.premium_monthly",
//   "transactionId": "1000000123456789",
//   "originalTransactionId": "1000000123456789",
//   "environment": "production"
// }

  //END: APPLE IN APP PURCHASE / SUBSCRIPTIONS

  final _subscriptionService = SubscriptionService();
  bool isLoading = false;
  //initial payment id
  String priceId = Env.stripeYearly;

  @override
  void initState() {
    super.initState();
    _loadSubscriptions(); //load Subscripions for in app purchase
    //OLD _listenToPurchaseUpdates();
    _startListeningToPurchaseUpdates();
  }

  @override
  void dispose() {
    // _subscription?.cancel(); //old
    _purchaseSubscription?.cancel(); //new
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> showInfoDialog() async {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (mounted) {
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

    //Step 3: Create subscription
    Future<void> createSubscription(Map<dynamic, dynamic> intent) async {
      await _subscriptionService.createSubscription(
        context,
        priceId: priceId,
        customerId: intent['customerId'] as String,
        setupIntentId: intent['setupIntentId'] as String,
        isSignupFlow: widget.showSkip,
      );
    }

    //Step 2: Pay
    Future<void> pay(BuildContext context, Map<dynamic, dynamic> intent) async {
      setState(() {
        isLoading = true;
      });
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
        await createSubscription(intent);
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
      if (context.mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    //END: Pay

    //Step 1: getPaymentIntent
    Future<void> getPaymentIntent() async {
      try {
        final Map<dynamic, dynamic> intent =
            await _subscriptionService.createPaymentIntent(
          context,
          priceId,
        );
        if (context.mounted) await pay(context, intent);
        debugPrint('✅ INTENT CREATED SUCCESSFULLY');
        debugPrint('INTENT: $intent');
      } on Exception catch (e) {
        debugPrint('❌ Error Creating Intent: $e');
        if (context.mounted) {
          context.flushBarErrorMessage(message: 'Something went wrong');
        }
      }
    }

    return MyScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: !widget.showSkip
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: !isLoading ? context.colors.mainGreenLight : Colors.grey,
                onPressed: !isLoading ? () => Navigator.pop(context) : null,
              )
            : const SizedBox.shrink(),
        actions: [
          if (widget.showSkip)
            MyTextButton(
              isDark: false,
              fontSize: 16.sp,
              label: context.l10n.sub_skip,
              // onPressed: () {
              //   context.read<NavigationProvider>().setIndex(0);
              //   Navigator.pushNamedAndRemoveUntil(
              //     arguments: true,
              //     context,
              //     RoutesName.navigation,
              //     (route) => false,
              //   );
              // },
              onPressed: showInfoDialog,
            ),
          SizedBox(width: 16.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Assets.images.logo.onlyLogo.svg(
                height: 50.h,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 10.h),
              Text(
                context.l10n.sub_now_title,
                style: context.typography.title.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: context.colors.white,
                  height: 1.21,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.l10n.sub_now_subtitle,
                style: context.typography.title.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: context.colors.white.withValues(alpha: .7),
                ),
              ),
              SizedBox(height: 16.h),
              //prices
              SubscriptionOption(
                subscriptionOptions: SubscriptionModel.subscriptions,
                onIndexChanged: (index) {
                  switch (index) {
                    case 0:
                      setState(() {
                        selectedSubscription = 0;
                        debugPrint(
                            'SELECTED SUBSCRIPTION ID: $selectedSubscription : YEARLY');
                        priceId = Env.stripeYearly;
                      });
                      break;
                    case 1:
                      setState(() {
                        selectedSubscription = 1;
                        debugPrint(
                            'SELECTED SUBSCRIPTION ID: $selectedSubscription : MONTHLY');
                        priceId = Env.stripeMonthly;
                      });
                      break;
                    case 2:
                      setState(() {
                        selectedSubscription = 2;
                        debugPrint(
                            'SELECTED SUBSCRIPTION ID: $selectedSubscription : WEEKLY');
                        priceId = Env.stripeWeekly;
                      });
                      break;
                  }
                },
              ),
              //END: prices
              SizedBox(height: 12.h),
              Text(
                context.l10n.sub_what_is_include,
                style: context.typography.title.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.mainGreenLight,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      Icons.check,
                      size: 24.w,
                      color: context.colors.mainGreenLight,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: ColoredRichText(
                      first: context.l10n.sub_discounts_title,
                      second: context.l10n.sub_discounts_subtitle,
                      firstColor: context.colors.white,
                      secondColor: context.colors.white.withValues(alpha: .5),
                      firstFontSize: 13.sp,
                      secondFontSize: 13.sp,
                      firstFontWeight: FontWeight.w600,
                      secondFontWeight: FontWeight.w500,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      Icons.check,
                      size: 24.w,
                      color: context.colors.mainGreenLight,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Flexible(
                    child: ColoredRichText(
                      first: context.l10n.sub_unlimited_title,
                      second: context.l10n.sub_unlimited_subtitle,
                      firstColor: context.colors.white,
                      secondColor: context.colors.white.withValues(alpha: .5),
                      firstFontSize: 13.sp,
                      secondFontSize: 13.sp,
                      firstFontWeight: FontWeight.w600,
                      secondFontWeight: FontWeight.w500,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              MyButton(
                isLoading: isLoading,
                label: context.l10n.subscribe,
                onPressed: () async {
                  setState(() => isLoading = true);
                  //Original
                  if (Platform.isIOS && _subscriptions.isNotEmpty) {
                    debugPrint(
                      'selectedSubscription on Button Pressed: $selectedSubscription',
                    );
                    final product = _subscriptions[selectedSubscription];
                    debugPrint('PRODUCTS LIST: $_subscriptions');
                    debugPrint(
                      'SELECTED PRODUCT: ${_subscriptions[selectedSubscription].title}',
                    );
                    _buySubscription(product);
                  } else {
                    await getPaymentIntent();
                  }

                  if (mounted) {
                    setState(() => isLoading = false);
                  }
                },
                // onPressed: () => pay(context),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
