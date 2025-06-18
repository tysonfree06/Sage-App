import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    required this.label,
    this.onPressed,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    final textColor = (isEnabled
        ? context.colors.textLightGreen
        : context.colors.textLightGreen.withValues(alpha: .50));

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        textStyle: const TextStyle(
          decoration: TextDecoration.underline,
        ),
        padding: EdgeInsets.zero, // no extra space
        minimumSize: Size.zero, // shrink to fit
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
