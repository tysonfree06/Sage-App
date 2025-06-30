import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/styles/app_radiuses.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/view/home/widgets/user_chip.dart';

class UserContentWidget extends StatelessWidget {
  const UserContentWidget({required this.user, super.key});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadiuses.hundredRadius),
          child: Image.network(
            user.image,
            height: 60.w,
            width: 60.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          user.name,
          style: context.typography.title.copyWith(
            fontSize: 15.sp,
            color: context.colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Divider(color: context.colors.white.withValues(alpha: .1)),
        Wrap(
          spacing: 5.w,
          runSpacing: 5.h,
          children: [
            UserChip(
              label: user.loveLanguage,
              backgroundColor: context.colors.yellow,
              textColor: context.colors.mainGreenDark,
            ),
            UserChip(
              label: user.apologyLanguage,
              backgroundColor: Color(0xFFBFA2DB),
              textColor: Colors.white,
            ),
            UserChip(
              label: user.communicationStyle,
              backgroundColor: Color(0xFFE5B7B4),
              textColor: Colors.white,
            ),
            ...user.interests.take(5).map(
                  (interest) => UserChip(
                    label: interest,
                    backgroundColor: context.colors.mainGreenLight,
                    textColor: Colors.white,
                  ),
                ),
            ...user.giftPreferences.take(5).map(
                  (preference) => UserChip(
                    label: preference,
                    backgroundColor: Colors.white,
                    textColor: context.colors.mainGreenDark,
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
