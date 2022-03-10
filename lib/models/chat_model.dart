import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/functions.utils.dart';

part 'chat_model.g.dart';

enum ChatType { user, shop, product }

extension ChatTypeExtension on ChatType {
  String get value {
    switch (this) {
      case ChatType.user:
        return 'user';
      case ChatType.shop:
        return 'shop';
      case ChatType.product:
        return 'product';
    }
  }
}

@JsonSerializable()
class Message {
  @JsonKey(required: true)
  String content;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: dateTimeToString,
  )
  DateTime createdAt;
  Message({
    required this.content,
    required this.createdAt,
  });

  Message copyWith({
    String? content,
    DateTime? createdAt,
  }) {
    return Message(
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  @override
  String toString() => 'Message(content: $content, createdAt: $createdAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.content == content &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => content.hashCode ^ createdAt.hashCode;
}

@JsonSerializable()
class ChatModel {
  // Common:
  @JsonKey(required: true)
  String id;
  @JsonKey(required: true)
  List<String> members;
  @JsonKey(required: true)
  String title;
  @JsonKey(required: true, fromJson: _chatTypeFromJson, toJson: _chatTypeToJson)
  ChatType chatType;
  @JsonKey(required: true)
  bool archived;
  @JsonKey(required: true)
  String communityId;
  @JsonKey(
    required: true,
    fromJson: createdAtFromJson,
    toJson: dateTimeToString,
  )
  DateTime createdAt;
  @JsonKey(required: true)
  Message lastMessage;

  // Shop
  String? shopId;
  String? customerName;

  // specific to product chat
  String? productId;

  ChatModel({
    required this.id,
    required this.members,
    required this.title,
    required this.chatType,
    required this.archived,
    required this.communityId,
    required this.createdAt,
    required this.lastMessage,
    this.shopId,
    this.customerName,
    this.productId,
  });

  ChatModel copyWith({
    String? id,
    List<String>? members,
    String? title,
    ChatType? chatType,
    bool? archived,
    String? communityId,
    DateTime? createdAt,
    Message? lastMessage,
    String? shopId,
    String? customerName,
    String? productId,
  }) {
    return ChatModel(
      id: id ?? this.id,
      members: members ?? this.members,
      title: title ?? this.title,
      chatType: chatType ?? this.chatType,
      archived: archived ?? this.archived,
      communityId: communityId ?? this.communityId,
      createdAt: createdAt ?? this.createdAt,
      lastMessage: lastMessage ?? this.lastMessage,
      shopId: shopId ?? this.shopId,
      customerName: customerName ?? this.customerName,
      productId: productId ?? this.productId,
    );
  }

  factory ChatModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChatModel.fromJson({'id': doc.id, ...doc.data()!});
  }

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  @override
  String toString() {
    return 'ChatModel(id: $id, members: $members, title: $title, '
        'chatType: $chatType, archived: $archived, communityId: $communityId, '
        'createdAt: $createdAt, lastMessage: $lastMessage, shopId: $shopId, '
        'customerName: $customerName, productId: $productId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.id == id &&
        listEquals(other.members, members) &&
        other.title == title &&
        other.chatType == chatType &&
        other.archived == archived &&
        other.communityId == communityId &&
        other.createdAt == createdAt &&
        other.lastMessage == lastMessage &&
        other.shopId == shopId &&
        other.customerName == customerName &&
        other.productId == productId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        members.hashCode ^
        title.hashCode ^
        chatType.hashCode ^
        archived.hashCode ^
        communityId.hashCode ^
        createdAt.hashCode ^
        lastMessage.hashCode ^
        shopId.hashCode ^
        customerName.hashCode ^
        productId.hashCode;
  }
}

ChatType _chatTypeFromJson(String chatType) {
  return ChatType.values.firstWhere(
    (e) => e.value == chatType,
    orElse: () => ChatType.user,
  );
}

String _chatTypeToJson(ChatType type) => type.value;
