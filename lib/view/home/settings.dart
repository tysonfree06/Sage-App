import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/logout_service.dart';
import 'package:sage/services/views/settings_service.dart';
import 'package:sage/view/home/widgets/settings_tile.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SessionController _sessionController = SessionController();
  @override
  Widget build(BuildContext context) {
    final UserModel user = _sessionController.user!;
    final bool isPremium = user.isPremium ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.settings_title,
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 45.w,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      (user.image != null && user.image!.isNotEmpty)
                          ? NetworkImage(user.image!)
                          : null,
                  child: (user.image == null || user.image!.isEmpty)
                      ? Assets.icons.user.svg(height: 60.w, width: 60.w)
                      : null,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                user.name,
                style: context.typography.label.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                user.email,
                style: context.typography.subtitle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.textDarkGreen.withValues(alpha: .60),
                ),
              ),
              SizedBox(height: 30.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.l10n.settings_settings,
                  style: context.typography.label.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.edit.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_edit_profile,
                onTap: () => SettingService.goToEditProfileScreen(
                  context,
                ).then((_) {
                  // This runs after EditProfileScreen is popped
                  // Refresh the screen or fetch new data
                  setState(() {});
                }),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.interest.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_update_interests,
                onTap: () => SettingService.goToUpdateInterestScreen(context),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.gift.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_update_gifts_preferences,
                onTap: () => SettingService.goToUpdatePrefScreen(context),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.lock.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_change_password,
                onTap: () => SettingService.goToChangePasswordScreen(context),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.subscription.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_subscription,
                onTap: () =>
                    SettingService.goToSubscriptionScreen(context, isPremium),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.delete.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_remove_partner,
                onTap: () {
                  if (user.partnerCode != null && user.partnerCode != 0) {
                    SettingService.showRemovePartnerDialog(context);
                  } else {
                    context.flushBarErrorMessage(
                      message: 'No Partner Added yet',
                    );
                  }
                },
              ),
              SizedBox(height: 20.h),
              const Divider(),
              SizedBox(height: 20.h),
              SettingTile(
                icon: Assets.icons.share.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_refer_friend,
                onTap: () => SettingService.gotReferAFriend(context),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.contact.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_contact_us,
                onTap: () => SettingService.goToContactUsScreen(context),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.privacy.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_privacy_policy,
                onTap: () => SettingService().sageLaunchUrl(
                  'https://sage-frontend-eta.vercel.app/privacy_policies',
                ),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.terms.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_terms_conditions,
                onTap: () => SettingService().sageLaunchUrl(
                  'https://sage-frontend-eta.vercel.app/termsandconditions',
                ),
              ),
              SizedBox(height: 20.h),
              const Divider(),
              SizedBox(height: 20.h),
              SettingTile(
                icon: Assets.icons.deleteRed.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_delete_account,
                textColor: context.colors.red,
                onTap: () => SettingService.showDeleteAccountDialog(context),
              ),
              SizedBox(height: 43.h),
              MyButton(
                label: context.l10n.settings_logout,
                onPressed: () {
                  //clear session here
                  LogoutService().logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
