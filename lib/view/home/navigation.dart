import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/model/user/user_model.dart';
import 'package:sage/provider/home/navigation_provider.dart';
import 'package:sage/services/session_manager/session_controller.dart';
import 'package:sage/services/views/signup_service.dart';
import 'package:sage/services/views/splash_services.dart';
import 'package:sage/view/home/home.dart';
import 'package:sage/view/home/ideas.dart';
import 'package:sage/view/home/settings.dart';
import 'package:sage/view/redeem_points/redeem_points.dart';

List<Widget> pages = [
  const HomeScreen(),
  const IdeaScreen(),
  const RedeemPointsScreen(),
  const SettingScreen(),
];

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({this.showPopup = false, super.key});
  final bool showPopup;
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  void loadProfile() {
    // final user = sessionController.user;
    // if (user == null)
    SplashServices().fetchProfile(context).then((_) {
      // check if user has completed his profile, otherwise, navigate to onboarding
      final UserModel user = SessionController().user!;
      if (user.email.isNotEmpty) {
        //original
        // if (user.loveLanguage == null || user.loveLanguage == '') {
        //   if (mounted) {
        //     SignupService.goToOnBoarding(context);
        //   }
        // }

        //new
        // bool isNullOrEmpty(String? value) =>
        //     value == null || value.trim().isEmpty;

        // final allEmptyOrNull = isNullOrEmpty(user.loveLanguage) &&
        //     isNullOrEmpty(user.apologyLanguage) &&
        //     isNullOrEmpty(user.communicationStyle) &&
        //     isNullOrEmpty(user.relationshipStatus) &&
        //     user.anniversaryDate == null &&
        //     user.dateOfBirth == null &&
        //     user.interests == null &&
        //     user.giftPreferences == null &&
        //     user.location == null;
        // if (allEmptyOrNull) {
        //   //If all fields are empty or null (User has bypassed the onboarding),
        //   //navigate to Onboarding
        //   if (mounted) {
        //     SignupService.goToOnBoarding(context);
        //   }
        // }
        //

        //latest
        final fields = [
          user.loveLanguage,
          user.apologyLanguage,
          user.communicationStyle,
          user.relationshipStatus,
          user.anniversaryDate,
          user.dateOfBirth,
          user.interests,
          user.giftPreferences,
          user.location,
        ];

        // Convert to bools for easier checking
        final bool allEmptyOrNull =
            fields.every((f) => f == null || (f is String && f.trim().isEmpty));
        final bool anyEmptyOrNull =
            fields.any((f) => f == null || (f is String && f.trim().isEmpty));

        if (allEmptyOrNull) {
          if (mounted) {
            SignupService.goToOnBoarding(context);
          }
        } else if (anyEmptyOrNull) {
          //isProfileIncomplete = true;
          SessionController().setProfileCompletionStatus(status: true);
          debugPrint('Profile Incomplete');
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
    // showInfoDialog();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NavigationProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.white,
        toolbarHeight: 0,
      ),
      body: pages[provider.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: provider.currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: provider.setIndex,
        backgroundColor: context.colors.chipBg,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Assets.icons.homeUnselected.svg(),
            activeIcon: Assets.icons.homeSelected.svg(),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.ideaUnselected.svg(),
            activeIcon: Assets.icons.ideaSelected.svg(),
            label: 'Ideas',
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.starUnselected.svg(),
            activeIcon: Assets.icons.starSelected.svg(),
            label: 'Points',
          ),
          BottomNavigationBarItem(
            icon: Assets.icons.profileUnselected.svg(),
            activeIcon: Assets.icons.profileSelected.svg(),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
