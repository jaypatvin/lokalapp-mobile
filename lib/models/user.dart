import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Users extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String get getUid => uid;
  String get getEmail => email;
  String uid;
  String firstName;
  String lastName;
  String profilePhoto;
  String gender;
  String email;
  String displayName;
  String communityId;
  String birthDate;
  Map<String, dynamic> address;
  Map<String, dynamic> registration;

  Users(
      {this.uid,
      this.firstName,
      this.lastName,
      this.email,
      this.displayName,
      this.address,
      this.birthDate,
      this.communityId,
      this.gender,
      this.profilePhoto,
      this.registration});

  factory Users.fromDocument(DocumentSnapshot doc) {
    return Users(
        uid: doc["uid"],
        firstName: doc["first_name"],
        lastName: doc["last_name"],
        email: doc["email"],
        displayName: doc["display_name"],
        address: doc["address"],
        birthDate: doc["birthdate"],
        communityId: doc["community_id"],
        gender: doc["gender"],
        profilePhoto: doc["profile_photo"],
        registration: doc["registration"]);
  }

  Future<String> signUpUser(String email, String password) async {
    String retVal = "false";
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      retVal = "success";
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }
}
