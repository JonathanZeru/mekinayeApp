import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mekinaye/screen/chat/chat_screen.dart';
import 'package:mekinaye/screen/rules/rules_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:mekinaye/generated/assets.dart';
import 'package:mekinaye/screen/profile/profile_screen.dart';
import 'package:mekinaye/util/app_routes.dart';

import 'home/home_screen.dart';
import 'message/message_screen.dart';


class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({Key? key}) : super(key: key);

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return PersistentTabView(

      context,
      controller: _controller,
      screens: buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: theme.colorScheme.surface,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style8,
      navBarHeight: 60
    );
  }

  List<Widget> buildScreens() {
    return [
      const HomeScreen(), // Index 0: Home Page
      ChatListScreen(), // Index 1: Chat  Page
      const RulesScreen() // Index 2: Rules  Page
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    ThemeData theme = Theme.of(context);
    Color activeColor = theme.colorScheme.primary;
    Color inactiveColor = theme.colorScheme.onSurface.withOpacity(0.6);

    return [
      _buildNavBarItem(
        icon: CupertinoIcons.house_fill,
        route: AppRoutes.home,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        tooltip: 'Home',
      ),
      _buildNavBarItem(
        icon: CupertinoIcons.chat_bubble_2_fill,
        route: AppRoutes.chat,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        tooltip: 'Chat',
      ),
      _buildNavBarItem(
        icon: CupertinoIcons.square_list_fill,
        route: AppRoutes.profile,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        tooltip: 'Rules and Regulations'
      )
    ];
  }

  PersistentBottomNavBarItem _buildNavBarItem({
    required IconData icon,
    required String route,
    required Color activeColor,
    required Color inactiveColor,
    required String tooltip,
  }) {
    return PersistentBottomNavBarItem(
      icon: GestureDetector(
        onTap: () {
          if (route == AppRoutes.profile) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          } else {
            _controller.jumpToTab(
              _navBarsItems().indexWhere(
                (item) => item.routeAndNavigatorSettings.initialRoute == route,
              ),
            );
          }
          _showTooltip(context, tooltip);
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final isActive = _controller.index ==
                _navBarsItems().indexWhere(
                  (item) =>
                      item.routeAndNavigatorSettings.initialRoute == route,
                );
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isActive ? activeColor : inactiveColor,
                  size: 30.sp,
                )
              ],
            );
          },
        ),
      ),
      inactiveIcon: Icon(
        icon,
        color: inactiveColor,
        size: 30.sp,
      ),
      activeColorPrimary: activeColor,
      inactiveColorPrimary: inactiveColor,
      textStyle: const TextStyle(fontSize: 10),
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: route,
      ),
    );
  }

  void _showTooltip(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
