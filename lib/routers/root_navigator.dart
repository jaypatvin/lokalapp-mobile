import 'package:flutter/cupertino.dart';
import 'package:lokalapp/screens/auth/invite_screen.dart';
import 'package:lokalapp/screens/auth/profile_registration.dart';
import 'package:lokalapp/screens/bottom_navigation.dart';

import '../models/app_navigator.dart';
import '../screens/home/draft_post.dart';

/// Handles named routes globally.
///
/// This is used when we don't want to display the `BottomNavBar`.
class RootNavigator extends AppNavigator {
  const RootNavigator(GlobalKey<NavigatorState> navigatorKey)
      : super(navigatorKey);

  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case BottomNavigation.routeName:
        return CupertinoPageRoute(builder: (_) => BottomNavigation());
      case DraftPost.routeName:
        return CupertinoPageRoute(builder: (_) => DraftPost());
      case InvitePage.routeName:
        return CupertinoPageRoute(builder: (_) => InvitePage());
      case ProfileRegistration.routeName:
        return CupertinoPageRoute(builder: (_) => ProfileRegistration());
      default:
        // TODO: implement unknownRoute
        throw UnimplementedError();
    }
  }
}
