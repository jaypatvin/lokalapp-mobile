import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'lokal_images.dart';

class Conversation {
  final String id;
  bool archived;
  DateTime? createdAt;
  String? message;
  String senderId;
  DateTime? sentAt;
  DocumentReference? replyTo;
  List<LokalImages>? media;

  Conversation({
    required this.id,
    required this.archived,
    required this.createdAt,
    required this.message,
    required this.senderId,
    required this.sentAt,
    this.replyTo,
    this.media,
  });

  Conversation copyWith({
    String? id,
    bool? archived,
    DateTime? createdAt,
    String? message,
    String? senderId,
    DateTime? sentAt,
    DocumentReference? replyTo,
    List<LokalImages>? media,
  }) {
    return Conversation(
      id: id ?? this.id,
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
      'id': id,
      'archived': archived,
      'created_at': Timestamp.fromDate(createdAt!),
      'message': message,
      'sender_id': senderId,
      'sent_at': Timestamp.fromDate(sentAt!),
      'reply_to': replyTo,
      'media': media?.map((x) => x.toMap()).toList(),
    };
  }

  static List<LokalImages> _getMediaFromMap(data) {
    return data == null
        ? const []
        : List<LokalImages>.from(
            data?.map((x) => LokalImages.fromMap(x)),
          );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return Conversation(
      id: doc.id,
      archived: data['archived'],
      message: data['message'] ?? '',
      sentAt: (data['sent_at'] as Timestamp?)?.toDate(),
      senderId: data['sender_id'],
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
      replyTo: data['reply_to'],
      media: _getMediaFromMap(data['media']),
    );
  }

  @override
  String toString() {
    return 'Conversation(archived: $archived, createdAt: $createdAt, '
        'message: $message, senderId: $senderId, sentAt: $sentAt, '
        'replyTo: $replyTo, media: $media)';
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
