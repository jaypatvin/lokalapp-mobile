import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/lokal_user.dart';

final usersRef = FirebaseFirestore.instance.collection("users");
final inviteRef = FirebaseFirestore.instance.collection("invites");
final shopRef = FirebaseFirestore.instance.collection("shops");
final chatsRef = FirebaseFirestore.instance.collection("chats");
final ordersRef = FirebaseFirestore.instance.collection("orders");
final Reference storageRef = FirebaseStorage.instance.ref();

// this class should be refactored for each collection
class Database {
  static Database _database;
  static Database get instance {
    if (_database == null) {
      _database = Database();
    }
    return _database;
  }

  CollectionReference getOrderStatuses() {
    return FirebaseFirestore.instance.collection("order_status");
  }

  Future<Map<String, dynamic>> getChatById(id) async {
    final chat =
        await FirebaseFirestore.instance.collection("chats").doc(id).get();

    final data = chat.data();

    if (data != null) {
      return {"id": chat.id, ...data};
    }
    return data;
  }

  Future<Map<String, dynamic>> getGroupChatByHash(String groupHash) async {
    final chat = await FirebaseFirestore.instance
        .collection("chats")
        .where("group_hash", isEqualTo: groupHash)
        .limit(1)
        .get();

    Map<String, dynamic> data = chat != null && chat.docs.length > 0
        ? {"id": chat.docs[0].id, ...chat.docs[0].data()}
        : null;

    return data;
  }

  String getChatId(List<String> members) {
    return "";
  }

  Stream<QuerySnapshot> getUserOrders(String userId, {int statusCode}) {
    if (statusCode != null) {
      return ordersRef
          .where("buyer_id", isEqualTo: userId)
          .where("status_code", isEqualTo: statusCode)
          .orderBy("created_at", descending: true)
          .snapshots();
    }

    return ordersRef
        .where("buyer_id", isEqualTo: userId)
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getShopOrders(String shopId, {int statusCode}) {
    if (statusCode != null) {
      return ordersRef
          .where("shop_id", isEqualTo: shopId)
          .where("status_code", isEqualTo: statusCode)
          .orderBy("created_at", descending: true)
          .snapshots();
    }
    return ordersRef
        .where("shop_id", isEqualTo: shopId)
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChats(String userId) {
    return chatsRef
        .where("members", arrayContains: userId)
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getConversations(String chatId) {
    return chatsRef
        .doc(chatId)
        .collection("conversation")
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getConversationsWithMedia(String chatId) {
    return chatsRef
        .doc(chatId)
        .collection("conversation")
        .where("media", isNotEqualTo: [])
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getConversationDocument(
    String chatId,
    String conversationId,
  ) {
    return chatsRef
        .doc(chatId)
        .collection("conversation")
        .doc(conversationId)
        .get();
  }

  Future<DocumentSnapshot> getConversationByReference(
      DocumentReference reference) {
    return reference.get();
  }

  Future<DocumentSnapshot> getChatDocument(String chatId) {
    return chatsRef.doc(chatId).get();
  }

  Future<Map> getUserInfo(String uid) async {
    Map data;
    try {
      final String documentId = await getUserDocId(uid);
      if (documentId != null && documentId.isNotEmpty) {
        DocumentSnapshot _docSnapshot = await usersRef.doc(documentId).get();
        if (_docSnapshot.exists) {
          data = _docSnapshot.data();
        }
      }
    } catch (e) {
      debugPrint(e);
    }
    return data;
  }

  Future getShopInfo(String uid) async {
    List data;
    try {
      final String documentId = await getUserDocId(uid);
      if (documentId != null && documentId.isNotEmpty) {
        QuerySnapshot _docSnapshot =
            await shopRef.where('user_id', isEqualTo: documentId).get();
        if (_docSnapshot != null) {
          data = _docSnapshot.docs;
        }
      }
    } catch (e) {
      debugPrint(e);
    }
    return data;
  }

  Future<String> updateShopById(
      LokalUser user, String key, dynamic value) async {
    String retVal = "error";
    try {
      final String docId = await getUserDocId(user.userUids.first);
      await shopRef.doc(docId).update({});
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }
    return retVal;
  }

  Future<String> getUserDocId(String userUid) async {
    String retVal = "";
    final QuerySnapshot snapshot =
        await usersRef.where("user_uids", arrayContains: userUid).get();

    var uids = <String>[];

    snapshot.docs.forEach((doc) {
      uids.add(doc.id);
    });

    if (uids.length > 1) {
      // this should not happen
      throw Exception("Multiple users with the same UID have been found.");
    } else if (uids.length < 1) {
      retVal = "";
    } else {
      retVal = uids.first;
    }

    return retVal;
  }

  // no function overloading for Dart

  Future<String> updateUser(LokalUser user, String key, dynamic value) async {
    String retVal = "error";
    try {
      final String docId = await getUserDocId(user.userUids.first);
      await usersRef.doc(docId).update({key: value});
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }
    return retVal;
  }

  Future<String> uploadImage(File imageFile, String fileName) async {
    UploadTask uploadTask =
        storageRef.child("$fileName.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<bool> checkIfDocExists(id) async {
    try {
      var collectionRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(id)
          .collection('conversations');
      var doc = await collectionRef.doc(id).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }
}
