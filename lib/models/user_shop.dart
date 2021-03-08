import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDay {
  String name;
  String opening;
  String closing;
  CustomDay({
    this.opening,
    this.closing,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'opening': opening,
      'closing': closing,
    };
  }

  factory CustomDay.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CustomDay(
      opening: map['opening'],
      closing: map['closing'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomDay.fromJson(String source) =>
      CustomDay.fromMap(json.decode(source));
}

class CustomHours {
  bool isCustom;
  String opening;
  String closing;
  CustomDay mon;
  CustomDay tue;
  CustomDay wed;
  CustomDay thu;
  CustomDay fri;
  CustomDay sat;
  CustomDay sun;
  CustomHours({
    this.isCustom,
    this.opening,
    this.closing,
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.sun,
  });

  Map<String, dynamic> toMap() {
    return {
      'is_custom': isCustom,
      'opening': opening,
      'closing': closing,
      'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'sat': sat,
      'sun': sun,
    };
  }

  factory CustomHours.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CustomHours(
      isCustom: map['is_custom'],
      opening: map['opening'],
      closing: map['closing'],
      mon: CustomDay.fromMap(map['mon']),
      tue: CustomDay.fromMap(map['tue']),
      wed: CustomDay.fromMap(map['wed']),
      thu: CustomDay.fromMap(map['thu']),
      fri: CustomDay.fromMap(map['fri']),
      sat: CustomDay.fromMap(map['sat']),
      sun: CustomDay.fromMap(map['sun']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomHours.fromJson(String source) =>
      CustomHours.fromMap(json.decode(source));
}

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
  CustomHours operatingHours;
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
      'is_closed': isClosed,
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
      isClosed: map['is_closed'],
      status: map['status'],
      operatingHours: CustomHours.fromMap(map['operating_hours']),
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
