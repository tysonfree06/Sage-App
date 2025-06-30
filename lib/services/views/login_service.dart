import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/provider/home/navigation_provider.dart';

class LoginService {
  static void goToForgotPassword(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.forgotPassword,
    );
  }

  static void goToHome(BuildContext context) {
    context.read<NavigationProvider>().setIndex(0);
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.navigation,
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
