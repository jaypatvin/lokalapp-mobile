import 'package:flutter/material.dart';
import 'package:lokalapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Users currentUser;
// final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance.collection('users');

class Database extends StatefulWidget {
  @override
  _DatabaseState createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
