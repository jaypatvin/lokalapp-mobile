import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../screens/home/draft_post.dart';
import '../screens/home/home.dart';
import '../screens/home/notifications.dart';
import '../screens/home/post_details.dart';
import 'home/post_details.props.dart';

class AppRouter {
  /// Used when we want to hide the PersistentBottomNavBar
  ///
  /// Should be used as the root navigator on our CupertinoApp/MaterialApp with
  /// the `rootNavigatorOnGenerateroute`.
  static GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey();

  /// GlobalKey to be used on navigating on the `Home` tab.
  ///
  /// If the `PersistentBottomTabBar` should be hidden, use the
  /// `rootNavigatorKey` instead.
  static GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey();

  /// GlobalKey to be used on navigating on the `Discover` tab.
  ///
  /// If the `PersistentBottomTabBar` should be hidden, use the
  /// `rootNavigatorKey` instead.
  static GlobalKey<NavigatorState> discoverNavigatorKey = GlobalKey();

  /// GlobalKey to be used on navigating on the `Chat` tab.
  ///
  /// If the `PersistentBottomTabBar` should be hidden, use the
  /// `rootNavigatorKey` instead.
  static GlobalKey<NavigatorState> chatNavigatorKey = GlobalKey();

  /// GlobalKey to be used on navigating on the `Activity` tab.
  ///
  /// If the `PersistentBottomTabBar` should be hidden, use the
  /// `rootNavigatorKey` instead.
  static GlobalKey<NavigatorState> activityNavigatorKey = GlobalKey();

  /// GlobalKey to be used on navigating on the `Profile` tab.
  ///
  /// If the `PersistentBottomTabBar` should be hidden, use the
  /// `rootNavigatorKey` instead.
  static GlobalKey<NavigatorState> profileNavigatorKey = GlobalKey();

  /// Handles named routes when we don't want to display the
  /// `PersistentBottomNavBar`.
  Route<dynamic> rootNavigatorOnGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DraftPost.routeName:
        return CupertinoPageRoute(builder: (_) => DraftPost());
      default:
        return CupertinoPageRoute(
          builder: (_) => Text('Unknown Route'),
        );
    }
  }

  final homeNavigator = RouteAndNavigatorSettings(
    navigatorKey: homeNavigatorKey,
    initialRoute: Home.routeName,
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case Home.routeName:
          return CupertinoPageRoute(builder: (_) => Home());
        case DraftPost.routeName:
          return CupertinoPageRoute(builder: (_) => DraftPost());
        case PostDetails.routeName:
          final props = settings.arguments as PostDetailsProps;
          return CupertinoPageRoute(
            builder: (_) => PostDetails(
              activity: props.activity,
              onUserPressed: props.onUserPressed,
              onLike: props.onLike,
            ),
          );
        case Notifications.routeName:
          return CupertinoPageRoute(builder: (_) => Notifications());
      }
    },
    onUnknownRoute: (_) => CupertinoPageRoute(
      builder: (_) => Text('Unknown Route'),
    ),
  );
}
