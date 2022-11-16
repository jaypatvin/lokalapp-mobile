import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../models/activity_feed_comment.dart';
import '../../../utils/constants/assets.dart';
import '../components/comment_card.dart';

class CommentFeed extends StatelessWidget {
  const CommentFeed(this._stream, this._activityId, {super.key});

  final String _activityId;
  final Stream<List<ActivityFeedComment>> _stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ActivityFeedComment>>(
      stream: _stream,
      builder: (
        ctx,
        snapshot,
      ) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Lottie.asset(kAnimationLoading),
              ),
            );
          default:
            if (snapshot.hasError) {
              return const Text(
                'There was an error loading the comments. Please try again.',
              );
            } else if (snapshot.data?.isEmpty ?? true) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Be the first one to comment!',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            } else {
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => CommentCard(
                  key: Key(snapshot.data![index].id),
                  activityId: _activityId,
                  comment: snapshot.data![index],
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: snapshot.data!.length,
              );
            }
        }
      },
    );
  }
}
