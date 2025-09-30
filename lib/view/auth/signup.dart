import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/constants/external_links.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/validations_exception.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/settings_service.dart';
import 'package:sage/services/views/signup_service.dart';
import 'package:sage/view/auth/widget/auth_scaffold.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();
  bool isChecked = false;

  // ValueNotifiers to toggle visibility
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController inviteCodeController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  final ValueNotifier<bool> isFormFilled = ValueNotifier(false);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Fill form with test data
    // _fillFormForTesting();

    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    nameController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
    inviteCodeController.addListener(_updateButtonState);
  }

  // void _fillFormForTesting() {
  //   nameController.text = 'MLB Test User';
  //   emailController.text = 'mtalha2410+SAGE24@gmail.com';
  //   passwordController.text = '12345678';
  //   confirmPasswordController.text = '12345678';
  // }

  @override
  void dispose() {
    emailController.removeListener(_updateButtonState);
    passwordController.removeListener(_updateButtonState);
    nameController.removeListener(_updateButtonState);
    confirmPasswordController.removeListener(_updateButtonState);
    inviteCodeController.removeListener(_updateButtonState);

    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    inviteCodeController.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    isFormFilled.dispose();

    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final isFilled = nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty &&
        isChecked;
    isFormFilled.value = isFilled;
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    firstFontSize: 16.sp,
                    secondFontSize: 16.sp,
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    context.l10n.lets_subtitle,
                    style: context.typography.subtitle.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color:
                          context.colors.textDarkGreen.withValues(alpha: .60),
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
                    controller: nameController,
                    hint: context.l10n.lets_name_hint,
                    suffixIcon: Assets.icons.user.svg(),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    readOnly: isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.error_name_required;
                      } else if (!value.nameValidator()) {
                        return context.l10n.error_name_invalid;
                      }
                      return null;
                    },
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
                    controller: emailController,
                    hint: context.l10n.lets_email_hint,
                    suffixIcon: Assets.icons.email.svg(),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    readOnly: isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.error_email_required;
                      } else if (!value.emailValidator()) {
                        return context.l10n.error_email_invalid;
                      }
                      return null;
                    },
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
                  MyFormTextField(
                    focusNode: _passwordFocusNode,
                    controller: passwordController,
                    hint: context.l10n.lets_password_hint,
                    obscureText: _obscurePassword.value,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                        () => _obscurePassword.value = !_obscurePassword.value,
                      ),
                      child: _obscurePassword.value
                          ? Assets.icons.visibilityOff.svg()
                          : Assets.icons.visibilityOn.svg(),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.none,
                    readOnly: isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.error_password_required;
                        // } else if (!value.lessSecurePasswordValidator()) {
                      } else if (!value.passwordValidator()) {
                        return context.l10n.error_password_strength;
                      }
                      return null;
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
                  MyFormTextField(
                    controller: confirmPasswordController,
                    hint: context.l10n.lets_password_hint,
                    obscureText: _obscureConfirmPassword.value,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(
                        () => _obscureConfirmPassword.value =
                            !_obscureConfirmPassword.value,
                      ),
                      child: _obscureConfirmPassword.value
                          ? Assets.icons.visibilityOff.svg()
                          : Assets.icons.visibilityOn.svg(),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    textCapitalization: TextCapitalization.none,
                    readOnly: isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.error_confirm_password_required;
                      } else if (value != passwordController.text) {
                        return context.l10n.error_confirm_password_mismatch;
                      }
                      return null;
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
                            color: context.colors.textDarkGreen.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  MyFormTextField(
                    controller: inviteCodeController,
                    hint: context.l10n.lets_invitation_hint,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    readOnly: isLoading,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length != 6) {
                        return context.l10n.error_invite_code_length;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: isLoading
                            ? null
                            : (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                  _updateButtonState();
                                });
                              },
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Wrap(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                context.l10n.lets_read_and_agree,
                                style: context.typography.subtitle.copyWith(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              MyTextButton(
                                fontSize: 15.sp,
                                label: context.l10n.lets_terms_conditions,
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        SettingService().sageLaunchUrl(
                                          ExternalLinks.sagetermsAndCondition,
                                        );
                                      },
                              ),
                              Text(
                                context.l10n.lets_and,
                                style: context.typography.subtitle.copyWith(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              MyTextButton(
                                label: context.l10n.lets_privacy_policy,
                                fontSize: 15.sp,
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        SettingService().sageLaunchUrl(
                                          ExternalLinks.sagePrivacyPolicy,
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 35.h),
                  ValueListenableBuilder<bool>(
                    valueListenable: isFormFilled,
                    builder: (_, isFilled, __) {
                      return MyButton(
                        label: context.l10n.login_signup,
                        isLoading: isLoading,
                        onPressed: isFilled && !isLoading
                            ? () async {
                                if (!formKey.currentState!.validate()) return;

                                setState(() => isLoading = true);
                                await SignupService()
                                    .signup(
                                  context,
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  inviteCode: inviteCodeController.text.trim(),
                                )
                                    .then(
                                  (_) {
                                    if (mounted) {
                                      setState(() => isLoading = false);
                                    }
                                  },
                                );
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
                        fontSize: 15.sp,
                        label: context.l10n.lets_login,
                        onPressed: isLoading
                            ? null
                            : () {
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
      ),
    );
  }
}
