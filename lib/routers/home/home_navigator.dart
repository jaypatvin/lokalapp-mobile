import 'package:flutter/cupertino.dart';

import '../../models/app_navigator.dart';
import '../../screens/home/draft_post.dart';
import '../../screens/home/home.dart';
import '../../screens/home/notifications.dart';
import '../../screens/home/post_details.dart';
import 'post_details.props.dart';

/// Handles named routes under the `Home` tab.
class HomeNavigator extends AppNavigator {
  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
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
      default:
        // TODO: implement unknownRoute
        throw UnimplementedError();
    }
  }
}
