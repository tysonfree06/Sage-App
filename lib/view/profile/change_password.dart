import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/app/utils/extensions/validations_exception.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/settings_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();

  // ValueNotifiers to toggle visibility
  final ValueNotifier<bool> _obscureOldPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureNewPassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  final ValueNotifier<bool> isFormFilled = ValueNotifier(false);

  bool isLoading = false;

  void _updateButtonState() {
    final isFilled = oldPasswordController.text.trim().isNotEmpty &&
        newPasswordController.text.trim().isNotEmpty &&
        confirmNewPasswordController.text.trim().isNotEmpty;
    isFormFilled.value = isFilled;
  }

  @override
  void initState() {
    super.initState();
    oldPasswordController.addListener(_updateButtonState);
    newPasswordController.addListener(_updateButtonState);
    confirmNewPasswordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _obscureOldPassword.dispose();
    _obscureNewPassword.dispose();
    _obscureConfirmPassword.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: context.colors.mainGreenLight),
        title: Text(
          context.l10n.change_password,
          style: context.typography.title.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 20.sp,
            color: context.colors.textDarkGreen,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.change_old_password_label,
                    style: context.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                ValueListenableBuilder<bool>(
                  valueListenable: _obscureOldPassword,
                  builder: (_, obscure, __) {
                    return MyFormTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.error_password_required;
                          // } else if (!value.lessSecurePasswordValidator()) {
                        } else if (!value.passwordValidator()) {
                          return context.l10n.error_password_strength;
                        }
                        return null;
                      },
                      controller: oldPasswordController,
                      hint: context.l10n.change_old_password_hint,
                      obscureText: obscure,
                      suffixIcon: GestureDetector(
                        onTap: () => _obscureOldPassword.value = !obscure,
                        child: obscure
                            ? Assets.icons.visibilityOff.svg()
                            : Assets.icons.visibilityOn.svg(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 15.h),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.error_password_required;
                        } else if (!value.passwordValidator()) {
                          // } else if (!value.lessSecurePasswordValidator()) {
                          return context.l10n.error_password_strength;
                        }
                        return null;
                      },
                      controller: newPasswordController,
                      hint: context.l10n.reset_new_password_hint,
                      obscureText: obscure,
                      suffixIcon: GestureDetector(
                        onTap: () => _obscureNewPassword.value = !obscure,
                        child: obscure
                            ? Assets.icons.visibilityOff.svg()
                            : Assets.icons.visibilityOn.svg(),
                      ),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.l10n.error_password_required;
                        } else if (!value.passwordValidator()) {
                          // } else if (!value.lessSecurePasswordValidator()) {
                          return context.l10n.error_password_strength;
                        }
                        return null;
                      },
                      controller: confirmNewPasswordController,
                      hint: context.l10n.reset_confirm_password_hint,
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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 30.h,
          ),
          child: ValueListenableBuilder<bool>(
            valueListenable: isFormFilled,
            builder: (_, isFilled, __) {
              return SizedBox(
                height: 50.h,
                child: MyButton(
                  isLoading: isLoading,
                  label: context.l10n.reset_continue,
                  onPressed: isFilled && !isLoading
                      ? () async {
                          if (newPasswordController.text !=
                              confirmNewPasswordController.text) {
                            context.flushBarErrorMessage(
                              message:
                                  context.l10n.error_confirm_password_mismatch,
                            );

                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });
                          if (formKey.currentState!.validate()) {
                            await SettingService().changePassword(
                              context: context,
                              oldPassword: oldPasswordController.text.trim(),
                              newPassword: newPasswordController.text.trim(),
                              confirmPassword:
                                  confirmNewPasswordController.text.trim(),
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
