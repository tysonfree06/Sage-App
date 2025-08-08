import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_chip.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/l10n/l10n.dart';

class Step3Screen extends StatefulWidget {
  const Step3Screen({
    required this.onNext, super.key,
    this.initialSelectedPrefs = const {},
  });

  final void Function(Set<String>) onNext;
  final Set<String> initialSelectedPrefs;

  @override
  State<Step3Screen> createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  late Set<String> _selectedPrefs;

  final List<String> _preferences = [
    'Experiences',
    'Tech & Gadgets',
    'Jewelry',
    'Fashion & Accessories',
    'Books',
    'Handmade & DIY',
    'Events',
    'Personalized Gifts',
    'Subscription Services',
    'Wellness & Self-Care',
    'Home & Decor',
    'Food & Gourmet',
    'Travel & Adventure',
    'Event Tickets',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPrefs = Set.from(widget.initialSelectedPrefs);
  }

  bool get _canProceed => _selectedPrefs.length == 5;

  void _onChipToggled(String item, bool selected) {
    setState(() {
      if (selected) {
        if (_selectedPrefs.length < 5) {
          _selectedPrefs.add(item);
        } else {
          context.flushBarErrorMessage(
            message: context.l10n.onboarding_step3_limit_5_preferences,
          );
        }
      } else {
        _selectedPrefs.remove(item);
      }
    });
  }

  void _submit() {
    if (_canProceed) {
      widget.onNext(_selectedPrefs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
          child: Column(
            children: [
              SizedBox(height: 24.h),
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
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  context
                      .l10n.onboarding_step3_select_your_top_5_gift_preferences,
                  style: context.typography.title.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    color: context.colors.textDarkGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24.h),

              // Preference chips
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.w,
                runSpacing: 10.h,
                children: _preferences.map((item) {
                  return MyChip(
                    label: item,
                    isSelected: _selectedPrefs.contains(item),
                    onChanged: (sel) => _onChipToggled(item, sel),
                  );
                }).toList(),
              ),

              const Spacer(),

              // Next button: enabled only when exactly 5 prefs picked
              MyButton(
                label: context.l10n.onboarding_step3_next,
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
