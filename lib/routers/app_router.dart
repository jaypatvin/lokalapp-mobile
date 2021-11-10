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

  final _navigators = <AppRoute, AppNavigator>{
    AppRoute.root: RootNavigator(),
    AppRoute.home: HomeNavigator(),
    AppRoute.discover: DiscoverNavigator(),
    AppRoute.chat: ChatNavigator(),
    AppRoute.activity: ActivityNavigator(),
    AppRoute.profile: ProfileNavigator(),
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
    if (appRoute == AppRoute.root || _tabController.index == appRoute.index - 1)
      return;

    if (keyOf(appRoute).currentState != null)
      keyOf(appRoute).currentState!.popUntil((route) => route.isFirst);

    _tabController.jumpToTab(appRoute.index - 1);
  }

  void popScreen(AppRoute appRoute, [dynamic result]) {
    return keyOf(appRoute).currentState!.pop(result);
  }
}
