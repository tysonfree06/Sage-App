import 'dart:async'; // Importing dart:async for asynchronous operations
import 'package:flutter/material.dart'; // Importing Flutter material library
import 'package:sage/app/routes/routes_name.dart';
// import 'package:sage/services/session_manager/session_controller.dart'; // Importing session controller for managing user session

/// A class containing services related to the splash screen.
class SplashServices {
  /// Checks authentication status and navigates accordingly.
  ///
  /// Takes a [BuildContext] as input and navigates to the home screen if the user is authenticated,
  /// otherwise navigates to the auth screen after a delay of 2 seconds.
  // Future<void> checkAuthentication(BuildContext context) async {
  //   await SessionController().getUserFromPreference().then((value) async {
  //     if (SessionController.isLogin ?? false) {
  //       Timer(
  //         const Duration(seconds: 1),
  //         () => Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           RoutesName.welcome,
  //           (route) => false,
  //         ),
  //       );
  //     } else {
  //       Timer(
  //         const Duration(seconds: 1),
  //         () => Navigator.pushNamedAndRemoveUntil(
  //           context,
  //           RoutesName.login,
  //           (route) => false,
  //         ),
  //       );
  //     }
  //   }).onError((error, stackTrace) {
  //     Timer(
  //       const Duration(seconds: 1),
  //       () => Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         RoutesName.login,
  //         (route) => false,
  //       ),
  //     );
  //   });
  // }

  Future<void> goToWelcome(BuildContext context) async {
    Timer(
      const Duration(seconds: 1),
      () => Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.welcome,
        (route) => false,
      ),
    );
  }
}
