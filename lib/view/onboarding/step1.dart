import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/custom_radio_group.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_datepicker_button.dart';
import 'package:sage/app/components/my_dropdown.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/components/step_progress_bar.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/general_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/onboarding_service.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({super.key});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  String _selected = 'Engaged';
  final List<String> statuses = ['Dating', 'Engaged', 'Married'];
  DateTime? anniversaryDate;
  DateTime? dob;
  // Define these dummy options at the top of your State class
  final List<String> loveLanguages = [
    'Words of Affirmation',
    'Acts of Service',
    'Receiving Gifts',
    'Quality Time',
    'Physical Touch',
  ];

  final List<String> apologyLanguages = [
    'Expressing Regret',
    'Accepting Responsibility',
    'Making Restitution',
    'Genuinely Repenting',
    'Requesting Forgiveness',
  ];

  final List<String> communicationStyles = [
    'Assertive',
    'Passive',
    'Aggressive',
    'Passive-Aggressive',
  ];

  final List<String> budgetLevels = [
    r'$0 - $50',
    r'$50 - $100',
    r'$100 - $200',
    r'$200+',
  ];

  final List<String> cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
  ];

  final List<String> states = [
    'California',
    'Texas',
    'New York',
    'Florida',
    'Illinois',
  ];

  final List<String> countries = [
    'United States',
    'Canada',
    'United Kingdom',
    'Australia',
    'India',
  ];

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.typography.title.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 16.sp,
      color: context.colors.textDarkGreen,
    );

    return LightStatusBar(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: context.colors.mainGreenLight),
          centerTitle: true,
          title: SizedBox(
            width: context.mediaQueryWidth / 2,
            child: const StepProgressBar(totalSteps: 4, currentStep: 0),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ColoredRichText(
                      first: context.l10n.onboarding_step1,
                      second: context.l10n.onboarding_steps_4,
                      firstFontSize: 15.sp,
                      secondFontSize: 15.sp,
                      firstFontWeight: FontWeight.w600,
                      secondFontWeight: FontWeight.w600,
                    ),
                  ),
                  Center(
                    child: Text(
                      context.l10n.onboarding_step1_lets_get_started,
                      style: context.typography.title.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                        color: context.colors.textDarkGreen,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    context.l10n.onboarding_step1_what_is_your_love_language,
                    style: labelStyle,
                  ),
                  SizedBox(height: 10.h),
                  MyDropdown(
                    items: loveLanguages,
                    onChanged: (value) {},
                    hint: context.l10n.onboarding_step1_words_of_affirmation,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.onboarding_step1_what_is_your_apology_language,
                    style: labelStyle,
                  ),
                  SizedBox(height: 10.h),
                  MyDropdown(
                    items: apologyLanguages,
                    onChanged: (value) {},
                    hint: context.l10n.onboarding_step1_expressing_regrets,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context
                        .l10n.onboarding_step1_what_is_your_communication_style,
                    style: labelStyle,
                  ),
                  SizedBox(height: 10.h),
                  MyDropdown(
                    items: communicationStyles,
                    onChanged: (value) {},
                    hint: context.l10n.onboarding_step1_assertive,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.onboarding_step1_budget_level,
                    style: labelStyle,
                  ),
                  SizedBox(height: 10.h),
                  MyDropdown(
                    items: budgetLevels,
                    onChanged: (value) {},
                    hint: context.l10n.onboarding_step1_budget_50_to_100,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.onboarding_step1_relationship_status,
                    style: labelStyle,
                  ),
                  SizedBox(height: 10.h),
                  CustomRadioGroup<String>(
                    options: statuses,
                    selectedValue: _selected,
                    onChanged: (newValue) {
                      setState(() {
                        _selected = newValue;
                      });
                    },
                    labelBuilder: (value) => value,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.onboarding_step1_anniversary_date,
                    style: labelStyle,
                  ),
                  SizedBox(height: 10.h),
                  MyDatePickerButton(
                    hintText: context.l10n.onboarding_step1_select_a_date,
                    selectedDate: anniversaryDate,
                    onChanged: (value) {
                      setState(() {
                        anniversaryDate = value;
                      });
                    },
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Assets.icons.calander.svg(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.onboarding_step1_date_of_birth,
                    style: labelStyle,
                  ),
                  SizedBox(height: 10.h),
                  MyDatePickerButton(
                    hintText: context.l10n.onboarding_step1_select_a_date,
                    selectedDate: dob,
                    onChanged: (value) {
                      setState(() {
                        dob = value;
                      });
                    },
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Assets.icons.calander.svg(),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.onboarding_step1_location,
                    style: labelStyle,
                  ),
                  SizedBox(height: 10.h),
                  MyDropdown(
                    items: cities,
                    onChanged: (value) {},
                    hint: context.l10n.onboarding_step1_select_city,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: MyDropdown(
                          items: states,
                          onChanged: (value) {},
                          hint: context.l10n.onboarding_step1_state,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: MyDropdown(
                          items: countries,
                          onChanged: (value) {},
                          hint: context.l10n.onboarding_step1_country,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  MyButton(
                    label: context.l10n.onboarding_step1_next,
                    onPressed: () {
                      OnboardingService.goToStep2(context);
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
