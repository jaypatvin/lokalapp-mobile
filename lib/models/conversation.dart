import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/chat_utils.dart';

class Conversation with ChangeNotifier {
  bool archived;
  DateTime createdAt;
  String message;
  String senderId;
  DateTime sentAt;

  Conversation({
    this.archived,
    this.createdAt,
    this.message,
    this.senderId,
    this.sentAt,
  });

  Conversation copyWith({
    bool archived,
    DateTime createdAt,
    String message,
    String senderId,
    DateTime sentAt,
  }) {
    return Conversation(
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'archived': archived,
      'created_at': createdAt.millisecondsSinceEpoch,
      'message': message,
      'sender_id': senderId,
      'sent_at': sentAt.millisecondsSinceEpoch,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      archived: map['archived'],
      message: map['message'],
      senderId: map['sender_id'],
      sentAt: Utils.toDateTime(map['sent_at']),
      createdAt: Utils.toDateTime(map['created_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) =>
      Conversation.fromMap(json.decode(source));

  factory Conversation.fromDocument(DocumentSnapshot doc) {
    return Conversation(
      archived: doc.data()['archived'],
      message: doc.data()['message'],
      sentAt: doc.data()['sent_at'],
      senderId: doc.data()['sender_id'],
      createdAt: doc.data()['created_at'],
    );
  }

  @override
  String toString() {
    return 'Conversation(archived: $archived, createdAt: $createdAt, message: $message, senderId: $senderId, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conversation &&
        other.archived == archived &&
        other.createdAt == createdAt &&
        other.message == message &&
        other.senderId == senderId &&
        other.sentAt == sentAt;
  }

  @override
  int get hashCode {
    return archived.hashCode ^
        createdAt.hashCode ^
        message.hashCode ^
        senderId.hashCode ^
        sentAt.hashCode;
  }
}
