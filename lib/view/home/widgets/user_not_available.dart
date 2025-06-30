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
          Assets.icons.addFilled.svg(),
          SizedBox(height: 8.h),
          Text('Add Partner', style: context.typography.body),
          Text('or', style: context.typography.body),
          Text('Share Code', style: context.typography.body),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: context.colors.white.withOpacity(.1),
              borderRadius: BorderRadius.circular(AppRadiuses.hundredRadius),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('546789', style: context.typography.body),
                SizedBox(width: 8.w),
                Assets.icons.copy.svg(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
