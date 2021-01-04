import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Invites {
  bool claimed;
  String code;
  String communityId;
  Timestamp createdAt;
  String invitee;
  String status;
  String inviter;
  String expiresBy;

  Invites(
      {this.communityId,
      this.status,
      this.claimed,
      this.code,
      this.createdAt,
      this.expiresBy,
      this.invitee,
      this.inviter});

  factory Invites.fromDocument(DocumentSnapshot doc) {
    return Invites(
      communityId: doc["community_id"],
      claimed: doc["claimed"],
      code: doc["code"],
      createdAt: doc["created_at"],
      invitee: doc["invitee"],
      inviter: doc["inviter"],
      expiresBy: doc["expires_by"],
      status: doc["status"],
    );
  }
}
