import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/subscription.dart';
import 'package:sage/provider/home/navigation_provider.dart';
import 'package:sage/view/subscription/widget/my_scaffold.dart';
import 'package:sage/view/subscription/widget/subscription_tile.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({
    super.key,
    this.showSkip = false,
  });
  final bool showSkip;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        actions: [
          if (showSkip)
            MyTextButton(
              isDark: false,
              fontSize: 16.sp,
              label: context.l10n.sub_skip,
              onPressed: () {
                context.read<NavigationProvider>().setIndex(0);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RoutesName.navigation,
                  (route) => false,
                );
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
              SubscriptionOption(
                subscriptionOptions: SubscriptionModel.subscriptions,
              ),
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
                label: context.l10n.subscribe,
                onPressed: () {},
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
