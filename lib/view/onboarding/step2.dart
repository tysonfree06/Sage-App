import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_chip.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/session_manager/session_controller.dart';

class Step2Screen extends StatefulWidget {
  const Step2Screen({
    required this.onNext,
    super.key,
    this.initialSelectedInterests = const {},
  });

  final Set<String> initialSelectedInterests;
  final void Function(Set<String> selectedInterests) onNext;

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  // local copy of the prop, so we don't mutate widget.initialSelectedInterests
  late Set<String> _selectedInterests;

  final List<String> _allInterests = [
    'Fitness',
    'Science and Math',
    'Outdoors',
    'Travel',
    'Wellness',
    'Food',
    'Games',
    'Tech',
    'Home',
    'Art',
    'Learning',
    'Entertainment',
    'Community',
    'Fashion',
    'Shopping',
    'Movies',
    'Sports',
    'Parenting',
    'Spirituality & Religion', //previously: 'Spirituality and Religion',
    'Music',
    'Finances',
    'Animals',
    'Dancing',
    'History',
    'Photography',
  ];

  final SessionController _sessionController = SessionController();
  @override
  void initState() {
    super.initState();
    // make a mutable copy
    // _selectedInterests = Set.from(widget.initialSelectedInterests);

    //Set from session
    _selectedInterests =
        (_sessionController.user?.interests ?? []).toSet().cast<String>();
  }

  // only allow Next when exactly 5 interests are chosen
  // bool get _canProceed => _selectedInterests.length == 5; //Changed #muttas
  bool get _canProceed => _selectedInterests.isNotEmpty;

  void _onChipToggled(String item, bool selected) {
    setState(() {
      if (selected) {
        if (_selectedInterests.length < 5) {
          _selectedInterests.add(item);
        } else {
          context.flushBarErrorMessage(
            message: context.l10n.onboarding_step2_limit_5_interests,
          );
        }
      } else {
        _selectedInterests.remove(item);
      }
    });
  }

  void _submit() {
    if (_canProceed) {
      widget.onNext(_selectedInterests);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Center(
                child: ColoredRichText(
                  first: context.l10n.onboarding_step2,
                  second: context.l10n.onboarding_steps_4,
                  firstFontSize: 15.sp,
                  secondFontSize: 15.sp,
                  firstFontWeight: FontWeight.w600,
                  secondFontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
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

              // Chips grid
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.w,
                runSpacing: 10.h,
                children: _allInterests.map((item) {
                  return MyChip(
                    label: item,
                    isSelected: _selectedInterests.contains(item),
                    onChanged: (isSelected) => _onChipToggled(item, isSelected),
                  );
                }).toList(),
              ),

              const Spacer(),

              // Next button, disabled until exactly 5 are selected
              MyButton(
                label: context.l10n.onboarding_step2_next,
                onPressed: _canProceed ? _submit : null,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
