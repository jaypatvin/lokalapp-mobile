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
  }) {
    switch (appRoute) {
      case AppRoute.home:
        if (_tabController.index != 0) {
          _tabController.jumpToTab(0);
        }
        break;
      case AppRoute.discover:
        if (_tabController.index != 1) {
          _tabController.jumpToTab(1);
        }
        break;
      case AppRoute.chat:
        if (_tabController.index != 2) {
          _tabController.jumpToTab(2);
        }
        break;
      case AppRoute.activity:
        if (_tabController.index != 3) {
          _tabController.jumpToTab(3);
        }
        break;
      case AppRoute.profile:
        if (_tabController.index != 4) {
          _tabController.jumpToTab(4);
        }
        break;
      default:
        break;
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
}
