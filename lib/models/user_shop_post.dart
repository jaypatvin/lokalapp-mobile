import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UserShopPost extends ChangeNotifier {
  String name;
  String userId;
  String communityId;
  String description;
  String profilePhoto;
  String coverPhoto;
  bool isClosed;
  String opening;
  String closing;
  bool useCustomHours;
  Map<String, String> customHours;
  String status;

  UserShopPost({
    this.closing,
    this.opening,
    this.coverPhoto,
    this.customHours,
    this.description,
    this.isClosed,
    this.name,
    this.status,
    this.userId,
    this.useCustomHours,
    this.communityId,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'community_id': communityId,
      'name': name,
      'description': description,
      'profile_photo': profilePhoto,
      'cover_photo': coverPhoto,
      'is_closed': isClosed,
      'opening': opening,
      'closing': closing,
      'use_custom_hours': useCustomHours,
      'custom_hours': customHours,
      'status': status,
    };
  }

  factory UserShopPost.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserShopPost(
      userId: map['user_id'],
      communityId: map['community_id'],
      name: map['name'],
      description: map['description'],
      profilePhoto: map['profile_photo'],
      coverPhoto: map['cover_photo'],
      isClosed: map['is_closed'],
      opening: map['opening'],
      closing: map['closing'],
      useCustomHours: map['use_custom_hours'],
      customHours: map['custom_hours'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserShopPost.fromJson(String source) =>
      UserShopPost.fromMap(json.decode(source));

  factory UserShopPost.fromDocument(DocumentSnapshot doc) {
    return UserShopPost(
      userId: doc.data()['user_id'],
      communityId: doc.data()['community_id'],
      name: doc.data()['name'],
      description: doc.data()['description'],
      profilePhoto: doc.data()['profile_photo'],
      coverPhoto: doc.data()['cover_photo'],
      isClosed: doc.data()['is_closed'],
      opening: doc.data()['opening'],
      closing: doc.data()['closing'],
      useCustomHours: doc.data()['use_custom_hours'],
      customHours: doc.data()['custom_hours'],
      status: doc.data()['status'],
    );
  }
}
