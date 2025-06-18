import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';

class WelcomeService {
  static void goToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.login,
      (route) => false,
    );
  }

  static void goToSignup(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.signup,
      (route) => false,
    );
  }
}
