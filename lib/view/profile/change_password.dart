import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/reset_password_service.dart';

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
          child: MyButton(
            label: context.l10n.change_update,
            onPressed: () {
              if (formKey.currentState!.validate()) {

              }
            },
          ),
        ),
      ),
    );
  }
}
