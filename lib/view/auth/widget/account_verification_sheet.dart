import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_pinput.dart';
import 'package:sage/app/components/my_text_button.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/services/views/signup_service.dart';

class AccountVerificationSheet extends StatefulWidget {
  const AccountVerificationSheet({
    required this.email,
    super.key,
  });
  final String email;

  @override
  State<AccountVerificationSheet> createState() =>
      _AccountVerificationSheetState();
}

class _AccountVerificationSheetState extends State<AccountVerificationSheet> {
  final pinController = TextEditingController();
  final signupService = SignupService();
  bool isResendAvailable = false;
  int remainingTime = 60;
  Timer? _timer;
  bool isLoading = false;
  bool isSendingOtp = false;

  void _startTimer() {
    setState(() {
      isResendAvailable = false;
      remainingTime = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime == 0) {
        setState(() => isResendAvailable = true);
        timer.cancel();
      } else {
        setState(() => remainingTime--);
      }
    });
  }

  Future<void> _sendOrResendOTP() async {
    setState(() => isSendingOtp = true);
    await signupService
        .sendOtp(
      context: context,
      email: widget.email,
    )
        .then((_) {
      _startTimer();
      if (mounted) {
        setState(() => isSendingOtp = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            second: widget.email,
            firstColor: context.colors.textDarkGreen.withValues(alpha: .60),
            secondColor: context.colors.textDarkGreen,
            firstFontSize: 15.sp,
            secondFontSize: 15.sp,
            firstFontWeight: FontWeight.w500,
            secondFontWeight: FontWeight.w500,
          ),
          SizedBox(height: 50.h),
          MyPinput(
            controller: pinController,
            enabled: !isLoading,
            onChanged: (value) => setState(() {}),
          ),
          SizedBox(height: 15.h),
          MyTextButton(
            label: isResendAvailable
                ? context.l10n.account_resend_otp
                : '${context.l10n.account_resend_otp} in $remainingTime s',
            onPressed: isResendAvailable && !isLoading && !isSendingOtp
                ? _sendOrResendOTP
                : null,
          ),
          SizedBox(height: 90.h),
          MyButton(
            label: context.l10n.account_verify,
            isLoading: isLoading,
            onPressed: pinController.text.length < 4
                ? null
                : () async {
                    setState(() => isLoading = true);
                    await signupService
                        .verifyOtp(
                      context: context,
                      email: widget.email,
                      otp: pinController.text,
                    )
                        .then((_) {
                      if (mounted) {
                        setState(() => isLoading = false);
                      }
                    });
                  },
          ),
        ],
      ),
    );
  }
}
