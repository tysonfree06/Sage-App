import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/view/profile/change_password.dart';
import 'package:sage/view/profile/edit_profile.dart';
import 'package:sage/view/profile/update_gift_preference.dart';
import 'package:sage/view/profile/update_interests.dart';
import 'package:sage/view/views.dart';

class Routes {
  static String initialRoute() => RoutesName.updateGiftPreference;

  // Map of all route names to their corresponding widget builders
  static final Map<String, Widget Function(BuildContext)> _routes = {
    RoutesName.splash: (_) => const SplashScreen(),
    RoutesName.welcome: (_) => const WelcomeScreen(),
    RoutesName.login: (_) => const LoginScreen(),
    RoutesName.signup: (_) => const SignupScreen(),
    RoutesName.forgotPassword: (_) => const ForgotPassword(),
    RoutesName.resetPassword: (_) => const ResetPassword(),
    RoutesName.home: (_) => const HomeScreen(),
    RoutesName.onBoarding: (_) => const OnBoardingScreen(),
    RoutesName.step1: (_) => const Step1Screen(),
    RoutesName.step2: (_) => const Step2Screen(),
    RoutesName.step3: (_) => const Step3Screen(),
    RoutesName.step4: (_) => const Step4Screen(),
    RoutesName.analyzeData: (_) => const AnalyzeDataScreen(),
    RoutesName.editProfile: (_) => const EditProfileScreen(),
    RoutesName.changePassword: (_) => const ChangePasswordScreen(),
    RoutesName.updateInterests: (_) => const UpdateInterestsScreen(),
    RoutesName.updateGiftPreference: (_) => const UpdateGiftPreferenceScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = _routes[settings.name];
    if (builder != null) {
      /// If arguments are needed for a screen, handle them here
      switch (settings.name) {
        /// Example with arguments (uncomment and update when needed)
        ///
        // case RoutesName.login:
        //   final email = settings.arguments as String?;
        //   return MaterialPageRoute(
        //     builder: (_) => LoginScreen(prefilledEmail: email),
        //   );

        default:
          return MaterialPageRoute(
            builder: builder,
            settings: settings,
          );
      }
    }

    // Fallback screen for undefined routes
    return MaterialPageRoute(
      builder: (_) => const UnknownRouteScreen(),
    );
  }
}

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: const Center(
        child: Text('No route defined for this screen.'),
      ),
    );
  }
}
