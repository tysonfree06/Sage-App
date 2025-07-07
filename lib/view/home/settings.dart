import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/settings_service.dart';
import 'package:sage/view/home/widgets/settings_tile.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
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
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.mainGreenLight.withValues(alpha: .2),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Name',
                style: context.typography.label.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'email@abc.com',
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
                onTap: () => SettingService.goToEditProfileScreen(context),
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
                onTap: () => SettingService.goToNoSubscriptionScreen(context),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.delete.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_remove_partner,
                onTap: () => SettingService.showRemovePartnerDialog(context),
              ),
              SizedBox(height: 20.h),
              const Divider(),
              SizedBox(height: 20.h),
              SettingTile(
                icon: Assets.icons.share.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_refer_friend,
                //onTap: () => SettingService.goToEditProfileScreen(context),
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
                //onTap: () => SettingService.goToPrivacyPolicyScreen(context),
              ),
              SizedBox(height: 10.h),
              SettingTile(
                icon: Assets.icons.terms.svg(width: 18.w, height: 18.w),
                text: context.l10n.settings_terms_conditions,
                //onTap: () => SettingService.goToTermsConditionScreen(context),
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
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesName.welcome,
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
