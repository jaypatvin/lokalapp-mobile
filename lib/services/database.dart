import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

Users users = Users();
final usersRef = FirebaseFirestore.instance.collection("users");
final Reference storageRef = FirebaseStorage.instance.ref();

class Database {
  Future<String> createUser(Users users) async {
    String retVal = "error";

    try {
      await usersRef.doc(users.uid).set({
        "uid": users.uid,
        // "display_name": users.displayName,
        "email": users.email,
        "first_name": users.firstName,
        "last_name": users.lastName,
        // "gender": users.gender,
        // "community_id": users.communityId,
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

  Future<Users> getUserInfo(String uid) async {
    Users retVal = Users();
    try {
      DocumentSnapshot _docSnapshot = await usersRef.doc(uid).get();
      retVal.uid = uid;
      // retVal.displayName = _docSnapshot.data()["display_name"];
      retVal.email = _docSnapshot.data()["email"];
      retVal.firstName = _docSnapshot.data()["first_name"];
      retVal.lastName = _docSnapshot.data()["last_name"];
      // retVal.registration = _docSnapshot.data()["registration"];
      // retVal.communityId = _docSnapshot.data()["community_id"];
      // retVal.gender = _docSnapshot.data()["gender"];
      retVal.address = _docSnapshot.data()["address"];
      // retVal.birthDate = _docSnapshot.data()["birthdate"];
      retVal.profilePhoto = _docSnapshot.data()["profile_photo"];
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
