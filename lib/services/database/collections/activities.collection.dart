import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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
              .map<ActivityFeedComment?>(
                (doc) {
                  try {
                    return ActivityFeedComment.fromDocument(doc);
                  } catch (e, stack) {
                    FirebaseCrashlytics.instance.recordError(e, stack);
                    return null;
                  }
                },
              )
              .whereType<ActivityFeedComment>()
              .toList(),
        );
  }

  Stream<List<ActivityFeed>> getUserFeed(String userId) {
    return reference
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map<List<ActivityFeed>>(_convertStream);
  }

  Stream<List<ActivityFeed>> getCommunityFeed(
    String communityId,
  ) {
    return reference
        .where('community_id', isEqualTo: communityId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map<List<ActivityFeed>>(_convertStream);
  }

  List<ActivityFeed> _convertStream(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs
        .map<ActivityFeed?>(_toElement)
        .whereType<ActivityFeed>()
        .toList();
  }

  ActivityFeed? _toElement(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      return ActivityFeed.fromDocument(doc);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return null;
    }
  }
}
