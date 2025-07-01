import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    required this.icon,
    required this.text,
    this.textColor,
    super.key,
    this.onTap,
    this.sufix,
  });
  final Widget icon;
  final String text;
  final Color? textColor;
  final VoidCallback? onTap;
  final Widget? sufix;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadiuses.mediumRadius),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 12.w),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.w),
              child: Text(
                text,
                style: context.typography.label.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? context.colors.textDarkGreen,
                ),
              ),
            ),
            const Spacer(),
            if (sufix != null)
              sufix!
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: context.colors.mainGreenLight,
                size: 18.sp,
              ),
          ],
        ),
      ),
    );
  }
}
