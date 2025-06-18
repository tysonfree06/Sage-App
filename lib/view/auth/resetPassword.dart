
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/view/auth/widget/auth_scaffold.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return AuthScaffold(
      appBar: AppBar(
        leading: BackButton(color: context.colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 22,
          horizontal: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
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
              MyFormTextField(
                hint: context.l10n.reset_new_password_hint,
                suffixIcon: Assets.icons.visibilityOn.svg(),
              ),
              SizedBox(height: 15.h),
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
              MyFormTextField(
                hint: context.l10n.reset_confirm_password_hint,
                suffixIcon: Assets.icons.visibilityOff.svg(),
              ),
              SizedBox(height: 10.h),
              SizedBox(height: 40.h),
              MyButton(
                label: context.l10n.reset_continue,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
