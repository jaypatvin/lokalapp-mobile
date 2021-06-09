import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  int pageIndex = 0;

  PersistentTabController _controller;

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      return [
        Home(),
        Discover(),
        Chat(),
        Activity(),
        ProfileShopMain(),
      ];
    }

    String assetHome = 'assets/bottomNavIcons/Home.svg';
    Widget svgHome = new SvgPicture.asset(
      assetHome,
    );
    String assetDiscover = 'assets/bottomNavIcons/Discover.svg';
    Widget svgDiscover = new SvgPicture.asset(
      assetDiscover,
    );
    String assetChat = 'assets/bottomNavIcons/Chats.svg';
    Widget svgChat = new SvgPicture.asset(
      assetChat,
    );
    String assetActivity = 'assets/bottomNavIcons/Activity.svg';
    Widget svgActivity = new SvgPicture.asset(
      assetActivity,
    );
    String assetProfile = 'assets/bottomNavIcons/Profile.svg';
    Widget svgProfile = new SvgPicture.asset(
      assetProfile,
      // color: Color(0xFFCC3752),
    );
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: svgHome,
          title: ("Home"),
          iconSize: 34,
          activeColor: Color(0xFFCC3752),
          inactiveColor: Color(0xFF103045),
        ),
        PersistentBottomNavBarItem(
          icon: svgDiscover,
          title: ("Discover"),
          iconSize: 34,
          activeColor: Color(0xFFCC3752),
          inactiveColor: Color(0xFF103045),
        ),
        PersistentBottomNavBarItem(
          icon: svgChat,
          title: ("Chat"),
          iconSize: 34,
          activeColor: Color(0xFFCC3752),
          inactiveColor: Color(0xFF103045),
        ),
        PersistentBottomNavBarItem(
          icon: svgActivity,
          title: ("Activity"),
          iconSize: 34,
          activeColor: Color(0xFFCC3752),
          inactiveColor: Color(0xFF103045),
        ),
        PersistentBottomNavBarItem(
          icon: svgProfile,
          title: ("Profile"),
          iconSize: 34,
          activeColor: Color(0xFFCC3752),
          inactiveColor: Color(0xFF103045),
        ),
      ];
    }

    return Scaffold(
        body: PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      // navBarHeight: 60.0,

      confineInSafeArea: true,
      backgroundColor: Colors.white,
      padding: NavBarPadding.only(bottom: 3),
      margin: EdgeInsets.all(2),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,

      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property.
    ));
  }
}
