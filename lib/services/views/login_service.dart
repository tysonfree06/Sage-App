import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';

class LoginService {
  static void goToForgotPassword(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.forgotPassword,
    );
  }

  static void goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.home,
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
