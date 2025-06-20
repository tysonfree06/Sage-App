import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sage/app/routes/routes_name.dart';

class OnboardingService {
  static void goToStep1(
    BuildContext context,
  ) {
    Navigator.pushNamed(
      context,
      RoutesName.step1,
    );
  }

  static void goToStep2(
      BuildContext context,
      ) {
    Navigator.pushNamed(
      context,
      RoutesName.step2,
    );
  }

  static void goToStep3(
      BuildContext context,
      ) {
    Navigator.pushNamed(
      context,
      RoutesName.step3,
    );
  }

  static void goToStep4(
      BuildContext context,
      ) {
    Navigator.pushNamed(
      context,
      RoutesName.step4,
    );
  }

  static void goToDataAnalysis(
      BuildContext context,
      ) {
    Navigator.pushNamed(
      context,
      RoutesName.analyzeData,
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

  static void goToHomeDelayed(
    BuildContext context,
  ) {
    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.home,
            (route) => false,
      ),
    );
  }
}
