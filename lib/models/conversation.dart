import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';
import 'lokal_images.dart';

part 'conversation.g.dart';

@JsonSerializable()
class Conversation {
  @JsonKey(required: true)
  final String id;
  @JsonKey(defaultValue: false)
  final bool archived;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime createdAt;
  @JsonKey(required: true)
  final String senderId;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: nullableDateTimeToString,
  )
  final DateTime sentAt;
  final String? message;
  @JsonKey(fromJson: _replyToFromJson, toJson: _replyToToJson)
  final DocumentReference? replyTo;
  @JsonKey(defaultValue: <LokalImages>[])
  final List<LokalImages>? media;

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

  Map<String, dynamic> toJson() => _$ConversationToJson(this);
  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  factory Conversation.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return Conversation.fromJson({'id': doc.id, ...data});
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

DocumentReference? _replyToFromJson(DocumentReference? reference) => reference;
DocumentReference? _replyToToJson(DocumentReference? reference) => reference;
