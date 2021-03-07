import 'dart:convert';

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
      'isCustom': isCustom,
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
      isCustom: map['isCustom'],
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
      'userId': userId,
      'communityId': communityId,
      'description': description,
      'profilePhoto': profilePhoto,
      'coverPhoto': coverPhoto,
      'isClosed': isClosed,
      'status': status,
      'operatingHours': operatingHours?.toMap(),
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ShopModel(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
      communityId: map['communityId'],
      description: map['description'],
      profilePhoto: map['profilePhoto'],
      coverPhoto: map['coverPhoto'],
      isClosed: map['isClosed'],
      status: map['status'],
      operatingHours: CustomHours.fromMap(map['operatingHours']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModel.fromJson(String source) =>
      ShopModel.fromMap(json.decode(source));
}
