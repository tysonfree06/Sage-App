import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/splash_services.dart';
import 'package:sage/view/home/widgets/user_chip.dart';

// ignore: must_be_immutable
class UserContentWidget extends StatefulWidget {
  UserContentWidget({
    required this.user,
    required this.isPartner,
    super.key,
  });
  UserModel user;
  final bool isPartner;

  @override
  State<UserContentWidget> createState() => _UserContentWidgetState();
}

class _UserContentWidgetState extends State<UserContentWidget> {
  Future<void> updateProfileInfo() async {
    if (widget.user.loveLanguage == null && widget.isPartner == false) {
      await SplashServices().fetchProfile(context);
      if (SessionController().user != null) {
        if (mounted) {
          setState(() {
            widget.user = SessionController().user!;
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    updateProfileInfo(); // Fetch profile info if not available
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          child: CircleAvatar(
            radius: 30.w,
            backgroundColor: context.colors.white.withValues(alpha: .3),
            backgroundImage:
                (widget.user.image != null && widget.user.image!.isNotEmpty)
                    ? NetworkImage(widget.user.image!)
                    : null,
            child: (widget.user.image == null || widget.user.image!.isEmpty)
                ? Assets.icons.user
                    .svg(height: 40.w, width: 40.w, color: Colors.white)
                : null,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: SizedBox(
                // width: 100.w,
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  widget.user.name,
                  style: context.typography.title.copyWith(
                    fontSize: 15.sp,
                    color: context.colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (!widget.isPartner)
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
              label: widget.user.loveLanguage ?? '',
              backgroundColor: context.colors.yellow,
              textColor: context.colors.mainGreenDark,
            ),
            UserChip(
              label: widget.user.apologyLanguage ?? '',
              backgroundColor: const Color(0xFFBFA2DB),
              textColor: Colors.white,
            ),
            UserChip(
              label: widget.user.communicationStyle ?? '',
              backgroundColor: const Color(0xFFE5B7B4),
              textColor: Colors.white,
            ),
            ...widget.user.interests!.take(5).map(
                  (interest) => UserChip(
                    label: interest,
                    backgroundColor: context.colors.mainGreenLight,
                    textColor: Colors.white,
                  ),
                ),
            ...widget.user.giftPreferences!.take(5).map(
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
