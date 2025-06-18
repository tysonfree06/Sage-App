import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class MyPinput extends StatelessWidget {
  const MyPinput({
    required this.controller,
    super.key,
    this.focusNode,
    this.length = 4,
    this.validator,
    this.onCompleted,
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final int length;
  final String? Function(String?)? validator;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final basePinTheme = PinTheme(
      width: 52.w,
      height: 52.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: context.colors.textDarkGreen.withValues(alpha: .60),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
        border: Border.all(color: context.colors.border),
      ),
    );

    return Pinput(
      controller: controller,
      focusNode: focusNode,
      length: length,
      defaultPinTheme: basePinTheme,
      focusedPinTheme: basePinTheme.copyWith(
        decoration: basePinTheme.decoration!.copyWith(
          border: Border.all(color: context.colors.mainGreenLight),
        ),
      ),
      submittedPinTheme: basePinTheme.copyWith(),
      errorPinTheme: basePinTheme.copyWith(
        decoration: basePinTheme.decoration!.copyWith(
          border: Border.all(color: context.colors.red),
        ),
      ),
      separatorBuilder: (index) => SizedBox(width: AppDimensions.mediumSmall),
      validator: validator,
      onCompleted: onCompleted,
      onChanged: onChanged,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
    );
  }
}
