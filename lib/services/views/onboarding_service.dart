import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sage/app/data/exception/app_exceptions.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/repository/user_repo.dart';

class OnboardingService {
  final UserRepository _userRepository = UserRepository();

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
      final response = await _userRepository.updateProfile(payload);
      if (response['message'] != null) {
        if (context.mounted) {
          context.flushBarSuccessMessage(
            message: response['message'] as String,
          );
          Timer(
            const Duration(seconds: 1),
            () => Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.subscription,
              arguments: true, //Show Skip Button
              (route) => false,
            ),
          );
        }
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
