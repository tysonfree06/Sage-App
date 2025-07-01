import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';

class UserNotAvailableWidget extends StatelessWidget {
  const UserNotAvailableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: [4, 4],
        color: context.colors.white.withValues(alpha: .1),
        radius: Radius.circular(10.r),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      ),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Assets.icons.addFilled.svg(),
          SizedBox(height: 8.h),
          Text(
            'Add Partner',
            style: context.typography.body.copyWith(
              color: context.colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 72.h),
          Text(
            'Or',
            style: context.typography.body.copyWith(
              color: context.colors.white.withValues(alpha: .50),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Share Code',
            style: context.typography.body.copyWith(
              color: context.colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: context.colors.white.withValues(alpha: .1),
              borderRadius: BorderRadius.circular(AppRadiuses.hundredRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '546789',
                  style: context.typography.body.copyWith(
                    color: context.colors.white.withValues(alpha: .6),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8.w),
                Assets.icons.copy.svg(height: 12.h, width: 12.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
