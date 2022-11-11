import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/json_converters/date_time_converter.dart';
import 'conversation_media.dart';

part 'conversation.freezed.dart';
part 'conversation.g.dart';

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    @Default(false) bool archived,
    @DateTimeConverter() required DateTime createdAt,
    required String senderId,
    @DateTimeConverter() required DateTime sentAt,
    String? message,
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _replyToFromJson, toJson: _replyToToJson)
        DocumentReference? replyTo,
    @Default(<ConversationMedia>[]) List<ConversationMedia>? media,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  factory Conversation.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return Conversation.fromJson({'id': doc.id, ...data});
  }
}

DocumentReference? _replyToFromJson(DocumentReference? reference) => reference;
DocumentReference? _replyToToJson(DocumentReference? reference) => reference;
