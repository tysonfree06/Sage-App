import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/provider/home/navigation_provider.dart';
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
      int profileCompetionStatus =
          SplashServices().checkProfileCompletionStatus();

      if (profileCompetionStatus == 0) {
        if (mounted) {
          SignupService.goToOnBoarding(context);
        }
      }
      // if (anyQuestionEmptyOrNull) {
      //     return 0;
      // if (mounted) {
      //   SignupService.goToOnBoarding(context);
      // }
      //   } else if (anyFieldEmptyOrNull) {
      //     return 1;
      //     //isProfileIncomplete = true;
      //     SessionController().setProfileCompletionStatus(status: true);
      //     debugPrint('Profile Incomplete');
      //   } else {
      //     return 2;
      //     SessionController().setProfileCompletionStatus(status: false);
      //     debugPrint('Profile Complete');
      //   }
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
