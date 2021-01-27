import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserAddress {
  String barangay;
  String country;
  String state;
  String city;
  String subdivision;
  String zipCode;
  String street;
  UserAddress({
    this.barangay,
    this.country,
    this.state,
    this.city,
    this.subdivision,
    this.zipCode,
    this.street,
  });

  Map<String, dynamic> toMap() {
    return {
      'barangay': barangay,
      'country': country,
      'state': state,
      'city': city,
      'subdivision': subdivision,
      'zip_code': zipCode,
      'street': street,
    };
  }

  factory UserAddress.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserAddress(
      barangay: map['barangay'],
      country: map['country'],
      state: map['state'],
      city: map['city'],
      subdivision: map['subdivision'],
      zipCode: map['zip_code'],
      street: map['street'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAddress.fromJson(String source) =>
      UserAddress.fromMap(json.decode(source));
}

class UserRegistrationStatus {
  int step;
  String idPhoto;
  bool verified;
  String notes;
  String idType;
  UserRegistrationStatus({
    this.step,
    this.idPhoto,
    this.verified,
    this.notes,
    this.idType,
  });

  Map<String, dynamic> toMap() {
    return {
      'step': step,
      'id_photo': idPhoto,
      'verified': verified,
      'notes': notes,
      'id_type': idType,
    };
  }

  factory UserRegistrationStatus.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserRegistrationStatus(
      step: map['step'],
      idPhoto: map['id_photo'],
      verified: map['verified'],
      notes: map['notes'],
      idType: map['id_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRegistrationStatus.fromJson(String source) =>
      UserRegistrationStatus.fromMap(json.decode(source));
}

class UserRoles {
  bool member;
  bool admin;
  UserRoles({
    this.member,
    this.admin,
  });

  Map<String, dynamic> toMap() {
    return {
      'member': member,
      'admin': admin,
    };
  }

  factory UserRoles.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserRoles(
      member: map['member'],
      admin: map['admin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoles.fromJson(String source) =>
      UserRoles.fromMap(json.decode(source));
}

class UserCreatedAt {
  Timestamp seconds;
  Timestamp nanoseconds;
  UserCreatedAt({
    this.seconds,
    this.nanoseconds,
  });

  Map<String, dynamic> toMap() {
    return {
      '_seconds': seconds,
      '_nanoseconds': nanoseconds,
    };
  }

  factory UserCreatedAt.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserCreatedAt(
      seconds: map['_seconds'],
      nanoseconds: map['_nanoseconds'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCreatedAt.fromJson(String source) =>
      UserCreatedAt.fromMap(json.decode(source));
}

class LokalUser extends ChangeNotifier {
  List<String> userUids;
  String id;
  String firstName;
  String lastName;
  String profilePhoto;
  String email;
  String displayName;
  String communityId;
  String birthDate;
  String status;
  UserAddress address;
  UserRegistrationStatus registration;
  UserRoles roles;
  UserCreatedAt createdAt;

  LokalUser({
    this.userUids,
    this.id,
    this.firstName,
    this.lastName,
    this.profilePhoto,
    this.email,
    this.displayName,
    this.communityId,
    this.birthDate,
    this.status,
    this.address,
    this.registration,
    this.roles,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_uids': userUids,
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'profile_photo': profilePhoto,
      'email': email,
      'display_name': displayName,
      'community_id': communityId,
      'birth_date': birthDate,
      'status': status,
      'address': address,
      'registration': registration,
      'roles': roles,
      'created_at': createdAt,
    };
  }

  factory LokalUser.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return LokalUser(
      userUids: List<String>.from(map['user_uids']),
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      profilePhoto: map['profile_photo'],
      email: map['email'],
      displayName: map['display_name'],
      communityId: map['community_id'],
      birthDate: map['birth_date'],
      status: map['status'],
      address: UserAddress.fromJson(map['address']),
      registration: UserRegistrationStatus.fromJson(map['registration']),
      roles: UserRoles.fromJson(map['roles']),
      createdAt: UserCreatedAt.fromMap(map['created_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LokalUser.fromJson(String source) =>
      LokalUser.fromMap(json.decode(source));
}
