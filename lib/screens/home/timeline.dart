import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../models/lokal_user.dart';
import '../../providers/activities.dart';
import '../../providers/auth.dart';
import '../../utils/constants/themes.dart';
import 'components/post_card.dart';
import 'post_details.dart';

class Timeline extends StatelessWidget {
  final List<ActivityFeed> activities;
  final ScrollController? scrollController;

  Timeline(this.activities, this.scrollController);

  void onLike(BuildContext context, ActivityFeed activity, LokalUser user) {
    if (activity.liked) {
      context.read<Activities>().unlikePost(
            activityId: activity.id,
            userId: user.id,
          );
      debugPrint("Unliked ${activity.id}");
    } else {
      context.read<Activities>().likePost(
            activityId: activity.id,
            userId: user.id,
          );
      debugPrint("Liked ${activity.id}");
    }
  }

  void onCommentsPressed(ActivityFeed activity, BuildContext context) {
    final user = context.read<Auth>().user!;
    context.read<Activities>().fetchComments(activityId: activity.id);
    pushNewScreen(
      context,
      screen: PostDetails(
        onUserPressed: (user) {
          debugPrint("Go to $user");
        },
        onLike: () => onLike(context, activity, user),
        activity: activity,
      ),
      withNavBar: false,
    );
  }

  void onTripleDotsPressed(BuildContext context, [bool isUser = false]) {
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
        return PostCard(
          activityFeed: activity,
          onCommentsPressed: () {
            this.onCommentsPressed(activity, context);
          },
          onLike: () => onLike(context, activity, user),
          onTripleDotsPressed: () {
            this.onTripleDotsPressed(context, user.id == activity.userId);
          },
          onUserPressed: () {
            debugPrint("Pressed the user: ${activity.userId}");
          },
          onMessagePressed: () {
            this.onCommentsPressed(activity, context);
          },
        );
      },
    );
  }
}
