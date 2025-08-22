import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sage/app/routes/routes_name.dart';

class OnboardingService {
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
    BuildContext context,
  ) async {
    // try {
    // final response = await _userRepository.updateProfile(payload);
    // if (response['message'] != null) {
    // if (context.mounted) {
    //   context.flushBarSuccessMessage(
    //     message: response['message'] as String,
    //   );
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.subscription,
        arguments: true, //Show Skip Button
        (route) => false,
      ),
    );

    // Timer(const Duration(seconds: 3), () async {

    //           final response = await _userAuth.getPartner(partnerCode);
    //     partner = UserModel.fromJson(
    //         response['partner'] as Map<String, dynamic>,
    //       );
    //       _sessionController.partner = UserModel.fromJson(
    //         response['partner'] as Map<String, dynamic>,
    //       );

    //   await Navigator.pushNamedAndRemoveUntil(
    //     context,
    //     RoutesName.subscription,
    //     arguments: true, //Show Skip Button
    //     (route) => false,
    //   );
    // });
    // }
    // }

    // debugPrint('[OnboardingService] ✅ OnBoarding Data Upload success');
    // } catch (e) {
    //   // Developer logging
    //   if (e is AppException) {
    //     debugPrint(
    //       '[OnboardingService] ❌ OnBoarding Data Upload failed: ${e.debugMessage}',
    //     );
    //   } else {
    //     debugPrint('[OnboardingService] ❌ Unexpected error: $e');
    //   }

    //   // Show user-friendly error
    //   if (context.mounted) {
    //     final errorMessage = (e is AppException)
    //         ? e.userMessage
    //         : 'Something went wrong. Please try again.';
    //     context.flushBarErrorMessage(message: errorMessage);
    //   }
    // }
  }
}
