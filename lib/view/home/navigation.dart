import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/provider/home/navigation_provider.dart';
import 'package:sage/view/home/home.dart';
import 'package:sage/view/home/ideas.dart';
import 'package:sage/view/home/points.dart';
import 'package:sage/view/home/settings.dart';
import 'package:sage/view/points/invite.dart';
import 'package:sage/view/points/radeem_offer_detail.dart';
import 'package:sage/view/points/redeem_points.dart';

List<Widget> pages = [
  const HomeScreen(),
  const IdeaScreen(),
  const RedeemPointsScreen(),
  const SettingScreen(),
];

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NavigationProvider>();

    return DarkStatusBar(
      child: Scaffold(
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
      ),
    );
  }
}
