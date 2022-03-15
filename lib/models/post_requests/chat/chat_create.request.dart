import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../conversation.dart';

part 'chat_create.request.g.dart';

@JsonSerializable()
class ChatCreateRequest {
  ChatCreateRequest({
    this.userId,
    required this.members,
    this.title,
    this.shopId,
    this.productId,
    this.message,
    this.media,
  }) : assert(
          (media?.isNotEmpty ?? false) || (message?.isNotEmpty ?? false),
          'Either message or media must not be empty.',
        );

  final String? userId;
  final List<String> members;
  final String? title;
  final String? shopId;
  final String? productId;
  final String? message;
  final List<ConversationMedia>? media;

  Map<String, dynamic> toJson() => _$ChatCreateRequestToJson(this);
  factory ChatCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatCreateRequestFromJson(json);

  ChatCreateRequest copyWith({
    String? userId,
    List<String>? members,
    String? title,
    String? shopId,
    String? productId,
    String? message,
    List<ConversationMedia>? media,
  }) {
    return ChatCreateRequest(
      userId: userId ?? this.userId,
      members: members ?? this.members,
      title: title ?? this.title,
      shopId: shopId ?? this.shopId,
      productId: productId ?? this.productId,
      message: message ?? this.message,
      media: media ?? this.media,
    );
  }

  @override
  String toString() {
    return 'ChatCreateRequest(userId: $userId, members: $members, '
        'title: $title, shopId: $shopId, productId: $productId, '
        'message: $message, media: $media)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatCreateRequest &&
        other.userId == userId &&
        listEquals(other.members, members) &&
        other.title == title &&
        other.shopId == shopId &&
        other.productId == productId &&
        other.message == message &&
        listEquals(other.media, media);
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        members.hashCode ^
        title.hashCode ^
        shopId.hashCode ^
        productId.hashCode ^
        message.hashCode ^
        media.hashCode;
  }
}
