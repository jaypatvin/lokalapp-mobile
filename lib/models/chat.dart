import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lokalapp/utils/chat_utils.dart';

class UserFieldChat {
  static final String lastMessageTime = 'lastMessageTime';
}

class Chat extends ChangeNotifier {
  String title;
  String message;
  DateTime createdAt;
  bool archived;
  String shopId;
  String customerName;
  String communityId;
  List members;
  String userId;
  DateTime updatedAt;

  Chat(
      {this.title,
      this.communityId,
      this.archived,
      this.customerName,
      this.updatedAt,
      this.shopId,
      this.message,
      this.createdAt,
      this.members,
      this.userId});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'updated_at': updatedAt,
      'archived': archived,
      'user_id': userId,
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
      message: map['message'],
      title: map['title'],
      userId: map['user_id'],
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
        message: json['message'],
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
        'message': message,
        'community_id': communityId,
        'created_at': Utils.fromDateTimeToJson(createdAt),
      };
  factory Chat.fromDocument(DocumentSnapshot doc) {
    return Chat(
        title: doc.data()['title'],
        shopId: doc.data()['shop_id'],
        archived: doc.data()['archived'],
        userId: doc.data()['user_id'],
        updatedAt: doc.data()['updated_at'],
        message: doc.data()['message'],
        customerName: doc.data()['customer_name'],
        communityId: doc.data()['community_id'],
        createdAt: doc.data()['created_at'],
        members: doc.data()['members']);
  }
}
