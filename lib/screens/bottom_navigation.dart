import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

import '../app/app.locator.dart';
import '../app/app.router.dart';
import '../app/app_router.dart';
import '../services/bottom_nav_bar_hider.dart';
import '../state/state_handler.dart';
import '../utils/constants/assets.dart';
import '../widgets/overlays/bottom_navigation_onboarding.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
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
            screens: [
              ExtendedNavigator(
                router: HomeRouter(),
                initialRoute: HomeRoutes.home,
                navigatorKey: _appRouter.keyOf(AppRoute.home),
              ),
              ExtendedNavigator(
                router: DiscoverRouter(),
                initialRoute: DiscoverRoutes.discover,
                navigatorKey: _appRouter.keyOf(AppRoute.discover),
              ),
              ExtendedNavigator(
                router: ChatRouter(),
                initialRoute: ChatRoutes.chat,
                navigatorKey: _appRouter.keyOf(AppRoute.chat),
              ),
              ExtendedNavigator(
                router: ActivityRouter(),
                initialRoute: ActivityRoutes.activity,
                navigatorKey: _appRouter.keyOf(AppRoute.activity),
              ),
              ExtendedNavigator(
                router: ProfileScreenRouter(),
                initialRoute: ProfileScreenRoutes.profileScreen,
                navigatorKey: _appRouter.keyOf(AppRoute.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
