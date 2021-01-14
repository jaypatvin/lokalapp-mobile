import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Imvites {
  bool claimed;
  String code;
  String communityId;
  Timestamp createdAt;
  String invitee;
  String status;
  String inviter;
  String expiresBy;
}
