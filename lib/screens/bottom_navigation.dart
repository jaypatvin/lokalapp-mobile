import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'activity/activity.dart';
import 'chat/chat.dart';
import 'discover/discover.dart';
import 'home.dart';
import 'profile_screens/profile.dart';

class BottomNavigation extends StatefulWidget {
  static const id = 'bottomNav';
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  List<Widget> _buildScreens() {
    return [
      Home(),
      Discover(),
      Chat(),
      Activity(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/bottomNavIcons/Home.svg'),
        title: ("Home"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: Home.routeName,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/bottomNavIcons/Discover.svg'),
        title: ("Discover"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: Discover.routeName,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/bottomNavIcons/Chats.svg'),
        title: ("Chat"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: Chat.routeName,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/bottomNavIcons/Activity.svg'),
        title: ("Activity"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: Activity.routeName,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/bottomNavIcons/Profile.svg'),
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
        //padding: NavBarPadding.only(bottom: 3),
        // margin: EdgeInsets.all(2),
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
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
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}
