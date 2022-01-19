import 'package:flutter/cupertino.dart';

import '../../models/app_navigator.dart';
import '../../screens/home/draft_post.dart';
import '../../screens/home/home.dart';
import '../../screens/home/notifications.dart';
import '../../screens/home/post_details.dart';
import 'post_details.props.dart';

/// Handles named routes under the `Home` tab.
class HomeNavigator extends AppNavigator {
  const HomeNavigator(GlobalKey<NavigatorState> navigatorKey)
      : super(navigatorKey);

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const Home(),
        );
      case DraftPost.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const DraftPost(),
        );
      case PostDetails.routeName:
        final props = settings.arguments! as PostDetailsProps;
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => PostDetails(
            activityId: props.activityId,
            onUserPressed: props.onUserPressed,
            onLike: props.onLike,
          ),
        );
      case Notifications.routeName:
        return CupertinoPageRoute(
          settings: settings,
          builder: (_) => const Notifications(),
        );
      default:
        // TODO: implement unknownRoute
        throw UnimplementedError();
    }
  }
}
