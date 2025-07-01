import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/loading_widget.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    required this.label,
    this.onPressed,
    this.isDark = true,
    this.isLoading = false,
    this.fontSize, // Optional fontSize parameter
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool isDark;
  final bool isLoading;
  final double? fontSize; // Optional parameter for font size

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    // Set the color depending on the isDark flag
    final textColor = isDark
        ? (isEnabled
            ? context.colors.textLightGreen
            : context.colors.textLightGreen.withValues(alpha: .50))
        : (isEnabled
            ? context.colors.mainGreenLight
            : context.colors.mainGreenLight.withValues(alpha: .50));

    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        textStyle: const TextStyle(
          decoration: TextDecoration.underline,
        ),
        padding: EdgeInsets.zero, // no extra space
        minimumSize: Size.zero, // shrink to fit
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: isLoading
          ? const LoadingWidget()
          : Text(
              label,
              style: context.typography.subtitle.copyWith(
                color: textColor,
                fontSize: fontSize ??
                    14.sp, // Use provided fontSize or default to 14.sp
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
    );
  }
}
