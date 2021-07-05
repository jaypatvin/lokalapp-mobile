import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'lokal_images.dart';

class Conversation {
  bool archived;
  DateTime createdAt;
  String message;
  String senderId;
  DateTime sentAt;
  DocumentReference replyTo;
  List<LokalImages> media;

  Conversation({
    @required this.archived,
    @required this.createdAt,
    @required this.message,
    @required this.senderId,
    @required this.sentAt,
    @required this.replyTo,
    @required this.media,
  });

  Conversation copyWith({
    bool archived,
    DateTime createdAt,
    String message,
    String senderId,
    DateTime sentAt,
    DocumentReference replyTo,
    List<LokalImages> media,
  }) {
    return Conversation(
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      sentAt: sentAt ?? this.sentAt,
      replyTo: replyTo ?? this.replyTo,
      media: media ?? this.media,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'archived': archived,
      'created_at': Timestamp.fromDate(createdAt),
      'message': message,
      'sender_id': senderId,
      'sent_at': Timestamp.fromDate(sentAt),
      'reply_to': replyTo,
      'media': media?.map((x) => x.toMap())?.toList(),
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    final media = map['media'] == null
        ? <LokalImages>[]
        : List<LokalImages>.from(
            map['media']?.map((x) => LokalImages.fromMap(x)),
          );

    return Conversation(
      archived: map['archived'],
      message: map['message'],
      senderId: map['sender_id'],
      sentAt: (map['sent_at'] as Timestamp)?.toDate(),
      createdAt: (map['created_at'] as Timestamp)?.toDate(),
      replyTo: map['reply_to'],
      media: media ?? [],
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
      replyTo: doc.data()['reply_to'],
      media: doc.data()['media'],
    );
  }

  @override
  String toString() {
    return 'Conversation(archived: $archived, createdAt: $createdAt, message: $message, senderId: $senderId, sentAt: $sentAt, replyTo: $replyTo, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conversation &&
        other.archived == archived &&
        other.createdAt == createdAt &&
        other.message == message &&
        other.senderId == senderId &&
        other.sentAt == sentAt &&
        other.replyTo == replyTo &&
        listEquals(other.media, media);
  }

  @override
  int get hashCode {
    return archived.hashCode ^
        createdAt.hashCode ^
        message.hashCode ^
        senderId.hashCode ^
        sentAt.hashCode ^
        replyTo.hashCode ^
        media.hashCode;
  }
}
