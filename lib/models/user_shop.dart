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

  @override
  String toString() {
    return 'ShopModel(id: $id, name: $name, userId: $userId, '
        'communityId: $communityId, description: $description, '
        'profilePhoto: $profilePhoto, coverPhoto: $coverPhoto, '
        'isClosed: $isClosed, status: $status, operatingHours: $operatingHours)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShopModel &&
        other.id == id &&
        other.name == name &&
        other.userId == userId &&
        other.communityId == communityId &&
        other.description == description &&
        other.profilePhoto == profilePhoto &&
        other.coverPhoto == coverPhoto &&
        other.isClosed == isClosed &&
        other.status == status &&
        other.operatingHours == operatingHours;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        userId.hashCode ^
        communityId.hashCode ^
        description.hashCode ^
        profilePhoto.hashCode ^
        coverPhoto.hashCode ^
        isClosed.hashCode ^
        status.hashCode ^
        operatingHours.hashCode;
  }
}
