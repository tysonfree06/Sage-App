import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/app/utils/extensions/flush_bar_extension.dart';
import 'package:sage/app/utils/service_error_handler.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/repository/user_repo.dart';
import 'package:sage/services/session_manager/session_controller.dart';

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

    //get subscription status
    final user = SessionController().user;
    final bool isPremium = user?.isPremium ?? false;

    Timer(
      const Duration(seconds: 3),
      () => isPremium
          ? Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.navigation,
              arguments: true, //Show Skip Button
              (route) => false,
            )
          : Navigator.pushNamedAndRemoveUntil(
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

  //Test
  final UserRepository _userRepository = UserRepository();
  Future<void> submitAllData(
      BuildContext context, Map<String, dynamic> payload) async {
    try {
      OnboardingService.goToDataAnalysis(
        context,
      );
      final response = await _userRepository.updateProfile(payload);
      debugPrint('RESPONSE IS: $response');
      if (context.mounted) {
        if (response['message'] != null) {
          context.flushBarSuccessMessage(
            message: response['message'].toString(),
          );
        }
        //FIXME: This is not a part of onboarding so exit the flow and push this screen to stack (it will also remove previous items in stack)

        // OnboardingService.goToDataAnalysis(
        //   context,
        // );
      }
    } catch (e) {
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
  //END: Test

  String formatLocation() {
    final session = SessionController();
    final user = session.user;
    //address
    String address = '';
    if (user?.location?.city != null && user?.location?.city != '') {
      address = '$address ${user?.location?.city},';
    }

    if (user?.location?.state != null && user?.location?.state != '') {
      address = '$address ${user?.location?.state},';
    }
    // _country = user?.location?.country;
    address = '$address ${user?.location?.country}';

    if (address.isNotEmpty && address.length > 1) {
      return address;
    }
    return '';
  }
}
