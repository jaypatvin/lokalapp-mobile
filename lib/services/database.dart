import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lokalapp/utils/constants.dart';
import 'package:start_jwt/json_web_token.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Users users = Users();
final usersRef = FirebaseFirestore.instance.collection("users");
final inviteRef = FirebaseFirestore.instance.collection("invites");
final Reference storageRef = FirebaseStorage.instance.ref();

class Database {
  static const _baseUrl =
      'https://us-central1-lokal-1baac.cloudfunctions.net/api';
  static const platform = const MethodChannel('ph.lokalapp.lokal');

  Future<Map> login(String user) async {
    var authResponse =
        await http.post('$_baseUrl/v1/stream/users', body: {'sender': user});
    var authToken = json.decode(authResponse.body)['authToken'];
    var feedResponse = await http.post(
        '$_baseUrl/v1/stream/stream-feed-credentials',
        headers: {'Authorization': 'Bearer $authToken'});
    var feedToken = json.decode(feedResponse.body)['token'];
    return {'authToken': authToken, 'feedToken': feedToken};
  }

  Future<List> users(Map account) async {
    var response = await http.get('$_baseUrl/v1/stream/users',
        headers: {'Authorization': 'Bearer ${account['authToken']}'});
    return json.decode(response.body)['users'];
  }

  Future<bool> postMessage(Map account, String message) async {
    final bool result = await platform.invokeMethod<bool>('postMessage', {
      'user': account['user'],
      'token': account['feedToken'],
      'message': message
    });
    return result;
  }

  Future<String> createUser(Users users) async {
    String retVal = "error";

    try {
      await usersRef.doc(users.userUids).set({
        "user_uids": {users.userUids},
        // "display_name": users.displayName,
        "email": users.email,
        "first_name": users.firstName,
        "last_name": users.lastName,
        // "gender": users.gender,
        // "community_id": users.communityId,
        "community_id": users.communityId,
        "address": users.address,
        // "birthdate": users.birthDate,
        // "registration": users.registration
        "profile_photo": users.profilePhoto,
      });
      // currentUser = Users.fromDocument(doc);
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> joinCommunity(String code, String userUid) async {
    String retVal = "error";
    try {
      DocumentReference _docRef = await inviteRef.add({
        "created_at": Timestamp.now(),
        "code": code,
        // "invitee":
      });
      // await inviteRef.doc(communityId).update({"invitee": userUid});
      await usersRef.doc(userUid).update({"community_id": _docRef.id});
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<Users> getUserInfo(String uid) async {
    Users retVal = Users();
    try {
      DocumentSnapshot _docSnapshot = await usersRef.doc(uid).get();
      retVal.userUids = uid;
      // retVal.displayName = _docSnapshot.data()["display_name"];
      retVal.email = _docSnapshot.data()["email"];
      retVal.firstName = _docSnapshot.data()["first_name"];
      retVal.lastName = _docSnapshot.data()["last_name"];
      // retVal.registration = _docSnapshot.data()["registration"];
      // retVal.communityId = _docSnapshot.data()["community_id"];
      retVal.communityId = _docSnapshot.data()["community_id"];
      // retVal.gender = _docSnapshot.data()["gender"];
      retVal.address = _docSnapshot.data()["address"];
      // retVal.birthDate = _docSnapshot.data()["birthdate"];
      retVal.profilePhoto = _docSnapshot.data()["profile_photo"];
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<bool> userExists(String uid) async {
    final DocumentSnapshot snapshot = await usersRef.doc(uid).get();
    return snapshot.exists;
  }

  Future<bool> inviteCodeExists(String uid) async {
    final DocumentSnapshot snapshot = await inviteRef.doc(uid).get();
    return snapshot.exists;
  }
}
