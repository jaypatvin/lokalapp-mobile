import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/invites.dart';
import 'package:lokalapp/models/user.dart';

Users users = Users();

final usersRef = FirebaseFirestore.instance.collection("users");
final inviteRef = FirebaseFirestore.instance.collection("invites");
final Reference storageRef = FirebaseStorage.instance.ref();

//  final Map account;
class Database {
  Future<String> createUser(Users user) async {
    String retVal = "error";
    debugPrint("Creating user");
    try {
      await usersRef.doc().set({
        "user_uids": user.userUids,
        "email": user.email,
        "first_name": user?.firstName,
        "last_name": user?.lastName,
        "community_id": user?.communityId,
        "address": user?.address,
        "profile_photo": user?.profilePhoto,
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
