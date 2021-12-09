import 'package:flutter/material.dart';
import 'package:lokalapp/services/bottom_nav_bar_hider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../routers/app_router.dart';
import '../utils/constants/assets.dart';
import 'activity/activity.dart';
import 'chat/chat.dart';
import 'discover/discover.dart';
import 'home/home.dart';
import 'profile/profile_screen.dart';

class BottomNavigation extends StatefulWidget {
  static const routeName = '/bottomNav';
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
      ProfileScreen(userId: context.read<Auth>().user!.id!),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        assetName: kBottomIconHome,
        title: ("Home"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: AppRouter.homeNavigatorKey,
          initialRoute: Home.routeName,
          onGenerateRoute: context
              .read<AppRouter>()
              .navigatorOf(AppRoute.home)
              .onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconDiscover,
        title: ("Discover"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: AppRouter.discoverNavigatorKey,
          initialRoute: Discover.routeName,
          onGenerateRoute: context
              .read<AppRouter>()
              .navigatorOf(AppRoute.discover)
              .onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconChat,
        title: ("Chat"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: AppRouter.chatNavigatorKey,
          initialRoute: Chat.routeName,
          onGenerateRoute: context
              .read<AppRouter>()
              .navigatorOf(AppRoute.chat)
              .onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconActivity,
        title: ("Activity"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: AppRouter.activityNavigatorKey,
          initialRoute: Activity.routeName,
          onGenerateRoute: context
              .read<AppRouter>()
              .navigatorOf(AppRoute.profile)
              .onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconProfile,
        title: ("Profile"),
        iconSize: 34,
        activeColorPrimary: Color(0xFFCC3752),
        inactiveColorPrimary: Color(0xFF103045),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: AppRouter.profileNavigatorKey,
          initialRoute: ProfileScreen.routeName,
          onGenerateRoute: context
              .read<AppRouter>()
              .navigatorOf(AppRoute.profile)
              .onGenerateRoute,
        ),
      ),
    ];
  }

  void _onItemSelected(int index) {
    final _pageController = context.read<PageController>();
    if (!_pageController.hasClients) return;
    if (_pageController.page == 0) return;
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: context.read<PersistentTabController>(),
        screens: _buildScreens(),
        items: _navBarsItems(),
        resizeToAvoidBottomInset: true,
        hideNavigationBar: context.watch<BottomNavBarHider>().isHidden,
        navBarStyle: NavBarStyle.svg,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
        ),
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
