import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../routers/app_router.dart';
import '../../routers/home/post_details.props.dart';
import '../../screens/home/post_details.dart';
import '../../screens/profile/profile_screen.dart';

class TimelineViewModel extends ChangeNotifier {
  TimelineViewModel(this.context);

  final BuildContext context;

  void onUserPressed(String userId) {
    if (context.read<Auth>().user!.id == userId) {
      context.read<AppRouter>().jumpToTab(AppRoute.profile);
      return;
    }

    context.read<AppRouter>().navigateTo(
      AppRoute.profile,
      ProfileScreen.routeName,
      arguments: {'userId': userId},
    );
  }

  void onLike(ActivityFeed activity) {
    final user = context.read<Auth>().user!;
    try {
      if (activity.liked) {
        context.read<Activities>().unlikePost(
              activityId: activity.id,
              userId: user.id!,
            );
      } else {
        context.read<Activities>().likePost(
              activityId: activity.id,
              userId: user.id!,
            );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  void onCommentsPressed(ActivityFeed activity) {
    context
      ..read<AppRouter>().navigateTo(
        AppRoute.home,
        PostDetails.routeName,
        arguments: PostDetailsProps(
          activity: activity,
          onUserPressed: (userId) => onUserPressed(userId),
          onLike: () => onLike(activity),
        ),
      );
  }

  void onTripleDotsPressed(Widget child, [bool isUser = false]) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (_) => child,
    );
  }
}
