import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/utils/chat_utils.dart';

class UserFieldChat {
  static final String lastMessageTime = 'lastMessageTime';
}

class Chat extends ChangeNotifier {
  String title;
  Map<String, String> lastMessage;
  DateTime createdAt;
  bool archived;
  String shopId;
  String customerName;
  String communityId;
  List members;
  DateTime updatedAt;

  Chat({
    this.title,
    this.communityId,
    this.archived,
    this.customerName,
    this.updatedAt,
    this.shopId,
    this.lastMessage,
    this.createdAt,
    this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      'last_message': lastMessage,
      'updated_at': updatedAt,
      'archived': archived,
      'customer_name': customerName,
      'title': title,
      'community_id': communityId,
      'createdAt': createdAt,
      'members': members,
      'shop_id': shopId,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Chat(
      shopId: map['shop_id'],
      customerName: map['customer_name'],
      archived: map['archived'],
      lastMessage: map['last_message'],
      title: map['title'],
      updatedAt: map['updated_at'],
      communityId: map['community_id'],
      members: map['members'],
      createdAt: map['created_at'],
    );
  }

  static Chat fromJson(Map<String, dynamic> json) => Chat(
        archived: json['archived'],
        title: json['title'],
        communityId: json['community_id'],
        updatedAt: json['updated_at'],
        lastMessage: json['last_message'],
        members: json['members'],
        customerName: json['customer_name'],
        shopId: json['shop_id'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'archived': archived,
        'shop_id': shopId,
        'title': title,
        'customer_name': customerName,
        'members': members,
        'updated_at': updatedAt,
        'last_message': lastMessage,
        'community_id': communityId,
        'created_at': Utils.fromDateTimeToJson(createdAt),
      };
  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat(
        title: doc.data()['title'],
        shopId: doc.data()['shop_id'],
        archived: doc.data()['archived'],
        updatedAt: doc.data()['updated_at'],
        lastMessage: doc.data()['last_message'],
        customerName: doc.data()['customer_name'],
        communityId: doc.data()['community_id'],
        createdAt: doc.data()['created_at'],
        members: doc.data()['members']);
  }
}
