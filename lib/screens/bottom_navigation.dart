import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../app/app_router.dart';
import '../services/bottom_nav_bar_hider.dart';
import '../state/state_handler.dart';
import '../utils/constants/assets.dart';
import '../widgets/overlays/bottom_navigation_onboarding.dart';
import 'activity/activity.dart';
import 'chat/chat.dart';
import 'discover/discover.dart';
import 'home/home.dart';
import 'profile/profile_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _appRouter = locator<AppRouter>();

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        assetName: kBottomIconHome,
        title: 'Home',
        iconSize: 34,
        activeColorPrimary: const Color(0xFFCC3752),
        inactiveColorPrimary: const Color(0xFF103045),
        textStyle: const TextStyle(
          fontSize: 9,
          fontFamily: 'Goldplay',
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: _appRouter.keyOf(AppRoute.home),
          initialRoute: DashboardRoutes.home,
          onGenerateRoute: HomeRouter().onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconDiscover,
        title: 'Discover',
        iconSize: 34,
        activeColorPrimary: const Color(0xFFCC3752),
        inactiveColorPrimary: const Color(0xFF103045),
        textStyle: const TextStyle(
          fontSize: 9,
          fontFamily: 'Goldplay',
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: _appRouter.keyOf(AppRoute.discover),
          initialRoute: DashboardRoutes.discover,
          onGenerateRoute: DiscoverRouter().onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconChat,
        title: 'Chat',
        iconSize: 34,
        activeColorPrimary: const Color(0xFFCC3752),
        inactiveColorPrimary: const Color(0xFF103045),
        textStyle: const TextStyle(
          fontSize: 9,
          fontFamily: 'Goldplay',
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: _appRouter.keyOf(AppRoute.chat),
          initialRoute: DashboardRoutes.chat,
          onGenerateRoute: ChatRouter().onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconActivity,
        title: 'Activity',
        iconSize: 34,
        activeColorPrimary: const Color(0xFFCC3752),
        inactiveColorPrimary: const Color(0xFF103045),
        textStyle: const TextStyle(
          fontSize: 9,
          fontFamily: 'Goldplay',
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: _appRouter.keyOf(AppRoute.activity),
          initialRoute: DashboardRoutes.activity,
          onGenerateRoute: ActivityRouter().onGenerateRoute,
        ),
      ),
      PersistentBottomNavBarItem(
        assetName: kBottomIconProfile,
        title: 'Profile',
        iconSize: 34,
        activeColorPrimary: const Color(0xFFCC3752),
        inactiveColorPrimary: const Color(0xFF103045),
        textStyle: const TextStyle(
          fontSize: 9,
          fontFamily: 'Goldplay',
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          navigatorKey: _appRouter.keyOf(AppRoute.profile),
          initialRoute: DashboardRoutes.profileScreen,
          onGenerateRoute: ProfileScreenRouter().onGenerateRoute,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StateHandler(
      child: Scaffold(
        body: BottomNavigationOnboarding(
          child: PersistentTabView(
            context,
            controller: _appRouter.tabController,
            items: _navBarsItems(),
            resizeToAvoidBottomInset: true,
            hideNavigationBar: context.watch<BottomNavBarHider>().isHidden,
            navBarStyle: NavBarStyle.svg,
            itemAnimationProperties: const ItemAnimationProperties(
              duration: Duration(milliseconds: 200),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: const ScreenTransitionAnimation(
              animateTabTransition: true,
            ),
            screens: const [
              Home(),
              Discover(),
              Chat(),
              Activity(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
