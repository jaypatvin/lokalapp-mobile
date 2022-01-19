import 'package:flutter/cupertino.dart';

import '../models/app_navigator.dart';
import '../screens/auth/invite_screen.dart';
import '../screens/auth/profile_registration.dart';
import '../screens/bottom_navigation.dart';
import '../screens/home/draft_post.dart';
import '../screens/welcome_screen.dart';

/// Handles named routes globally.
///
/// This is used when we don't want to display the `BottomNavBar`.
class RootNavigator extends AppNavigator {
  const RootNavigator(GlobalKey<NavigatorState> navigatorKey)
      : super(navigatorKey);

  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case WelcomeScreen.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const WelcomeScreen(),
        );
      case BottomNavigation.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => BottomNavigation(),
        );
      case DraftPost.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const DraftPost(),
        );
      case InvitePage.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const InvitePage(),
        );
      case ProfileRegistration.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const ProfileRegistration(),
        );
      default:
        // TODO: implement unknownRoute
        throw UnimplementedError();
    }
  }
}
