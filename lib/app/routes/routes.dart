import 'package:flutter/material.dart';
import 'package:sage/app/routes/routes_name.dart';
import 'package:sage/model/redeem/redeem_model.dart';
import 'package:sage/view/ideas/add_idea.dart';
import 'package:sage/view/ideas/explore_ideas.dart';
import 'package:sage/view/ideas/idea_details.dart';
import 'package:sage/view/ideas/my_added_ideas.dart';
import 'package:sage/view/notifications/notifications.dart';
import 'package:sage/view/subscription/active_subscription.dart';
import 'package:sage/view/views.dart';

class Routes {
  static String initialRoute() => RoutesName.splash;

  static final Map<String, Widget Function(BuildContext)> _routes = {
    RoutesName.splash: (_) => const SplashScreen(),
    RoutesName.welcome: (_) => const WelcomeScreen(),
    RoutesName.login: (_) => const LoginScreen(),
    RoutesName.signup: (_) => const SignupScreen(),
    RoutesName.forgotPassword: (_) => const ForgotPassword(),
    RoutesName.home: (_) => const HomeScreen(),
    RoutesName.onBoarding: (_) => const OnBoardingScreen(),
    RoutesName.onBoardingFlow: (_) => const OnboardingFlowScreen(),
    RoutesName.editProfile: (_) => const EditProfileScreen(),
    RoutesName.changePassword: (_) => const ChangePasswordScreen(),
    RoutesName.updateInterests: (_) => const UpdateInterestsScreen(),
    RoutesName.updateGiftPreference: (_) => const UpdateGiftPreferenceScreen(),
    RoutesName.invitation: (_) => const InvitationScreen(),
    RoutesName.redeemPoint: (_) => const RedeemPointsScreen(),
    RoutesName.contactUs: (_) => const ContactUsScreen(),
    RoutesName.exploreIdeas: (_) => const ExploreIdeasScreen(),
    // RoutesName.savedIdeas: (_) => const SavedIdeasScreen(),
    RoutesName.myAddedIdeas: (_) => const MyAddedIdeasScreen(),
    RoutesName.activeSubscription: (_) => const ActiveSubscriptionScreen(),
    RoutesName.notifications: (_) => const NotificationsScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.subscription:
        final showSkip = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => SubscriptionScreen(showSkip: showSkip),
          settings: settings,
        );

      case RoutesName.analyzeData:
        return MaterialPageRoute(
          builder: (_) => const AnalyzeDataScreen(),
          settings: settings,
        );
      case RoutesName.navigation:
        final showPopup = settings.arguments as bool?;
        return MaterialPageRoute(
          builder: (_) => NavigationScreen(
            showPopup: showPopup ?? false,
          ),
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
        return MaterialPageRoute(
          builder: (_) => ResetPassword(email: email),
          settings: settings,
        );

      case RoutesName.addIdea:
        final Map<String, dynamic> emptyMap = {};
        final args = settings.arguments! as Map<String, dynamic>;
        final isEditIdea = args['isEditIdea'];
        final ideaDetails = args['ideaDetails'] ?? emptyMap;
        return MaterialPageRoute(
          builder: (_) => AddIdeaScreen(
            isEditIdea: isEditIdea as bool,
            ideaDetails: ideaDetails as Map<String, dynamic>,
          ),
          settings: settings,
        );

      case RoutesName.ideaDetails:
        final args = settings.arguments! as Map<String, dynamic>;
        final isAddedIdeaScreen = args['isAddedIdeaScreen'];
        final ideaDetails = args['ideaDetails'] as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => IdeaDetailsScreen(
            isAddedIdea: isAddedIdeaScreen as bool,
            ideaDetails: ideaDetails,
          ),
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
