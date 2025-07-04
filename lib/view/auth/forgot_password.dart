import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_form_text_field.dart';
import 'package:sage/app/components/my_pinput.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/validations_exception.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/forgot_password_service.dart';
import 'package:sage/view/auth/widget/auth_scaffold.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final pinController = TextEditingController();
  bool isLoading = false;
  bool isSendingOtp = false;
  bool hasSentOtp = false;
  int remainingTime = 0;
  Timer? _timer;

  void _startTimer() {
    setState(() {
      remainingTime = 60;
      hasSentOtp = true; // Moved here to ensure proper state after sending
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        timer.cancel();
      } else {
        setState(() => remainingTime--);
      }
    });
  }

  Future<void> _sendOtp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isSendingOtp = true);

    final isSent = await ForgotPasswordService().sendOtp(
      context: context,
      email: emailController.text.trim(),
    );
    if (isSent) {
      _startTimer();
    }
    if (mounted) {
      setState(() => isSendingOtp = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appBar: AppBar(
        leading: BackButton(
          color: context.colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  controller: emailController,
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
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyTextButton(
                    // Fixed button text logic
                    label: hasSentOtp
                        ? (remainingTime > 0
                            ? '${context.l10n.forgot_resend_otp} in $remainingTime s'
                            : context.l10n.forgot_resend_otp)
                        : context.l10n.forgot_send_otp,
                    onPressed:
                        (isSendingOtp || remainingTime > 0) ? null : _sendOtp,
                  ),
                ),
                SizedBox(height: 40.h),
                MyPinput(
                  controller: pinController,
                  enabled: !isLoading,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: 90.h),
                MyButton(
                  label: context.l10n.forgot_verify,
                  isLoading: isLoading,
                  onPressed: pinController.text.length < 4 ||
                          emailController.text.trim().isEmpty
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setState(() => isLoading = true);
                          await ForgotPasswordService().verifyOtp(
                            context: context,
                            email: emailController.text.trim(),
                            otp: pinController.text,
                          );
                          if (mounted) {
                            setState(() => isLoading = false);
                          }
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
