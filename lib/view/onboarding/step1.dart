import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_datepicker_button.dart';
import 'package:sage/app/components/my_dropdown.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/components/step_progress_bar.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/general_extensions.dart';
import 'package:sage/l10n/l10n.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({super.key});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
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
          title: SizedBox(
            width: context.mediaQueryWidth / 2,
            child: const StepProgressBar(totalSteps: 4, currentStep: 0),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ColoredRichText(
                    first: context.l10n.onboarding_step1,
                    second: context.l10n.onboarding_steps_4,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
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
                Text(
                  context.l10n.onboarding_step1_what_is_your_love_language,
                  style: labelStyle,
                ),
                MyDropdown(
                  items: [],
                  onChanged: (value) {},
                  hint: context.l10n.onboarding_step1_words_of_affirmation,
                ),
                Text(
                  context.l10n.onboarding_step1_what_is_your_apology_language,
                  style: labelStyle,
                ),
                MyDropdown(
                  items: [],
                  onChanged: (value) {},
                  hint: context.l10n.onboarding_step1_expressing_regrets,
                ),
                Text(
                  context
                      .l10n.onboarding_step1_what_is_your_communication_style,
                  style: labelStyle,
                ),
                MyDropdown(
                  items: [],
                  onChanged: (value) {},
                  hint: context.l10n.onboarding_step1_assertive,
                ),
                Text(
                  context.l10n.onboarding_step1_budget_level,
                  style: labelStyle,
                ),
                MyDropdown(
                  items: [],
                  onChanged: (value) {},
                  hint: context.l10n.onboarding_step1_budget_50_to_100,
                ),
                Text(
                  context.l10n.onboarding_step1_relationship_status,
                  style: labelStyle,
                ),
                Text(
                  context.l10n.onboarding_step1_anniversary_date,
                  style: labelStyle,
                ),
                Text(
                  context.l10n.onboarding_step1_date_of_birth,
                  style: labelStyle,
                ),
                Text(
                  context.l10n.onboarding_step1_location,
                  style: labelStyle,
                ),
                MyDropdown(
                  items: [],
                  onChanged: (value) {},
                  hint: context.l10n.onboarding_step1_select_city,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyDropdown(
                        items: [],
                        onChanged: (value) {},
                        hint: context.l10n.onboarding_step1_state,
                      ),
                    ),
                    SizedBox(width: 16), // Optional spacing between dropdowns
                    Expanded(
                      child: MyDropdown(
                        items: [],
                        onChanged: (value) {},
                        hint: context.l10n.onboarding_step1_country,
                      ),
                    ),
                  ],
                ),
                MyButton(
                  label: context.l10n.onboarding_step1_next,
                  onPressed: () {},
                ),
                MyDatePickerButton(
                  hintText: "hint",
                  selectedDate: null,
                  onChanged: (_) {},
                  suffixIcon: Icon(Icons.calendar_month_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
