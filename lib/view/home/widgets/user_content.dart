import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/view/home/widgets/user_chip.dart';

class UserContentWidget extends StatelessWidget {
  const UserContentWidget({
    required this.user,
    super.key,
    required this.isPartner,
  });
  final UserModel user;
  final bool isPartner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          child: CircleAvatar(
            radius: 30.w,
            backgroundColor: context.colors.white.withValues(alpha: .3),
            backgroundImage: (user.image != null && user.image!.isNotEmpty)
                ? NetworkImage(user.image!)
                : null,
            child: (user.image == null || user.image!.isEmpty)
                ? Assets.icons.user
                    .svg(height: 40.w, width: 40.w, color: Colors.white)
                : null,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name,
              style: context.typography.title.copyWith(
                fontSize: 15.sp,
                color: context.colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!isPartner)
              Text(
                '(You)',
                style: TextStyle(
                  color: context.colors.white.withValues(alpha: .3),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
        Divider(color: context.colors.white.withValues(alpha: .1)),
        Wrap(
          spacing: 5.w,
          runSpacing: 5.h,
          children: [
            UserChip(
              label: user.loveLanguage ?? '',
              backgroundColor: context.colors.yellow,
              textColor: context.colors.mainGreenDark,
            ),
            UserChip(
              label: user.apologyLanguage ?? '',
              backgroundColor: const Color(0xFFBFA2DB),
              textColor: Colors.white,
            ),
            UserChip(
              label: user.communicationStyle ?? '',
              backgroundColor: const Color(0xFFE5B7B4),
              textColor: Colors.white,
            ),
            ...user.interests!.take(5).map(
                  (interest) => UserChip(
                    label: interest,
                    backgroundColor: context.colors.mainGreenLight,
                    textColor: Colors.white,
                  ),
                ),
            ...user.giftPreferences!.take(5).map(
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
