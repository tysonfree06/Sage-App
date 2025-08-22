import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
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
  final _subscriptionService = SubscriptionService();
  bool isLoading = false;
  //initial payment id
  String priceId = Env.stripeYearly;
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
              subtitle: 'Don’t miss out on free points to be used on prizes!',
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
        priceId,
        intent['customerId'] as String,
        intent['setupIntentId'] as String,
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
          //
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
                        priceId = Env.stripeYearly;
                      });
                    case 1:
                      setState(() {
                        priceId = Env.stripeMonthly;
                      });

                    case 2:
                      setState(() {
                        priceId = Env.stripeWeekly;
                      });

                    default:
                      setState(() {
                        priceId = Env.stripeYearly;
                      });
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
                  await getPaymentIntent();
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
