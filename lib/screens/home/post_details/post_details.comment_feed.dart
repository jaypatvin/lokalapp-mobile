import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../models/activity_feed_comment.dart';
import '../../../utils/constants/assets.dart';
import '../components/comment_card.dart';

class CommentFeed extends StatelessWidget {
  const CommentFeed(this._stream, this._activityId, {Key? key})
      : super(key: key);

  final String _activityId;
  final Stream<QuerySnapshot<Map<String, dynamic>>> _stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (
        ctx,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
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
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text(
                'No posts yet! Be the first one to post.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              );
            } else {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final comment = ActivityFeedComment.fromDocument(
                    snapshot.data!.docs[index],
                  );
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommentCard(
                        key: Key(comment.id),
                        activityId: _activityId,
                        comment: comment,
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
            }
        }
      },
    );
  }
}
