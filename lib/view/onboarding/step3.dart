import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_chip.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/components/step_progress_bar.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/app/utils/extensions/general_extensions.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/onboarding_service.dart';

class Step3Screen extends StatefulWidget {
  const Step3Screen({super.key});

  @override
  State<Step3Screen> createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  TextEditingController pinController = TextEditingController();
  List<String> preferences = [
    "Experiences",
    "Tech & Gadgets",
    "Jewelry",
    "Fashion & Accessories",
    "Books",
    "Handmade & DIY",
    "Events",
    "Personalized Gifts",
    "Subscription Services",
    "Wellness & Self-Care",
    "Home & Decor",
    "Food & Gourmet",
    "Travel & Adventure",
    "Event Tickets"
  ];
  Set<String> selectedPreferences = {};

  @override
  Widget build(BuildContext context) {
    
    return LightStatusBar(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: context.colors.mainGreenLight),
          centerTitle: true,
          title: SizedBox(
            width: context.mediaQueryWidth / 2,
            child: const StepProgressBar(totalSteps: 4, currentStep: 2),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
            child: Column(
              children: [
                Center(
                  child: ColoredRichText(
                    first: context.l10n.onboarding_step3,
                    second: context.l10n.onboarding_steps_4,
                   firstFontSize: 15.sp,
                      secondFontSize: 15.sp,
                      firstFontWeight: FontWeight.w600,
                      secondFontWeight: FontWeight.w600,
                  ),
                ),
                Center(
                  child: Text(
                    context.l10n.onboarding_step3_select_your_top_5_gift_preferences,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 24.sp,
                      color: context.colors.textDarkGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.h),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: preferences
                      .map(
                        (item) => MyChip(
                      label: item,
                      isSelected: selectedPreferences.contains(item),
                      onChanged: (selected) {
                        setState(() {
                          if (selected) {
                            if (selectedPreferences.length < 5) {
                              selectedPreferences.add(item);
                            } else {
                              // Optional: Show a toast or alert to limit 5
                              context.flushBarErrorMessage(
                                message:
                                'You can select up to 5 preferences only.',
                              );
                            }
                          } else {
                            selectedPreferences.remove(item);
                          }
                        });
                      },
                    ),
                  )
                      .toList(),
                ),

                const Spacer(),
                MyButton(
                  label: context.l10n.onboarding_step3_next,
                  onPressed: () {
                    OnboardingService.goToStep4(context);
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
