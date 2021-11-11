import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/activity_feed.dart';
import '../../providers/auth.dart';
import '../../utils/constants/assets.dart';
import '../../utils/constants/themes.dart';
import '../../view_models/home/timeline.vm.dart';
import 'components/post_card.dart';

class Timeline extends StatelessWidget {
  final Stream<QuerySnapshot<Map<String, dynamic>>> activityFeed;
  final ScrollController? scrollController;
  final double firstIndexPadding;

  Timeline(
    this.activityFeed, {
    this.scrollController,
    this.firstIndexPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => TimelineViewModel(ctx),
      builder: (_, __) {
        return Consumer<TimelineViewModel>(
          builder: (ctx, vm, _) {
            return StreamBuilder(
              stream: activityFeed,
              builder: (
                ctx2,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
              ) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Lottie.asset(kAnimationLoading),
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (!snapshot.hasData ||
                        snapshot.data!.docs.length == 0)
                      return Text(
                        'No posts yet! Be the first one to post.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    else
                      return ListView.builder(
                        physics: ScrollPhysics(),
                        controller: this.scrollController,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final user = context.read<Auth>().user!;
                          final activity = ActivityFeed.fromDocument(
                            snapshot.data!.docs[index],
                          );

                          return Container(
                            margin: index == 0
                                ? EdgeInsets.only(top: this.firstIndexPadding)
                                : EdgeInsets.zero,
                            child: PostCard(
                              activityFeed: activity,
                              onCommentsPressed: () =>
                                  vm.onCommentsPressed(activity),
                              onLike: () => vm.onLike(activity),
                              onTripleDotsPressed: () =>
                                  vm.onTripleDotsPressed(_PostOptions(
                                isUser: user.id == activity.userId,
                              )),
                              onUserPressed: () =>
                                  vm.onUserPressed(activity.userId),
                              onMessagePressed: () =>
                                  vm.onCommentsPressed(activity),
                            ),
                          );
                        },
                      );
                }
              },
            );
          },
        );
      },
    );
  }
}

class _PostOptions extends StatelessWidget {
  const _PostOptions({
    Key? key,
    this.isUser = false,
  }) : super(key: key);

  final bool isUser;

  @override
  Widget build(BuildContext context) {
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
  }
}
