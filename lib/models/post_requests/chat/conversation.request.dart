import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../conversation.dart';

part 'conversation.request.g.dart';

@JsonSerializable()
class ConversationRequest {
  ConversationRequest({
    this.userId,
    this.replyTo,
    this.message,
    this.media,
  }) : assert(
          (media?.isNotEmpty ?? false) || (message?.isNotEmpty ?? false),
          'Either message or media must not be empty.',
        );

  final String? userId;
  final String? replyTo;
  final String? message;
  final List<ConversationMedia>? media;

  Map<String, dynamic> toJson() => _$ConversationRequestToJson(this);
  factory ConversationRequest.fromJson(Map<String, dynamic> json) =>
      _$ConversationRequestFromJson(json);

  ConversationRequest copyWith({
    String? userId,
    String? replyTo,
    String? message,
    List<ConversationMedia>? media,
  }) {
    return ConversationRequest(
      userId: userId ?? this.userId,
      replyTo: replyTo ?? this.replyTo,
      message: message ?? this.message,
      media: media ?? this.media,
    );
  }

  @override
  String toString() {
    return 'ConversationRequest(userId: $userId, replyTo: $replyTo, '
        'message: $message, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConversationRequest &&
        other.userId == userId &&
        other.replyTo == replyTo &&
        other.message == message &&
        listEquals(other.media, media);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        replyTo.hashCode ^
        message.hashCode ^
        media.hashCode;
  }
}
