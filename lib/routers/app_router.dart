import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../models/app_navigator.dart';
import 'activity/activity_navigator.dart';
import 'chat/chat_navigator.dart';
import 'discover/discover_navigator.dart';
import 'home/home_navigator.dart';
import 'profile/profile_navigator.dart';
import 'root_navigator.dart';

enum AppRoute {
  root,
  home,
  discover,
  chat,
  activity,
  profile,
}

class AppRouter {
  AppRouter(this._tabController);

  final PersistentTabController _tabController;

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final homeNavigatorKey = GlobalKey<NavigatorState>();
  static final discoverNavigatorKey = GlobalKey<NavigatorState>();
  static final chatNavigatorKey = GlobalKey<NavigatorState>();
  static final activityNavigatorKey = GlobalKey<NavigatorState>();
  static final profileNavigatorKey = GlobalKey<NavigatorState>();

  final _navigators = <AppRoute, AppNavigator>{
    AppRoute.root: RootNavigator(rootNavigatorKey),
    AppRoute.home: HomeNavigator(homeNavigatorKey),
    AppRoute.discover: DiscoverNavigator(discoverNavigatorKey),
    AppRoute.chat: ChatNavigator(chatNavigatorKey),
    AppRoute.activity: ActivityNavigator(activityNavigatorKey),
    AppRoute.profile: ProfileNavigator(profileNavigatorKey),
  };

  /// Get the navigator keys using the `AppRoute` enum.
  ///
  /// Should be used when we want to have complex navigation. Otherwise, use
  /// `navigateTo()` instead.
  GlobalKey<NavigatorState> keyOf(AppRoute appRoute) =>
      _navigators[appRoute]!.navigatorKey;

  /// Get the navigators using the `AppRoute` enum.
  AppNavigator navigatorOf(AppRoute appRoute) => _navigators[appRoute]!;

  /// Makes navigation across the tabs easier.
  ///
  /// Handles the tab controller without explicitly controlling the index.
  Future<dynamic> navigateTo(
    AppRoute appRoute,
    String routeName, {
    dynamic arguments,
    bool replace = false,
  }) async {
    jumpToTab(appRoute);

    if (keyOf(appRoute).currentState == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (replace) {
      return keyOf(appRoute).currentState!.pushReplacementNamed(
            routeName,
            arguments: arguments,
          );
    }
    return keyOf(appRoute).currentState!.pushNamed(
          routeName,
          arguments: arguments,
        );
  }

  void jumpToTab(AppRoute appRoute) {
    if (appRoute == AppRoute.root ||
        _tabController.index == appRoute.index - 1) {
      return;
    }

    if (keyOf(appRoute).currentState != null) {
      keyOf(appRoute).currentState!.popUntil((route) => route.isFirst);
    }

    _tabController.jumpToTab(appRoute.index - 1);
  }

  void popScreen(AppRoute appRoute, [dynamic result]) {
    return keyOf(appRoute).currentState!.pop(result);
  }

  /// Push a new screen without NavigatorKeys.
  /// Can also hide the bottom navigation bar.
  ///
  /// This will automatically use the [rootNavigatorKey] if `withNavBar` is true.
  static Future<T?> pushNewScreen<T>(
    BuildContext context, {
    required Widget screen,
    bool? withNavBar,
    PageTransitionAnimation pageTransitionAnimation =
        PageTransitionAnimation.cupertino,
    PageRoute? customPageRoute,
  }) {
    withNavBar ??= true;

    return Navigator.of(context, rootNavigator: !withNavBar).push<T>(
      customPageRoute as Route<T>? ??
          getPageRoute(pageTransitionAnimation, enterPage: screen),
    );
  }

  /// Push a dynamic (non-widget) screen without NavigatorKeys.
  /// Can also hide the bottom navigation bar.
  ///
  /// This will automatically use the [rootNavigatorKey] if `withNavBar` is true.
  static Future<T?> pushDynamicScreen<T>(
    BuildContext context, {
    required dynamic screen,
    bool? withNavBar,
  }) {
    withNavBar ??= true;
    return Navigator.of(context, rootNavigator: !withNavBar).push<T>(screen);
  }

  /// Push a new screen with route settings without NavigatorKeys.
  /// Can also hide the bottom navigation bar.
  ///
  /// This will automatically use the [rootNavigatorKey] if `withNavBar` is true.
  /// Typically used if we want to pass named routes.
  static Future<T?> pushNewScreenWithRouteSettings<T>(
    BuildContext context, {
    required Widget screen,
    required RouteSettings settings,
    bool? withNavBar,
    PageTransitionAnimation pageTransitionAnimation =
        PageTransitionAnimation.cupertino,
    PageRoute? customPageRoute,
  }) {
    withNavBar ??= true;
    return Navigator.of(context, rootNavigator: !withNavBar).push<T>(
      customPageRoute as Route<T>? ??
          getPageRoute(
            pageTransitionAnimation,
            enterPage: screen,
            settings: settings,
          ),
    );
  }
}
