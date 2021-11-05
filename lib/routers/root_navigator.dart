import 'package:flutter/cupertino.dart';

import '../models/app_navigator.dart';
import '../screens/home/draft_post.dart';

/// Handles named routes globally.
///
/// This is used when we don't want to display the `BottomNavBar`.
class RootNavigator extends AppNavigator {
  @override
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DraftPost.routeName:
        return CupertinoPageRoute(builder: (_) => DraftPost());
      default:
        // TODO: implement unknownRoute
        throw UnimplementedError();
    }
  }
}
