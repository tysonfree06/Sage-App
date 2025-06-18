import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_pinput.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/l10n/l10n.dart';

class AccountVerificationSheet extends StatelessWidget {
  const AccountVerificationSheet({super.key, this.email});
  final String? email;

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColoredRichText(
            first: context.l10n.account,
            second: context.l10n.account_verification,
          ),
          SizedBox(height: 7.h),
          ColoredRichText(
            first: context.l10n.account_subtitle,
            second: email ?? '',
            firstColor: context.colors.textDarkGreen.withValues(alpha: .60),
            secondColor: context.colors.textDarkGreen,
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          ),
          SizedBox(height: 50.h),
          MyPinput(controller: pinController),
          SizedBox(height: 15.h),
          MyTextButton(
            label: context.l10n.account_resend_otp,
            onPressed: () {},
          ),
          SizedBox(height: 90.h),
          MyButton(
            label: context.l10n.account_verify,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
