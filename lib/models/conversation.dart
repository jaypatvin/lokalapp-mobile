import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/utils/chat_utils.dart';

class Conversation with ChangeNotifier {
  bool archived;
  DateTime createdAt;
  String message;
  String senderId;
  DateTime sentAt;

  Conversation(
      {this.archived,
      this.createdAt,
      this.message,
      this.senderId,
      this.sentAt});

  Map<String, dynamic> toMap() {
    return {
      'archived': archived,
      'created_at': createdAt,
      'message': message,
      'sender_id': senderId,
      'sent_at': sentAt
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Conversation(
      archived: map['archived'],
      message: map['message'],
      senderId: map['sender_id'],
      sentAt: map['sent_at'],
      createdAt: map['created_at'],
    );
  }

  static Conversation fromJson(Map<String, dynamic> json) => Conversation(
        archived: json['archived'],
        senderId: json['sender_id'],
        sentAt: json['sent_at'],
        message: json['message'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'archived': archived,
        'sender_id': senderId,
        'sent_at': sentAt,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt),
      };
  factory Conversation.fromDocument(DocumentSnapshot doc) {
    return Conversation(
      archived: doc.data()['archived'],
      message: doc.data()['message'],
      sentAt: doc.data()['sent_at'],
      senderId: doc.data()['sender_id'],
      createdAt: doc.data()['created_at'],
    );
  }
}
