import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/repository/auth/auth_repo.dart';

class OnboardingService {
  final AuthRepository _authRepository = AuthRepository();

  // static void goToStep1(
  //   BuildContext context,
  // ) {
  //   Navigator.pushNamed(
  //     context,
  //     RoutesName.step1,
  //   );
  // }

  // static void goToStep2(
  //   BuildContext context,
  // ) {
  //   Navigator.pushNamed(
  //     context,
  //     RoutesName.step2,
  //   );
  // }

  // static void goToStep3(
  //   BuildContext context,
  // ) {
  //   Navigator.pushNamed(
  //     context,
  //     RoutesName.step3,
  //   );
  // }

  // static void goToStep4(
  //   BuildContext context,
  // ) {
  //   Navigator.pushNamed(
  //     context,
  //     RoutesName.step4,
  //   );
  // }

  static Future<void> goToOnBoarding(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      RoutesName.onBoardingFlow,
    );
  }

  static void goToDataAnalysis(
    BuildContext context, {
    Map<String, dynamic>? payload,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.analyzeData,
      arguments: payload,
      (route) => false,
    );
  }

  static void goToHome(
    BuildContext context,
  ) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.home,
      (route) => false,
    );
  }

  Future<void> goToSubscriptionDelayed(
    BuildContext context, {
    required Map<String, dynamic> payload,
  }) async {
    try {
      await _authRepository.login(payload);

      if (context.mounted) {
        context.flushBarSuccessMessage(message: 'Data Uploaded');
        Timer(
          const Duration(seconds: 1),
          () => Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.subscription,
            arguments: true,
            (route) => false,
          ),
        );
      }

      debugPrint('[OnboardingService] ✅ OnBoarding Data Upload success');
    } catch (e) {
      // Developer logging
      if (e is AppException) {
        debugPrint(
          '[OnboardingService] ❌ OnBoarding Data Upload failed: ${e.debugMessage}',
        );
      } else {
        debugPrint('[OnboardingService] ❌ Unexpected error: $e');
      }

      // Show user-friendly error
      if (context.mounted) {
        final errorMessage = (e is AppException)
            ? e.userMessage
            : 'Something went wrong. Please try again.';
        context.flushBarErrorMessage(message: errorMessage);
      }
    }
  }
}
