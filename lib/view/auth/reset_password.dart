import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/validations_exception.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/reset_password_service.dart';
import 'package:sage/view/auth/widget/auth_scaffold.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({
    required this.email,
    super.key,
  });
  final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ValueNotifier<bool> _obscureNewPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);
  final ValueNotifier<bool> isFormFilled = ValueNotifier(false);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    _obscureNewPassword.dispose();
    _obscureConfirmPassword.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final isFilled = passwordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty;
    isFormFilled.value = isFilled;
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(color: context.colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ColoredRichText(
                  first: context.l10n.reset,
                  second: context.l10n.reset_password,
                ),
                SizedBox(height: 7.h),
                Text(
                  context.l10n.reset_subtitle,
                  style: context.typography.subtitle.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.textDarkGreen.withValues(alpha: .60),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),

                // NEW PASSWORD
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.reset_new_password_label,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                ValueListenableBuilder<bool>(
                  valueListenable: _obscureNewPassword,
                  builder: (_, obscure, __) {
                    return MyFormTextField(
                      controller: passwordController,
                      hint: context.l10n.reset_new_password_hint,
                      obscureText: obscure,
                      suffixIcon: GestureDetector(
                        onTap: () => _obscureNewPassword.value = !obscure,
                        child: obscure
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
                        } else if (!value.passwordValidator()) {
                          // } else if (!value.lessSecurePasswordValidator()) {
                          return context.l10n.error_password_strength;
                        }
                        return null;
                      },
                    );
                  },
                ),

                SizedBox(height: 15.h),

                // CONFIRM PASSWORD
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.reset_confirm_password_label,
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
                      controller: confirmPasswordController,
                      hint: context.l10n.reset_confirm_password_hint,
                      obscureText: obscure,
                      suffixIcon: GestureDetector(
                        onTap: () => _obscureConfirmPassword.value = !obscure,
                        child: obscure
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
                    );
                  },
                ),

                SizedBox(height: 50.h),
                ValueListenableBuilder<bool>(
                  valueListenable: isFormFilled,
                  builder: (_, isFilled, __) {
                    return MyButton(
                      label: context.l10n.reset_continue,
                      onPressed: isFilled && !isLoading
                          ? () async {
                              if (!formKey.currentState!.validate()) return;
                              setState(() => isLoading = true);
                              await ResetPasswordService()
                                  .resetPassword(
                                context: context,
                                newPassword: passwordController.text.trim(),
                                email: widget.email,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
