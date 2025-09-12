import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/env.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/subscription.dart';
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
  bool isLoading = false;
  //initial payment id
  String priceId = Env.stripeYearly;

  @override
  void initState() {
    super.initState();
    loadSubscriptions(); //load Subscripions for in app purchase
    startListeningToPurchaseUpdates(context, isSignupFlow: widget.showSkip);
  }

  @override
  void dispose() {
    purchaseSubscription?.cancel(); //new
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                showInfoDialog(context);
              },
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
                // onPressed: () async {
                //   await handleSubscribeButton(getPaymentIntent(context, priceId,
                //       isSignupFlow: widget.showSkip));
                // },
                onPressed: () async {
                  if (Platform.isIOS && subscriptions.isNotEmpty) {
                    setState(() => isLoading = true);
                    debugPrint(
                      'selectedSubscription on Button Pressed: $selectedSubscription',
                    );
                    // final product = _subscriptions[selectedSubscription]; //previously used

                    //for precise package / subscription selection

                    final Map<int, String> keywords = {
                      0: 'Year',
                      1: 'Month',
                      2: 'Week',
                    };

                    ProductDetails product = subscriptions.firstWhere(
                      (product) => product.title.contains('Year'),
                      orElse: () => throw Exception(
                        'Yearly Subscription not found',
                      ),
                    );

                    setState(() {
                      final keyword = keywords[selectedSubscription];

                      product = subscriptions.firstWhere(
                        (product) => product.title.contains(keyword ?? 'Year'),
                        orElse: () => throw Exception(
                          '$keyword Subscription not found',
                        ),
                      );
                    });
                    // buySubscription(product);
                    await buySubscription(product).then(
                      (_) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                    );
                  } else {
                    //for android (the stripe way)
                    await getPaymentIntent(
                      context,
                      priceId,
                      isSignupFlow: widget.showSkip,
                      updateLoading: () {
                        setState(
                          () {
                            isLoading = !isLoading;
                          },
                        );
                      },
                    );
                  }

                  // if (mounted) {
                  //   setState(() => isLoading = false);
                  // }
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
