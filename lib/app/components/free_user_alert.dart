import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/settings_service.dart';
import 'package:sage/services/views/splash_services.dart';

class FreeUserAlert extends StatefulWidget {
  const FreeUserAlert({
    super.key,
    this.title,
    this.subtitle,
    this.buttonText,
  });
  final String? title;
  final String? subtitle;
  final String? buttonText;

  @override
  State<FreeUserAlert> createState() => _FreeUserAlertState();
}

@override
class _FreeUserAlertState extends State<FreeUserAlert> {
  bool isPremium = SessionController().user!.isPremium ?? false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await SettingService.goToSubscriptionScreen(
          context,
          false,
        );
        //fetch user profile
        if (context.mounted) {
          await SplashServices().fetchProfile(context);
        }
        setState(() {
          isPremium = SessionController().user!.isPremium ?? false;
        });
        debugPrint('👤 Subscription status updated : $isPremium');
      },
      child: isPremium
          ? const SizedBox.shrink()
          : Container(
              // margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.mainGreenLight.withAlpha(75),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    widget.title ?? 'Subscribe',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  UnlockButton(widget: widget),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    widget.subtitle ?? 'You are not subscribed!',
                    style: TextStyle(
                      // fontSize: 14.sp,
                      color: context.colors.subtext,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class UnlockButton extends StatelessWidget {
  const UnlockButton({
    required this.widget,
    super.key,
  });

  final FreeUserAlert widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
        horizontal: 10.w,
      ),
      decoration: BoxDecoration(
        color: context.colors.greenBg,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.premium.svg(),
          SizedBox(
            width: 4.w,
          ),
          Text(
            widget.buttonText ?? 'Unlock Now',
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color.fromRGBO(
                243,
                229,
                171,
                1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
