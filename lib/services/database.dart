import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/activity_feed.dart';
import '../models/lokal_user.dart';

final activitiesRef = FirebaseFirestore.instance.collection('activities');
final usersRef = FirebaseFirestore.instance.collection('users');
final inviteRef = FirebaseFirestore.instance.collection('invites');
final shopRef = FirebaseFirestore.instance.collection('shops');
final chatsRef = FirebaseFirestore.instance.collection('chats');
final ordersRef = FirebaseFirestore.instance.collection('orders');
final productsRef = FirebaseFirestore.instance.collection('products');
final subscriptionPlansRef =
    FirebaseFirestore.instance.collection('product_subscription_plans');

final Reference storageRef = FirebaseStorage.instance.ref();

// this class should be refactored for each collection
class Database {
  static Database? _database;
  static Database get instance => _database ??= Database();

  Future<LokalUser> getUserById(String id) async {
    final _data = await usersRef.doc(id).get();
    return LokalUser.fromDocument(_data);
  }

  Future<bool> isProductLiked({
    required String productId,
    required String userId,
  }) async {
    final snapshot = await productsRef
        .doc(productId)
        .collection('likes')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<List<String>> getProductLikes(String productId) async {
    final snapshot = await productsRef.doc(productId).collection('likes').get();

    return snapshot.docs
        .map<String?>((doc) {
          final data = doc.data();
          return data['user_id'];
        })
        .whereType<String>()
        .toList();
  }

  Future<void> onNotificationSeen({
    required String userId,
    required String notificationId,
  }) {
    return usersRef
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'viewed': true});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserNotifications(
    String userId,
  ) {
    return usersRef
        .doc(userId)
        .collection('notifications')
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getBankCodes() {
    return FirebaseFirestore.instance.collection('bank_codes').get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBankCodesStream() {
    return FirebaseFirestore.instance.collection('bank_codes').snapshots();
  }

  Future<List<String>> getActivityLikes(String activityId) async {
    final snapshot =
        await activitiesRef.doc(activityId).collection('likes').get();

    return snapshot.docs.map<String>((doc) => doc.id).toList();
  }

  Future<bool> isCommentLiked({
    required String activityId,
    required String userId,
    required String commentId,
  }) async {
    final snapshot = await activitiesRef
        .doc(activityId)
        .collection('comments')
        .doc(commentId)
        .collection('comment_likes')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<bool> isActivityLiked(String activityId, String userId) async {
    final snapshot = await activitiesRef
        .doc(activityId)
        .collection('likes')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentFeed(
    String activityId,
  ) {
    return activitiesRef
        .doc(activityId)
        .collection('comments')
        .where('archived', isEqualTo: false)
        .orderBy('created_at', descending: false)
        .snapshots();
  }

  Stream<List<ActivityFeed>> getUserFeed(String userId) {
    return activitiesRef
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map<List<ActivityFeed>>(
          (snapshot) => snapshot.docs
              .map((doc) => ActivityFeed.fromDocument(doc))
              .toList(),
        );
  }

  Stream<List<ActivityFeed>> getUserFeedStream(String userId) {
    return activitiesRef
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map<List<ActivityFeed>>(
          (snapshot) => snapshot.docs
              .map((doc) => ActivityFeed.fromDocument(doc))
              .toList(),
        );
  }

  Stream<List<ActivityFeed>> getCommunityFeedStream(
    String communityId,
  ) {
    return activitiesRef
        .where('community_id', isEqualTo: communityId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map<List<ActivityFeed>>(
          (snapshot) => snapshot.docs
              .map((doc) => ActivityFeed.fromDocument(doc))
              .toList(),
        );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommunityFeed(
    String communityId,
  ) {
    return activitiesRef
        .where('community_id', isEqualTo: communityId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getNotificationTypes() {
    return FirebaseFirestore.instance.collection('notification_types').get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPostLikes(
    String activityId,
    String docId,
  ) {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(activityId)
        .collection('likes')
        .doc(docId)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostImages(String docId) {
    return FirebaseFirestore.instance
        .collection('activities')
        .doc(docId)
        .collection('images')
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostImagesCollection() async {
    return FirebaseFirestore.instance.collectionGroup('images').get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommunityProducts(
    String communityId,
  ) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('community_id', isEqualTo: communityId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommunityShops(
    String communityId,
  ) {
    return FirebaseFirestore.instance
        .collection('shops')
        .where('community_id', isEqualTo: communityId)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommunityUsers(
    String communityId,
  ) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('community_id', isEqualTo: communityId)
        .snapshots();
  }

  CollectionReference getOrderStatuses() {
    return FirebaseFirestore.instance.collection('order_status');
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserSubscriptionPlans(
    String? userId,
  ) {
    return subscriptionPlansRef
        .where('buyer_id', isEqualTo: userId)
        // .orderBy("created_at", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getShopSubscriptionPlans(
    String? shopId,
  ) {
    return subscriptionPlansRef
        .where('shop_id', isEqualTo: shopId)
        // .orderBy("created_at", descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getChatById(String id) async {
    final chat =
        await FirebaseFirestore.instance.collection('chats').doc(id).get();

    final data = chat.data();

    if (data != null) {
      return {'id': chat.id, ...data};
    }
    return data;
  }

  Future<Map<String, dynamic>?> getGroupChatByHash(String groupHash) async {
    final chat = await FirebaseFirestore.instance
        .collection('chats')
        .where('group_hash', isEqualTo: groupHash)
        .limit(1)
        .get();

    final Map<String, dynamic>? data = chat.docs.isNotEmpty
        ? {'id': chat.docs[0].id, ...chat.docs[0].data()}
        : null;

    return data;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserOrders(
    String? userId, {
    int? statusCode,
  }) {
    if (statusCode != null) {
      return ordersRef
          .where('buyer_id', isEqualTo: userId)
          .where('status_code', isEqualTo: statusCode)
          .orderBy('created_at', descending: true)
          .snapshots();
    }

    return ordersRef
        .where('buyer_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getShopOrders(
    String? shopId, {
    int? statusCode,
  }) {
    if (statusCode != null) {
      return ordersRef
          .where('shop_id', isEqualTo: shopId)
          .where('status_code', isEqualTo: statusCode)
          .orderBy('created_at', descending: true)
          .snapshots();
    }
    return ordersRef
        .where('shop_id', isEqualTo: shopId)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats(String? userId) {
    return chatsRef
        .where('members', arrayContains: userId)
        .orderBy('last_message.created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getConversations(String? chatId) {
    return chatsRef
        .doc(chatId)
        .collection('conversation')
        .orderBy('archived')
        .where('archived', isNotEqualTo: true)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getConversationsWithMedia(String chatId) {
    return chatsRef
        .doc(chatId)
        .collection('conversation')
        .where('media', isNotEqualTo: [])
        .orderBy('created_at', descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getConversationDocument(
    String chatId,
    String conversationId,
  ) {
    return chatsRef
        .doc(chatId)
        .collection('conversation')
        .doc(conversationId)
        .get();
  }

  Future<DocumentSnapshot> getConversationByReference(
    DocumentReference reference,
  ) {
    return reference.get();
  }

  Future<DocumentSnapshot> getChatDocument(String chatId) {
    return chatsRef.doc(chatId).get();
  }

  Future<String> getUserDocId(String userUid) async {
    String retVal = '';
    final QuerySnapshot snapshot =
        await usersRef.where('user_uids', arrayContains: userUid).get();

    final uids = <String>[];

    for (final doc in snapshot.docs) {
      uids.add(doc.id);
    }

    if (uids.length > 1) {
      // this should not happen
      throw Exception('Multiple users with the same UID have been found.');
    } else if (uids.isEmpty) {
      retVal = '';
    } else {
      retVal = uids.first;
    }

    return retVal;
  }

  Future<String> uploadImage({
    required File file,
    required String src,
    required String fileName,
  }) async {
    final UploadTask uploadTask =
        storageRef.child('/images/$src/$fileName.jpg').putFile(file);
    final TaskSnapshot storageSnap = await uploadTask;
    final String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }
}
