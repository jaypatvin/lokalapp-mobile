import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UserShopPost extends ChangeNotifier{
  String name;
  String userUid;
  String communityId;
  String description;
  String profilePhoto;
  String coverPhoto;
  bool isClosed;
  String opening;
  String closing;
  bool useCustomHours;
  Map <String, String>customHours;
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
    this.userUid,
    this.useCustomHours,
    this.communityId,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_uid': userUid,
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
      userUid: map['user_uid'],
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
}
