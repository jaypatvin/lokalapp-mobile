import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../routers/routers.dart';
import '../utils/constants/assets.dart';
import 'activity/activity.dart';
import 'chat/chat.dart';
import 'discover/discover.dart';
import 'home/home.dart';
import 'profile/profile_screen.dart';

class BottomNavigation extends StatefulWidget {
  static const routeName = 'bottomNav';
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  void initState() {
    super.initState();
    context.read<PersistentTabController>().addListener(() {});
  }

  List<Widget> _buildScreens() {
    return [
      Home(),
      Discover(),
      Chat(),
      Activity(),
      ProfileScreen(userId: context.read<Auth>().user!.id!),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        assetName: kBottomIconHome,
        title: ("Home"),
        contentPadding: 0.0,
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        // routeAndNavigatorSettings: RouteAndNavigatorSettings(
        //   initialRoute: Home.routeName,
        // ),
        routeAndNavigatorSettings: context.read<AppRouter>().homeNavigator,
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconDiscover,
        title: ("Discover"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: Discover.routeName,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconChat,
        title: ("Chat"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: Chat.routeName,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconActivity,
        title: ("Activity"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: Activity.routeName,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconProfile,
        title: ("Profile"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: ProfileScreen.routeName,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: context.read<PersistentTabController>(),
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.svg,
      ),
    );
  }
}
