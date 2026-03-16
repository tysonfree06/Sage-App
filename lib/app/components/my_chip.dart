import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';

class MyChip extends StatelessWidget {
  const MyChip({
    required this.label,
    required this.isSelected,
    required this.onChanged,
    super.key,
  });
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? colors.mainGreenLight : Colors.white,
          borderRadius: BorderRadius.circular(AppRadiuses.hundredRadius),
        ),
        child: Text(
          label,
          style: typography.body.copyWith(
            color: isSelected ? Colors.white : colors.mainGreenDark,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
