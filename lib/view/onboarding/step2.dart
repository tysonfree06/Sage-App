import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/components/step_progress_bar.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/general_extensions.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/onboarding_service.dart';

class Step2Screen extends StatefulWidget {
  const Step2Screen({super.key});

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.typography.subtitle.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 15.sp,
      color: context.colors.textDarkGreen.withValues(alpha: 0.6),
    );
    return LightStatusBar(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: context.colors.mainGreenLight),
          title: SizedBox(
            width: context.mediaQueryWidth / 2,
            child: const StepProgressBar(totalSteps: 4, currentStep: 1),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
            child: Column(
              children: [
                Center(
                  child: ColoredRichText(
                    first: context.l10n.onboarding_step2,
                    second: context.l10n.onboarding_steps_4,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Center(
                  child: Text(
                    context.l10n.onboarding_step2_select_your_top_5_interests,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp,
                      color: context.colors.textDarkGreen,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                const Wrap(
                  children: [
                    Chip(label: Text('f')),
                  ],
                ),
                //TODO

                const Spacer(),
                MyButton(
                  label: context.l10n.onboarding_step2_next,
                  onPressed: () {
                    OnboardingService.goToStep1(context);
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
