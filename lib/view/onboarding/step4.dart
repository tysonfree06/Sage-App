import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sage/app/components/colored_rich_text.dart';
import 'package:sage/app/components/my_button.dart';
import 'package:sage/app/components/my_pinput.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/app/utils/service_error_handler.dart';
import 'package:sage/l10n/l10n.dart';
import 'package:sage/repository/user_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/onboarding_service.dart';

class Step4Screen extends StatefulWidget {
  const Step4Screen({
    required this.payload,
    // required this.onNext,
    this.initialPartnerId,
    super.key,
  });

  final String? initialPartnerId;
  final Map<String, dynamic> payload;
  // final void Function(String? selectedPartnerId) onNext;

  @override
  State<Step4Screen> createState() => _Step4ScreenState();
}

class _Step4ScreenState extends State<Step4Screen> {
  late TextEditingController _pinController;
  final UserRepository _userRepository = UserRepository();
  final sessionController = SessionController();

  // whether we have any non-empty PIN
  bool get _canConnect =>
      _pinController.text.trim().isNotEmpty && _pinController.text.length == 5;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController(
      text: widget.initialPartnerId ?? '',
    )..addListener(() {
        setState(() {
          // rebuild to update button enabled state
        });
      });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submitAllData(Map<String, dynamic> payload) async {
    try {
      final response = await _userRepository.updateProfile(payload);
      debugPrint('RESPONSE IS: $response');
      if (mounted) {
        if (response['message'] != null) {
          context.flushBarSuccessMessage(
            message: response['message'].toString(),
          );
        }
        //FIXME: This is not a part of onboarding so exit the flow and push this screen to stack (it will also remove previous items in stack)

        OnboardingService.goToDataAnalysis(
          context,
        );
      }
    } catch (e, st) {
      if (context.mounted) {
        ErrorHandler.handle(context, e, serviceName: 'OnboardingService');
      }
      // Developer logging
      //   if (e is AppException) {
      //     if (mounted) {
      //       debugPrint(
      //         // ignore: lines_longer_than_80_chars
      //         '[OnboardingService] ❌ OnBoarding Data Upload failed: ${e.debugMessage}',
      //       );
      //       debugPrint('USER MESSAGE IS: ${e.userMessage}');
      //       context.flushBarErrorMessage(
      //         message: 'Invalid Partner Code or Partner already linked',
      //       );
      //     }
      //   } else {
      //     if (mounted) {
      //       context.flushBarErrorMessage(
      //         message: 'Something went wrong...',
      //       );
      //     }
      //     debugPrint('[OnboardingService] ❌ Unexpected error: $e');
      //   }
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.typography.subtitle.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 15.sp,
      color: context.colors.textDarkGreen.withOpacity(0.6),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.medium),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              Center(
                child: ColoredRichText(
                  first: context.l10n.onboarding_step4,
                  second: context.l10n.onboarding_steps_4,
                  firstFontSize: 15.sp,
                  secondFontSize: 15.sp,
                  firstFontWeight: FontWeight.w600,
                  secondFontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  context.l10n.onboarding_step4_add_partner,
                  style: context.typography.title.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 24.sp,
                    color: context.colors.textDarkGreen,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                context.l10n.onboarding_step4_add_partner_with_code,
                style: labelStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 35.h),

              // PIN input
              MyPinput(
                controller: _pinController,
                length: 5,
              ),

              const Spacer(),

              // CONNECT—only enabled when PIN is non-empty
              MyButton(
                label: context.l10n.onboarding_step4_connect,
                onPressed: _canConnect
                    ? () {
                        // widget.onNext(_pinController.text.trim());
                        widget.payload['partnerCode'] =
                            _pinController.text.trim();
                        _submitAllData(widget.payload);
                      }
                    : null,
              ),
              SizedBox(height: 12.h),

              // WILL ADD LATER—always enabled, passes null
              MyButton(
                label: context.l10n.onboarding_step4_will_add_later,
                isDark: true,
                onPressed: () {
                  widget.payload.remove('partnerCode');
                  _submitAllData(widget.payload);
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
