import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../models/failure_exception.dart';
import '../../../models/lokal_user.dart';
import '../collection_impl.dart';
import '../database.dart';

class UsersCollection extends CollectionImpl {
  UsersCollection(Collection collection) : super(collection);

  Future<String> getUserDocId(String userUid) async {
    String retVal = '';
    final snapshot =
        await reference.where('user_uids', arrayContains: userUid).get();

    final uids = <String>[];

    for (final doc in snapshot.docs) {
      uids.add(doc.id);
    }

    if (uids.length > 1) {
      // this should not happen
      throw FailureException(
        'Multiple users with the same UID have been found.',
      );
    } else if (uids.isEmpty) {
      retVal = '';
    } else {
      retVal = uids.first;
    }

    return retVal;
  }

  Future<LokalUser?> getUserById(String id) async {
    try {
      final data = await reference.doc(id).get();
      return LokalUser.fromDocument(data);
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(e, stack);
      return null;
    }
  }

  Future<void> onNotificationSeen({
    required String userId,
    required String notificationId,
  }) {
    try {
      return reference
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({'viewed': true});
    } catch (e, stack) {
      return FirebaseCrashlytics.instance.recordError(e, stack);
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String userId) {
    return reference.doc(userId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserNotifications(
    String userId,
  ) {
    return reference
        .doc(userId)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommunityUsers(
    String communityId,
  ) {
    return reference.where('community_id', isEqualTo: communityId).snapshots();
  }
}
