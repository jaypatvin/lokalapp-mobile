import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Users extends ChangeNotifier {
  String userUids;
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
      {this.userUids,
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
        userUids: doc["user_uids"],
        firstName: doc["first_name"],
        lastName: doc["last_name"],
        email: doc["email"],
        address: doc["address"],
        displayName: doc["display_name"],
        birthDate: doc["birthdate"],
        communityId: doc["community_id"],
        gender: doc["gender"],
        profilePhoto: doc["profile_photo"],
        registration: doc["registration"]);
  }
}
