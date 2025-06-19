import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/view/onboarding/step2.dart';
import 'package:sage/view/onboarding/step3.dart';
import 'package:sage/view/onboarding/step4.dart';
import 'package:sage/view/views.dart';

class Routes {
  static String initialRoute() => RoutesName.step2;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        );

      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        );

      case RoutesName.welcome:
        return MaterialPageRoute(
          builder: (BuildContext context) => const WelcomeScreen(),
        );

      case RoutesName.forgotPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ForgotPassword(),
        );
      case RoutesName.onBoarding:
        return MaterialPageRoute(
          builder: (BuildContext context) => const OnBoardingScreen(),
        );
      case RoutesName.step1:
        return MaterialPageRoute(
          builder: (BuildContext context) => const Step1Screen(),
        );
      case RoutesName.step2:
        return MaterialPageRoute(
          builder: (BuildContext context) => const Step2Screen(),
        );
      case RoutesName.step3:
        return MaterialPageRoute(
          builder: (BuildContext context) => const Step3Screen(),
        );

      case RoutesName.step4:
        return MaterialPageRoute(
          builder: (BuildContext context) => const Step4Screen(),
        );

      case RoutesName.resetPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ResetPassword(),
        );

      case RoutesName.analyzeData:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AnalyzeDataScreen(),
        );

      case RoutesName.signup:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignupScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: Text('No route defined'),
              ),
            );
          },
        );
    }
  }
}
