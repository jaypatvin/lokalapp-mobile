import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:lokalapp/services/database.dart';

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

  Future<String> onStartUp() async {
    String retVal = "error";
    try {
      User _firebaseUser = await _auth.currentUser;
      uid = _firebaseUser.uid;
      email = _firebaseUser.email;
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> onSignOut() async {
    String retVal = "error";
    try {
      await _auth.signOut();
      retVal = "success";
    } catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> signUpUser(String email, String password) async {
    String retVal = "error";
    Users _user = Users();
    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user.uid = _authResult.user.uid;
      _user.email = _authResult.user.email;
      Database().createUser(_user);
      retVal = "success";
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }
}
