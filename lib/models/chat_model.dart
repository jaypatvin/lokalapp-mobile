import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'timestamp_time_object.dart';

enum ChatType { user, shop, product }

extension ChatTypeExtension on ChatType {
  String get value {
    switch (this) {
      case ChatType.user:
        return 'Day';
      case ChatType.shop:
        return 'Week';
      case ChatType.product:
        return 'Month';
    }
  }
}

class Message {
  String content;
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

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'],
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : TimestampObject.fromMap(map['created_at']).toDateTime(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

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

class ChatModel {
  // Common:
  String id;
  List<String> members;
  String title;
  ChatType chatType;
  bool archived;
  String communityId;
  DateTime createdAt;
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'members': members,
      'title': title,
      'chat_type': chatType.value,
      'archived': archived,
      'community_id': communityId,
      'created_at': Timestamp.fromDate(createdAt),
      'last_message': lastMessage.toMap(),
      'shop_id': shopId,
      'customer_name': customerName,
      'product_id': productId,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    ChatType chatType;
    switch (map['chat_type']) {
      case 'product':
        chatType = ChatType.product;
        break;
      case 'shop':
        chatType = ChatType.shop;
        break;
      default:
        chatType = ChatType.user;
        break;
    }

    return ChatModel(
      id: map['id'],
      members: map['members'] != null
          ? List<String>.from(
              map['members'],
            )
          : const [],
      title: map['title'],
      chatType: chatType,
      archived: map['archived'],
      communityId: map['community_id'],
      createdAt: map['created_at'] is Timestamp
          ? (map['created_at'] as Timestamp).toDate()
          : TimestampObject.fromMap(map['created_at']).toDateTime(),
      lastMessage: Message.fromMap(map['last_message']),
      shopId: map['shop_id'],
      customerName: map['customer_name'],
      productId: map['product_id'],
    );
  }

  factory ChatModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return ChatModel.fromMap({'id': doc.id, ...doc.data()!});
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

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
