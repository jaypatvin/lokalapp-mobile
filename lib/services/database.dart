import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final usersRef = FirebaseFirestore.instance.collection("users");
final inviteRef = FirebaseFirestore.instance.collection("invites");
final Reference storageRef = FirebaseStorage.instance.ref();

//  final Map account;
class Database {
  static const _baseUrl =
      'https://us-central1-lokal-1baac.cloudfunctions.net/api/v1/users';

  Future<String> createUserPostRequest(Map data) async {
    var body = json.encode(data);
    var response = await http.post(
      _baseUrl,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response.body;
  }

  // Future<String> createUserPostRequest(Map data) async {
  //   HttpClient httpClient = HttpClient();
  //   HttpClientRequest request = await httpClient.postUrl(Uri.parse(_baseUrl));
  //   request.headers.set('content-type', 'application/json');
  //   request.add(utf8.encode(json.encode(data)));
  //   HttpClientResponse response = await request.close();
  //   String reply = await response.transform(utf8.decoder).join();
  //   httpClient.close();
  //   return reply;
  // }

  Future<Map> getUserInfo(String uid) async {
    Map data;
    try {
      final String documentId = await getCurrentUserDocId(uid);
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

  Future<bool> inviteCodeExists(String code) async {
    final QuerySnapshot snapshot =
        await inviteRef.where("code", isEqualTo: code).get();

    return snapshot.docs.isNotEmpty;
  }

  Future<String> getCommunityIdFromInvite(String code) async {
    String communityId;

    final QuerySnapshot snapshot =
        await inviteRef.where("code", isEqualTo: code).get();

    if (snapshot.docs.length == 1) {
      final Map documentData = snapshot.docs.first.data();
      if (documentData["claimed"] == false) {
        communityId = snapshot.docs.first.data()["community_id"];
      }
    }
    return communityId;
  }

  Future<bool> claimInviteCode({String code, String invitee}) async {
    bool claimed = false;
    try {
      final QuerySnapshot snapshot =
          await inviteRef.where("code", isEqualTo: code).get();

      if (snapshot.docs.length == 1) {
        await inviteRef.doc(snapshot.docs.first.id).update({
          "claimed": true,
          "invitee": invitee,
        });
        claimed = true;
      }
    } catch (e) {}
    return claimed;
  }

  Future<String> getCurrentUserDocId(String userUid) async {
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
}
