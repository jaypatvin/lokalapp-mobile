import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'address.dart';
import 'timestamp_time_object.dart';

class UserRegistrationStatus {
  int? step;
  String? idPhoto;
  bool? verified;
  String? notes;
  String? idType;
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
    required this.member,
    required this.admin,
  });

  Map<String, dynamic> toMap() {
    return {
      'member': member,
      'admin': admin,
    };
  }

  factory UserRoles.fromMap(Map<String, dynamic> map) {
    return UserRoles(
      member: map['member'],
      admin: map['admin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoles.fromJson(String source) =>
      UserRoles.fromMap(json.decode(source));
}

class LokalUser {
  List<String>? userUids;
  String? id;
  String? firstName;
  String? lastName;
  String? profilePhoto;
  String? email;
  String? displayName;
  String? communityId;
  String? birthDate;
  String? status;
  Address? address;
  UserRegistrationStatus? registration;
  UserRoles? roles;
  DateTime? createdAt;
  Map<String, dynamic> notificationSettings;
  bool showReadReceipts;

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
    this.notificationSettings = const <String, dynamic>{},
    this.showReadReceipts = false,
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
      'address': address!.toMap(),
      'registration': registration!.toMap(),
      'roles': roles!.toMap(),
      'created_at': createdAt,
      'notification_settings': notificationSettings,
      'chat_settings': showReadReceipts
    };
  }

  factory LokalUser.fromMap(Map<String, dynamic> map) {
    late final DateTime _createdAt;
    if (map['created_at'] is Timestamp) {
      _createdAt = (map['created_at'] as Timestamp).toDate();
    } else if (map['created_at'] is Map) {
      _createdAt = TimestampObject.fromMap(map['created_at']).toDateTime();
    }

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
      address: Address.fromMap(map['address'] ?? Map()),
      registration:
          UserRegistrationStatus.fromMap(map['registration'] ?? Map()),
      roles: UserRoles.fromMap(map['roles'] ?? Map()),
      createdAt: _createdAt,
      notificationSettings: map['notification_settings'] ?? {},
      showReadReceipts: map['chat_settings']?['show_read_receipts'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory LokalUser.fromJson(String source) =>
      LokalUser.fromMap(json.decode(source));

  LokalUser copyWith({
    List<String>? userUids,
    String? id,
    String? firstName,
    String? lastName,
    String? profilePhoto,
    String? email,
    String? displayName,
    String? communityId,
    String? birthDate,
    String? status,
    Address? address,
    UserRegistrationStatus? registration,
    UserRoles? roles,
    DateTime? createdAt,
    Map<String, dynamic>? notificationSettings,
    bool? showReadReceipts,
  }) {
    return LokalUser(
      userUids: userUids ?? this.userUids,
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      communityId: communityId ?? this.communityId,
      birthDate: birthDate ?? this.birthDate,
      status: status ?? this.status,
      address: address ?? this.address,
      registration: registration ?? this.registration,
      roles: roles ?? this.roles,
      createdAt: createdAt ?? this.createdAt,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      showReadReceipts: showReadReceipts ?? this.showReadReceipts,
    );
  }

  @override
  String toString() {
    return 'LokalUser(userUids: $userUids, id: $id, firstName: $firstName, '
        'lastName: $lastName, profilePhoto: $profilePhoto, email: $email, '
        'displayName: $displayName, communityId: $communityId, '
        'birthDate: $birthDate, status: $status, address: $address, '
        'registration: $registration, roles: $roles, createdAt: $createdAt, '
        'notificationSettings: $notificationSettings, '
        'showReadReceipts: $showReadReceipts)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LokalUser &&
        listEquals(other.userUids, userUids) &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.profilePhoto == profilePhoto &&
        other.email == email &&
        other.displayName == displayName &&
        other.communityId == communityId &&
        other.birthDate == birthDate &&
        other.status == status &&
        other.address == address &&
        other.registration == registration &&
        other.roles == roles &&
        other.createdAt == createdAt &&
        mapEquals(other.notificationSettings, notificationSettings) &&
        other.showReadReceipts == showReadReceipts;
  }

  @override
  int get hashCode {
    return userUids.hashCode ^
        id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        profilePhoto.hashCode ^
        email.hashCode ^
        displayName.hashCode ^
        communityId.hashCode ^
        birthDate.hashCode ^
        status.hashCode ^
        address.hashCode ^
        registration.hashCode ^
        roles.hashCode ^
        createdAt.hashCode ^
        notificationSettings.hashCode ^
        showReadReceipts.hashCode;
  }
}
