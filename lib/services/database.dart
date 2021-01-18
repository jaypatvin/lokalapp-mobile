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
//  final Map account;
class Database {
  static const _baseUrl =
      'https://us-central1-lokal-1baac.cloudfunctions.net/api';
  static const platform = const MethodChannel('io.getstream/backend');

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
    return await platform.invokeMethod<bool>(
        'postMessage', {'user': account['user'], 'token': account['feedToken'], 'message': message});
  }
  
 Future<dynamic> getActivities(Map account) async {
    var result =
        await platform.invokeMethod<String>('getActivities', {'user': account['user'], 'token': account['feedToken']});
    return json.decode(result);
  }

 Future<dynamic> getTimeline(Map account) async {
    var result =
        await platform.invokeMethod<String>('getTimeline', {'user': account['user'], 'token': account['feedToken']});
    return json.decode(result);
  }
 Future<bool> follow(Map account, String userToFollow) async {
    return await platform.invokeMethod<bool>(
        'follow', {'user': account['user'], 'token': account['feedToken'], 'userToFollow': userToFollow});
  }
  Future<String> createUser(Users users) async {
    String retVal = "error";
    debugPrint("Creating user");
    try {
      await usersRef.doc().set({
        "user_uids": users.userUids,
        // "display_name": users.displayName,
        "email": users.email,
        "first_name": "",
        "last_name": "",
        // "gender": users.gender,
        "community_id": "",
        "address": "",
        // "birthdate": users.birthDate,
        // "registration": users.registration
        "profile_photo": "",
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
    // to return null when user does not exist
    Users retVal;
    try {
      final String documentId = await getCurrentUserDocId(uid);
      DocumentSnapshot _docSnapshot = await usersRef.doc(documentId).get();

      // if snapshot exists, the docID is in the collection
      if (_docSnapshot.exists) {
        // initialize retVal if snapshot exists
        retVal = Users();

        retVal.userUids = List<String>.from(_docSnapshot.data()["user_uids"]);
        // retVal.displayName = _docSnapshot.data()["display_name"];
        retVal.email = _docSnapshot.data()["email"];
        retVal.firstName = _docSnapshot.data()["first_name"];
        retVal.lastName = _docSnapshot.data()["last_name"];
        // retVal.registration = _docSnapshot.data()["registration"];
        retVal.communityId = _docSnapshot.data()["community_id"];
        // retVal.gender = _docSnapshot.data()["gender"];
        retVal.address = _docSnapshot.data()["address"];
        // retVal.birthDate = _docSnapshot.data()["birthdate"];
        retVal.profilePhoto = _docSnapshot.data()["profile_photo"];
      }
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<bool> inviteCodeExists(String code) async {
    final QuerySnapshot snapshot =
        await inviteRef.where("code", isEqualTo: code).get();
    return snapshot.docs.isNotEmpty;
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
    } else if (uids.length < 0) {
      retVal = "";
    } else {
      retVal = uids.first;
    }

    return retVal;
  }

  Future<String> updateUser(String docId, Users user) async {
    String retVal = "error";
    try {
      await usersRef.doc(docId).update({
        "user_uids": user.userUids,
        "first_name": user.firstName,
        "last_name": user.lastName,
        "address": user.address,
        "community_id": user.communityId,
        "email": user.email,
        //"profile_photo" : "",
      });
      retVal = "Success";
    } catch (e) {
      retVal = e.toString();
    }
    return retVal;
  }
}
