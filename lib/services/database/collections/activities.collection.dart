import '../../../models/activity_feed.dart';
import '../../../models/activity_feed_comment.dart';
import '../collection_impl.dart';
import '../database.dart';

class ActivitiesCollection extends CollectionImpl {
  ActivitiesCollection(Collection collection) : super(collection);

  Future<List<String>> getActivityLikes(String activityId) async {
    final snapshot = await reference.doc(activityId).collection('likes').get();
    return snapshot.docs.map<String>((doc) => doc.id).toList();
  }

  Future<bool> isCommentLiked({
    required String activityId,
    required String userId,
    required String commentId,
  }) async {
    final snapshot = await reference
        .doc(activityId)
        .collection('comments')
        .doc(commentId)
        .collection('comment_likes')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<bool> isActivityLiked(String activityId, String userId) async {
    final snapshot = await reference
        .doc(activityId)
        .collection('likes')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Stream<List<ActivityFeedComment>> getCommentFeed(
    String activityId,
  ) {
    return reference
        .doc(activityId)
        .collection('comments')
        .where('archived', isEqualTo: false)
        .orderBy('created_at', descending: false)
        .snapshots()
        .map<List<ActivityFeedComment>>(
          (event) => event.docs
              .map((doc) => ActivityFeedComment.fromDocument(doc))
              .toList(),
        );
  }

  Stream<List<ActivityFeed>> getUserFeed(String userId) {
    return reference
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map<List<ActivityFeed>>(
          (e) => e.docs.map((doc) => ActivityFeed.fromDocument(doc)).toList(),
        );
  }

  Stream<List<ActivityFeed>> getCommunityFeed(
    String communityId,
  ) {
    return reference
        .where('community_id', isEqualTo: communityId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map<List<ActivityFeed>>(
          (snapshot) => snapshot.docs
              .map((doc) => ActivityFeed.fromDocument(doc))
              .toList(),
        );
  }
}
