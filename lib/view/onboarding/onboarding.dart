import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/onboarding_service.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Assets.images.onBoarding.svg(fit: BoxFit.fitWidth),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 72.h),
                  ColoredRichText(
                    first: context.l10n.onboarding_lets_see_what,
                    firstColor: context.colors.textDarkGreen,
                    second: context.l10n.onboarding_fuels,
                    secondColor: context.colors.textLightGreen,
                    fontSize: 28.sp,
                  ),
                  ColoredRichText(
                    first: context.l10n.onboarding_your,
                    firstColor: context.colors.textDarkGreen,
                    second: context.l10n.onboarding_connection,
                    secondColor: context.colors.textLightGreen,
                    fontSize: 28.sp,
                  ),
                  SizedBox(height: 65.h),
                  MyButton(
                    label: context.l10n.onboarding_start,
                    onPressed: () {
                      OnboardingService.goToStep1(context);
                    },
                  ),
                  SizedBox(height: 12.h),
                  MyButton(
                    label: context.l10n.onboarding_maybe_latter,
                    isDark: true,
                    onPressed: () {
                      OnboardingService.goToHome(context);
                    },
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
