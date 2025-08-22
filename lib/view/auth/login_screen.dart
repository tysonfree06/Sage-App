import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/validations_exception.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/login_service.dart';
import 'package:sage/view/auth/widget/auth_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginService = LoginService();
  final formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isFormFilled = ValueNotifier(false);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // emailController.text = 'malirazaansari45@gmail.com';
    // passwordController.text = '12345678';
    // emailController.text = 'mtalha2410+SAGE29@gmail.com';
    // passwordController.text = '12345678';
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    _updateButtonState();
  }

  void _updateButtonState() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    isFormFilled.value = email.isNotEmpty && password.isNotEmpty;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _obscurePassword.dispose();
    isFormFilled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 22.h,
            horizontal: 16.w,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ColoredRichText(
                  first: context.l10n.login,
                  second: context.l10n.login_to_your_account,
                ),
                SizedBox(height: 7.h),
                Text(
                  context.l10n.login_subtitle,
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
                    context.l10n.login_email_label,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                MyFormTextField(
                  controller: emailController,
                  hint: context.l10n.login_email_hint,
                  suffixIcon: Assets.icons.email.svg(),
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.error_email_required;
                    } else if (!value.emailValidator()) {
                      return context.l10n.error_email_invalid;
                    }
                    return null;
                  },
                  readOnly: isLoading,
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.login_password_label,
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
                      controller: passwordController,
                      hint: context.l10n.login_password_hint,
                      obscureText: obscure,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      suffixIcon: GestureDetector(
                        onTap: () => _obscurePassword.value = !obscure,
                        child: obscure
                            ? Assets.icons.visibilityOff.svg()
                            : Assets.icons.visibilityOn.svg(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.error_password_required;
                          // } else if (!value.lessSecurePasswordValidator()) {
                        } else if (!value.passwordValidator()) {
                          return context.l10n.error_password_strength;
                        }
                        return null;
                      },
                      readOnly: isLoading,
                    );
                  },
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyTextButton(
                    label: context.l10n.login_forgot_password,
                    onPressed: () {
                      LoginService.goToForgotPassword(context);
                    },
                  ),
                ),
                SizedBox(height: 40.h),
                ValueListenableBuilder<bool>(
                  valueListenable: isFormFilled,
                  builder: (_, isFilled, __) {
                    return MyButton(
                      label: context.l10n.login,
                      isLoading: isLoading,
                      onPressed: isFilled && !isLoading
                          ? () async {
                              if (!formKey.currentState!.validate()) return;
                              setState(() => isLoading = true);
                              await loginService.login(
                                context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              setState(() => isLoading = false);
                            }
                          : null,
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.l10n.login_no_account,
                      style: context.typography.subtitle.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: context.colors.textDarkGreen.withValues(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 5.w),
                    MyTextButton(
                      label: context.l10n.login_signup,
                      onPressed: () {
                        LoginService.goToSignup(context);
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
