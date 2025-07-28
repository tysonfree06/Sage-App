import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_bottom_sheet.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/view/home/widgets/add_partner_sheet.dart';

class UserNotAvailableWidget extends StatelessWidget {
  const UserNotAvailableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SessionController _sessionController = SessionController();
    final referalCode = _sessionController.user!.mineinvitationCode ?? '';
    // const String referalCode = '546789';
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
          GestureDetector(
              onTap: () => MyBottomSheet.show<void>(
                    context,
                    child: const AddPartnerSheet(),
                  ),
              child: Assets.icons.addFilled.svg()),
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
                  referalCode,
                  style: context.typography.body.copyWith(
                    color: context.colors.white.withValues(alpha: .6),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: referalCode));
                    if (context.mounted) {
                      context.flushBarSuccessMessage(
                        message: 'Copied to clipboard',
                      );
                    }
                  },
                  child: Assets.icons.copy.svg(height: 12.h, width: 12.w),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
