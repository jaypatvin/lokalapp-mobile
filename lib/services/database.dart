import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lokalapp/models/lokal_user.dart';

final usersRef = FirebaseFirestore.instance.collection("users");
final inviteRef = FirebaseFirestore.instance.collection("invites");
final Reference storageRef = FirebaseStorage.instance.ref();

//  final Map account;
class Database {
  static const _baseUrl =
      'https://us-central1-lokal-1baac.cloudfunctions.net/api/v1/users';
  static const _storeUrl =
      'https://us-central1-lokal-1baac.cloudfunctions.net/api/v1/shops';
  Future<String> createUserPostRequest(Map data) async {
    var body = json.encode(data);
    var response = await http.post(
      _baseUrl,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response.body;
  }

  Future<String> createStorePostRequest(Map data) async {
    var body = json.encode(data);
    var response = await http.post(
      _storeUrl,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response.body;
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
}
