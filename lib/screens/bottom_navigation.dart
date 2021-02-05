import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'timeline.dart';
import 'profileScreens/profile.dart';
import '../states/current_user.dart';
import 'package:provider/provider.dart';

import 'activity.dart';
import 'chat.dart';
import 'discover.dart';
import 'home.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int pageIndex = 0;
  // PageController _pageController = PageController();
  PersistentTabController _controller;

  void _onTap(int value) {
    setState(() {
      pageIndex = value;
    });
    // _pageController.jumpToPage(value);
  }

  void onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final Map account = Provider.of<CurrentUser>(context).getStreamAccount;

    List<Widget> _buildScreens() {
      return [
         Home(
          account: account,
        ),
        Discover(),
        Chat(),
        Activity(),
        Profile(
          account: account,
        )
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.home_outlined),
          title: ("Home"),
          iconSize: 34,
          activeColor: Color(0xFFCC3752),
          inactiveColor: Color(0xFF103045),
          
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.web_asset_outlined),
          title: ("Discover"),
             iconSize: 34,
          activeColor: Color(0xFFCC3752),
           inactiveColor: Color(0xFF103045),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.chat_outlined),
          title: ("Chat"),
            iconSize: 34,
          activeColor: Color(0xFFCC3752),
           inactiveColor: Color(0xFF103045),
        ),
          PersistentBottomNavBarItem(
          icon: Icon(Icons.pie_chart_outlined),
          title: ("Activity"),
            iconSize: 34,
          activeColor: Color(0xFFCC3752),
            inactiveColor: Color(0xFF103045),
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
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
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      padding: NavBarPadding.only(top: 1),
      margin: EdgeInsets.all(9),
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
      bottomScreenMargin: 80,
      // navBarHeight: 40,
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