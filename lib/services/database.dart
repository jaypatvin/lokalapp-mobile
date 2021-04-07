import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/lokal_user.dart';

final usersRef = FirebaseFirestore.instance.collection("users");
final inviteRef = FirebaseFirestore.instance.collection("invites");
final shopRef = FirebaseFirestore.instance.collection("shops");
final Reference storageRef = FirebaseStorage.instance.ref();

class Database {
  static Database _database;
  static Database get instance {
    if (_database == null) {
      _database = Database();
    }
    return _database;
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

  Future getShopInfo(String uid) async {
    List data;
    try {
      final String documentId = await getUserDocId(uid);
      if (documentId != null && documentId.isNotEmpty) {
        QuerySnapshot _docSnapshot =
            await shopRef.where('user_id', isEqualTo: documentId).get();
        if (_docSnapshot != null) {
          data = _docSnapshot.docs;
        }
      }
    } catch (e) {
      debugPrint(e);
    }
    return data;
  }

  Future<String> updateShopById(
      LokalUser user, String key, dynamic value) async {
    String retVal = "error";
    try {
      final String docId = await getUserDocId(user.userUids.first);
      await shopRef.doc(docId).update({});
      retVal = "success";
    } catch (e) {
      retVal = e.toString();
    }
    return retVal;
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

  Future<String> uploadImage(File imageFile, String fileName) async {
    UploadTask uploadTask =
        storageRef.child("$fileName.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }
}
