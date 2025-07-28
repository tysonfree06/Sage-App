import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_pinput.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/l10n/l10n.dart';

class Step4Screen extends StatefulWidget {
  const Step4Screen({
    required this.onNext,
    this.initialPartnerId,
    super.key,
  });

  final String? initialPartnerId;
  final void Function(String? selectedPartnerId) onNext;

  @override
  State<Step4Screen> createState() => _Step4ScreenState();
}

class _Step4ScreenState extends State<Step4Screen> {
  late TextEditingController _pinController;

  // whether we have any non-empty PIN
  bool get _canConnect =>
      _pinController.text.trim().isNotEmpty && _pinController.text.length == 4;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController(
      text: widget.initialPartnerId ?? '',
    )..addListener(() {
        setState(() {
          // rebuild to update button enabled state
        });
      });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.typography.subtitle.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 15.sp,
      color: context.colors.textDarkGreen.withOpacity(0.6),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Center(
                child: ColoredRichText(
                  first: context.l10n.onboarding_step4,
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
                  context.l10n.onboarding_step4_add_partner,
                  style: context.typography.title.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    color: context.colors.textDarkGreen,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                context.l10n.onboarding_step4_add_partner_with_code,
                style: labelStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 35.h),

              // PIN input
              MyPinput(
                controller: _pinController,
                length: 5,
              ),

              const Spacer(),

              // CONNECT—only enabled when PIN is non-empty
              MyButton(
                label: context.l10n.onboarding_step4_connect,
                onPressed: _canConnect
                    ? () => widget.onNext(_pinController.text.trim())
                    : null,
              ),
              SizedBox(height: 12.h),

              // WILL ADD LATER—always enabled, passes null
              MyButton(
                label: context.l10n.onboarding_step4_will_add_later,
                isDark: true,
                onPressed: () => widget.onNext(null),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
