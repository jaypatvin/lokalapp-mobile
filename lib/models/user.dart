import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Users extends ChangeNotifier {
  String uid;
  String firstName;
  String lastName;
  String profilePhoto;
  String gender;
  String email;
  String photoId;
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
      this.photoId,
      this.gender,
      this.profilePhoto,
      this.registration});

  factory Users.fromDocument(DocumentSnapshot doc) {
    return Users(
        uid: doc["uid"],
        photoId: doc["photo_id"],
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
