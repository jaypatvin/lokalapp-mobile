import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked_services/stacked_services.dart';

import '../utils/constants/navigation_keys.dart';

enum AppRoute {
  root,
  home,
  discover,
  chat,
  activity,
  profile,
}

class AppRouter {
  final _tabController = PersistentTabController();
  PersistentTabController get tabController => _tabController;

  static final rootNavigatorKey = StackedService.navigatorKey;

  static final homeNavigatorKey =
      StackedService.nestedNavigationKey(kHomeNavigationKey);
  static final discoverNavigatorKey =
      StackedService.nestedNavigationKey(kDiscoverNavigationKey);
  static final chatNavigatorKey =
      StackedService.nestedNavigationKey(kChatNavigationKey);
  static final activityNavigatorKey =
      StackedService.nestedNavigationKey(kActivityNavigationKey);
  static final profileNavigatorKey =
      StackedService.nestedNavigationKey(kProfileNavigationKey);

  final _navigators = <AppRoute, GlobalKey<NavigatorState>?>{
    AppRoute.root: rootNavigatorKey,
    AppRoute.home: homeNavigatorKey,
    AppRoute.discover: discoverNavigatorKey,
    AppRoute.chat: chatNavigatorKey,
    AppRoute.activity: activityNavigatorKey,
    AppRoute.profile: profileNavigatorKey,
  };

  /// Get the navigator keys using the `AppRoute` enum.
  ///
  /// Should be used when we want to have complex navigation. Otherwise, use
  /// `navigateTo()` instead.
  GlobalKey<NavigatorState>? keyOf(AppRoute appRoute) => _navigators[appRoute];

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

    if (keyOf(appRoute)?.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (replace) {
      return keyOf(appRoute)?.currentState?.pushReplacementNamed(
            routeName,
            arguments: arguments,
          );
    }
    return keyOf(appRoute)?.currentState?.pushNamed(
          routeName,
          arguments: arguments,
        );
  }

  /// Wrapper for [pushNamedAndRemoveUntil]
  ///
  /// predicate defaults to (route) => false
  Future<dynamic> pushNamedAndRemoveUntil(
    AppRoute appRoute,
    String routeName, {
    RoutePredicate? predicate,
    dynamic arguments,
  }) async {
    jumpToTab(appRoute);

    if (keyOf(appRoute)?.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    keyOf(appRoute)?.currentState?.pushNamedAndRemoveUntil(
          routeName,
          predicate ?? (route) => false,
          arguments: arguments,
        );
  }

  /// Wrapper for [popUntil]
  ///
  /// predicate defaults to (route) => false
  Future<dynamic> popUntil(
    AppRoute appRoute, {
    RoutePredicate? predicate,
  }) async {
    if (keyOf(appRoute)?.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    keyOf(appRoute)?.currentState?.popUntil(predicate ?? (route) => false);
  }

  // TODO: delete this
  Future<dynamic> pushDynamicScreen(
    AppRoute appRoute,
    Route<dynamic> route, {
    bool replace = false,
  }) async {
    jumpToTab(appRoute);

    if (keyOf(appRoute)?.currentState == null) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (replace) {
      return keyOf(appRoute)?.currentState?.pushReplacement(route);
    }

    return keyOf(appRoute)?.currentState?.push(route);
  }

  /// Move the screen to the specified index using the [AppRoute]
  void jumpToTab(AppRoute appRoute) {
    if (appRoute == AppRoute.root ||
        _tabController.index == appRoute.index - 1) {
      return;
    }

    if (keyOf(appRoute)?.currentState != null) {
      keyOf(appRoute)?.currentState?.popUntil((route) => route.isFirst);
    }

    _tabController.jumpToTab(appRoute.index - 1);
  }

  /// Pop the screen on the specified tab.
  void popScreen(AppRoute appRoute, [dynamic result]) {
    return keyOf(appRoute)?.currentState?.pop(result);
  }

  AppRoute get currentTabRoute {
    switch (_tabController.index) {
      case 0:
        return AppRoute.home;
      case 1:
        return AppRoute.discover;
      case 2:
        return AppRoute.chat;
      case 3:
        return AppRoute.activity;
      case 4:
        return AppRoute.profile;
      default:
        return AppRoute.root;
    }
  }
}
