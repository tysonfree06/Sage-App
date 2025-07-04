import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/model/redeem/radeem_model.dart';
import 'package:sage/view/views.dart';

class Routes {
  static String initialRoute() => RoutesName.splash;

  // Map of all route names to their corresponding widgets builders
  static final Map<String, Widget Function(BuildContext)> _routes = {
    RoutesName.splash: (_) => const SplashScreen(),
    RoutesName.welcome: (_) => const WelcomeScreen(),
    RoutesName.login: (_) => const LoginScreen(),
    RoutesName.signup: (_) => const SignupScreen(),
    RoutesName.forgotPassword: (_) => const ForgotPassword(),
    RoutesName.home: (_) => const HomeScreen(),
    RoutesName.onBoarding: (_) => const OnBoardingScreen(),
    RoutesName.step1: (_) => const Step1Screen(),
    RoutesName.step2: (_) => const Step2Screen(),
    RoutesName.step3: (_) => const Step3Screen(),
    RoutesName.step4: (_) => const Step4Screen(),
    RoutesName.analyzeData: (_) => const AnalyzeDataScreen(),
    RoutesName.navigation: (_) => const NavigationScreen(),
    RoutesName.editProfile: (_) => const EditProfileScreen(),
    RoutesName.changePassword: (_) => const ChangePasswordScreen(),
    RoutesName.updateInterests: (_) => const UpdateInterestsScreen(),
    RoutesName.updateGiftPreference: (_) => const UpdateGiftPreferenceScreen(),
    RoutesName.invitation: (_) => const InvitationScreen(),
    RoutesName.redeemPoint: (_) => const RedeemPointsScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.subscription:
        final showSkip = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => SubscriptionScreen(showSkip: showSkip),
          settings: settings,
        );

      case RoutesName.offerDetail:
        final offer = settings.arguments! as RedeemOfferDetails;
        return MaterialPageRoute(
          builder: (_) => OfferDetailScreen(offer: offer),
          settings: settings,
        );

      case RoutesName.resetPassword:
        final args = settings.arguments! as Map<String, String>;
        final email = args['email']!;
        final otp = args['otp']!;
        return MaterialPageRoute(
          builder: (_) => ResetPassword(email: email, otp: otp),
          settings: settings,
        );

      default:
        final builder = _routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder, settings: settings);
        }
        return MaterialPageRoute(builder: (_) => const UnknownRouteScreen());
    }
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
