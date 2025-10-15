import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/signup_service.dart';

class ProfileIncompleteAlert extends StatefulWidget {
  const ProfileIncompleteAlert({
    super.key,
  });

  @override
  State<ProfileIncompleteAlert> createState() => _ProfileIncompleteAlertState();
}

class _ProfileIncompleteAlertState extends State<ProfileIncompleteAlert> {
  bool profileIncomplete = SessionController().isProfileIncomplete;
  void refreshWidget() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          profileIncomplete = SessionController().isProfileIncomplete;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    refreshWidget();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return profileIncomplete
        ? Container(
            // margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.colors.mainGreenLight.withAlpha(75),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Finish Profile Setup',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Icon(
                      Icons.edit,
                      size: 18.w,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        //navigate to onboarding
                        if (mounted) {
                          SignupService.goToOnBoarding(context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 4.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.greenBg,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Assets.icons.premium.svg(),
                            Icon(
                              Icons.person,
                              size: 14.w,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  // '''Your profile is not complete. Please fill all information to get perfect ideas!''',
                  '''You're almost there. Complete the final step to unlock your full experience.''',
                  style: TextStyle(
                    // fontSize: 14.sp,
                    color: context.colors.subtext,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
