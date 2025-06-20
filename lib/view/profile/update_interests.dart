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

class UpdateInterestsScreen extends StatefulWidget {
  const UpdateInterestsScreen({super.key});

  @override
  State<UpdateInterestsScreen> createState() => _UpdateInterestsScreenState();
}

class _UpdateInterestsScreenState extends State<UpdateInterestsScreen> {
  TextEditingController pinController = TextEditingController();
  List<String> allInterests = [
      "Fitness",
      "Science and Math",
      "Outdoors",
      "Travel",
      "Wellness",
      "Food",
      "Games",
      "Tech",
      "Home",
      "Art",
      "Learning",
      "Entertainment",
      "Community",
      "Fashion",
      "Shopping",
      "Movies",
      "Sports",
      "Movies",
      "Parenting",
      "Spirituality and Religion",
      "Music",
      "Finances",
      "Animals",
      "Dancing",
      "History",
      "Photography",
    ];

  Set<String> selectedInterests = {};

  @override
  Widget build(BuildContext context) {
    return LightStatusBar(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: context.colors.mainGreenLight),
          title: Text(
            context.l10n.update_interests,
            style: context.typography.title.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20.sp,
              color: context.colors.textDarkGreen,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Center(
                  child: Text(
                    context.l10n.update_interests_choose_upto_5_interests,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: context.colors.textDarkGreen,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: allInterests
                      .map(
                        (item) => MyChip(
                          label: item,
                          isSelected: selectedInterests.contains(item),
                          onChanged: (selected) {
                            setState(() {
                              if (selected) {
                                if (selectedInterests.length < 5) {
                                  selectedInterests.add(item);
                                } else {
                                  // Optional: Show a toast or alert to limit 5
                                  context.flushBarErrorMessage(
                                    message:
                                        'You can select up to 5 interests only.',
                                  );
                                }
                              } else {
                                selectedInterests.remove(item);
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const Spacer(),
                MyButton(
                  label: context.l10n.interests_update,
                  onPressed: () {
                    OnboardingService.goToStep3(context);
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
