import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/signup_service.dart';
import 'package:sage/view/auth/widget/auth_scaffold.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  // ValueNotifiers to toggle visibility
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 16,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ColoredRichText(
                  first: context.l10n.lets_get_started_1,
                  firstColor: context.colors.textDarkGreen,
                  second: context.l10n.lets_get_started_2,
                  secondColor: context.colors.textLightGreen,
                ),
                SizedBox(height: 7.h),
                Text(
                  context.l10n.lets_subtitle,
                  style: context.typography.subtitle.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textDarkGreen.withValues(alpha: .60),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.lets_name_label,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                MyFormTextField(
                  hint: context.l10n.lets_name_hint,
                  suffixIcon: Assets.icons.user.svg(),
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.lets_email_label,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                MyFormTextField(
                  hint: context.l10n.lets_email_hint,
                  suffixIcon: Assets.icons.email.svg(),
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.lets_password_label,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                ValueListenableBuilder<bool>(
                  valueListenable: _obscurePassword,
                  builder: (_, obscure, __) {
                    return MyFormTextField(
                      hint: context.l10n.lets_password_hint,
                      obscureText: obscure,
                      suffixIcon: GestureDetector(
                        onTap: () => _obscurePassword.value = !obscure,
                        child: obscure
                            ? Assets.icons.visibilityOff.svg()
                            : Assets.icons.visibilityOn.svg(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.lets_confirm_password_label,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                ValueListenableBuilder<bool>(
                  valueListenable: _obscureConfirmPassword,
                  builder: (_, obscure, __) {
                    return MyFormTextField(
                      hint: context.l10n.lets_password_hint,
                      obscureText: obscure,
                      suffixIcon: GestureDetector(
                        onTap: () => _obscureConfirmPassword.value = !obscure,
                        child: obscure
                            ? Assets.icons.visibilityOff.svg()
                            : Assets.icons.visibilityOn.svg(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        context.l10n.lets_invitation_label,
                        style: context.typography.title.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        context.l10n.lets_optional,
                        style: context.typography.subtitle.copyWith(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.textDarkGreen.withValues(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                MyFormTextField(hint: context.l10n.lets_invitation_hint),
                SizedBox(height: 40.h),
                MyButton(
                  label: context.l10n.login_signup,
                  onPressed: () {
                    SignupService.showVerificationSheet(context);
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.lets_already_have_an_account,
                      style: context.typography.subtitle.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: context.colors.textDarkGreen.withValues(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 5.w),
                    MyTextButton(
                      label: context.l10n.lets_login,
                      onPressed: () {
                        SignupService.goToLogin(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
