import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../models/lokal_user.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../routers/home/post_details.props.dart';
import '../../routers/app_router.dart';
import '../../utils/constants/themes.dart';
import '../profile/profile_screen.dart';
import 'components/post_card.dart';
import 'post_details.dart';

class Timeline extends StatelessWidget {
  final List<ActivityFeed> activities;
  final ScrollController? scrollController;
  final double firstIndexPadding;

  Timeline(
    this.activities,
    this.scrollController, {
    this.firstIndexPadding = 0,
  });

  void _onUserPressed(BuildContext context, String userId) {
    context.read<AppRouter>().navigateTo(
      AppRoute.profile,
      ProfileScreen.routeName,
      arguments: {'userId': userId},
    );
  }

  void _onLike(BuildContext context, ActivityFeed activity, LokalUser user) {
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

  void _onCommentsPressed(ActivityFeed activity, BuildContext context) {
    final user = context.read<Auth>().user!;
    context
      ..read<Activities>().fetchComments(activityId: activity.id)
      ..read<AppRouter>().navigateTo(
        AppRoute.home,
        PostDetails.routeName,
        arguments: PostDetailsProps(
          activity: activity,
          onUserPressed: (userId) => _onUserPressed(context, userId),
          onLike: () => _onLike(context, activity, user),
        ),
      );
  }

  void _onTripleDotsPressed(BuildContext context, [bool isUser = false]) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  MdiIcons.alertCircleOutline,
                  color: kPinkColor,
                ),
                title: Text(
                  isUser ? "Edit Post" : "Report Post",
                  softWrap: true,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: kPinkColor),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  MdiIcons.eyeOffOutline,
                  color: Colors.black,
                ),
                title: Text(
                  isUser ? "Delete Post" : "Hide Post",
                  softWrap: true,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  MdiIcons.linkVariant,
                  color: Colors.black,
                ),
                title: Text(
                  "Copy Link",
                  softWrap: true,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = context.read<Auth>().user!;
    if (activities.length <= 0) {
      return Center(
        child: Text("No posts yet! Be the first one to post."),
      );
    }

    return ListView.builder(
      physics: ScrollPhysics(),
      controller: this.scrollController,
      shrinkWrap: true,
      itemCount: activities.length,
      itemBuilder: (context, index) {
        var activity = activities[index];
        return Container(
          margin: index == 0
              ? EdgeInsets.only(top: this.firstIndexPadding)
              : EdgeInsets.zero,
          child: PostCard(
            activityFeed: activity,
            onCommentsPressed: () {
              this._onCommentsPressed(activity, context);
            },
            onLike: () => _onLike(context, activity, user),
            onTripleDotsPressed: () {
              this._onTripleDotsPressed(context, user.id == activity.userId);
            },
            onUserPressed: () {
              debugPrint("Pressed the user: ${activity.userId}");
              if (activity.userId == user.id) {
                context.read<PersistentTabController>().jumpToTab(4);
                return;
              }
              return _onUserPressed(context, activity.userId);
            },
            onMessagePressed: () {
              this._onCommentsPressed(activity, context);
            },
          ),
        );
      },
    );
  }
}
