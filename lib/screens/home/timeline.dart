import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../providers/activities.dart';
import '../../utils/constants/assets.dart';
import 'components/post_card.dart';

class Timeline extends StatelessWidget {
  final ScrollController? scrollController;
  final String? userId;
  final double firstIndexPadding;

  const Timeline({
    this.scrollController,
    this.userId,
    this.firstIndexPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Activities>(
      builder: (_, activities, __) {
        if (activities.isLoading) {
          return SizedBox.expand(
            child: Lottie.asset(
              kAnimationLoading,
              fit: BoxFit.cover,
              repeat: true,
            ),
          );
        }

        final activityFeed =
            userId != null ? activities.findByUser(userId) : activities.feed;
        if (activityFeed.isEmpty) {
          return const Center(
            child: Text(
              'No posts yet! Be the first one to post.',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
        return ListView.builder(
          physics: const ScrollPhysics(),
          controller: scrollController,
          itemCount: activityFeed.length, //snapshot.data!.length,
          itemBuilder: (context, index) {
            final activity = activityFeed[index];
            return Container(
              key: ValueKey(activity.id),
              margin: index == 0
                  ? EdgeInsets.only(top: firstIndexPadding)
                  : EdgeInsets.zero,
              child: PostCard(
                key: ValueKey(activity.id),
                activity: activity,
              ),
            );
          },
        );
      },
    );
  }
}
