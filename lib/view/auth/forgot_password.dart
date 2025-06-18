import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_bottom_sheet.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/components/my_pinput.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/view/auth/widget/account_verification_sheet.dart';
import 'package:sage/view/auth/widget/auth_scaffold.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final pinController = TextEditingController();
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
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColoredRichText(
                first: context.l10n.forgot,
                second: context.l10n.forgot_password,
              ),
              SizedBox(height: 7.h),
              Text(
                context.l10n.forgot_subtitle,
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
                  context.l10n.forgot_email_label,
                  style: context.typography.title.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              MyFormTextField(
                hint: context.l10n.forgot_email_hint,
                suffixIcon: Assets.icons.email.svg(),
              ),
              SizedBox(height: 10.h),
              Align(
                alignment: Alignment.centerRight,
                child: MyTextButton(
                  label: context.l10n.forgot_send_otp,
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 40.h),
              MyPinput(
                controller: pinController,
              ),
              SizedBox(height: 90.h),
              MyButton(
                label: context.l10n.forgot_verify,
                onPressed: () {
                  //TODO: When Lets Get Start is Done copy following bottom sheet there
                  MyBottomSheet.show<void>(
                    context,
                    child: const AccountVerificationSheet(
                      email: 'alex123@gmail.com',
                    ),
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
