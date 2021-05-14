import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'operating_hours.dart';

class ShopModel {
  String id;
  String name;
  String userId;
  String communityId;
  String description;
  String profilePhoto;
  String coverPhoto;
  bool isClosed;
  String status;
  OperatingHours operatingHours;
  ShopModel({
    this.id,
    this.name,
    this.userId,
    this.communityId,
    this.description,
    this.profilePhoto,
    this.coverPhoto,
    this.isClosed,
    this.status,
    this.operatingHours,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user_id': userId,
      'community_id': communityId,
      'description': description,
      'profile_photo': profilePhoto,
      'cover_photo': coverPhoto,
      'is_close': isClosed,
      'status': status,
      'operating_hours': operatingHours?.toMap(),
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ShopModel(
      id: map['id'],
      name: map['name'],
      userId: map['user_id'],
      communityId: map['community_id'],
      description: map['description'],
      profilePhoto: map['profile_photo'],
      coverPhoto: map['cover_photo'],
      isClosed: map['is_close'],
      status: map['status'],
      operatingHours: map['operating_hours'] != null
          ? OperatingHours.fromMap(map['operating_hours'])
          : OperatingHours(),
    );
  }
  factory ShopModel.fromDocument(DocumentSnapshot doc) {
    return ShopModel(
        id: doc.data()['id'],
        name: doc.data()['name'],
        userId: doc.data()['user_id'],
        communityId: doc.data()['community_id'],
        description: doc.data()['description'],
        profilePhoto: doc.data()['profile_photo'],
        coverPhoto: doc.data()['cover_photo'],
        isClosed: doc.data()['is_closed'],
        status: doc.data()['status'],
        operatingHours: doc.data()['operating_hours']);
  }
  String toJson() => json.encode(toMap());

  factory ShopModel.fromJson(String source) =>
      ShopModel.fromMap(json.decode(source));
}
