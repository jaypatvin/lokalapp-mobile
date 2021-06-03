import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../providers/activities.dart';
import '../../providers/user.dart';
import '../../utils/themes.dart';
import 'components/post_card.dart';
import 'post_details.dart';

class Timeline extends StatelessWidget {
  final List<ActivityFeed> activities;

  Timeline(this.activities);

  void onLike(BuildContext context, ActivityFeed activity, CurrentUser user) {
    if (activity.liked) {
      Provider.of<Activities>(context, listen: false).unlikePost(
        authToken: user.idToken,
        activityId: activity.id,
        userId: user.id,
      );
      debugPrint("Unliked ${activity.id}");
    } else {
      Provider.of<Activities>(context, listen: false).likePost(
        authToken: user.idToken,
        activityId: activity.id,
        userId: user.id,
      );
      debugPrint("Liked ${activity.id}");
    }
  }

  void onCommentsPressed(ActivityFeed activity, BuildContext context) {
    var user = Provider.of<CurrentUser>(context, listen: false);
    Provider.of<Activities>(context, listen: false)
        .fetchComments(authToken: user.idToken, activityId: activity.id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetails(
          onUserPressed: (user) {
            debugPrint("Go to $user");
          },
          onLike: () => onLike(context, activity, user),
          activity: activity,
        ),
      ),
    );
  }

  void onUserTripleDotsPressed(BuildContext context) {
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
                  MdiIcons.squareEditOutline,
                  color: Colors.black,
                ),
                title: Text(
                  "Edit Post",
                  softWrap: true,
                  style: kTextStyle,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: ListTile(
                leading: Icon(
                  MdiIcons.deleteOutline,
                  color: kPinkColor,
                ),
                title: Text(
                  "Delete Post",
                  softWrap: true,
                  style: kTextStyle.copyWith(color: kPinkColor),
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
                  style: kTextStyle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void onTripleDotsPressed(BuildContext context) {
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
                  "Report Post",
                  softWrap: true,
                  style: kTextStyle.copyWith(color: kPinkColor),
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
                  "Hide Post",
                  softWrap: true,
                  style: kTextStyle,
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
                  style: kTextStyle,
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
    var user = Provider.of<CurrentUser>(context, listen: false);
    return ListView.builder(
      physics: ScrollPhysics(),
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
            user.id == activity.userId
                ? this.onUserTripleDotsPressed(context)
                : this.onTripleDotsPressed(context);
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
