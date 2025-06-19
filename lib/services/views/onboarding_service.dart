import 'package:flutter/cupertino.dart';
import 'package:sage/app/routes/routes_name.dart';

class OnboardingService {
  static void goToStep1(
    BuildContext context,
  ) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.step1,
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
}
