import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/welcome_service.dart';
import 'package:sage/view/auth/widget/welcome_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeScaffold(
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Assets.images.logo.whiteLogo.svg(height: 100.sp, width: 100.sp),
            SizedBox(height: 23.h),
            ColoredRichText(
              first: context.l10n.welcome_to,
              firstColor: context.colors.white,
              second: context.l10n.welcome_sage.toUpperCase(),
              secondColor: context.colors.mainGreenLight,
              fontSize: 30.sp,
            ),
            SizedBox(height: 7.h),
            Text(
              context.l10n.welcome_subtitle,
              style: context.typography.subtitle.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                color: context.colors.white,
              ),
            ),
            SizedBox(height: 32.h),
            MyButton(
              label: context.l10n.welcome_signup,
              isDark: true,
              onPressed: () {
                WelcomeService.goToSignup(context);
              },
            ),
            SizedBox(height: 15.h),
            MyButton(
              label: context.l10n.welcome_to_your_account,
              onPressed: () {
                WelcomeService.goToLogin(context);
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
