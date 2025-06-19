import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/loading_widget.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    required this.label,
    this.onPressed,
    this.isDark = false,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isDark;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    final backgroundColor = isDark
        ? (isEnabled
            ? context.colors.mainGreenDark
            : context.colors.mainGreenDark.withValues(alpha: .20))
        : (isEnabled
            ? context.colors.mainGreenLight
            : context.colors.mainGreenLight.withValues(alpha: .20));

    final foregroundColor = context.colors.white;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadiuses.largeRadius),
          ),
        ),
        child: isLoading
            ? const LoadingWidget(
                size: 20,
              )
            : Text(
                label,
                style: context.typography.button.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
