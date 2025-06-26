import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/view/subscription/widget/my_scaffold.dart';
import 'package:sage/view/subscription/widget/subscription_tile.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        leading: BackButton(color: context.colors.white),
        title: Align(
          alignment: Alignment.topRight,
          child: MyTextButton(
            label: context.l10n.sub_skip,
            onPressed: () {},
          ),
          ),
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Assets.images.logo.onlyLogo.svg(
                height: 50.h,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 24.h),
              Text(
                context.l10n.sub_now_title,
                style: context.typography.title.copyWith(
                  fontSize:24.sp,
                  fontWeight: FontWeight.w700,
                  color: context.colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                context.l10n.sub_now_subtitle,
                style: context.typography.title.copyWith(
                  fontSize:15.sp,
                  fontWeight: FontWeight.w500,
                    color: context.colors.white,
                ),
              ),
              SizedBox(height: 20.h),

              const SubscriptionOption(
                label: 'Yearly',
                price: '\$67.99',
                discount: 60,
              ),
              SizedBox(height: 10.h),
              const SubscriptionOption(
                label: 'Yearly',
                price: '\$67.99',
                discount: 60,
              ),
              SizedBox(height: 10.h),
              const SubscriptionOption(
                label: 'Yearly',
                price: '\$67.99',
                discount: 60,
              ),

              SizedBox(height: 12.h),
              Text(
                context.l10n.sub_what_is_include,
                style: context.typography.title.copyWith(
                  fontSize:16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.mainGreenLight,
                ),
              ),

              ListTile(
                leading: Icon(Icons.check, size: 22, color: context.colors.mainGreenLight),
                title: Text(
                  context.l10n.sub_discounts_title,
                  style: context.typography.title.copyWith(
                    fontSize:13.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.white,
                  ),
                ),
                subtitle: Text(
                  context.l10n.sub_discounts_subtitle,
                  style: context.typography.subtitle.copyWith(
                    fontSize:13.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.white.withValues(alpha: .6),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              ListTile(
                leading: Icon(Icons.check, size: 22, color: context.colors.mainGreenLight),
                title: Text(
                  context.l10n.sub_unlimited_title,
                  style: context.typography.subtitle.copyWith(
                    fontSize:13.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.white.withValues(alpha: .6),
                  ),
                ),
                  subtitle: Text(
                    context.l10n.sub_unlimited_subtitle,
                    style: context.typography.title.copyWith(
                      fontSize:13.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colors.white,
                    ),
                  ),
              ),
              MyButton(
                label: context.l10n.subscribe,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}